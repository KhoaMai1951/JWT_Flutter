import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/globals/user_global.dart';
import 'package:flutter_login_test_2/models/plant_detail_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/plant_care/plant_edit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingServerPlantDetailEditScreen extends StatefulWidget {
  int id;
  LoadingServerPlantDetailEditScreen({Key key, @required this.id})
      : super(key: key);
  @override
  _LoadingServerPlantDetailEditScreenState createState() =>
      _LoadingServerPlantDetailEditScreenState();
}

class _LoadingServerPlantDetailEditScreenState
    extends State<LoadingServerPlantDetailEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitRing(
          color: Colors.teal,
          lineWidth: 3.0,
          size: 40.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchServerPlantDetail();
  }

  fetchServerPlantDetail() async {
    var data = {
      'server_plant_id': widget.id,
      'user_id': UserGlobal.user['id'],
    };
    var res = await Network()
        .postData(data, '/server_plant/get_plant_detail_for_edit/');
    var body = json.decode(res.body);

    PlantDetailModel plantDetailModel = new PlantDetailModel(
      hasViewed: body['plant']['has_viewed'],
      imageUrl: body['plant']['image_url'],
      commonName: body['plant']['common_name'],
      id: body['plant']['server_plant_id'],
      commonIssue: body['plant']['common_issue'],
      petFriendly: body['plant']['pet_friendly'],
      difficulty: body['plant']['difficulty'],
      feedInformation: body['plant']['feed_information'],
      information: body['plant']['information'],
      scientificName: body['plant']['scientific_name'],
      sunLight: body['plant']['sunlight'],
      temperatureRange: body['plant']['temperature_range'],
      waterLevel: body['plant']['water_level'],
    );
    // pop trang loading ra khỏi stack
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return PlantEditScreen(
          hasRequestEdit: body['has_request_edit'],
          plantDetailModel: plantDetailModel,
        );
      }),
    );
  }
}
