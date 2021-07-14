import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/globals/user_global.dart';
import 'package:flutter_login_test_2/helpers/account_manage.dart';
import 'package:flutter_login_test_2/helpers/multi_image_picker_helper.dart';
import 'package:flutter_login_test_2/models/post_detail_model.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/account/avatar_preview.dart';
import 'package:flutter_login_test_2/screens/account/change_password.dart';
import 'package:flutter_login_test_2/screens/account/profile_edit.dart';
import 'package:flutter_login_test_2/screens/chat/chat.dart';
import 'package:flutter_login_test_2/screens/expert/expert_request.dart';
import 'package:flutter_login_test_2/screens/user_plant/user_plant_news_feed.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_login_test_2/widgets/label/expert_label.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../loading/loading_post_detail.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.user, this.currentUserId}) : super(key: key);
  UserModel user;
  int currentUserId;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  UserModel user;
  TabController _tabController;
  //list bài viết của user
  int skipUserPosts = 0;
  int takeUserPosts = 6;
  int skipExchangePosts = 0;
  int takeExchangePosts = 6;
  //bool noMoreDataToFetch = false;
  bool isLoadingUserPosts = false;
  bool isLoadingExchangePosts = false;
  bool stillSendApiUserPosts = true;
  bool stillSendApiExchangePosts = true;
  List<PostDetailModel> postsOfUser = []; //post của user
  List<PostDetailModel> savedPostsOfUser = []; //post được user save
  List<PostDetailModel> postsForExchange = []; //post có tag trao đổi
  //theo dõi user
  bool isFollow;
  //image picker
  List<Asset> images = <Asset>[];
  List<MultipartFile> files = [];
  MultiImagePickerHelper imagePicker = new MultiImagePickerHelper();

  // 1. HÀM GỌI API LẤY DS POST CỦA USER
  fetchPosts() async {
    setState(() {
      isLoadingUserPosts = true;
    });
    var data = {
      'current_user_id': UserGlobal.user['id'],
      'user_id': widget.user.id,
      'skip': this.skipUserPosts,
      'take': takeUserPosts,
    };
    var res = await Network().postData(data, '/post/user_posts');
    var body = json.decode(res.body);

    // Nếu có kết quả trả về
    if (body['posts'].isEmpty == false) {
      List<PostDetailModel> fetchedPosts = [];
      for (var post in body['posts']) {
        PostDetailModel postDetailModel = new PostDetailModel(
            id: post['id'],
            createdAt: post['created_at'],
            thumbNailUrl: post['image_url'],
            title: post['title'],
            content: post['short_content'],
            like: post['like'],
            commentsNumber: post['comments_number']);

        fetchedPosts.add(postDetailModel);
      }
      setState(() {
        this.skipUserPosts += takeUserPosts;
        this.postsOfUser.addAll(fetchedPosts);
        isLoadingUserPosts = false;
        print(skipUserPosts);
      });
    }
    // Nếu kết trả không còn
    else {
      setState(() {
        isLoadingUserPosts = false;
        stillSendApiUserPosts = false;
      });
    }
  }

  // 2. GỌI HÀM LẤY DS POST + CHECK CUỘN BOTTOM ĐỂ GỌI TIẾP
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // check follow
    checkFollow();
    // get post
    fetchPosts();
    fetchSavedPosts();
    fetchExchangePosts();

    _scrollController.addListener(() {
      //nếu cuộn cuối màn hình
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //nếu không còn đang load api
        if (isLoadingUserPosts == false) {
          //nếu còn data để gọi
          if (stillSendApiUserPosts == true) {
            fetchPosts();
          }
          //nếu còn data để gọi
          if (stillSendApiExchangePosts == true) {
            fetchExchangePosts();
          }
        }
      }
    });
  }

  // get saved posts
  fetchSavedPosts() async {
    setState(() {
      isLoadingUserPosts = true;
    });
    var data = {
      'user_id': widget.user.id,
      'current_user_id': UserGlobal.user['id'],
      'skip': this.skipUserPosts,
      'take': takeUserPosts,
    };
    var res = await Network().postData(data, '/post/get_saved_posts');
    var body = json.decode(res.body);

    // Nếu có kết quả trả về
    if (body['posts'].isEmpty == false) {
      List<PostDetailModel> fetchedPosts = [];
      for (var post in body['posts']) {
        PostDetailModel postDetailModel = new PostDetailModel(
            id: post['id'],
            createdAt: post['created_at'],
            thumbNailUrl: post['image_url'],
            title: post['title'],
            content: post['short_content'],
            like: post['like'],
            commentsNumber: post['comments_number']);

        fetchedPosts.add(postDetailModel);
      }
      setState(() {
        this.skipUserPosts += takeUserPosts;
        this.savedPostsOfUser.addAll(fetchedPosts);
        isLoadingUserPosts = false;
        print(skipUserPosts);
      });
    }
    // Nếu kết trả không còn
    else {
      setState(() {
        isLoadingUserPosts = false;
        stillSendApiUserPosts = false;
      });
    }
  }

  // get posts for exchange
  fetchExchangePosts() async {
    setState(() {
      isLoadingExchangePosts = true;
    });
    var data = {
      'user_id': widget.user.id,
      'skip': this.skipExchangePosts,
      'take': takeExchangePosts,
    };
    var res = await Network().postData(data, '/post/get_exchange_posts');
    var body = json.decode(res.body);

    // Nếu có kết quả trả về
    if (body['posts'].isEmpty == false) {
      List<PostDetailModel> fetchedPosts = [];
      for (var post in body['posts']) {
        PostDetailModel postDetailModel = new PostDetailModel(
            id: post['id'],
            createdAt: post['created_at'],
            thumbNailUrl: post['image_url'],
            title: post['title'],
            content: post['short_content'],
            like: post['like'],
            commentsNumber: post['comments_number']);

        fetchedPosts.add(postDetailModel);
      }
      setState(() {
        this.skipExchangePosts += takeExchangePosts;
        this.postsForExchange.addAll(fetchedPosts);
        isLoadingExchangePosts = false;
      });
    }
    // Nếu kết trả không còn
    else {
      setState(() {
        isLoadingExchangePosts = false;
        stillSendApiExchangePosts = false;
      });
    }
  }

  // 3. DISPOSE CONTROLLER
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kAppBarColor,
        title: Text(widget.user.username),
      ),
      body: bodyLayout(),
      bottomNavigationBar: buildBottomNavigationBar(
          context: context, index: kBottomBarIndexProfile),
    );
  }

  // BODY
  bodyLayout() {
    return NestedScrollView(
      controller: this._scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          // USER INFO
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    color: kUserInfoColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.0),
                        // USER INFO
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // AVATAR
                            Container(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  // thay avatar
                                  widget.currentUserId == widget.user.id
                                      ? getAvatar()
                                      : null;
                                },
                                // AVATAR + NÚT ĐỔI AVATAR
                                child: Container(
                                  // NÚT ĐỔI AVATAR
                                  child: widget.currentUserId == widget.user.id
                                      ? Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            width: 20.0,
                                            height: 20.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF294e21),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 15.0,
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  height:
                                      MediaQuery.of(context).size.width - 220,
                                  width:
                                      MediaQuery.of(context).size.width - 220,
                                  // AVATAR
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90.0),
                                      image: DecorationImage(
                                          image: widget.user.avatarUrl != ''
                                              ? NetworkImage(
                                                  widget.user.avatarUrl)
                                              : AssetImage(
                                                  'images/no-avatar.png'),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            // COLUMN INFO
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // LABEL EXPERT
                                  widget.user.roleId == 2
                                      ? expertLabelBuild()
                                      : SizedBox(),
                                  // NAME + SETTING BUTTON
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // NAME
                                      Text(
                                        widget.user.name,
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      // SETTING BUTTON
                                      widget.currentUserId == widget.user.id
                                          ? GearButtonBuild()
                                          : SizedBox(),
                                    ],
                                  ),
                                  Divider(),
                                  // FOLLOW INFO
                                  Row(
                                    children: [
                                      // FOLLOWERS
                                      Column(
                                        children: [
                                          Text(
                                            widget.user.followersNumber
                                                .toString(),
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                          Text(
                                            'followers',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.teal),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      // FOLLOWING
                                      Column(
                                        children: [
                                          Text(
                                            widget.user.followingNumber
                                                .toString(),
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                          Text(
                                            'following',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.teal),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        // BIO
                        Text(widget.user.bio),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // FOLLOW BUTTON
                            widget.currentUserId != widget.user.id
                                ? Container(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: isFollow == true
                                            ? Colors.grey
                                            : Colors.teal,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        followOrUnfollow();
                                      },
                                      child: isFollow == true
                                          ? Text('Đang theo dõi')
                                          : Text('Theo dõi'),
                                    ),
                                    margin:
                                        EdgeInsets.only(right: 2.0, left: 2.0),
                                  )
                                : SizedBox(),
                            // CHAT BUTTON
                            Container(
                              margin: EdgeInsets.only(right: 2.0, left: 2.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.teal,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        userToChat: widget.user,
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Chat'),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // NAVIGATE TAB
          //SliverToBoxAdapter(
          SliverAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            expandedHeight: 80,
            floating:
                true, // <--- this is required if you want the appbar to come back into view when you scroll up
            // pinned: true, // <--- this will make the appbar disappear on scrolling down
            snap: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.teal,
                isScrollable: false,
                tabs: [
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    child: Tab(
                      text: 'Danh sách \nbài viết',
                    ),
                  ),
                  widget.user.id == UserGlobal.user['id']
                      ? Tab(
                          text: 'Bài viết \nđã lưu',
                        )
                      : SizedBox(),
                  Tab(
                    text: 'Bài viết \ntrao đổi cây',
                  ),
                ],
              ),
            ),
            /* child: Center(
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.teal,
                isScrollable: true,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 3.0),
                  insets: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                tabs: [
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Tab(
                      text: 'Danh sách \nbài viết',
                    ),
                  ),
                  Tab(
                    text: 'Bài viết \nđã lưu',
                  ),
                ],
              ),
            ),*/
          ),
        ];
      },
      body: Container(
        child: TabBarView(
          controller: _tabController,
          children: [
            infiniteUserPostsListView(), //LIST DANH SÁCH BÀI POST CỦA USER
            widget.user.id == UserGlobal.user['id']
                ? infiniteSavedPostsListView()
                : SizedBox(), //LIST DANH SÁCH BÀI ĐƯỢC SAVE POST CỦA USER
            infiniteExchangePostsListView(), //LIST DANH SÁCH BÀI CÓ TAG TRAO ĐÔI
          ],
        ),
      ),
    );
  }

  // NÚT GEAR
  Align GearButtonBuild() {
    return Align(
      child: IconButton(
        color: Colors.teal,
        icon: Icon(Icons.settings),
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.white,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                  ),
                ),
                child: ListView(
                  children: [
                    // PLANTS FOR EXCHANGE
                    Ink(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.grass),
                        title: Text('Cây để trao đổi'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserPlantNewsFeedScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    // EDIT INFO BUTTON
                    Ink(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Chỉnh sửa thông tin'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileEditScreen(
                                userModel: widget.user,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // CHANGE PASSWORD
                    Ink(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.lock),
                        title: Text('Thay đổi mật khẩu'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePasswordScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    // REQUEST EXPERT ROLE
                    Ink(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.local_police),
                        title: Text('Yêu cầu làm chuyên gia cây cảnh'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExpertRequestScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    // LOGOUT BUTTON
                    Ink(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Đăng xuất'),
                        onTap: () {
                          AccountManage.logout(context: this.context);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      alignment: Alignment.bottomRight,
    );
  }

  //LIST DANH SÁCH BÀI POST CỦA USER
  infiniteUserPostsListView() {
    return ListView.builder(
      //controller: this._scrollController,
      itemCount: postsOfUser.length,
      physics: const NeverScrollableScrollPhysics(), // new
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                // BÀI VIẾT MINI
                Card(
                  margin: EdgeInsets.all(1),
                  color: Colors.white,
                  shadowColor: Colors.blueGrey,
                  elevation: 1,
                  child: InkWell(
                    child: Row(
                      children: [
                        // THUMBNAIL
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: (postsOfUser[index].thumbNailUrl != null)
                                  ? NetworkImage(
                                      postsOfUser[index].thumbNailUrl,
                                    )
                                  : AssetImage('images/no-image.png'),
                              fit: BoxFit.cover,
                              alignment: AlignmentDirectional.center,
                            ),
                          ),
                        ),
                        // CONTENT
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // TITLE + CONTENT
                              ListTile(
                                title: Text(
                                  postsOfUser[index].title,
                                  style: TextStyle(fontSize: 20),
                                ),
                                subtitle: Text(postsOfUser[index].content),
                              ),
                              // LIKE + COMMENT
                              Row(
                                children: [
                                  SizedBox(width: 15),
                                  // LIKE
                                  Icon(
                                    Icons.thumb_up,
                                    color: Colors.grey,
                                    size: 17,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    postsOfUser[index].like.toString(),
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  SizedBox(width: 20),
                                  // COMMENT
                                  Icon(
                                    Icons.message,
                                    color: Colors.grey,
                                    size: 17,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    postsOfUser[index]
                                        .commentsNumber
                                        .toString(),
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoadingPostDetailScreen(
                            id: postsOfUser[index].id,
                          ),
                          //builder: (context) => PostDetail(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            //isLoading == true ? Text('loading...') : SizedBox(),
          ],
        );
      },
    );
  }

  //LIST DANH SÁCH BÀI POST ĐƯỢC SAVE CỦA USER
  infiniteSavedPostsListView() {
    return ListView.builder(
      //controller: this._scrollController,
      itemCount: savedPostsOfUser.length,
      physics: const NeverScrollableScrollPhysics(), // new
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                // BÀI VIẾT MINI
                Card(
                  margin: EdgeInsets.all(1),
                  color: Colors.white,
                  shadowColor: Colors.blueGrey,
                  elevation: 1,
                  child: InkWell(
                    child: Row(
                      children: [
                        // THUMBNAIL
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  (savedPostsOfUser[index].thumbNailUrl != null)
                                      ? NetworkImage(
                                          savedPostsOfUser[index].thumbNailUrl,
                                        )
                                      : AssetImage('images/no-image.png'),
                              fit: BoxFit.cover,
                              alignment: AlignmentDirectional.center,
                            ),
                          ),
                        ),
                        // CONTENT
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // TITLE + CONTENT
                              ListTile(
                                title: Text(
                                  savedPostsOfUser[index].title,
                                  style: TextStyle(fontSize: 20),
                                ),
                                subtitle: Text(savedPostsOfUser[index].content),
                              ),
                              // LIKE + COMMENT
                              Row(
                                children: [
                                  SizedBox(width: 15),
                                  // LIKE
                                  Icon(
                                    Icons.thumb_up,
                                    color: Colors.grey,
                                    size: 17,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    savedPostsOfUser[index].like.toString(),
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  SizedBox(width: 20),
                                  // COMMENT
                                  Icon(
                                    Icons.message,
                                    color: Colors.grey,
                                    size: 17,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    savedPostsOfUser[index]
                                        .commentsNumber
                                        .toString(),
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoadingPostDetailScreen(
                            id: savedPostsOfUser[index].id,
                          ),
                          //builder: (context) => PostDetail(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            //isLoading == true ? Text('loading...') : SizedBox(),
          ],
        );
      },
    );
  }

  //LIST DANH SÁCH BÀI POST CÓ TAG TRAO ĐỔI
  infiniteExchangePostsListView() {
    return ListView.builder(
      //controller: this._scrollController,
      itemCount: postsForExchange.length,
      physics: const NeverScrollableScrollPhysics(), // new
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                // BÀI VIẾT MINI
                Card(
                  margin: EdgeInsets.all(1),
                  color: Colors.white,
                  shadowColor: Colors.blueGrey,
                  elevation: 1,
                  child: InkWell(
                    child: Row(
                      children: [
                        // THUMBNAIL
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  (postsForExchange[index].thumbNailUrl != null)
                                      ? NetworkImage(
                                          postsForExchange[index].thumbNailUrl,
                                        )
                                      : AssetImage('images/no-image.png'),
                              fit: BoxFit.cover,
                              alignment: AlignmentDirectional.center,
                            ),
                          ),
                        ),
                        // CONTENT
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // TITLE + CONTENT
                              ListTile(
                                title: Text(
                                  postsForExchange[index].title,
                                  style: TextStyle(fontSize: 20),
                                ),
                                subtitle: Text(postsForExchange[index].content),
                              ),
                              // LIKE + COMMENT
                              Row(
                                children: [
                                  SizedBox(width: 15),
                                  // LIKE
                                  Icon(
                                    Icons.thumb_up,
                                    color: Colors.grey,
                                    size: 17,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    postsForExchange[index].like.toString(),
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  SizedBox(width: 20),
                                  // COMMENT
                                  Icon(
                                    Icons.message,
                                    color: Colors.grey,
                                    size: 17,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    postsForExchange[index]
                                        .commentsNumber
                                        .toString(),
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoadingPostDetailScreen(
                            id: postsForExchange[index].id,
                          ),
                          //builder: (context) => PostDetail(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            //isLoading == true ? Text('loading...') : SizedBox(),
          ],
        );
      },
    );
  }

  // CHECK FOLLOW FUNCTION
  Future<void> checkFollow() async {
    var data = {
      'user_id': widget.user.id,
      'current_user_id': widget.currentUserId
    };

    var res = await Network().postData(data, '/user/check_follow');
    var body = json.decode(res.body);

    if (body['result'] == false) {
      setState(() {
        isFollow = false;
      });
    } else {
      setState(() {
        isFollow = true;
      });
    }
  }

  // UNFOLLOW / FOLLOW FUNCTION
  Future<void> followOrUnfollow() async {
    var data = {
      'user_id': widget.user.id,
      'current_user_id': widget.currentUserId
    };
    var res = await Network().postData(data, '/user/follow_user');

    var body = json.decode(res.body);

    if (body['follow'] == false) {
      setState(() {
        isFollow = false;
      });
    } else {
      setState(() {
        isFollow = true;
      });
    }
  }

  // IMAGE PICKER AVATAR
  Future getAvatar() async {
    this.images.clear();
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#294e21",
          actionBarTitle: "Chọn ảnh",
          allViewTitle: "Tất cả hình ảnh",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });

    if (this.images.isEmpty == false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AvatarPreviewScreen(
            images: this.images,
            userId: widget.currentUserId,
          ),
        ),
      );
    }
  }
}
