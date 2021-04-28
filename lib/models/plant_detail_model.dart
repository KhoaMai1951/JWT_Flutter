class PlantDetailModel {
  int id;
  String imageUrl;
  String commonName;
  String scientificName;
  bool isSaved;
  bool petFriendly;
  int difficulty;
  int waterLevel;
  int sunLight;
  String information;
  String feedInformation;
  String commonIssue;
  List<dynamic> temperatureRange = [];
  List<int> pHRange = [];

  PlantDetailModel({
    this.id,
    this.imageUrl,
    this.commonName,
    this.scientificName,
    this.isSaved,
    this.petFriendly,
    this.difficulty,
    this.waterLevel,
    this.information,
    this.sunLight,
    this.feedInformation,
    this.commonIssue,
    this.temperatureRange,
    this.pHRange,
  });
}
