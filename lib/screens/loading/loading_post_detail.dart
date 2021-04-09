import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/models/post_detail_model.dart';
import 'package:flutter_login_test_2/models/tag_model.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/post_detail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPostDetailScreen extends StatefulWidget {
  LoadingPostDetailScreen({Key key, this.id}) : super(key: key);
  int id;
  @override
  _LoadingPostDetailScreenState createState() =>
      _LoadingPostDetailScreenState();
}

class _LoadingPostDetailScreenState extends State<LoadingPostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitRing(
          color: Colors.teal,
          size: 100.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPost(searchId: widget.id);
  }

  getPost({int searchId}) async {
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
    int commentsNumber = body['comments_number'];
    List<String> imagesForPost = [];
    String createdAt = body['post']['created_at'];
    for (var image in body['images_for_post']) {
      imagesForPost.add(image['dynamic_url']);
    }

    PostDetailModel postDetail = new PostDetailModel(
        id: id,
        like: like,
        commentsNumber: commentsNumber,
        title: title,
        content: content,
        imagesForPost: imagesForPost,
        tags: tags,
        createdAt: createdAt);

    // user model
    int userId = body['user']['id'];
    String username = body['user']['username'];

    UserModel user = new UserModel(id: userId, username: username);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return PostDetail(
          userOfPost: user,
          post: postDetail,
        );
      }),
    );
  }
}
