class CommentModel {
  int userId;
  int postId;
  String content;
  int id;
  String createdAt;
  String username;
  String avatarLink;

  CommentModel({
    this.createdAt,
    this.id,
    this.username,
    this.content,
    this.userId,
    this.postId,
    this.avatarLink,
  });
}
