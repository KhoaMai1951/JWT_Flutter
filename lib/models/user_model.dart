class UserModel {
  UserModel(
      {this.bio,
      this.email,
      this.name,
      this.username,
      this.id,
      this.avatarUrl,
      this.followersNumber,
      this.followingNumber});

  String bio;
  String name;
  String email;
  String username;
  int id;
  String avatarUrl;
  int followingNumber;
  int followersNumber;
}
