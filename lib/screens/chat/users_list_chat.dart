import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/globals/user_global.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_login_test_2/widgets/label/expert_label.dart';

import 'chat.dart';

class UsersListChatScreen extends StatefulWidget {
  @override
  _UsersListChatScreenState createState() => _UsersListChatScreenState();
}

class _UsersListChatScreenState extends State<UsersListChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// SEARCH
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  String keyword = '';
// Biến phục vụ cho comment infinite scroll của user
  int skipUser = 0;
  int takeUser = 6;
  bool isLoadingUser = false;
  bool stillSendApiUser = true;
  List<UserModel> users = [];
  // SCROLL CONTROLLER
  ScrollController _scrollController = new ScrollController();
  //1 HÀM GỌI API LẤY DS USER THEO CỤM
  fetchUsers() async {
    setState(() {
      isLoadingUser = true;
    });
    var data = {
      'skip': this.skipUser,
      'take': takeUser,
      'keyword': keyword,
      'user_id': UserGlobal.user['id'],
    };
    var res = await Network().postData(data, '/chat/get_chatting_list');
    var body = json.decode(res.body);
    // Nếu có kết quả trả về
    if (body['users'].isEmpty == false) {
      List<UserModel> fetchedUsers = [];
      for (var user in body['users']) {
        // user handle
        UserModel userModel = new UserModel(
          id: user['id'],
          username: user['username'],
          name: user['name'],
          avatarUrl: user['avatar_url'],
          roleId: user['role_id'],
        );

        fetchedUsers.add(userModel);
      }
      setState(() {
        this.skipUser += takeUser;
        this.users.addAll(fetchedUsers);
        isLoadingUser = false;
      });
    }
    // Nếu kết trả không còn
    else {
      setState(() {
        stillSendApiUser = false;
        isLoadingUser = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    fetchUsers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // FOR USERS
        handleScrollBottomForUsers();
      }
    });
  }

  // HANDLE SCROLL BOTTOM USER
  handleScrollBottomForUsers() {
    if (isLoadingUser == true) return;
    if (stillSendApiUser == true) {
      fetchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        leading: _isSearching ? const BackButton() : SizedBox(),
        title: _isSearching
            ? _buildSearchField()
            : Text(
                'Danh sách chat ',
              ),
        actions: _buildActions(),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomNavigationBar(
          context: context, index: kBottomBarIndexChat),
    );
  }

  buildBody() {
    return Column(
      children: [
        SizedBox(height: 20.0),
        SizedBox(height: 20.0),
        // USER FEED
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            //controller: this._scrollController,
            itemCount: users.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        userToChat: users[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Column(
                    children: [
                      ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          // THÔNG TIN USER
                          Row(
                            children: [
                              // AVATAR
                              Container(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90.0),
                                      image: DecorationImage(
                                          image: (users[index].avatarUrl != '')
                                              ? NetworkImage(
                                                  users[index].avatarUrl)
                                              : AssetImage(
                                                  'images/no-avatar.png'),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              // USERNAME + LABEL
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  users[index].roleId == 2
                                      ? expertLabelBuild()
                                      : SizedBox(),
                                  // USERNAME
                                  Text(
                                    users[index].username,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  // NAME
                                  Text(
                                    users[index].name,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            thickness: 1,
                          ),
                        ],
                      ),
                      //isLoading == true ? Text('loading...') : SizedBox(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // SPINNING
        isLoadingUser == true ? Text('đang tải...') : SizedBox(),
      ],
    );
  }

  Widget _buildSearchField() {
    return Column(
      children: [
        TextField(
          cursorColor: Colors.white,
          controller: _searchQueryController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Tìm kiếm",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white, fontSize: 16.0),
          onChanged: (query) => updateSearchQuery(query),
        ),
      ],
    );
  }

  // A. LIST WIDGET TRÊN APP BAR
  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        //CANCEL SEARCH BUTTON
        IconButton(
          icon: const Icon(
            Icons.clear,
          ),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }
    return <Widget>[
      //SEARCH BUTTON
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      stillSendApiUser = true;
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      keyword = newQuery;
      // FOR USERS
      users.clear();
      skipUser = 0;
      searchQuery = newQuery;
    });
    fetchUsers();
  }
}
