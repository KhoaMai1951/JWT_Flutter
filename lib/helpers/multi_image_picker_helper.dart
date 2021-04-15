import 'package:dio/dio.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class MultiImagePickerHelper {
  MultiImagePickerHelper({
    this.images,
    this.files,
    this.mounted,
    this.setStateFunction,
  });

  var mounted;
  List<Asset> images = <Asset>[];
  List<MultipartFile> files = [];
  Function setStateFunction;

  // IMAGE PICKER AVATAR
  Future getAvatar() async {
    this.images != null ? this.images.clear() : '';
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Chọn ảnh",
          allViewTitle: "Tất cả hình ảnh",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    this.images = resultList;
  }
}
