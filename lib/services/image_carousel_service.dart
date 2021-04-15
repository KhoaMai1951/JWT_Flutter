// class ImageCarouselService {
//   // IMAGE CAROUSEL
//   ImageCarouselBuilder() {
//     return Row(
//       children: [
//         Expanded(
//           child: CarouselSlider(
//             options: CarouselOptions(
//               height: 300,
//               //aspectRatio: 4 / 3,
//               viewportFraction: 1,
//               initialPage: 0,
//               enableInfiniteScroll: true,
//               reverse: false,
//               autoPlayInterval: Duration(seconds: 3),
//               autoPlayAnimationDuration: Duration(milliseconds: 800),
//               autoPlayCurve: Curves.fastOutSlowIn,
//               enlargeCenterPage: true,
//               onPageChanged: (index, reason) {
//                 setState(() {
//                   _currentImageIndicator = index;
//                 });
//               },
//               scrollDirection: Axis.horizontal,
//             ),
//             items: widget.post.imagesForPost.map((i) {
//               return Builder(
//                 builder: (BuildContext context) {
//                   return Container(
//                     child: Center(
//                       child: Image.network(i, fit: BoxFit.cover, width: 1000),
//                     ),
//                   );
//                 },
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // CAROUSEL INDICATOR
//   CarouselIndicator() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: map<Widget>(widget.post.imagesForPost, (index, url) {
//         return Container(
//           width: 10.0,
//           height: 10.0,
//           margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: _currentImageIndicator == index ? Colors.green : Colors.grey,
//           ),
//         );
//       }),
//     );
//   }
//
//   // CAROUSEL INDICATOR FUNCTION
//   List<T> map<T>(List list, Function handler) {
//     List<T> result = [];
//     for (var i = 0; i < list.length; i++) {
//       result.add(handler(i, list[i]));
//     }
//     return result;
//   }
// }
