class PlantDetailModel {
  int id;
  String imageUrl;
  String commonName;
  String scientificName;
  bool isSaved;
  bool petFriendly;
  int difficulty;
  int waterLevel;
  String information;
  String sunLight;
  String feedInformation;
  String commonIssue;
  List<int> temperatureRange = [];
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
