import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/helpers/account_manage.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/screens/post_detail.dart';
import 'package:flutter_login_test_2/screens/submit_post.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.user}) : super(key: key);
  UserModel user;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  UserModel user;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('bottom');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListViews',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(widget.user.username),
          ),
        ),
        body: bodyLayout(),
        bottomNavigationBar: buildBottomNavigationBar(
            context: context, index: kBottomBarIndexProfile),
      ),
    );
  }

  // BODY
  bodyLayout() {
    return ListView(
      controller: _scrollController,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
          child: Column(children: [
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
                              widget.user.avatarUrl,
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
                    // NAME + SETTING BUTTON
                    Row(
                      children: [
                        // NAME
                        Align(
                          child: Text(
                            widget.user.name,
                            style: TextStyle(fontSize: 18.0),
                          ),
                          alignment: Alignment.bottomLeft,
                        ),
                        SizedBox(
                          width: 60.0,
                        ),
                        // SETTING BUTTON
                        GearButtonBuild(),
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
                              widget.user.followersNumber.toString(),
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Text(
                              'người theo dõi',
                              style:
                                  TextStyle(fontSize: 15.0, color: Colors.teal),
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
                              widget.user.followingNumber.toString(),
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Text(
                              'đang theo dõi',
                              style:
                                  TextStyle(fontSize: 15.0, color: Colors.teal),
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
            // BIO
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(widget.user.bio),
            ),
            SizedBox(
              height: 20,
            ),
            // TAB BAR
            DefaultTabController(
              length: 4,
              initialIndex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // NAVIGATION TAB
                  Container(
                    child: TabBar(
                      labelColor: Colors.green,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(
                          text: 'Bài viết',
                          icon: Icon(Icons.assignment),
                        ),
                        Tab(text: 'Tab 2'),
                        Tab(text: 'Tab 3'),
                        Tab(text: 'Tab 4'),
                      ],
                    ),
                  ),
                  // TAB CONTENT
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    child: TabBarView(
                      children: [
                        testListView(),
                        testListView2(),
                        Container(
                          child: Center(
                            child: Text('Display Tab 3',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Text('Display Tab 4',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  bodyLayoutTest() {
    return CustomScrollView(
      controller: this._scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Container(
                  margin:
                      const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                  child: Column(children: [
                    // ROW THÔNG TIN NGƯỜI DÙNG
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
                            // NAME + SETTING BUTTON
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
                                GearButtonBuild(),
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
                    // BIO
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('Đây là 1 dòng bio bio'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // TAB BAR
                    DefaultTabController(
                      length: 4,
                      initialIndex: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // NAVIGATION TAB
                          Container(
                            child: TabBar(
                              labelColor: Colors.green,
                              unselectedLabelColor: Colors.black,
                              tabs: [
                                Tab(
                                  text: 'Bài ',
                                  icon: Icon(Icons.assignment),
                                ),
                                Tab(text: 'Tab 22'),
                                Tab(text: 'Tab 3'),
                                Tab(text: 'Tab 4'),
                              ],
                            ),
                          ),
                          // TAB CONTENT
                          Container(
                            height: 400,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.grey, width: 0.5),
                              ),
                            ),
                            child: TabBarView(
                              children: [
                                testListView(),
                                testListView2(),
                                Container(
                                  child: Center(
                                    child: Text('Display Tab 3',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Container(
                                  child: Center(
                                    child: Text('Display Tab 4',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ]),
        ),
      ],
    );
  }

  // NÚT GEAR
  Align GearButtonBuild() {
    return Align(
      child: IconButton(
        color: Colors.teal,
        icon: Icon(Icons.settings),
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.white,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                  ),
                ),
                child: ListView(
                  children: [
                    // EDIT INFO BUTTON
                    Ink(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Chỉnh sửa thông tin'),
                        onTap: () {},
                      ),
                    ),
                    // LOGOUT BUTTON
                    Ink(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Đăng xuất'),
                        onTap: () {
                          AccountManage.logout(context: this.context);
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
    );
  }

  testListView() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Text('data 1'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 2'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 3'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 4'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 5'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 6'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 7'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 8'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 9'),
      ],
    );
  }

  testListView2() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Text('data 1'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 2'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 3'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 4'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 5'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 6'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 7'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 8'),
        SizedBox(
          height: 30.0,
        ),
        Text('data 9'),
      ],
    );
  }
}
