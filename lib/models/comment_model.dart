import 'package:flutter_login_test_2/models/user_model.dart';

class CommentModel {
  int userId;
  int postId;
  String content;
  int id;
  String createdAt;
  String username;
  String avatarLink;
  String imageUrl;
  int likes;
  bool isLiked;
  UserModel userModel;

  CommentModel({
    this.createdAt,
    this.id,
    this.username,
    this.content,
    this.userId,
    this.postId,
    this.avatarLink,
    this.imageUrl,
    this.likes,
    this.isLiked,
    this.userModel,
  });
}
