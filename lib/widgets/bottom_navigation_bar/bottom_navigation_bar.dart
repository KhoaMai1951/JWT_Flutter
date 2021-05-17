import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';

import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/discover/discover.dart';
import 'package:flutter_login_test_2/screens/home.dart';

import 'package:flutter_login_test_2/screens/loading/loading_user_profile.dart';
import 'package:flutter_login_test_2/screens/news_feed.dart';
import 'package:flutter_login_test_2/screens/plant_care/plant_discover.dart';
import 'package:flutter_login_test_2/screens/submit_post/submit_post.dart';

BottomNavigationBar buildBottomNavigationBar(
    {int index, BuildContext context}) {
  //GET AVATAR URL
  getAvatarUrl({int userId}) async {
    var data = {
      'id': userId,
    };

    var res = await Network().postData(data, '/user/get_avatar_url');
    var body = json.decode(res.body);
    return body['avatar_link'];
  }

  return BottomNavigationBar(
    // showSelectedLabels: false, // <-- HERE
    // showUnselectedLabels: false, // <-- AND HERE
    type: BottomNavigationBarType.fixed,
    backgroundColor: kBottomBarColor,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(
          Icons.shopping_cart,
          size: 25,
        ),
        label: 'Trao đổi',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.featured_play_list_outlined,
          size: 25,
        ),
        label: 'Lướt',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.add_circle_outline,
          size: 30,
        ),
        label: 'Đăng bài',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.local_florist,
          size: 25,
        ),
        label: 'Cây cảnh',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.account_box,
          size: 25,
        ),
        label: 'Cá nhân',
      ),
    ],
    currentIndex: index,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white60,
    onTap: (navigationIndex) async {
      switch (navigationIndex) {
        case kBottomBarIndexNewsFeed:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsFeedScreen(),
            ),
          );
          break;
        case kBottomBarIndexDiscover:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiscoverScreen(),
            ),
          );
          break;
        case kBottomBarIndexSubmitPost:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitPostScreen(),
            ),
          );
          break;
        case kBottomBarIndexPlant:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantDiscoverScreen(),
            ),
          );
          break;
        case kBottomBarIndexProfile:
          Navigator.push(
            context,
            MaterialPageRoute(
              // builder: (context) => ProfileScreen(),
              builder: (context) => LoadingProfileScreen(
                userId: -1,
              ),
            ),
          );
          break;
      }
    },
  );
}
