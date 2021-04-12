// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_login_test_2/models/post_detail_model.dart';
// import 'package:flutter_login_test_2/models/user_model.dart';
// import 'package:flutter_login_test_2/network_utils/api.dart';
// import 'package:flutter_login_test_2/screens/loading/loading_post_detail.dart';
//
// class UserPostInfinite extends StatefulWidget {
//   UserPostInfinite({Key key, this.user}) : super(key: key);
//   UserModel user;
//   @override
//   _UserPostInfiniteState createState() => _UserPostInfiniteState();
// }
//
// class _UserPostInfiniteState extends State<UserPostInfinite> {
//   int skip = 0;
//   int take = 6;
//   //bool noMoreDataToFetch = false;
//   bool isLoading = false;
//   bool stillSendApi = true;
//   List<PostDetailModel> posts = [];
//   ScrollController _scrollController = new ScrollController();
//
//   // 1. HÀM GỌI API LẤY DS POST
//   fetchPosts() async {
//     setState(() {
//       isLoading = true;
//     });
//     var data = {
//       'user_id': widget.user.id,
//       'skip': this.skip,
//       'take': take,
//     };
//     var res = await Network()
//         .postData(data, '/post/get_all_posts_by_chunk_by_user_id');
//     var body = json.decode(res.body);
//     // Nếu có kết quả trả về
//     if (body['posts'].isEmpty == false) {
//       List<PostDetailModel> fetchedPosts = [];
//       for (var post in body['posts']) {
//         PostDetailModel cmt = new PostDetailModel(
//           id: post['id'],
//           createdAt: post['created_at'],
//           thumbNailUrl: post['image_url'],
//           title: post['title'],
//           content: post['short_content'],
//           like: post['like'],
//         );
//
//         fetchedPosts.add(cmt);
//       }
//       setState(() {
//         this.skip += take;
//         this.posts.addAll(fetchedPosts);
//         isLoading = false;
//         print(skip);
//       });
//     }
//     // Nếu kết trả không còn
//     else {
//       setState(() {
//         stillSendApi = false;
//       });
//     }
//   }
//
//   // 2. GỌI HÀM LẤY DS POST + CHECK CUỘN BOTTOM ĐỂ GỌI TIẾP
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchPosts();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         if (isLoading == false) {
//           if (stillSendApi == true) {
//             fetchPosts();
//           }
//         }
//       }
//     });
//   }
//
//   // 3. DISPOSE CONTROLLER
//   void dispose() {
//     super.dispose();
//     _scrollController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return infiniteListView();
//   }
//
//   getListView() {
//     return Padding(
//       padding: EdgeInsets.all(5),
//       child: ListView(
//         physics: AlwaysScrollableScrollPhysics(),
//         shrinkWrap: true,
//         children: [
//           // BÀI VIẾT MINI
//           Card(
//             margin: EdgeInsets.all(5),
//             color: Colors.white,
//             shadowColor: Colors.blueGrey,
//             elevation: 10,
//             child: InkWell(
//               child: Row(
//                 children: [
//                   Container(
//                     width: 100.0,
//                     height: 100.0,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         // image: NetworkImage(
//                         //   'https://image.freepik.com/free-photo/image-human-brain_99433-298.jpg',
//                         // ),
//                         image: AssetImage('images/no-image.png'),
//                         fit: BoxFit.cover,
//                         alignment: AlignmentDirectional.center,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const ListTile(
//                           title: Text(
//                             "Let's Talk About Love",
//                             style: TextStyle(fontSize: 20),
//                           ),
//                           subtitle: Text('Modern Talking Album...'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => LoadingPostDetailScreen(
//                       id: 9,
//                     ),
//                     //builder: (context) => PostDetail(),
//                   ),
//                 );
//               },
//             ),
//           ),
//           SizedBox(
//             height: 100,
//           ),
//         ],
//       ),
//     );
//   }
//
//   infiniteListView() {
//     return ListView.builder(
//       controller: this._scrollController,
//       itemCount: posts.length,
//       physics: const NeverScrollableScrollPhysics(), // new
//       itemBuilder: (context, index) {
//         return ListView(
//           physics: NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           children: [
//             // BÀI VIẾT MINI
//             Card(
//               margin: EdgeInsets.all(1),
//               color: Colors.white,
//               shadowColor: Colors.blueGrey,
//               elevation: 1,
//               child: InkWell(
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 100.0,
//                       height: 100.0,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           // image: NetworkImage(
//                           //   'https://image.freepik.com/free-photo/image-human-brain_99433-298.jpg',
//                           // ),
//                           //image: AssetImage('images/no-image.png'),
//                           image: posts[index].thumbNailUrl != ''
//                               ? NetworkImage(
//                                   posts[index].thumbNailUrl,
//                                 )
//                               : AssetImage('images/no-image.png'),
//                           fit: BoxFit.cover,
//                           alignment: AlignmentDirectional.center,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           ListTile(
//                             title: Text(
//                               posts[index].title,
//                               style: TextStyle(fontSize: 20),
//                             ),
//                             subtitle: Text(posts[index].content),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => LoadingPostDetailScreen(
//                         id: posts[index].id,
//                       ),
//                       //builder: (context) => PostDetail(),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(
//               height: 100,
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
