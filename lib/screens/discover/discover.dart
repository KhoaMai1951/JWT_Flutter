import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/components/MultiSelectChipForSubmitPost.dart';
import 'package:flutter_login_test_2/components/MultiSelectChipFilter.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/globals/user_global.dart';
import 'package:flutter_login_test_2/models/post_detail_model.dart';
import 'package:flutter_login_test_2/models/tag_model.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/loading/loading_post_detail.dart';
import 'package:flutter_login_test_2/screens/loading/loading_user_profile.dart';
import 'package:flutter_login_test_2/services/TagService.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_login_test_2/widgets/label/expert_label.dart';
import 'package:flutter_login_test_2/widgets/post_mini/post_mini.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //current tab
  int currentTabIndex = 0;
  // SEARCH
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  String keyword = '';
  // FILTER
  bool _plantTagListIsLoading = true;
  bool _contentTagListIsLoading = true;
  bool _exchangeTagListIsLoading = true;
  //var plantTagList;
  var plantTagList;
  var selectedPlantTagList = [];
  //var contentTagList;
  var contentTagList;
  var selectedContentTagList = [];
  //var exchangeTagList;
  var exchangeTagList;
  var selectedExchangeTagList = [];
  var tagIds = [];
  //COUNTER TAGS
  int maxPlantTagCounter = 0;
  int maxContentTagCounter = 0;
  int maxExchangeTagCounter = 0;
  //audience target
  int audienceRadioValue = 1;
  int titleOrContent = 1;

  // Biến phục vụ cho comment infinite scroll của global
  int skipPostGlobal = 0;
  int takePostGlobal = 10;
  bool isLoadingPostGlobal = false;
  bool stillSendApiPostGlobal = true;
  List<PostDetailModel> postsGlobal = [];
  // Biến phục vụ cho comment infinite scroll của home
  int skipPostHome = 0;
  int takePostHome = 10;
  bool isLoadingPostHome = false;
  bool stillSendApiPostHome = true;
  List<PostDetailModel> postsHome = [];
  // Biến phục vụ cho comment infinite scroll của user
  int skipUser = 0;
  int takeUser = 6;
  bool isLoadingUser = false;
  bool stillSendApiUser = true;
  List<UserModel> users = [];
  // SCROLL CONTROLLER
  ScrollController _scrollController = new ScrollController();
  // TAB
  TabController _tabController;

  //1C HÀM GỌI API LẤY DS USER THEO CỤM
  fetchUsers() async {
    setState(() {
      isLoadingUser = true;
    });
    var data = {
      'skip': this.skipUser,
      'take': takeUser,
      'keyword': keyword,
      'role_id_array': [1, 2],
    };
    var res = await Network().postData(data, '/user/search_user');
    var body = json.decode(res.body);
    // Nếu có kết quả trả về
    if (body['users'].isEmpty == false) {
      List<UserModel> fetchedUsers = [];
      for (var user in body['users']) {
        // user handle
        UserModel userModel = new UserModel(
          id: user['id'],
          username: user['username'],
          name: user['name'],
          avatarUrl: user['avatar_url'],
          roleId: user['role_id'],
        );

        fetchedUsers.add(userModel);
      }
      setState(() {
        this.skipUser += takeUser;
        this.users.addAll(fetchedUsers);
        isLoadingUser = false;
      });
    }
    // Nếu kết trả không còn
    else {
      setState(() {
        stillSendApiUser = false;
        isLoadingUser = false;
      });
    }
  }

  //1B. HÀM GỌI API LẤY DS POST GLOBAL THEO CỤM
  fetchPostsGlobal() async {
    setState(() {
      isLoadingPostGlobal = true;
    });
    var data = {
      'skip': this.skipPostGlobal,
      'take': takePostGlobal,
      'keyword': keyword,
      'user_id': UserGlobal.user['id'],
      'tag_ids': tagIds,
    };
    var res = await Network().postData(data, '/post/global_newsfeed');
    var body = json.decode(res.body);
    // Nếu có kết quả trả về
    if (body['posts'].isEmpty == false) {
      List<PostDetailModel> fetchedPosts = [];
      for (var post in body['posts']) {
        // tag model
        List<TagModel> tags = [];
        if (post['tags'] != null) {
          for (var tag in post['tags']) {
            TagModel tagModel = new TagModel(
              id: tag['id'],
              name: tag['name'],
              tagTypeId: tag['tag_type_id'],
            );
            tags.add(tagModel);
          }
        }
        // user handle
        UserModel userModel = new UserModel(
          id: post['user']['id'],
          username: post['user']['username'],
          avatarUrl: post['user']['avatar_url'],
          roleId: post['user']['role_id'],
        );
        // image for post handle
        List<String> imagesForPost = [];
        for (var image in post['images_for_post']) {
          imagesForPost.add(image['dynamic_url']);
        }
        // post handle
        PostDetailModel postModel = new PostDetailModel(
          id: post['id'],
          createdAt: post['created_at'],
          imagesForPost: imagesForPost,
          title: post['title'],
          content: post['short_content'],
          like: post['like'],
          commentsNumber: post['comments_number'],
          user: userModel,
          currentImageIndicator: 0,
          isLiked: post['is_liked'],
          tags: tags,
        );
        fetchedPosts.add(postModel);
      }

      setState(() {
        this.skipPostGlobal += takePostGlobal;
        this.postsGlobal.addAll(fetchedPosts);
        isLoadingPostGlobal = false;
      });
    }
    // Nếu kết quả trả về không còn
    else {
      setState(() {
        stillSendApiPostGlobal = false;
        isLoadingPostGlobal = false;
      });
    }
  }

  //1A. HÀM GỌI API LẤY DS POST HOME THEO CỤM
  fetchPostsHome() async {
    setState(() {
      isLoadingPostHome = true;
    });
    var data = {
      'user_id': UserGlobal.user['id'],
      'skip': this.skipPostHome,
      'take': takePostHome,
      'keyword': keyword,
      'tag_ids': tagIds,
    };
    var res = await Network().postData(data, '/post/home_newsfeed');

    var body = json.decode(res.body);
    // Nếu có kết quả trả về
    if (body['posts'].isEmpty == false) {
      List<PostDetailModel> fetchedPosts = [];
      for (var post in body['posts']) {
        // tag model
        List<TagModel> tags = [];
        if (post['tags'] != null) {
          for (var tag in post['tags']) {
            TagModel tagModel = new TagModel(
              id: tag['id'],
              name: tag['name'],
              tagTypeId: tag['tag_type_id'],
            );
            tags.add(tagModel);
          }
        }
        // user handle
        UserModel userModel = new UserModel(
          id: post['user']['id'],
          username: post['user']['username'],
          avatarUrl: post['user']['avatar_url'],
          roleId: post['user']['role_id'],
        );
        // image for post handle
        List<String> imagesForPost = [];
        for (var image in post['images_for_post']) {
          imagesForPost.add(image['dynamic_url']);
        }
        // post handle
        PostDetailModel postModel = new PostDetailModel(
          id: post['id'],
          createdAt: post['created_at'],
          imagesForPost: imagesForPost,
          title: post['title'],
          content: post['short_content'],
          like: post['like'],
          commentsNumber: post['comments_number'],
          user: userModel,
          currentImageIndicator: 0,
          isLiked: post['is_liked'],
          isSuggested: post['is_suggested'],
          tags: tags,
        );
        fetchedPosts.add(postModel);
      }
      setState(() {
        this.skipPostHome += takePostHome;
        this.postsHome.addAll(fetchedPosts);
        isLoadingPostHome = false;
      });
    } else {
      setState(() {
        stillSendApiPostHome = false;
        isLoadingPostHome = false;
      });
    }
  }

  // 2A. GỌI HÀM LẤY DS POST HOME + CHECK CUỘN BOTTOM ĐỂ GỌI TIẾP
  // 2B. GỌI HÀM LẤY DS POST GLOBAL + CHECK CUỘN BOTTOM ĐỂ GỌI TIẾP
  // 2C. GỌI HÀM LẤY DS USER + CHECK CUỘN BOTTOM ĐỂ GỌI TIẾP
  @override
  void initState() {
    super.initState();
    // FETCH TAGS
    // Load plant tag list
    TagService.getTagsByTypeId(1).then((data) {
      setState(() {
        _plantTagListIsLoading = false;
        plantTagList = data;
      });
    });

    // Load content tag list
    TagService.getTagsByTypeId(2).then((data) {
      setState(() {
        _contentTagListIsLoading = false;
        contentTagList = data;
      });
    });

    // Load exchange plant tag list
    TagService.getTagsByTypeId(4).then((data) {
      setState(() {
        _exchangeTagListIsLoading = false;
        exchangeTagList = data;
      });
    });

    // TAB CONTROLLER
    _tabController = TabController(length: 3, vsync: this);
    // get post
    fetchPostsHome();
    fetchPostsGlobal();
    fetchUsers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // FOR POSTS HOME
        handleScrollBottomForPostsHome();
        // FOR POSTS GLOBAL
        handleScrollBottomForPostsGlobal();
        // FOR USERS
        handleScrollBottomForUsers();
      }
    });
  }

  // HANDLE SCROLL BOTTOM HOME
  handleScrollBottomForPostsHome() {
    if (isLoadingPostHome == true) return;
    if (stillSendApiPostHome == true) {
      fetchPostsHome();
    }
  }

  // HANDLE SCROLL BOTTOM GLOBAL
  handleScrollBottomForPostsGlobal() {
    if (isLoadingPostGlobal == true) return;
    if (stillSendApiPostGlobal == true) {
      fetchPostsGlobal();
    }
  }

  // HANDLE SCROLL BOTTOM USER
  handleScrollBottomForUsers() {
    if (isLoadingUser == true) return;
    if (stillSendApiUser == true) {
      fetchUsers();
    }
  }

  // 3A. DISPOSE CONTROLLER
  // 3B. DISPOSE CONTROLLER
  @override
  void dispose() {
    super.dispose();
    //_scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        leading: _isSearching ? const BackButton() : SizedBox(),
        title: _isSearching
            ? _buildSearchField()
            : Text(
                '🌿 Don\'t Leaf Me ',
                style: TextStyle(fontFamily: 'Parisienne'),
              ),
        actions: _buildActions(),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomNavigationBar(
          context: context, index: kBottomBarIndexDiscover),
    );
  }

  buildBody() {
    return NestedScrollView(
      controller: this._scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          // NAVIGATE TAB
          SliverAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            expandedHeight: 40.0,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Column(
                children: [
                  TabBar(
                    onTap: (index) {
                      setState(() {
                        currentTabIndex = index;
                      });
                    },
                    controller: _tabController,
                    labelColor: Colors.teal,
                    isScrollable: false,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.home),
                      ),
                      Tab(
                        icon: Icon(Icons.public),
                      ),
                      Tab(
                        icon: Icon(Icons.people),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body: Container(
        child: TabBarView(
          controller: _tabController,
          children: [
            infiniteHomeListView(),
            infiniteGlobalListView(), // LIST DS BÀI VIẾT THEO TỪ KHÓA
            infiniteUserListView(),
          ],
        ),
      ),
    );
  }

  // LIST DS BÀI VIẾT HOME
  infiniteHomeListView() {
    return Column(
      children: [
        //NEWSFEED
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: postsHome.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      // BÀI VIẾT MINI
                      PostMini(
                        currentUserId: UserGlobal.user['id'],
                        post: postsHome[index],
                        onImageChange: (int currentImageIndexIndicator) {
                          setState(() {
                            postsHome[index].currentImageIndicator =
                                currentImageIndexIndicator;
                          });
                        },
                        onLikePost: (int numberOfLikes, bool isLiked) {
                          setState(() {
                            postsHome[index].like = numberOfLikes;
                            postsHome[index].isLiked = isLiked;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                  //isLoading == true ? Text('loading...') : SizedBox(),
                ],
              );
            },
          ),
        ),
        //SPINNING
        isLoadingPostGlobal == true ? Text('đang tải...') : SizedBox(),
      ],
    );
  }

  // LIST DS BÀI VIẾT GLOBAL
  infiniteGlobalListView() {
    /*return Column(
      children: [
        SizedBox(height: 20.0),
        // LABEL
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              Text(
                'Khám phá bài viết',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        // NEWSFEED
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: postsGlobal.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      // BÀI VIẾT MINI
                      PostMini(
                        currentUserId: UserGlobal.user['id'],
                        post: postsGlobal[index],
                        onImageChange: (int currentImageIndexIndicator) {
                          setState(() {
                            postsGlobal[index].currentImageIndicator =
                                currentImageIndexIndicator;
                          });
                        },
                        onLikePost: (int numberOfLikes, bool isLiked) {
                          setState(() {
                            postsGlobal[index].like = numberOfLikes;
                            postsGlobal[index].isLiked = isLiked;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                  //isLoading == true ? Text('loading...') : SizedBox(),
                ],
              );
            },
          ),
        ),
        // SPINNING
        isLoadingPostGlobal == true ? Text('đang tải...') : SizedBox(),
      ],
    );*/
    return Column(
      children: [
        //NEWSFEED
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: postsGlobal.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      // BÀI VIẾT MINI
                      PostMini(
                        currentUserId: UserGlobal.user['id'],
                        post: postsGlobal[index],
                        onImageChange: (int currentImageIndexIndicator) {
                          setState(() {
                            postsGlobal[index].currentImageIndicator =
                                currentImageIndexIndicator;
                          });
                        },
                        onLikePost: (int numberOfLikes, bool isLiked) {
                          setState(() {
                            postsGlobal[index].like = numberOfLikes;
                            postsGlobal[index].isLiked = isLiked;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        //SPINNING
        isLoadingPostGlobal == true ? Text('đang tải...') : SizedBox(),
      ],
    );
  }

  // LIST DS USER THEO TỪ KHÓA
  infiniteUserListView() {
    return Column(
      children: [
        SizedBox(height: 20.0),
        // LABEL
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              Text(
                'Tìm kiếm người dùng',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        // USER FEED
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            //controller: this._scrollController,
            itemCount: users.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      // THÔNG TIN USER
                      Row(
                        children: [
                          // AVATAR
                          InkWell(
                            child: Container(
                              alignment: Alignment.center,
                              child: Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90.0),
                                    image: DecorationImage(
                                        image: (users[index].avatarUrl != '')
                                            ? NetworkImage(
                                                users[index].avatarUrl)
                                            : AssetImage(
                                                'images/no-avatar.png'),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            onTap: () {
                              navigateToUserProfile(userId: users[index].id);
                            },
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          // USERNAME + LABEL
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              users[index].roleId == 2
                                  ? expertLabelBuild()
                                  : SizedBox(),
                              // USERNAME
                              InkWell(
                                child: Text(
                                  users[index].username,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                onTap: () {
                                  navigateToUserProfile(
                                      userId: users[index].id);
                                },
                              ),
                              // NAME
                              InkWell(
                                child: Text(
                                  users[index].name,
                                  style: TextStyle(fontSize: 15),
                                ),
                                onTap: () {
                                  navigateToUserProfile(
                                      userId: users[index].id);
                                },
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                  //isLoading == true ? Text('loading...') : SizedBox(),
                ],
              );
            },
          ),
        ),
        // SPINNING
        isLoadingUser == true
            ? SpinKitRing(
                color: Colors.teal,
                lineWidth: 3.0,
                size: 40.0,
              )
            : SizedBox(),
      ],
    );
  }

  Widget _buildSearchField() {
    return Column(
      children: [
        TextField(
          cursorColor: Colors.white,
          controller: _searchQueryController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Tìm kiếm",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white, fontSize: 16.0),
          onChanged: (query) => updateSearchQuery(query),
        ),
      ],
    );
  }

  void updateSearchQuery(String newQuery) {
    switch (currentTabIndex) {
      case 0: // nếu đang ở tab home
        setState(() {
          keyword = newQuery;
          // FOR HOME POSTS
          postsHome.clear();
          skipPostHome = 0;
          searchQuery = newQuery;
        });
        fetchPostsHome();
        break;
      case 1: // nếu đang ở tab global
        setState(() {
          keyword = newQuery;
          // FOR GLOBAL POSTS
          postsGlobal.clear();
          skipPostGlobal = 0;
          searchQuery = newQuery;
        });
        fetchPostsGlobal();
        break;
      case 2: // nếu đang ở tab user
        setState(() {
          keyword = newQuery;
          // FOR USERS
          users.clear();
          skipUser = 0;
          searchQuery = newQuery;
        });
        fetchUsers();
        break;
    }
  }

  void showPostFilterDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        //context: _scaffoldKey.currentContext,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.only(left: 25, right: 25),
              title: Center(child: Text("Lọc bài viết")),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Container(
                height: 600,
                width: 300,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      // LABEL PLANT TAG
                      Text('danh mục loại cây'),
                      // BUILD CHIP PLANT
                      BuildPlantTagChip(),
                      // LABEL CONTENT TAG
                      Text('danh mục nội dung'),
                      // BUILD CHIP PLANT
                      BuildContentTagChip(),
                      // LABEL EXCHANGE TAG
                      Text('danh mục trao đổi'),
                      // BUILD CHIP PLANT
                      BuildExchangeTagChip(),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 70.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.20,
                        child: RaisedButton(
                          child: new Text(
                            'Ok',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color(0xFF121A21),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          onPressed: () {
                            saveFilter();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ],
                )
              ],
            );
          });
        });
  }

  saveFilter() {
    //clear toàn bộ tag ids cũ
    setState(() {
      tagIds.clear();
    });
    //add plant tag mới vào tag ids
    selectedPlantTagList.forEach((element) {
      setState(() {
        tagIds.add(element['id']);
      });
    });
    //add content tag mới vào tag ids
    selectedContentTagList.forEach((element) {
      setState(() {
        tagIds.add(element['id']);
      });
    });
    //add exchange tag mới vào tag ids
    selectedExchangeTagList.forEach((element) {
      setState(() {
        tagIds.add(element['id']);
      });
    });
    setState(() {
      this.skipPostHome = 0;
      postsHome.clear();
      this.skipPostGlobal = 0;
      postsGlobal.clear();
    });
    fetchPostsHome();
    fetchPostsGlobal();
  }

  // BUILD CHIP PLANT
  BuildPlantTagChip() {
    if (_plantTagListIsLoading) return Text('đang tải...');
    return MultiSelectChipFilter(
        selectLimit: 200,
        list: this.plantTagList,
        selectedChoices: this.selectedPlantTagList,
        onSelectionChanged: (selectedList, maxCounter) {
          setState(() {
            selectedPlantTagList = selectedList;
            this.maxPlantTagCounter = maxCounter;
          });
        });
  }

  // BUILD CHIP CONTENT
  BuildContentTagChip() {
    if (_contentTagListIsLoading) return Text('đang tải...');
    return MultiSelectChipFilter(
        selectLimit: 200,
        list: this.contentTagList,
        selectedChoices: this.selectedContentTagList,
        onSelectionChanged: (selectedList, maxCounter) {
          setState(() {
            selectedContentTagList = selectedList;
            this.maxContentTagCounter = maxCounter;
          });
        });
  }

  // BUILD CHIP EXCHANGE
  BuildExchangeTagChip() {
    if (_exchangeTagListIsLoading) return Text('đang tải...');
    return MultiSelectChipFilter(
        selectLimit: 200,
        list: this.exchangeTagList,
        selectedChoices: this.selectedExchangeTagList,
        onSelectionChanged: (selectedList, maxCounter) {
          setState(() {
            selectedExchangeTagList = selectedList;
            this.maxContentTagCounter = maxCounter;
          });
        });
  }

  // A. LIST WIDGET TRÊN APP BAR
  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        //FILTER BUTTON
        IconButton(
          icon: const Icon(
            Icons.filter_alt,
          ),
          onPressed: () {
            showPostFilterDialog();
          },
        ),
        //CANCEL SEARCH BUTTON
        IconButton(
          icon: const Icon(
            Icons.clear,
          ),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }
    return <Widget>[
      //FILTER BUTTON
      IconButton(
        icon: const Icon(
          Icons.filter_alt,
          //color: (this.selectedContentTagList != null) ? Colors.white38,
          color: Colors.white38,
        ),
        onPressed: () {
          showPostFilterDialog();
        },
      ),
      //SEARCH BUTTON
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      stillSendApiPostGlobal = true;
      stillSendApiUser = true;
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  //NAVIGATE TO PROFILE SCREEN
  navigateToUserProfile({int userId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => ProfileScreen(),
        builder: (context) => LoadingProfileScreen(
          userId: userId,
        ),
      ),
    );
  }
}
