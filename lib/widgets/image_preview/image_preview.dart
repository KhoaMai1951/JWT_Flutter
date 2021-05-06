// XUẤT HÌNH TỪ LIST ASSET RA ĐỂ REVIEW
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImagePreview extends StatefulWidget {
  List<Asset> images;
  int listCount;
  Function deleteImageFunction;
  ImagePreview({
    this.images,
    this.listCount,
    this.deleteImageFunction,
  });
  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return widget.images.length != 0
        ? GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: widget.listCount,
            children: List.generate(widget.images.length, (index) {
              Asset asset = widget.images[index];
              return Stack(
                children: <Widget>[
                  AssetThumb(
                    asset: asset,
                    width: 300,
                    height: 300,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: ClipOval(
                      child: Material(
                        color: Colors.white, // button color
                        child: InkWell(
                          splashColor: Colors.red, // inkwell color
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: Icon(
                              Icons.delete,
                              color: Colors.grey,
                              size: 15.0,
                            ),
                          ),
                          onTap: () {
                            widget.deleteImageFunction(index);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          )
        : SizedBox();
  }
}
