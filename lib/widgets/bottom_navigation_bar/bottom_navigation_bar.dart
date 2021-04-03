import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/screens/home.dart';
import 'package:flutter_login_test_2/screens/submit_post.dart';
import 'package:flutter_login_test_2/screens/upload_image.dart';
import 'package:flutter_login_test_2/services/TagService.dart';

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
        icon: Icon(Icons.person_pin),
        label: 'Cá nhân',
      ),
    ],
    currentIndex: index,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white60,
    onTap: (navigationIndex) async {
      switch (navigationIndex) {
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
          );
          break;
        case 2:
          var plantTagList = await TagService.getTagsByTypeId(1);
          var contentTagList = await TagService.getTagsByTypeId(2);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitPostScreen(
                  plantTagList: plantTagList, contentTagList: contentTagList),
            ),
          );
          break;
      }
    },
  );
}
