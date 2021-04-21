import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';

import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/screens/discover/discover.dart';
import 'package:flutter_login_test_2/screens/home.dart';

import 'package:flutter_login_test_2/screens/loading/loading_user_profile.dart';
import 'package:flutter_login_test_2/screens/news_feed.dart';
import 'package:flutter_login_test_2/screens/submit_post/submit_post.dart';

BottomNavigationBar buildBottomNavigationBar(
    {int index, BuildContext context}) {
  return BottomNavigationBar(
    showSelectedLabels: false, // <-- HERE
    showUnselectedLabels: false, // <-- AND HERE
    type: BottomNavigationBarType.fixed,
    backgroundColor: kBottomBarColor,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(
          Icons.people,
          size: 25,
        ),
        label: ' ',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.public,
          size: 25,
        ),
        label: 'Khám phá',
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
          Icons.android_rounded,
          size: 25,
        ),
        label: 'Trang test',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.person_pin,
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
