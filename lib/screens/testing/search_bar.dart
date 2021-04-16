import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/models/post_detail_model.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/loading/loading_post_detail.dart';
import 'package:flutter_login_test_2/screens/loading/loading_user_profile.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class SearchBarScreen extends StatefulWidget {
  @override
  _SearchBarScreenState createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  // SEARCH
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  String keyword = '';
  // INFINITE SCROLL
  // Biến phục vụ cho comment infinite scroll
  int skip = 0;
  int take = 6;
  bool isLoading = false;
  bool stillSendApi = true;
  List<PostDetailModel> posts = [];
  ScrollController _scrollController = new ScrollController();
  // Biến phục vụ cho image carousel
  int _currentImageIndicator = 0;

  //1. HÀM GỌI API LẤY DS POST THEO CỤM
  fetchPosts() async {
    setState(() {
      isLoading = true;
    });
    var data = {
      'skip': this.skip,
      'take': take,
      'keyword': keyword,
    };
    var res = await Network().postData(data, '/post/test_search');
    var body = json.decode(res.body);

    // Nếu có kết quả trả về
    if (body['posts'].isEmpty == false) {
      List<PostDetailModel> fetchedPosts = [];
      for (var post in body['posts']) {
        // user handle
        UserModel userModel = new UserModel(
          id: post['user']['id'],
          username: post['user']['username'],
          avatarUrl: post['user']['avatar_url'],
        );
        // image for post handle
        List<String> imagesForPost = [];
        for (var image in post['images_for_post']) {
          imagesForPost.add(image['dynamic_url']);
        }
        // post handle
        PostDetailModel postModel = new PostDetailModel(
          id: post['id'],
          createdAt: post['created_at'],
          imagesForPost: imagesForPost,
          title: post['title'],
          content: post['short_content'],
          like: post['like'],
          commentsNumber: post['comments_number'],
          user: userModel,
          currentImageIndicator: 0,
          isLiked: post['is_liked'],
        );

        fetchedPosts.add(postModel);
      }
      setState(() {
        this.skip += take;
        this.posts.addAll(fetchedPosts);
        isLoading = false;
      });
    }
    // Nếu kết trả không còn
    else {
      setState(() {
        stillSendApi = false;
        isLoading = false;
      });
    }
  }

  // 2. GỌI HÀM LẤY DS POST + CHECK CUỘN BOTTOM ĐỂ GỌI TIẾP
  @override
  void initState() {
    super.initState();
    // get post
    fetchPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (isLoading == false) {
          if (stillSendApi == true) {
            fetchPosts();
          }
        }
      }
    });
  }

  // 3. DISPOSE CONTROLLER
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : Container(),
        title: _isSearching ? _buildSearchField() : Text('hi'),
        actions: _buildActions(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Column(
      children: [
        // NEWSFEED
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            controller: this._scrollController,
            itemCount: posts.length,
            physics: const AlwaysScrollableScrollPhysics(), // new
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      // BÀI VIẾT MINI
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // BÀI VIẾT
                          Container(
                            margin: const EdgeInsets.only(right: 2, left: 2),
                            child: Column(
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
                                            borderRadius:
                                                BorderRadius.circular(90.0),
                                            image: DecorationImage(
                                                image: posts[index]
                                                            .user
                                                            .avatarUrl !=
                                                        ''
                                                    ? NetworkImage(posts[index]
                                                        .user
                                                        .avatarUrl)
                                                    : AssetImage(
                                                        'images/no-image.png'),
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    // USERNAME
                                    InkWell(
                                      child: Text(
                                        posts[index].user.username,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () {
                                        navigateToUserProfile(
                                            userId: posts[index].user.id);
                                      },
                                    ),
                                  ],
                                ),
                                // NGÀY
                                Row(
                                  children: [
                                    // NGÀY
                                    Text(
                                      timeAgoSinceDate(
                                          dateString: posts[index].createdAt),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                // TIÊU ĐỀ BÀI VIẾT
                                InkWell(
                                  onTap: () {
                                    navigateToPostDetail(
                                        postId: posts[index].id);
                                  },
                                  child: Text(
                                    posts[index].title,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                // NỘI DUNG BÀI VIẾT
                                InkWell(
                                  onTap: () {
                                    navigateToPostDetail(
                                        postId: posts[index].id);
                                  },
                                  child: Text(
                                    posts[index].content,
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5.0),
                          ImageCarouselBuilder(
                              postDetailModel: posts[index],
                              indexInPostsArray: index),
                          CarouselIndicator(
                              postDetailModel: posts[index],
                              indexInPostsArray: index),
                          // LIKE + COMMENT ICON
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // LIKE ICON
                              IconButton(
                                onPressed: () {
                                  likePost(
                                    userId: 1,
                                    postId: posts[index].id,
                                    currentPostsIndex: index,
                                  );
                                },
                                iconSize: 30.0,
                                icon: Icon(
                                  Icons.favorite,
                                  color: posts[index].isLiked == true
                                      ? Colors.teal
                                      : Colors.grey,
                                ),
                              ),
                              // LIKE NUMBER
                              Text(
                                posts[index].like.toString(),
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              SizedBox(
                                width: 40.0,
                              ),
                              // COMMENT
                              InkWell(
                                child: Row(
                                  children: [
                                    // COMMENT ICON
                                    Icon(
                                      Icons.chat,
                                      size: 27.0,
                                    ),
                                    SizedBox(
                                      width: 7.0,
                                    ),
                                    // COMMENT NUMBER
                                    Text(
                                      posts[index].commentsNumber.toString(),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  navigateToPostDetail(postId: posts[index].id);
                                },
                              ),
                            ],
                          ),
                          // BÌNH LUẬN
                          //CommentList(),
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
              );
            },
          ),
        ),
        // SPINNING
        isLoading == true
            ? SpinKitRing(
                color: Colors.teal,
                lineWidth: 3.0,
                size: 40.0,
              )
            : SizedBox(),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
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

  void updateSearchQuery(String newQuery) {
    setState(() {
      keyword = newQuery;
      posts.clear();
      skip = 0;
      searchQuery = newQuery;
    });
    fetchPosts();
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  // ==========NEWSFEED FUNCTIONS============

  //NAVIGATE TO PROFILE SCREEN
  navigateToUserProfile({int userId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => ProfileScreen(),
        builder: (context) => LoadingProfileScreen(
          userId: userId,
        ),
      ),
    );
  }

  //NAVIGATE TO POST DETAIL SCREEN
  navigateToPostDetail({int postId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => ProfileScreen(),
        builder: (context) => LoadingPostDetailScreen(
          id: postId,
        ),
      ),
    );
  }

  // IMAGE CAROUSEL
  ImageCarouselBuilder(
      {PostDetailModel postDetailModel, int indexInPostsArray}) {
    return Row(
      children: [
        Expanded(
          child: CarouselSlider(
            options: CarouselOptions(
              height: 300,
              //aspectRatio: 4 / 3,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  posts[indexInPostsArray].currentImageIndicator = index;
                });
              },
              scrollDirection: Axis.horizontal,
            ),
            items: postDetailModel.imagesForPost.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    child: Center(
                      child: Image.network(i, fit: BoxFit.cover, width: 1000),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // CAROUSEL INDICATOR
  CarouselIndicator({PostDetailModel postDetailModel, int indexInPostsArray}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: map<Widget>(postDetailModel.imagesForPost, (index, url) {
        return Container(
          width: 10.0,
          height: 10.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: posts[indexInPostsArray].currentImageIndicator == index
                ? Colors.green
                : Colors.grey,
          ),
        );
      }),
    );
  }

  // CAROUSEL INDICATOR FUNCTION
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  // GET TIME AGO
  static String timeAgoSinceDate(
      {String dateString, bool numericDates = true}) {
    DateTime notificationDate = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      //return dateString.toString();
      return DateFormat('dd-MM-yyyy').format(DateTime.parse(dateString)) +
          ' lúc ' +
          DateFormat('HH:mm').format(DateTime.parse(dateString));
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 tuần trước' : 'Tuần trước';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 ngày trước' : 'Hôm qua';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 giờ trước' : 'Một giờ trước';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 phút trước' : 'Một phút trước';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} giây trước';
    } else {
      return 'Vừa đây';
    }
  }

  // LIKE FUNCTION
  Future<void> likePost({int postId, int userId, int currentPostsIndex}) async {
    var res = await Network().getData('/post/like_post?post_id=' +
        postId.toString() +
        '&user_id=' +
        userId.toString());

    var body = json.decode(res.body);

    // handle number of likes + like/unlike condition
    setState(() {
      posts[currentPostsIndex].isLiked = body['liked'];
      posts[currentPostsIndex].like = body['likes']['like'];
    });
  }
}
