import 'package:flutter/cupertino.dart';
import 'package:flutter_login_test_2/models/tag_model.dart';

class PostDetailModel {
  PostDetailModel(
      {this.id,
      this.title,
      this.content,
      this.createdAt,
      this.like,
      this.imagesForPost,
      this.tags});

  int id;
  String title;
  String content;
  var createdAt;
  int like;
  List<String> imagesForPost;
  List<TagModel> tags;
}
