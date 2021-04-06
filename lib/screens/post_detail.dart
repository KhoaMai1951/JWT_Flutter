import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';

class PostDetail extends StatefulWidget {
  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListViews',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Đăng bài')),
        body: bodyLayout(),
        bottomNavigationBar: buildBottomNavigationBar(
            context: context, index: kBottomBarIndexTestPostDetail),
      ),
    );
  }

  bodyLayout() {
    return ListView(
      children: [
        Column(
          children: [
            Row(
              children: [
                Image.network(
                  'http://192.168.1.2:8000/uploads/images/store/f36693eb-e131-4f04-bb21-9b24932e4fcc1615570960000.jpg',
                  width: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                      "https://images.pexels.com/photos/2820884/pexels-photo-2820884.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                )
              ],
            ),
            Text(
              'Tiêu đề bài viết',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
                'Nội dung bài viết is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum'),
          ],
        )
      ],
    );
  }
}
