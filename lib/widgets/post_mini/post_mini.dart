import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/models/post_detail_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/loading/loading_post_detail.dart';
import 'package:flutter_login_test_2/screens/loading/loading_user_profile.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class PostMini extends StatefulWidget {
  PostMini(
      {this.onImageChange, this.onLikePost, this.post, this.currentUserId});
  PostDetailModel post;
  int currentUserId;
  final Function(int) onImageChange;
  final Function(int numberOfLikes, bool liked) onLikePost;
  @override
  _PostMiniState createState() => _PostMiniState();
}

class _PostMiniState extends State<PostMini> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // BÀI VIẾT
        Container(
          margin: const EdgeInsets.only(right: 2, left: 2),
          child: Column(
            children: [
              // THÔNG TIN USER + MENU
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // THÔNG TIN USER
                    Column(
                      children: [
                        // THÔNG TIN USER
                        Row(
                          children: [
                            // AVATAR
                            InkWell(
                              child: Container(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90.0),
                                      image: DecorationImage(
                                          image: (widget.post.user.avatarUrl !=
                                                  '')
                                              ? NetworkImage(
                                                  widget.post.user.avatarUrl)
                                              : AssetImage(
                                                  'images/no-avatar.png'),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              onTap: () {
                                navigateToUserProfile(
                                    userId: widget.post.user.id);
                              },
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            // USERNAME + NGÀY
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // USERNAME
                                InkWell(
                                  child: Text(
                                    widget.post.user.username,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  onTap: () {
                                    navigateToUserProfile(
                                        userId: widget.post.user.id);
                                  },
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                // NGÀY
                                Text(
                                  timeAgoSinceDate(
                                      dateString: widget.post.createdAt),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.5),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    // MENU
                    GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        var selected = _showPopupMenu(
                            details.globalPosition, widget.post.user.id);
                        print(selected);
                      },
                      child: Icon(Icons.more_vert),
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(left: 7, top: 5),
              ),
              SizedBox(
                height: 5.0,
              ),
              // TIÊU ĐỀ BÀI VIẾT
              InkWell(
                onTap: () {
                  navigateToPostDetail(postId: widget.post.id);
                },
                child: Text(
                  widget.post.title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              // NỘI DUNG BÀI VIẾT
              InkWell(
                onTap: () {
                  navigateToPostDetail(postId: widget.post.id);
                },
                child: Text(
                  widget.post.content,
                  style: TextStyle(fontSize: 17.0),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.0),
        ImageCarouselBuilder(postDetailModel: widget.post),
        CarouselIndicator(postDetailModel: widget.post),
        // LIKE + COMMENT ICON
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LIKE ICON
            IconButton(
              onPressed: () {
                likePost(
                  userId: 1,
                  postId: widget.post.id,
                );
              },
              iconSize: 30.0,
              icon: Icon(
                Icons.favorite,
                color: widget.post.isLiked == true ? Colors.teal : Colors.grey,
              ),
            ),
            // LIKE NUMBER
            Text(
              widget.post.like.toString(),
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
                    widget.post.commentsNumber.toString(),
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
              onTap: () {
                navigateToPostDetail(postId: widget.post.id);
              },
            ),
          ],
        ),

        // BÌNH LUẬN
        //CommentList(),
      ],
    );
  }

  // IMAGE CAROUSEL
  ImageCarouselBuilder({PostDetailModel postDetailModel}) {
    return Row(
      children: [
        Expanded(
          child: CarouselSlider(
            options: CarouselOptions(
              height: 300,
              aspectRatio: 4 / 3,
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
                  //posts[indexInPostsArray].currentImageIndicator = index;
                  widget.onImageChange(index);
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
  CarouselIndicator({PostDetailModel postDetailModel}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: map<Widget>(postDetailModel.imagesForPost, (index, url) {
        return Container(
          width: 10.0,
          height: 10.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.post.currentImageIndicator == index
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
  Future<void> likePost({int postId, int userId}) async {
    var res = await Network().getData('/post/like_post?post_id=' +
        postId.toString() +
        '&user_id=' +
        userId.toString());

    var body = json.decode(res.body);

    // handle number of likes + like/unlike condition
    setState(() {
      // widget.post.isLiked = body['liked'];
      // widget.post.like = body['likes']['like'];
      widget.onLikePost(body['likes']['like'], body['liked']);
    });
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

  //POPUP MENU
  _showPopupMenu(Offset offset, int postUserId) async {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
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
              (widget.currentUserId == widget.post.user.id)
                  ? Ink(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Chỉnh sửa bài viết'),
                        onTap: () {},
                      ),
                    )
                  : SizedBox(),
              // EDIT INFO BUTTON
              Ink(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(Icons.bookmarks),
                  title: Text('Lưu bài viết'),
                  onTap: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
