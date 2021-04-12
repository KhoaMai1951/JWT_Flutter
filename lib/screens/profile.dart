import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/helpers/account_manage.dart';
import 'package:flutter_login_test_2/models/post_detail_model.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/post_detail.dart';
import 'package:flutter_login_test_2/screens/submit_post.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_login_test_2/widgets/user_post_infinite_list/user_post_infinite_list.dart';

import 'loading/loading_post_detail.dart';

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
  int skip = 0;
  int take = 6;
  //bool noMoreDataToFetch = false;
  bool isLoading = false;
  bool stillSendApi = true;
  List<PostDetailModel> posts = [];

  // 1. HÀM GỌI API LẤY DS POST CỦA USER
  fetchPosts() async {
    setState(() {
      isLoading = true;
    });
    var data = {
      'user_id': widget.user.id,
      'skip': this.skip,
      'take': take,
    };
    var res = await Network()
        .postData(data, '/post/get_all_posts_by_chunk_by_user_id');
    var body = json.decode(res.body);

    // Nếu có kết quả trả về
    if (body['posts'].isEmpty == false) {
      List<PostDetailModel> fetchedPosts = [];
      for (var post in body['posts']) {
        PostDetailModel cmt = new PostDetailModel(
            id: post['id'],
            createdAt: post['created_at'],
            thumbNailUrl: post['image_url'],
            title: post['title'],
            content: post['short_content'],
            like: post['like'],
            commentsNumber: post['comments_number']);

        fetchedPosts.add(cmt);
      }
      setState(() {
        this.skip += take;
        this.posts.addAll(fetchedPosts);
        isLoading = false;
        print(skip);
      });
    }
    // Nếu kết trả không còn
    else {
      setState(() {
        stillSendApi = false;
      });
    }
  }

  // 2. GỌI HÀM LẤY DS POST + CHECK CUỘN BOTTOM ĐỂ GỌI TIẾP
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    fetchPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (isLoading == false) {
          if (stillSendApi == true) {
            fetchPosts();
          }
        }
      }
    });
  }

  // 3. DISPOSE CONTROLLER
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListViews',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(widget.user.username),
          ),
        ),
        body: bodyLayout(),
        bottomNavigationBar: buildBottomNavigationBar(
            context: context, index: kBottomBarIndexProfile),
      ),
    );*/

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.0),
                // USER INFO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // AVATAR
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90.0),
                            image: DecorationImage(
                                image: widget.user.avatarUrl != ''
                                    ? NetworkImage(widget.user.avatarUrl)
                                    : AssetImage('images/no-image.png'),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    // COLUMN INFO
                    Column(
                      children: [
                        // NAME + SETTING BUTTON
                        Row(
                          children: [
                            // NAME
                            Align(
                              child: Text(
                                widget.user.name,
                                style: TextStyle(fontSize: 18.0),
                              ),
                              alignment: Alignment.bottomLeft,
                            ),

                            // SETTING BUTTON
                            widget.currentUserId == widget.user.id
                                ? GearButtonBuild()
                                : SizedBox(),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),

                        SizedBox(
                          height: 10.0,
                        ),
                        // FOLLOW INFO
                        Row(
                          children: [
                            // FOLLOWERS
                            Column(
                              children: [
                                Text(
                                  widget.user.followersNumber.toString(),
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                Text(
                                  'người theo dõi',
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.teal),
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
                                  widget.user.followingNumber.toString(),
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                Text(
                                  'đang theo dõi',
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.teal),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                // BIO
                Text(widget.user.bio),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
          // NAVIGATE TAB
          SliverToBoxAdapter(
            child: Center(
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.teal,
                isScrollable: true,
                tabs: [
                  Tab(text: 'Danh sách \nbài viết'),
                  Tab(text: 'Tab 2'),
                  Tab(text: 'Tab 3'),
                  Tab(text: 'Tab 4'),
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
            infiniteListView(),
            Container(
              child: Center(
                child: Text('Display Tab 3',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              child: Center(
                child: Text('Display Tab 3',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              child: Center(
                child: Text(
                  'Display Tab 4',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
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
                    // EDIT INFO BUTTON
                    Ink(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Chỉnh sửa thông tin'),
                        onTap: () {},
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
  infiniteListView() {
    return ListView.builder(
      //controller: this._scrollController,
      itemCount: posts.length,
      physics: const NeverScrollableScrollPhysics(), // new
      itemBuilder: (context, index) {
        /*return ListView(
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
                          image: posts[index].thumbNailUrl != ''
                              ? NetworkImage(
                                  posts[index].thumbNailUrl,
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
                              posts[index].title,
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: Text(posts[index].content),
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
                                posts[index].like.toString(),
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
                                posts[index].commentsNumber.toString(),
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
                        id: posts[index].id,
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
        );*/
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
                              image: posts[index].thumbNailUrl != ''
                                  ? NetworkImage(
                                      posts[index].thumbNailUrl,
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
                                  posts[index].title,
                                  style: TextStyle(fontSize: 20),
                                ),
                                subtitle: Text(posts[index].content),
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
                                    posts[index].like.toString(),
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
                                    posts[index].commentsNumber.toString(),
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
                            id: posts[index].id,
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
}
