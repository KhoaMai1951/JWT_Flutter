import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/globals/user_global.dart';
import 'package:flutter_login_test_2/models/post_detail_model.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_login_test_2/widgets/post_mini/post_mini.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  // Biến phục vụ cho image carousel
  int _currentImageIndicator = 0;

  // 1. HÀM GỌI API LẤY DS POST THEO CỤM
  fetchPosts() async {
    setState(() {
      isLoading = true;
    });
    var data = {
      'user_id': UserGlobal.user['id'],
      'skip': this.skip,
      'take': take,
    };
    var res = await Network().postData(
        data, '/post/get_all_posts_of_following_users_by_chunk_by_user_id');
    var body = json.decode(res.body);

    // Nếu có kết quả trả về
    if (body['posts'].isEmpty == false) {
      List<PostDetailModel> fetchedPosts = [];
      for (var post in body['posts']) {
        // user handle
        UserModel userModel = new UserModel(
          id: post['user']['id'],
          username: post['user']['username'],
          avatarUrl: post['user']['avatar_url'],
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
        isLoading = false;
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
        backgroundColor: kAppBarColor,
      ),
      body: bodyLayout(),
      bottomNavigationBar: buildBottomNavigationBar(
          context: context, index: kBottomBarIndexNewsFeed),
    );
  }

  bodyLayout() {
    return Column(
      children: [
        // NEWSFEED
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
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
                      PostMini(
                        currentUserId: UserGlobal.user['id'],
                        post: posts[index],
                        onImageChange: (int currentImageIndexIndicator) {
                          setState(() {
                            posts[index].currentImageIndicator =
                                currentImageIndexIndicator;
                          });
                        },
                        onLikePost: (int numberOfLikes, bool isLiked) {
                          setState(() {
                            posts[index].like = numberOfLikes;
                            posts[index].isLiked = isLiked;
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
        isLoading == true
            ? SpinKitRing(
                color: Colors.teal,
                lineWidth: 3.0,
                size: 40.0,
              )
            : SizedBox(),
      ],
    );
  }

  // LIKE FUNCTION
  Future<void> likePost({int postId, int userId, int currentPostsIndex}) async {
    var res = await Network().getData('/post/like_post?post_id=' +
        postId.toString() +
        '&user_id=' +
        userId.toString());

    var body = json.decode(res.body);

    // handle number of likes + like/unlike condition
    setState(() {
      posts[currentPostsIndex].isLiked = body['liked'];
      posts[currentPostsIndex].like = body['likes']['like'];
    });
  }
}
