import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/screens/home.dart';
import 'package:flutter_login_test_2/screens/loading/loading_post_detail.dart';
import 'package:flutter_login_test_2/screens/post_detail.dart';
import 'package:flutter_login_test_2/screens/submit_post.dart';

BottomNavigationBar buildBottomNavigationBar(
    {int index, BuildContext context}) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.teal,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: 'Trang chính',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.android_rounded),
        label: 'Trang test',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline),
        label: 'Đăng bài',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_photo_alternate_outlined),
        label: 'Test chi tiết \n bài viết',
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
        case kBottomBarIndexTest:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
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
        case kBottomBarIndexTestPostDetail:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoadingPostDetailScreen(
                id: 9,
              ),
              //builder: (context) => PostDetail(),
            ),
          );
          break;
      }
    },
  );
}
