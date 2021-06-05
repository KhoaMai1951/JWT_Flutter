import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/models/user_plant_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'dart:convert';

import 'package:flutter_login_test_2/screens/loading/loading_user_profile.dart';

class UserPlantDetailScreen extends StatefulWidget {
  UserPlantModel userPlantModel;
  int postId;
  bool isExchange = false;
  UserPlantDetailScreen({
    Key key,
    @required this.userPlantModel,
    this.postId,
    this.isExchange,
  }) : super(key: key);
  @override
  _UserPlantDetailScreenState createState() => _UserPlantDetailScreenState();
}

class _UserPlantDetailScreenState extends State<UserPlantDetailScreen> {
  String username = 'loading...';
  bool didExchange = false; //đã trao đổi chưa
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsername();
    checkExchanged();
  }

  fetchUsername() async {
    // get username
    var data = {
      'user_id': widget.userPlantModel.userId,
    };

    var res = await Network().postData(data, '/user/get_username');
    var body = json.decode(res.body);
    print(body);
    setState(() {
      username = body['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text('Chi tiết cây trao đổi'),
      ),
      body: bodyLayout(),
      backgroundColor: Colors.white,
    );
  }

  bodyLayout() {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(widget.userPlantModel.thumbnailImage),
                ),
              ),
            ),
            // EXCHANGE BUTTON
            widget.isExchange == true ? exchangeButtonBuilder() : SizedBox(),
            // INFO
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BY USER
                  Row(
                    children: [
                      Text('bởi: '),
                      InkWell(
                        child: Text(
                          username,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // builder: (context) => ProfileScreen(),
                              builder: (context) => LoadingProfileScreen(
                                userId: widget.userPlantModel.userId,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  // SCIENTIFIC NAME
                  Text('tên khoa học: ' + widget.userPlantModel.scientificName),
                  SizedBox(
                    height: 10.0,
                  ),
                  // SCIENTIFIC NAME
                  Text('tên thông thường: ' + widget.userPlantModel.commonName),
                  SizedBox(
                    height: 10.0,
                  ),
                  // DESCRIPTION
                  Text('mô tả: ' + widget.userPlantModel.description),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // EXCHANGE BUTTON
  exchangeButtonBuilder() {
    return didExchange == false
        ? Center(
            child: ElevatedButton(
              onPressed: () async {
                var data = {
                  'post_id': widget.postId,
                  'plant_id': widget.userPlantModel.id,
                };
                var res = await Network()
                    .postData(data, '/post/accept_exchange_plant');
                var body = json.decode(res.body);
                setState(() {
                  didExchange = true;
                });
              },
              child: Text("Trao đổi"),
            ),
          )
        : Center(
            child: ElevatedButton(
              onPressed: () async {
                var data = {
                  'post_id': widget.postId,
                  'plant_id': widget.userPlantModel.id,
                };
                var res = await Network()
                    .postData(data, '/post/cancel_exchange_plant');
                var body = json.decode(res.body);
                setState(() {
                  didExchange = false;
                });
              },
              child: Text("Hủy trao đổi"),
            ),
          );
  }

  // CHECK EXCHANGED
  checkExchanged() async {
    var data = {
      'post_id': widget.postId,
      'plant_id': widget.userPlantModel.id,
    };
    var res =
        await Network().postData(data, '/post/check_accepted_exchange_plant');
    var body = json.decode(res.body);
    int result = body['accepted'];
    if (result == 1) {
      setState(() {
        didExchange = true;
      });
    }
  }
}
