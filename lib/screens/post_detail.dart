import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/validate_name_constant.dart';
import 'package:flutter_login_test_2/models/comment_model.dart';
import 'package:flutter_login_test_2/models/post_detail_model.dart';
import 'package:flutter_login_test_2/models/tag_model.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_login_test_2/widgets/text_form_field/text_form_field_universal.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loading/loading_user_profile.dart';

class PostDetail extends StatefulWidget {
  static const String id = 'post_detail_screen';

  PostDetail({Key key, this.post, this.userOfPost}) : super(key: key);
  //int id;
  PostDetailModel post;
  UserModel userOfPost;

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final _formKey = GlobalKey<FormState>();
  var currentUser;
  int _currentImageIndicator = 0;
  bool isLiked = false;
  int like;
  String numberOfComments;
  PostDetailModel post;
  // Controller cho comment
  TextEditingController commentController = TextEditingController();
  // Biến phục vụ cho comment infinite scroll
  int skip = 0;
  int take = 6;
  bool isLoading = false;
  bool stillSendApi = true;
  List<CommentModel> comments = [];
  ScrollController _scrollController = new ScrollController();

  // Hàm future lấy list comment
  Future<dynamic> _getComments;

  // Hàm clear toàn bộ mảng comments + lấy cụm comments mới + lấy lấy số lượng comment
  void _loadComments() {
    setState(() {
      //_getComments = getCommentList();
      comments.clear();
      skip = 0;
      fetchComments();
      getNumberOfComment().then((value) {
        setState(() {
          numberOfComments = value.toString();
        });
      });
    });
  }

  // Hàm lấy comment theo cụm
  fetchComments() async {
    setState(() {
      isLoading = true;
    });
    var data = {
      'post_id': widget.post.id,
      'skip': this.skip,
      'take': take,
    };
    var res = await Network()
        .postData(data, '/comment/get_comments_by_chunk_by_post_id');
    var body = json.decode(res.body);
    // Nếu có kết quả trả về
    if (body['comments'].isEmpty == false) {
      List<CommentModel> fetchedComments = [];
      for (var comment in body['comments']) {
        CommentModel cmt = new CommentModel(
          username: comment['username'],
          content: comment['content'],
          id: comment['id'],
          createdAt: comment['created_at'],
          postId: comment['post_id'],
          userId: comment['user_id'],
        );

        fetchedComments.add(cmt);
      }
      setState(() {
        this.skip += take;
        this.comments.addAll(fetchedComments);
        isLoading = false;
      });
    }
    // Nếu kết trả không còn
    else {
      setState(() {
        stillSendApi = false;
      });
    }
  }

  // Hàm listview builder theo cụm
  listViewCommentsBuild() {
    return ListView.builder(
      //controller: this._scrollController,
      physics: NeverScrollableScrollPhysics(),
      //physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: comments.length,
      itemBuilder: (context, index) {
        //return Text(result['comments'][index]['content']);
        return Align(
          alignment: Alignment.topLeft,
          child: CommentBubble(
            content: comments[index].content,
            username: comments[index].username,
            createdDate: comments[index].createdAt,
            userId: comments[index].userId,
          ),
        );
      },
    );
  }

  // Hàm listview lấy nội dung bài viết
  listViewPostContentBuild() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Column(
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
                        // USERNAME
                        Text('Bởi '),
                        InkWell(
                          child: Text(
                            widget.userOfPost.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            navigateToUserProfile(userId: widget.userOfPost.id);
                          },
                        ),
                      ],
                    ),
                    // NGÀY
                    Row(
                      children: [
                        // NGÀY
                        Text(
                          timeAgoSinceDate(dateString: widget.post.createdAt),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    // TIÊU ĐỀ BÀI VIẾT
                    Text(
                      widget.post.title,
                      style: TextStyle(
                          fontSize: 40.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    // NỘI DUNG BÀI VIẾT
                    Text(
                      widget.post.content,
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              // IMAGES CAROUSEL
              ImageCarouselBuilder(),
              // CAROUSEL INDICATOR
              CarouselIndicator(),
              // LIKE + COMMENT ICON
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // LIKE ICON
                  IconButton(
                    iconSize: 30.0,
                    color: this.isLiked == true ? Colors.teal : Colors.grey,
                    icon: const Icon(Icons.favorite),
                    onPressed: () {
                      likePost();
                    },
                  ),
                  // LIKE NUMBER
                  Text(
                    like.toString(),
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    width: 40.0,
                  ),
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
                    //widget.post.commentsNumber.toString(),
                    numberOfComments != null ? numberOfComments : 'loading',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
              // FORM NHẬP BÌNH LUẬN
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      // Ô NHẬP BÌNH LUẬN
                      Expanded(
                          child: TextFormFieldMethod(
                              validateOption: kValidateCommentInput,
                              hintText: 'Nhập bình luận',
                              textEditingController: commentController,
                              maxLines: 2)),
                      // NÚT ĐĂNG BÌNH LUẬN
                      IconButton(
                        iconSize: 30.0,
                        color: Colors.teal,
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            // submit bài post
                            commentSubmit();
                            // clear field nhập comment
                            commentController.clear();
                            // load lại cmt
                            _loadComments();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // BÌNH LUẬN
              //CommentList(),
            ],
          ),
        )
      ],
    );
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    like = widget.post.like;
    _loadUserData();
    checkLikePost();
    // Hàm clear toàn bộ mảng comments + lấy cụm comments mới + lấy lấy số lượng comment
    _loadComments();

    // xử lý infinite scroll cho comment
    //fetchComments();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (isLoading == false) {
          if (stillSendApi == true) {
            fetchComments();
          }
        }
      }
    });
  }

  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'ListViews',
    //   theme: ThemeData(
    //     primarySwatch: Colors.teal,
    //   ),
    //   home: Scaffold(
    //     appBar: AppBar(title: Text('Nội dung bài viết')),
    //     body: bodyLayout(),
    //     bottomNavigationBar: buildBottomNavigationBar(
    //         context: context, index: kBottomBarIndexTestPostDetail),
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Nội dung bài viết',
        ),
        backgroundColor: Colors.teal,
      ),
      body: bodyLayout(),
      bottomNavigationBar: buildBottomNavigationBar(
          context: context, index: kBottomBarIndexTestPostDetail),
    );
  }

  // GET POST
  Future<PostDetailModel> getPost(int searchId) async {
    var res = await Network().getData('/post/get_post?id=$searchId');
    var body = json.decode(res.body);

    // tags model
    List<TagModel> tags = [];
    for (var tag in body['tags']) {
      TagModel tagModel = new TagModel(id: tag['id'], name: tag['name']);
      tags.add(tagModel);
    }
    // post model
    int id = body['post']['id'];
    String title = body['post']['title'];
    String content = body['post']['content'];
    int like = body['post']['like'];
    List<String> imagesForPost = [];
    var createdAt = body['post']['created_at'];
    for (var image in body['images_for_post']) {
      imagesForPost.add(image['dynamic_url']);
    }

    PostDetailModel postDetail = new PostDetailModel(
        id: id,
        like: like,
        title: title,
        content: content,
        imagesForPost: imagesForPost,
        tags: tags,
        createdAt: createdAt);

    return postDetail;
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        currentUser = user;
      });
    }
  }

  bodyLayout() {
    return Container(
      child: CustomScrollView(
        controller: this._scrollController,
        slivers: [
          // NỘI DUNG BÀI VIẾT
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // listview content bài viết
                listViewPostContentBuild(),
              ],
            ),
          ),
          // DS BÌNH LUẬN
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // listview bình luận
                listViewCommentsBuild(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SUBMIT COMMENT
  commentSubmit() async {
    var data = {
      'post_id': widget.post.id,
      'user_id': currentUser['id'],
      'content': commentController.text,
    };
    var res = await Network().postData(data, '/comment/submit_comment');
    var body = json.decode(res.body);
    print(body);
  }

  // COMMENT LIST
  CommentList() {
    return FutureBuilder<dynamic>(
      //future: getCommentList(), // async work
      future: _getComments, // async work
      // async work
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading....');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading....');
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else {
              var result = snapshot.data;
              return Container(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: result['comments'].length,
                  itemBuilder: (context, index) {
                    //return Text(result['comments'][index]['content']);
                    return Align(
                      alignment: Alignment.topLeft,
                      child: CommentBubble(
                          content: result['comments'][index]['content'],
                          username: result['comments'][index]['username'],
                          createdDate: result['comments'][index]['created_at']),
                    );
                  },
                ),
              );
              //return Text(result['comments'][0]['content']);
            }
        }
      },
    );
  }

  // COMMENT
  CommentBubble(
      {String content, String username, String createdDate, int userId}) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.circular(10.0),
            elevation: 5.0,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // USERNAME
                  InkWell(
                    child: Text(
                      username,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      navigateToUserProfile(userId: userId);
                    },
                  ),
                  SizedBox(height: 5.0),
                  // CONTENT
                  Text(
                    content,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  const Divider(
                    color: Colors.grey,
                  ),
                  // TIME AGO
                  Text(
                    timeAgoSinceDate(dateString: createdDate),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // IMAGE CAROUSEL
  ImageCarouselBuilder() {
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
                  _currentImageIndicator = index;
                });
              },
              scrollDirection: Axis.horizontal,
            ),
            items: widget.post.imagesForPost.map((i) {
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
  CarouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: map<Widget>(widget.post.imagesForPost, (index, url) {
        return Container(
          width: 10.0,
          height: 10.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentImageIndicator == index ? Colors.green : Colors.grey,
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

  // CHECK LIKE FUNCTION
  Future<void> checkLikePost() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    var res = await Network().getData('/post/check_like_post?post_id=' +
        widget.post.id.toString() +
        '&user_id=' +
        user['id'].toString());

    var body = json.decode(res.body);
    if (body['result'] == false) {
      setState(() {
        isLiked = false;
      });
    } else {
      setState(() {
        isLiked = true;
      });
    }
  }

  // LIKE FUNCTION
  Future<void> likePost() async {
    var res = await Network().getData('/post/like_post?post_id=' +
        widget.post.id.toString() +
        '&user_id=' +
        this.currentUser['id'].toString());

    var body = json.decode(res.body);

    // handle number of likes
    setState(() {
      like = body['likes']['like'];
    });

    // unliked
    if (body['liked'] == false) {
      setState(() {
        this.isLiked = false;
      });
    }
    // liked
    else {
      setState(() {
        this.isLiked = true;
      });
    }
  }

  // GET COMMENTS LIST
  getCommentList() async {
    var res = await Network().getData(
        '/comment/get_all_comments_by_post_id?post_id=' +
            widget.post.id.toString());
    var body = json.decode(res.body);
    return body;
  }

  // GET COMMENTS LIST
  Future<int> getNumberOfComment() async {
    var res = await Network().getData(
        '/comment/get_number_of_comments_by_post_id?post_id=' +
            widget.post.id.toString());
    var body = json.decode(res.body);
    var num = body['comments'];

    return num;
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
}
