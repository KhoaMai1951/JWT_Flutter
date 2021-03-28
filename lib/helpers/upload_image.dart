class UploadImageHelper {
  List<String> images;

  UploadImageHelper({this.images});

  factory UploadImageHelper.fromJson(Map<String, dynamic> json) {
    return UploadImageHelper(images: parseImage(json['images']));
  }

  static List<String> parseImage(json) {
    return new List<String>.from(json);
  }
}
