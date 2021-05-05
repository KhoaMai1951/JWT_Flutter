import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/models/post_detail_model.dart';
import 'package:flutter_login_test_2/models/tag_model.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/blank/no_post.dart';
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
          lineWidth: 3.0,
          size: 40.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handleRedirect(searchId: widget.id);
  }

  // HANDLE REDIRECT LOGIC
  handleRedirect({int searchId}) async {
    // FETCH POST
    var res = await Network().getData('/post/get_post?id=$searchId');
    // IF STATUS 400
    if (res.statusCode == 400) {
      redirectNoPost();
      return;
    }
    // ELSE
    var body = json.decode(res.body);
    // tags model
    List<TagModel> tags = handleTagObject(body);
    // user model
    UserModel user = handleUserObject(body);
    // post model
    PostDetailModel postDetail = handlePostObject(body, tags, user);
    // REDIRECT TO POST DETAIL
    redirectPostDetail(userOfPost: user, postDetailModel: postDetail);
  }

  // HANDLE TAG MODEL
  handleTagObject(var body) {
    List<TagModel> tags = [];
    for (var tag in body['tags']) {
      TagModel tagModel = new TagModel(id: tag['id'], name: tag['name']);
      tags.add(tagModel);
    }
    return tags;
  }

  // HANDLE USER MODEL
  handleUserObject(var body) {
    int userId = body['user']['id'];
    String username = body['user']['username'];
    String avatarUrl = body['post']['user']['avatar_url'];
    int roleId = body['post']['user']['role_id'];

    return new UserModel(
      id: userId,
      username: username,
      avatarUrl: avatarUrl,
      roleId: roleId,
    );
  }

  // HANDLE POST MODEL
  handlePostObject(var body, var tags, var user) {
    int id = body['post']['id'];
    String title = body['post']['title'];
    String content = body['post']['content'];
    int like = body['post']['like'];
    int commentsNumber = body['comments_number'];
    List<String> imagesForPost = [];
    String createdAt = body['post']['created_at'];
    bool isLiked = body['post']['is_liked'];

    for (var image in body['images_for_post']) {
      imagesForPost.add(image['dynamic_url']);
    }

    return new PostDetailModel(
      id: id,
      like: like,
      commentsNumber: commentsNumber,
      title: title,
      content: content,
      imagesForPost: imagesForPost,
      tags: tags,
      createdAt: createdAt,
      isLiked: isLiked,
      currentImageIndicator: 0,
      user: user,
    );
  }

  // REDIRECT TO POST DETAIL
  redirectPostDetail({UserModel userOfPost, PostDetailModel postDetailModel}) {
    // pop trang loading ra khỏi stack
    Navigator.pop(context);
    // push vào stack trang post detail
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return PostDetail(
          userOfPost: userOfPost,
          post: postDetailModel,
        );
      }),
    );
  }

  // REDIRECT TO NO POST
  redirectNoPost() {
    // pop trang loading ra khỏi stack
    Navigator.pop(context);
    // push vào stack trang post detail
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return NoPostScreen();
      }),
    );
  }
}
