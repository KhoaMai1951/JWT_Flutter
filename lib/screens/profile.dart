import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListViews',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(title: Center(child: Text('Chronicle1951'))),
        body: bodyLayout(),
        bottomNavigationBar: buildBottomNavigationBar(
            context: context, index: kBottomBarIndexProfile),
      ),
    );
  }

  bodyLayout() {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
          child: Column(
            children: [
              Row(
                children: [
                  // AVATAR
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90.0),
                          image: DecorationImage(
                              image: NetworkImage(
                                "https://nimiuscms.s3.eu-west-1.amazonaws.com/images/photographing-northern-lights-in-iceland-20190521154451.jpg",
                              ),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  // COLUMN INFO
                  Column(
                    children: [
                      Row(
                        children: [
                          // NAME
                          Align(
                            child: Text(
                              'Khoa Mai',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            alignment: Alignment.bottomLeft,
                          ),
                          SizedBox(
                            width: 60.0,
                          ),
                          // SETTING BUTTON
                          Align(
                            child: IconButton(
                              color: Colors.teal,
                              icon: Icon(Icons.settings),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 100.0,
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          Material(
                                            color:
                                                Colors.white.withOpacity(0.0),
                                            child: InkWell(
                                              splashColor: Colors.orange,
                                              child: Text(
                                                  'Hello'), // actually here it's a Container wrapping an image
                                              onTap: () {
                                                print('Click');
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            alignment: Alignment.bottomRight,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        color: Colors.teal,
                        height: 1.0,
                        width: 180.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      // FOLLOW INFO
                      Row(
                        children: [
                          // FOLLOWERS
                          Column(
                            children: [
                              Text(
                                '7',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Text(
                                'người theo dõi',
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.teal),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          // FOLLOWING
                          Column(
                            children: [
                              Text(
                                '7',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Text(
                                'đang theo dõi',
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.teal),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text('Đây là 1 dòng bio'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
