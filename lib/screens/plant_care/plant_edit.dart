import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/constants/text_style.dart';
import 'package:flutter_login_test_2/globals/user_global.dart';
import 'package:flutter_login_test_2/models/plant_detail_model.dart';
import 'package:flutter_login_test_2/screens/plant_care/plant_discover.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PlantEditScreen extends StatefulWidget {
  PlantDetailModel plantDetailModel;
  bool hasRequestEdit;
  PlantEditScreen(
      {Key key, @required this.plantDetailModel, @required this.hasRequestEdit})
      : super(key: key);
  @override
  _PlantEditScreenState createState() => _PlantEditScreenState();
}

class _PlantEditScreenState extends State<PlantEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String contributorName;
  //focus node
  FocusNode focusContributorName = new FocusNode();
  FocusNode focusCommonName = new FocusNode();
  FocusNode focusScientificName = new FocusNode();

  //for pet toggle
  int initialIndex = 0;
  //range
  double minTemperature = 20;
  double maxTemperature = 40;
  RangeValues temperatureRangeValue = new RangeValues(20, 30);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      //FOR TEMP
      temperatureRangeValue = new RangeValues(
          widget.plantDetailModel.temperatureRange[0].toDouble(),
          widget.plantDetailModel.temperatureRange[1].toDouble());
      //FOR PET
      widget.plantDetailModel.petFriendly ? initialIndex = 0 : initialIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text('Đóng góp \nthông tin cây cảnh'),
      ),
      body: bodyLayout(),
      backgroundColor: Colors.white,
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
                  // STATUS
                  widget.hasRequestEdit == true
                      ? labelBuilder(
                          label: 'Đang chờ duyệt',
                        )
                      : SizedBox(),
                  // CONTRIBUTOR NAME LABEL ====================================
                  labelBuilder(
                    label: 'Thông tin người đóng góp',
                  ),
                  // NAME TEXTFIELD
                  textFormFieldBuilder(
                    focusNode: focusContributorName,
                    label: 'Tên \*',
                    hintText: 'Tên',
                    validateFunction: (value) {
                      if (value.length > 100) {
                        focusContributorName.requestFocus();
                        return 'Tên phải nhỏ hơn 100 kí tự';
                      }
                      // if (value.length == 0) {
                      //   focusContributorName.requestFocus();
                      //   return 'Phải nhập tên';
                      // }
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
                    focusNode: focusCommonName,
                    initialValue: widget.plantDetailModel.commonName,
                    label: 'Tên thường gọi \*',
                    hintText: 'Tên thường gọi',
                    validateFunction: (value) {
                      if (value.length > 100) {
                        focusCommonName.requestFocus();
                        return 'Tên phải nhỏ hơn 100 kí tự';
                      }
                      if (value.length == 0) {
                        focusCommonName.requestFocus();
                        return 'Phải nhập tên';
                      }
                      setState(() {
                        widget.plantDetailModel.commonName = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // COMMON NAME TEXT FIELD
                  textFormFieldBuilder(
                    initialValue: widget.plantDetailModel.scientificName,
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
                        widget.plantDetailModel.scientificName = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // COMMON NAME TEXT FIELD
                  textFormFieldBuilder(
                    initialValue: widget.plantDetailModel.information,
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
                        widget.plantDetailModel.information = value;
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
                      currentLevel:
                          widget.plantDetailModel.waterLevel.toDouble(),
                      labelList: waterLevelString,
                      length: 5),
                  // WATER LEVEL SLIDER
                  sliderBuilder(
                      currentLevel:
                          widget.plantDetailModel.waterLevel.toDouble(),
                      divisions: 4,
                      max: 5,
                      min: 1,
                      function: (double value) {
                        setState(() {
                          widget.plantDetailModel.waterLevel = value.toInt();
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
                      currentLevel: widget.plantDetailModel.sunLight.toDouble(),
                      labelList: sunlightLevelString,
                      length: 5),
                  // SUNLIGHT LEVEL SLIDER
                  sliderBuilder(
                      currentLevel: widget.plantDetailModel.sunLight.toDouble(),
                      divisions: 4,
                      max: 5,
                      min: 1,
                      function: (double value) {
                        setState(() {
                          widget.plantDetailModel.sunLight = value.toInt();
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
                                ? widget.plantDetailModel.petFriendly = true
                                : widget.plantDetailModel.petFriendly = false;
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
                    initialValue: widget.plantDetailModel.feedInformation,
                    maxLines: 4,
                    label: 'Bón phân',
                    hintText: 'Bón phân',
                    validateFunction: (value) {
                      if (value.length > 1000) {
                        return 'Tên phải nhỏ hơn 1000 kí tự';
                      }
                      setState(() {
                        widget.plantDetailModel.feedInformation = value;
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
                    initialValue: widget.plantDetailModel.commonIssue,
                    maxLines: 4,
                    label: 'Các vấn đề thường gặp',
                    hintText: 'Các vấn đề thường gặp',
                    validateFunction: (value) {
                      if (value.length > 1000) {
                        return 'Tên phải nhỏ hơn 1000 kí tự';
                      }
                      setState(() {
                        widget.plantDetailModel.commonIssue = value;
                      });
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 60.0,
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
            onPressed: () async {
              if (_formKey.currentState.validate() == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Đang gửi'),
                      duration: const Duration(seconds: 1)),
                );
                //SUBMIT TO SERVER
                // DIO
                FormData formData = new FormData.fromMap({
                  'user_name': contributorName,
                  'user_id': UserGlobal.user['id'],
                  'server_plant_id': widget.plantDetailModel.id,
                  'common_name': widget.plantDetailModel.commonName,
                  'scientific_name': widget.plantDetailModel.scientificName,
                  'pet_friendly': widget.plantDetailModel.petFriendly ? 1 : 0,
                  'water_level': widget.plantDetailModel.waterLevel.toInt(),
                  'sunlight': widget.plantDetailModel.sunLight.toInt(),
                  'information': widget.plantDetailModel.information,
                  'feed_information': widget.plantDetailModel.feedInformation,
                  'common_issue': widget.plantDetailModel.commonIssue,
                  'min_temperature':
                      widget.plantDetailModel.temperatureRange[0],
                  'max_temperature':
                      widget.plantDetailModel.temperatureRange[1],
                });
                // BEGIN CALL API
                Dio dio = new Dio();
                SharedPreferences localStorage =
                    await SharedPreferences.getInstance();
                var token =
                    jsonDecode(localStorage.getString('token'))['token'];
                try {
                  var response = await dio.post(
                    kApiUrl + "/server_plant_user_edit/upload_plant",
                    data: formData,
                    options: Options(
                      headers: {
                        'Accept': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                    ),
                  );

                  var jsonData = json.decode(response.toString());
                  if (jsonData['status'] == true) {
                    // Redirect to post detail
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantDiscoverScreen(),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã gửi'),
                      ),
                    );
                  } else
                    print('Failed');
                } catch (e) {
                  print('exception: ' + e.toString());
                  Future.error(e.toString());
                }
              }
            },
            child: Text('Đóng góp'),
          ),
        ],
      ),
    );
  }

  // TEXT FORM FIELD
  textFormFieldBuilder({
    String label,
    String initialValue,
    int maxLines,
    String hintText,
    FocusNode focusNode,
    Function validateFunction,
  }) {
    return TextFormField(
      focusNode: focusNode,
      initialValue: initialValue,
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
}
