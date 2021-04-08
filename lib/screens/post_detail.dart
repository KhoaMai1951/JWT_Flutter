import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/models/post_detail_model.dart';
import 'package:flutter_login_test_2/models/tag_model.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostDetail extends StatefulWidget {
  PostDetail({Key key, this.post, this.userOfPost}) : super(key: key);
  int id;
  PostDetailModel post;
  UserModel userOfPost;

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  var currentUser;
  int _current = 0;
  bool isLiked = false;
  int like;
  PostDetailModel post;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    like = widget.post.like;
    _loadUserData();
    checkLikePost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListViews',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Nội dung bài viếthá ha')),
        body: bodyLayout(),
        bottomNavigationBar: buildBottomNavigationBar(
            context: context, index: kBottomBarIndexTestPostDetail),
      ),
    );
  }

  // GET POST
  Future<PostDetailModel> getPost(int searchId) async {
    var res = await Network().getData('/post/get_post?id=$searchId');
    var body = json.decode(res.body);

    // tags model
    List<TagModel> tags = [];
    for (var tag in body['tags']) {
      TagModel tagModel = new TagModel(id: tag['id'], name: tag['name']);
      tags.add(tagModel);
    }
    // post model
    int id = body['post']['id'];
    String title = body['post']['title'];
    String content = body['post']['content'];
    int like = body['post']['like'];
    List<String> imagesForPost = [];
    var createdAt = body['post']['created_at'];
    for (var image in body['images_for_post']) {
      imagesForPost.add(image['dynamic_url']);
    }

    PostDetailModel postDetail = new PostDetailModel(
        id: id,
        like: like,
        title: title,
        content: content,
        imagesForPost: imagesForPost,
        tags: tags,
        createdAt: DateTime.parse(createdAt));

    return postDetail;
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        currentUser = user;
      });
    }
    print(currentUser['id']);
  }

  bodyLayout() {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BÀI VIẾT
              Container(
                margin: const EdgeInsets.only(right: 2, left: 2),
                child: Column(
                  children: [
                    // THÔNG TIN USER
                    Row(
                      children: [
                        // USERNAME
                        Text('Bởi '),
                        Text(
                          widget.userOfPost.username,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    // TIÊU ĐỀ BÀI VIẾT
                    Text(
                      widget.post.title,
                      style: TextStyle(
                          fontSize: 40.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    // NỘI DUNG BÀI VIẾT
                    Text(
                      widget.post.content,
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ],
                ),
              ),
              // IMAGES CAROUSEL
              ImageCarouselBuilder(),
              // CAROUSEL INDICATOR
              CarouselIndicator(),
              // LIKE + COMMENT ICON
              Row(
                children: [
                  IconButton(
                    color: this.isLiked == true ? Colors.teal : Colors.grey,
                    icon: const Icon(Icons.thumb_up),
                    onPressed: () {
                      likePost();
                    },
                  ),
                  Text(like.toString()),
                ],
              ),
              // BÌNH LUẬN
              CommentBubble(),
              CommentBubble(),
            ],
          ),
        )
      ],
    );
  }

  // COMMENT
  CommentBubble() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.circular(10.0),
            elevation: 5.0,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'username',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'This method will save memory by building items once it becomes necessary. This way they wont be built if theyre not currently meant to be visible on screen. It can be used to build different child item widgets related to content or by item index.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // IMAGE CAROUSEL
  ImageCarouselBuilder() {
    return Row(
      children: [
        Expanded(
          child: CarouselSlider(
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
              scrollDirection: Axis.horizontal,
            ),
            items: widget.post.imagesForPost.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    child: Center(
                      child: Image.network(i, fit: BoxFit.cover, width: 1000),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // CAROUSEL INDICATOR
  CarouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: map<Widget>(widget.post.imagesForPost, (index, url) {
        return Container(
          width: 10.0,
          height: 10.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _current == index ? Colors.green : Colors.grey,
          ),
        );
      }),
    );
  }

  // CAROUSEL INDICATOR FUNCTION
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  // CHECK LIKE FUNCTION
  Future<void> checkLikePost() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    var res = await Network().getData('/post/check_like_post?post_id=' +
        widget.post.id.toString() +
        '&user_id=' +
        user['id'].toString());

    var body = json.decode(res.body);
    print(body);
    if (body['result'] == false) {
      setState(() {
        isLiked = false;
      });
    } else {
      setState(() {
        isLiked = true;
      });
    }
  }

  // LIKE FUNCTION
  Future<void> likePost() async {
    var res = await Network().getData('/post/like_post?post_id=' +
        widget.post.id.toString() +
        '&user_id=' +
        this.currentUser['id'].toString());

    var body = json.decode(res.body);
    print(body);
    // handle number of likes
    setState(() {
      like = body['likes']['like'];
    });

    // unliked
    if (body['liked'] == false) {
      setState(() {
        this.isLiked = false;
      });
    }
    // liked
    else {
      setState(() {
        this.isLiked = true;
      });
    }
  }
}
