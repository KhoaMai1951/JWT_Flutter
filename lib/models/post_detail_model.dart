import 'package:flutter/cupertino.dart';
import 'package:flutter_login_test_2/models/tag_model.dart';

class PostDetailModel {
  PostDetailModel(
      {this.id,
      this.title,
      this.content,
      this.createdAt,
      this.thumbNailUrl,
      this.commentsNumber,
      this.like,
      this.imagesForPost,
      this.tags});

  int id;
  String title;
  String content;
  String createdAt;
  String thumbNailUrl;
  int like;
  int commentsNumber;
  List<String> imagesForPost;
  List<TagModel> tags;
}
