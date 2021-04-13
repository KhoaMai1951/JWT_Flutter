import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/models/post_detail_model.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:intl/intl.dart';

import 'loading/loading_post_detail.dart';
import 'loading/loading_user_profile.dart';

class NewsFeedScreen extends StatefulWidget {
  NewsFeedScreen({Key key, this.user}) : super(key: key);
  UserModel user;
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  // Biến phục vụ cho comment infinite scroll
  int skip = 0;
  int take = 6;
  bool isLoading = false;
  bool stillSendApi = true;
  List<PostDetailModel> posts = [];
  ScrollController _scrollController = new ScrollController();

  //1. HÀM GỌI API LẤY DS POST THEO CỤM
  fetchPosts() async {
    setState(() {
      isLoading = true;
    });
    var data = {
      'user_id': widget.user.id,
      'skip': this.skip,
      'take': take,
    };
    var res = await Network().postData(data, '/post/get_all_posts_by_chunk');
    var body = json.decode(res.body);

    // Nếu có kết quả trả về
    if (body['posts'].isEmpty == false) {
      List<PostDetailModel> fetchedPosts = [];
      for (var post in body['posts']) {
        UserModel userModel = new UserModel(
          id: post['user']['id'],
          username: post['user']['username'],
          avatarUrl: post['user']['avatar_url'],
        );

        PostDetailModel postModel = new PostDetailModel(
          id: post['id'],
          createdAt: post['created_at'],
          thumbNailUrl: post['image_url'],
          title: post['title'],
          content: post['short_content'],
          like: post['like'],
          commentsNumber: post['comments_number'],
          user: userModel,
        );

        fetchedPosts.add(postModel);
      }
      setState(() {
        this.skip += take;
        this.posts.addAll(fetchedPosts);
        isLoading = false;
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

    // get post
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Trang chính',
        ),
        backgroundColor: Colors.teal,
      ),
      body: bodyLayout(),
      bottomNavigationBar: buildBottomNavigationBar(
          context: context, index: kBottomBarIndexNewsFeed),
    );
  }

  bodyLayout() {
    return ListView.builder(
      controller: this._scrollController,
      itemCount: posts.length,
      physics: const AlwaysScrollableScrollPhysics(), // new
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                // BÀI VIẾT MINI
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // BÀI VIẾT
                    Container(
                      margin: const EdgeInsets.only(right: 2, left: 2),
                      child: Column(
                        children: [
                          // THÔNG TIN USER
                          Row(
                            children: [
                              // AVATAR
                              Container(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90.0),
                                      image: DecorationImage(
                                          image: posts[index].user.avatarUrl !=
                                                  ''
                                              ? NetworkImage(
                                                  posts[index].user.avatarUrl)
                                              : AssetImage(
                                                  'images/no-image.png'),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              // USERNAME
                              InkWell(
                                child: Text(
                                  posts[index].user.username,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  navigateToUserProfile(
                                      userId: posts[index].user.id);
                                },
                              ),
                            ],
                          ),
                          // NGÀY
                          Row(
                            children: [
                              // NGÀY
                              Text(
                                timeAgoSinceDate(
                                    dateString: posts[index].createdAt),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          // TIÊU ĐỀ BÀI VIẾT
                          InkWell(
                            onTap: () {
                              navigateToPostDetail(postId: posts[index].id);
                            },
                            child: Text(
                              posts[index].title,
                              style: TextStyle(
                                  fontSize: 40.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          // NỘI DUNG BÀI VIẾT
                          InkWell(
                            onTap: () {
                              navigateToPostDetail(postId: posts[index].id);
                            },
                            child: Text(
                              posts[index].content,
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    // LIKE + COMMENT ICON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // LIKE ICON
                        IconButton(
                          iconSize: 30.0,
                          color: Colors.grey,
                          icon: const Icon(Icons.thumb_up),
                        ),
                        // LIKE NUMBER
                        Text(
                          posts[index].like.toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        // COMMENT ICON
                        Icon(
                          Icons.chat,
                          size: 27.0,
                        ),
                        SizedBox(
                          width: 7.0,
                        ),
                        // COMMENT NUMBER
                        Text(
                          posts[index].commentsNumber.toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                    // BÌNH LUẬN
                    //CommentList(),
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
    );
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

  //NAVIGATE TO PROFILE SCREEN
  navigateToPostDetail({int postId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => ProfileScreen(),
        builder: (context) => LoadingPostDetailScreen(
          id: postId,
        ),
      ),
    );
  }

  // GET TIME AGO
  static String timeAgoSinceDate(
      {String dateString, bool numericDates = true}) {
    DateTime notificationDate = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      //return dateString.toString();
      return DateFormat('dd-MM-yyyy').format(DateTime.parse(dateString)) +
          ' lúc ' +
          DateFormat('HH:mm').format(DateTime.parse(dateString));
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 tuần trước' : 'Tuần trước';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 ngày trước' : 'Hôm qua';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 giờ trước' : 'Một giờ trước';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 phút trước' : 'Một phút trước';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} giây trước';
    } else {
      return 'Vừa đây';
    }
  }
}
