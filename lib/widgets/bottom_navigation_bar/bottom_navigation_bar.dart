import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';

import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/screens/home.dart';
import 'package:flutter_login_test_2/screens/loading/loading_news_feed.dart';

import 'package:flutter_login_test_2/screens/loading/loading_user_profile.dart';
import 'package:flutter_login_test_2/screens/submit_post/submit_post.dart';
import 'package:flutter_login_test_2/screens/testing/search_bar.dart';

BottomNavigationBar buildBottomNavigationBar(
    {int index, BuildContext context}) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: kBottomBarColor,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(
          Icons.people,
        ),
        label: 'Trang chính',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.public,
        ),
        label: 'Khám phá',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline),
        label: 'Đăng bài',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.android_rounded),
        label: 'Trang test',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_pin),
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
              builder: (context) => LoadingNewsFeedScreen(),
            ),
          );
          break;
        case kBottomBarIndexDiscover:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchBarScreen(),
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
        case kBottomBarIndexTest:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
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
