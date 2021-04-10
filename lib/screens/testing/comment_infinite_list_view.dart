import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/models/comment_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';

class CommentInfinite extends StatefulWidget {
  @override
  _CommentInfiniteState createState() => _CommentInfiniteState();
}

class _CommentInfiniteState extends State<CommentInfinite> {
  int skip = 0;
  int take = 6;
  //bool noMoreDataToFetch = false;
  bool isLoading = false;
  bool stillSendApi = true;
  List<CommentModel> comments = [];
  ScrollController _scrollController = new ScrollController();

  fetchComments() async {
    setState(() {
      isLoading = true;
    });
    var data = {
      'post_id': 9,
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
        print(skip);
        // print(comments.length);
      });
    }
    // Nếu kết trả không còn
    else {
      setState(() {
        stillSendApi = false;
      });
    }
  }

  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchComments();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListViews',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Nội dung bài viết')),
        body: bodyLayout(),
        bottomNavigationBar:
            buildBottomNavigationBar(context: context, index: 1),
      ),
    );
  }

  bodyLayout() {
    return ListView.builder(
      controller: this._scrollController,
      itemCount: comments.length,
      physics: const AlwaysScrollableScrollPhysics(), // new
      itemBuilder: (context, index) {
        return Padding(
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
                      // USERNAME
                      Text(
                        comments[index].username,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      // CONTENT
                      Text(
                        comments[index].content,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
