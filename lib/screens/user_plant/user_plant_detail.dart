import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/models/user_plant_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/chat/chat.dart';
import 'dart:convert';

import 'package:flutter_login_test_2/screens/loading/loading_user_profile.dart';
import 'package:flutter_login_test_2/screens/user_plant/user_plant_want_to_exchange.dart';

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
  bool didExchange = false; //đã trao đổi chưa
  bool loadingUser = false;
  UserModel userModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUser();
    checkExchanged();
  }

  fetchUser() async {
    var data = {
      'id': widget.userPlantModel.userId,
    };

    var res = await Network().postData(data, '/user/get_user_info_by_id');
    var body = json.decode(res.body);

    UserModel fetchedUser = new UserModel(
      id: body['user'][0]['id'],
      username: body['user'][0]['username'],
      avatarUrl: body['avatar_link'],
    );
    setState(() {
      this.userModel = fetchedUser;
      loadingUser = true;
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
            // CHAT BUTTON
            widget.isExchange == true
                ? Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              userToChat: this.userModel,
                            ),
                          ),
                        );
                      },
                      child: Text("Nhắn tin"),
                    ),
                  )
                : SizedBox(),
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
                          this.loadingUser != false
                              ? this.userModel.username
                              : 'loading...',
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
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserPlantWantToExchangeScreen(
                      postId: widget.postId,
                    ),
                  ),
                );
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
