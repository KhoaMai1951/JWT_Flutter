import 'dart:convert';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/api_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/constants/validate_name_constant.dart';
import 'package:flutter_login_test_2/globals/user_global.dart';
import 'package:flutter_login_test_2/models/comment_model.dart';
import 'package:flutter_login_test_2/models/post_detail_model.dart';
import 'package:flutter_login_test_2/models/tag_model.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_login_test_2/widgets/label/expert_label.dart';
import 'package:flutter_login_test_2/widgets/post_mini/post_mini.dart';
import 'package:flutter_login_test_2/widgets/snack_bar/snack_bar.dart';
import 'package:flutter_login_test_2/widgets/text_form_field/text_form_field_universal.dart';

import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loading/loading_user_profile.dart';

class PostDetail extends StatefulWidget {
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
  String commentContent;
  // Biến phục vụ cho comment infinite scroll
  int skip = 0;
  int take = 6;
  bool isLoading = false;
  bool stillSendApi = true;
  List<CommentModel> comments = [];
  ScrollController _scrollController = new ScrollController();
  //biến hình ảnh cmt
  List<Asset> images = <Asset>[];
  List<MultipartFile> files = [];
  //biến phục vụ submit comment
  bool isSubmittingComment = false;
  //biến phục vụ like cmt
  bool isLikingComment = false;

  // Hàm future lấy list comment
  Future<dynamic> _getComments;

  // Hàm clear toàn bộ mảng comments + lấy cụm comments mới + lấy số lượng comment
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
      'user_id': UserGlobal.user['id'],
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
        //USER MODEL
        UserModel userModel = new UserModel(
          id: comment['user_id'],
          roleId: comment['user']['role_id'],
          username: comment['user']['username'],
          avatarUrl: comment['user']['avatar_link'],
        );
        //COMMENT MODEL
        CommentModel cmt = new CommentModel(
          imageUrl: comment['image_url'] == null ? '' : comment['image_url'],
          content: comment['content'],
          id: comment['id'],
          createdAt: comment['created_at'],
          postId: comment['post_id'],
          likes: comment['like'],
          isLiked: comment['is_liked'],
          userModel: userModel,
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

  // Hàm listview builder comment theo cụm
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
            commentModel: comments[index],
            commentIndex: index,
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
              PostMini(
                currentUserId: UserGlobal.user['id'],
                post: widget.post,
                onLikePost: (int numberOfLikes, bool isLiked) {
                  setState(() {
                    widget.post.like = numberOfLikes;
                    widget.post.isLiked = isLiked;
                  });
                },
                onImageChange: (int currentImageIndexIndicator) {
                  setState(() {
                    widget.post.currentImageIndicator =
                        currentImageIndexIndicator;
                  });
                },
              ),
              // FORM NHẬP BÌNH LUẬN
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      // NÚT CHỌN HÌNH ẢNH
                      IconButton(
                        iconSize: 30.0,
                        color: Colors.grey,
                        icon: const Icon(Icons.image),
                        onPressed: () {
                          loadAssets();
                        },
                      ),
                      // Ô NHẬP BÌNH LUẬN
                      Expanded(
                        child: textFormFieldBuilder(
                          maxLines: 2,
                          textController: commentController,
                          hintText: 'Nhập bình luận',
                          validateFunction: (value) {
                            if (value.isEmpty) {
                              return 'Xin nhập bình luận';
                            }
                            setState(() {
                              this.commentContent = value;
                            });
                            return null;
                          },
                        ),
                      ),
                      // NÚT ĐĂNG BÌNH LUẬN
                      IconButton(
                        iconSize: 30.0,
                        color: Colors.teal,
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            // submit comment
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
              // VÙNG REVIEW ẢNH ĐÃ CHỌN
              buildGridView(),
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Nội dung bài viết',
        ),
        backgroundColor: kAppBarColor,
      ),
      body: bodyLayout(),
      bottomNavigationBar: buildBottomNavigationBar(context: context, index: 1),
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
    // var data = {
    //   'post_id': widget.post.id,
    //   'user_id': currentUser['id'],
    //   'content': commentController.text,
    // };
    // var res = await Network().postData(data, '/comment/submit_comment');
    // var body = json.decode(res.body);
    // print(body);

    if (isSubmittingComment == false) {
      setState(() {
        isSubmittingComment = true;
      });
      List<MultipartFile> listFiles =
          await assetToFile() as List<MultipartFile>;
      FormData formData = new FormData.fromMap({
        "files": listFiles,
        "post_id": widget.post.id,
        "user_id": UserGlobal.user['id'],
        "content": commentContent,
      });

      Dio dio = new Dio();
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var token = jsonDecode(localStorage.getString('token'))['token'];
      if (token == null) {
        token = 1;
      }
      var response = await dio.post(
        kApiUrl + "/comment/submit_comment",
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      //clear hình ảnh + comment
      setState(() {
        this.commentContent = '';
        this.commentController.clear();
        this.images.clear();
        this.comments.clear();
        this.skip = 0;
        this.isSubmittingComment = false;
      });
      // gọi mới
      fetchComments();
      var jsonData = json.decode(response.toString());
    }
  }

  CommentBubble({
    int commentIndex,
    CommentModel commentModel,
  }) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //AVATAR
          Column(
            children: [
              SizedBox(
                height: 12.0,
              ),
              CircleAvatar(
                backgroundColor: Colors.red,
                radius: 22,
                backgroundImage: NetworkImage(commentModel.userModel.avatarUrl),
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
          // CONTENT
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(10.0),
                  elevation: 5.0,
                  color: Colors.white,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // EXPERT LABEL + USERNAME
                            Column(
                              children: [
                                // EXPERT LABEL
                                commentModel.userModel.roleId == 2
                                    ? expertLabelBuild()
                                    : SizedBox(),
                                // USERNAME
                                InkWell(
                                  child: Text(
                                    commentModel.userModel.username,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    navigateToUserProfile(
                                        userId: commentModel.userModel.id);
                                  },
                                ),
                              ],
                            ),
                            // MENU FOR COMMENT
                            commentModel.userModel.id == UserGlobal.user['id']
                                ? Container(
                                    margin: EdgeInsets.only(left: 12.0),
                                    child: InkWell(
                                      child: Icon(Icons.more_vert),
                                      onTap: () async {
                                        // show popup menu
                                        _showPopupMenu(
                                          commentIndex: commentIndex,
                                          commentModel: commentModel,
                                        );
                                      },
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        // CONTENT
                        Text(
                          commentModel.content,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                        ),
                        // IMAGE
                        commentModel.imageUrl != ''
                            ? Container(
                                height: 200,
                                width: 200,
                                child: Image.network(commentModel.imageUrl),
                              )
                            : SizedBox(),
                        SizedBox(height: 5.0),
                        const Divider(
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // TIME AGO
                            Text(
                              timeAgoSinceDate(
                                  dateString: commentModel.createdAt),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 30.0),
                            // LIKE COMMENT BUTTON
                            InkWell(
                              child: Icon(
                                Icons.favorite,
                                size: 25.0,
                                color: commentModel.isLiked
                                    ? Colors.teal
                                    : Colors.grey,
                              ),
                              onTap: () {
                                likeComment(
                                  commentId: comments[commentIndex].id,
                                  commentIndex: commentIndex,
                                );
                              },
                            ),
                            // LIKES NUMBER
                            Text(commentModel.likes.toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  // LIKE POST FUNCTION
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

  // LIKE COMMENT FUNCTION
  likeComment({int commentId, int commentIndex}) async {
    if (isLikingComment == false) {
      setState(() {
        isLikingComment = true;
        comments[commentIndex].isLiked = !comments[commentIndex].isLiked;
      });
      var res = await Network().getData('/comment/like_comment?comment_id=' +
          commentId.toString() +
          '&user_id=' +
          UserGlobal.user['id'].toString());

      var body = json.decode(res.body);

      // handle number of likes
      setState(() {
        comments[commentIndex].likes = body['likes']['like'];
      });

      // // unliked
      // if (body['liked'] == false) {
      //   setState(() {
      //     comments[commentIndex].isLiked = false;
      //   });
      // }
      // // liked
      // else {
      //   setState(() {
      //     comments[commentIndex].isLiked = true;
      //   });
      // }

      setState(() {
        isLikingComment = false;
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

  // GET NUMBER OF COMMENTS
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

  // LẤY ẢNH TRONG GALLERY VÀO LIST ASSET
  Future<void> loadAssets() async {
    this.images.clear();
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Chọn hình ảnh",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  // CONVERT TỪ ASSET SANG MULTIPLE PART FILE
  Future<dynamic> assetToFile() async {
    files.clear();

    //images.forEach((asset) async {
    for (var asset in images) {
      int MAX_WIDTH = 500; //keep ratio
      int height = ((500 * asset.originalHeight) / asset.originalWidth).round();

      ByteData byteData =
          await asset.getThumbByteData(MAX_WIDTH, height, quality: 80);

      if (byteData != null) {
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile u =
            await MultipartFile.fromBytes(imageData, filename: asset.name);

        setState(() {
          this.files.add(u);
        });
      }
    }
    ;

    return files;
  }

  // XUẤT HÌNH TỪ LIST ASSET RA ĐỂ REVIEW
  Widget buildGridView() {
    if (this.images.length != 0) {
      return Row(
        children: [
          Container(
            margin: const EdgeInsets.all(1.0),
            child: AssetThumb(
              asset: images[0],
              width: 100,
              height: 100,
            ),
          ),
          InkWell(
            child: Icon(Icons.cancel),
            onTap: () {
              setState(() {
                this.images.clear();
              });
            },
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  // TEXT FORM FIELD
  textFormFieldBuilder(
      {String label,
      TextEditingController textController,
      int maxLines,
      String hintText,
      Function validateFunction}) {
    return TextFormField(
      controller: textController,
      maxLines: maxLines,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          color: Colors.blueGrey,
        ),
        labelText: label,
        hintText: hintText,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: validateFunction,
    );
  }

  //POPUP MENU
  _showPopupMenu({
    int commentIndex,
    CommentModel commentModel,
  }) async {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: new BoxDecoration(
            color: Colors.transparent,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0),
            ),
          ),
          child: ListView(
            children: [
              // CHỈNH SỬA BÌNH LUẬN
              Ink(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Chỉnh sửa bình luận'),
                  onTap: () {
                    // Navigator.pop(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => EditPostScreen(
                    //       postId: widget.post.id,
                    //     ),
                    //   ),
                    // );
                  },
                ),
              ),
              // XÓA BÌNH LUẬN
              Ink(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Xóa bình luận'),
                  onTap: () async {
                    // delete comment in array
                    setState(() {
                      this.comments.removeAt(commentIndex);
                    });
                    // Close popup menu
                    Navigator.pop(context);
                    // Show snack bar
                    buildSnackBar(
                        context: context, message: 'Đã xóa bình luận');
                    // call api
                    var res = await Network().getData(
                        '/comment/delete_comment?id=' +
                            commentModel.id.toString());
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
