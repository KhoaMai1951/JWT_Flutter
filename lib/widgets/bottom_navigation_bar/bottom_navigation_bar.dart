import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/screens/home.dart';
import 'package:flutter_login_test_2/screens/submit_post.dart';
import 'package:flutter_login_test_2/screens/upload_image.dart';
import 'package:flutter_login_test_2/screens/upload_image_2.dart';
import 'package:flutter_login_test_2/screens/upload_image_3.dart';
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
        icon: Icon(Icons.add_photo_alternate_outlined),
        label: 'Test upload \n hình',
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
        case kBottomBarIndexTestUploadImage:
          Navigator.push(
            context,
            MaterialPageRoute(
              //builder: (context) => UploadImage(),
              builder: (context) => UploadImage3(),
            ),
          );
          break;
      }
    },
  );
}
