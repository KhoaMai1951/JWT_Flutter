import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/constants/text_style.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ContributePlantScreen extends StatefulWidget {
  @override
  _ContributePlantScreenState createState() => _ContributePlantScreenState();
}

class _ContributePlantScreenState extends State<ContributePlantScreen> {
  List<Asset> images = <Asset>[];
  List<MultipartFile> files = [];
  final _formKey = GlobalKey<FormState>();
  //enable info
  var contributorNameEnable = false;
  //for pet toggle
  int initialIndex = 0;
  //plant info
  String contributorName;
  String commonName;
  String scientificName;
  bool petFriendly = false;
  int difficulty;
  double waterLevel = 1;
  double sunLight = 1;
  String information;
  String feedInformation;
  String commonIssue;
  double maxTemperature = 30;
  double minTemperature = 1;
  //range
  RangeValues temperatureRangeValue = const RangeValues(20, 30);
  List<String> waterLevelString = [
    'thỉnh thoảng',
    'thỉnh thoảng\n-thường xuyên',
    'thường xuyên',
    'thường xuyên\n-liên tục',
    'liên tục',
  ];
  List<String> sunlightLevelString = [
    'bóng râm',
    'bóng râm\n-tránh trực tiếp',
    'tránh trực tiếp',
    'tránh trực tiếp\n-ngoài trời',
    'ngoài trời',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text('🌷  Đóng góp cây cảnh mới'),
      ),
      body: bodyLayout(),
      bottomNavigationBar: buildBottomNavigationBar(
          context: context, index: kBottomBarIndexPlant),
    );
  }

  bodyLayout() {
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: [
        Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CONTRIBUTOR NAME LABEL ====================================
                  labelBuilder(
                    label: 'Thông tin người đóng góp',
                  ),
                  // NAME TEXTFIELD
                  textFormFieldBuilder(
                    label: 'Tên \*',
                    hintText: 'Tên',
                    validateFunction: (value) {
                      if (value.length > 100) {
                        return 'Tên phải nhỏ hơn 100 kí tự';
                      }
                      if (value.length == 0) {
                        return 'Phải nhập tên';
                      }
                      setState(() {
                        this.contributorName = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  // CONTRIBUTOR NAME LABEL ====================================
                  labelBuilder(
                    label: 'Thông tin cây cảnh',
                  ),
                  // COMMON NAME TEXT FIELD
                  textFormFieldBuilder(
                    label: 'Tên thường gọi \*',
                    hintText: 'Tên thường gọi',
                    validateFunction: (value) {
                      if (value.length > 100) {
                        return 'Tên phải nhỏ hơn 100 kí tự';
                      }
                      if (value.length == 0) {
                        return 'Phải nhập tên';
                      }
                      setState(() {
                        this.commonName = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // COMMON NAME TEXT FIELD
                  textFormFieldBuilder(
                    label: 'Tên khoa học \*',
                    hintText: 'Tên khoa học',
                    validateFunction: (value) {
                      if (value.length > 100) {
                        return 'Tên phải nhỏ hơn 100 kí tự';
                      }
                      if (value.length == 0) {
                        return 'Phải nhập tên';
                      }
                      setState(() {
                        this.scientificName = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // COMMON NAME TEXT FIELD
                  textFormFieldBuilder(
                    label: 'Mô tả \*',
                    hintText: 'Mô tả',
                    maxLines: 5,
                    validateFunction: (value) {
                      if (value.length > 4000) {
                        return 'Tên phải nhỏ hơn 4000 kí tự';
                      }
                      if (value.length == 0) {
                        return 'Phải nhập tên';
                      }
                      setState(() {
                        this.information = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  // WATER LABEL ====================================
                  labelBuilder(
                    label: 'Tưới nước',
                  ),
                  // SLIDER LABEL
                  sliderLabelBuilder(
                      currentLevel: waterLevel,
                      labelList: waterLevelString,
                      length: 5),
                  // WATER LEVEL SLIDER
                  sliderBuilder(
                      currentLevel: waterLevel,
                      divisions: 4,
                      max: 5,
                      min: 1,
                      function: (double value) {
                        setState(() {
                          waterLevel = value;
                        });
                      }),
                  SizedBox(
                    height: 60.0,
                  ),
                  // SUNLIGHT LABEL ====================================
                  labelBuilder(
                    label: 'Ánh sáng mặt trời',
                  ),
                  // SLIDER LABEL
                  sliderLabelBuilder(
                      currentLevel: sunLight,
                      labelList: sunlightLevelString,
                      length: 5),
                  // SUNLIGHT LEVEL SLIDER
                  sliderBuilder(
                      currentLevel: sunLight,
                      divisions: 4,
                      max: 5,
                      min: 1,
                      function: (double value) {
                        setState(() {
                          sunLight = value;
                        });
                      }),
                  SizedBox(
                    height: 60.0,
                  ),
                  // CONTRIBUTOR NAME LABEL ====================================
                  labelBuilder(
                    label: 'Nhiệt độ',
                  ),
                  //SLIDER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //degree
                      Expanded(
                        flex: 1,
                        child: Text(
                          temperatureRangeValue.start.round().toString() + '°C',
                        ),
                      ),
                      // SLIDER
                      Expanded(
                        flex: 8,
                        child: SliderTheme(
                          data: SliderThemeData(
                            thumbColor: Colors.green,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 11),
                            activeTrackColor: Colors.green,
                            inactiveTrackColor: Colors.grey,
                            activeTickMarkColor: Colors.green,
                            inactiveTickMarkColor: Colors.grey,
                            tickMarkShape:
                                RoundSliderTickMarkShape(tickMarkRadius: 8.0),
                          ),
                          child: RangeSlider(
                            values: temperatureRangeValue,
                            min: 0,
                            max: 50,
                            divisions: 49,
                            onChanged: (RangeValues values) {
                              setState(() {
                                temperatureRangeValue = values;
                              });
                            },
                          ),
                        ),
                      ),
                      //degree
                      Expanded(
                        flex: 1,
                        child: Align(
                          child: Text(
                            temperatureRangeValue.end.round().toString() + '°C',
                          ),
                          alignment: Alignment.bottomRight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  // PET FRIENDLY LABEL ====================================
                  labelBuilder(
                    label: 'Thân thiện thú cưng',
                  ),
                  Center(
                    child: ToggleSwitch(
                        initialLabelIndex: initialIndex,
                        minWidth: 90.0,
                        cornerRadius: 20,
                        activeBgColor: Colors.green,
                        inactiveBgColor: Colors.grey,
                        labels: ['CÓ', 'KHÔNG'],
                        onToggle: (index) {
                          setState(() {
                            initialIndex = index;
                            index == 0
                                ? petFriendly = true
                                : petFriendly = false;
                          });
                        }),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  // CONTRIBUTOR NAME LABEL ====================================
                  labelBuilder(
                    label: 'Bón phân',
                  ),
                  // NAME TEXTFIELD
                  textFormFieldBuilder(
                    maxLines: 4,
                    label: 'Bón phân',
                    hintText: 'Bón phân',
                    validateFunction: (value) {
                      if (value.length > 1000) {
                        return 'Tên phải nhỏ hơn 1000 kí tự';
                      }
                      if (value.length == 0) {
                        return 'Phải nhập tên';
                      }
                      setState(() {
                        this.feedInformation = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  // CONTRIBUTOR NAME LABEL ====================================
                  labelBuilder(
                    label: 'Các vấn đề thường gặp',
                  ),
                  // NAME TEXTFIELD
                  textFormFieldBuilder(
                    maxLines: 4,
                    label: 'Các vấn đề thường gặp',
                    hintText: 'Các vấn đề thường gặp',
                    validateFunction: (value) {
                      if (value.length > 1000) {
                        return 'Tên phải nhỏ hơn 1000 kí tự';
                      }
                      if (value.length == 0) {
                        return 'Phải nhập tên';
                      }
                      setState(() {
                        this.commonIssue = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  // CONTRIBUTOR NAME LABEL ====================================
                  labelBuilder(
                    label: 'Hình ảnh',
                  ),
                  // CHOOSE PIC
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kButtonColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.insert_photo),
                          Text("Chọn ảnh"),
                        ],
                      ),
                      onPressed: loadAssets,
                    ),
                  ),
                  // VÙNG REVIEW ẢNH ĐÃ CHỌN
                  buildGridView(),
                  SizedBox(
                    height: 30.0,
                  ),
                  Divider(
                    color: kBottomBarColor,
                    thickness: 2.0,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  // SUBMIT BUTTON
                  submitButton(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // SUBMIT BUTTON
  submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(kButtonColor),
            ),
            onPressed: () {
              if (_formKey.currentState.validate() == true) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
              }
            },
            child: Text('Đóng góp'),
          ),
        ],
      ),
    );
  }

  // TEXT FORM FIELD
  textFormFieldBuilder(
      {String label,
      int maxLines,
      String hintText,
      Function validateFunction}) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          color: Colors.blueGrey,
        ),
        labelText: label,
        hintText: hintText,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: validateFunction,
    );
  }

  // LABEL
  labelBuilder({String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TITLE CONTRIBUTOR NAME
        Text(
          label,
          style: kContributeLabel,
        ),
        SizedBox(height: 10.0),
        Divider(
          color: kBottomBarColor,
          thickness: 2.0,
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  // SLIDER
  sliderBuilder({
    double min,
    double max,
    int divisions,
    double currentLevel,
    Function function,
  }) {
    return SliderTheme(
      data: SliderThemeData(
        thumbColor: Colors.green,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 11),
        activeTrackColor: Colors.green,
        inactiveTrackColor: Colors.grey,
        activeTickMarkColor: Colors.green,
        inactiveTickMarkColor: Colors.grey,
        tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 8.0),
      ),
      child: Slider(
        value: currentLevel,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: function,
      ),
    );
  }

  // SLIDER LABEL
  sliderLabelBuilder(
      {int length, double currentLevel, List<String> labelList}) {
    return Container(
      height: 35.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(length, (index) {
          if (index + 1 == currentLevel)
            return Text(labelList[index]);
          else
            return SizedBox();
        }),
      ),
    );
  }

  // LẤY ẢNH TRONG GALLERY VÀO LIST ASSET
  Future<void> loadAssets() async {
    this.images.clear();
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
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
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

    setState(() {
      images = resultList;
    });
  }

  // CONVERT TỪ ASSET SANG MULTIPLE PART FILE
  Future<dynamic> assetToFile() async {
    files.clear();

    //images.forEach((asset) async {
    for (var asset in images) {
      int MAX_WIDTH = 500; //keep ratio
      int height = ((500 * asset.originalHeight) / asset.originalWidth).round();

      ByteData byteData =
          await asset.getThumbByteData(MAX_WIDTH, height, quality: 80);

      if (byteData != null) {
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile u =
            await MultipartFile.fromBytes(imageData, filename: asset.name);

        setState(() {
          this.files.add(u);
        });
      }
    }
    ;

    return files;
  }

  // XUẤT HÌNH TỪ LIST ASSET RA ĐỂ REVIEW
  Widget buildGridView() {
    return this.images.length != 0
        ? GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 1,
            children: List.generate(images.length, (index) {
              Asset asset = images[index];
              return Container(
                margin: const EdgeInsets.all(1.0),
                child: AssetThumb(
                  asset: asset,
                  width: 300,
                  height: 300,
                ),
              );
            }),
          )
        : SizedBox();
  }
}
