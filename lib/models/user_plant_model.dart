class UserPlantModel {
  UserPlantModel({
    this.id,
    this.scientificName,
    this.commonName,
    this.like,
    this.commentsNumber,
    this.currentImageIndicator,
    this.userId,
    this.description,
    this.imagesForUserPlant,
    this.thumbnailImage,
    this.accepted,
  });

  String commonName;
  String scientificName = '';
  String description;
  int id;
  int userId;
  List<String> imagesForUserPlant;
  String thumbnailImage;
  int like;
  int commentsNumber;
  int currentImageIndicator = 0;
  int accepted = 0;
}
