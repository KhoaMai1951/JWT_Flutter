import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/constants/text_style.dart';
import 'package:flutter_login_test_2/models/plant_detail_model.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';

class PlantDetailScreen extends StatefulWidget {
  PlantDetailModel plantDetailModel;
  PlantDetailScreen({Key key, @required this.plantDetailModel})
      : super(key: key);
  @override
  _PlantDetailScreenState createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text(widget.plantDetailModel.commonName),
      ),
      body: bodyLayoutTest(),
      backgroundColor: Colors.white,
      bottomNavigationBar: buildBottomNavigationBar(
          context: context, index: kBottomBarIndexPlant),
    );
  }

  bodyLayout() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            // IMAGE + NAMES
            Stack(clipBehavior: Clip.none, children: [
              // IMAGE
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        "https://cf.shopee.vn/file/202d4cfe4546d4273665d3b24a707d55"),
                  ),
                ),
              ),
              // NAMES
              Positioned(
                top: 265.0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 4.0,
                        color: Colors.white,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'cây nắp ấm',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Nepenthes edwardsiana',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            // INFO
            Container(
              //margin: EdgeInsets.only(left: 5.0, right: 5.0),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  top: 40.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // left
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Độ khó',
                            style: kPlantInfoLabel,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Thân thiện thú nuôi',
                          style: kPlantInfoLabel,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Ánh sáng',
                          style: kPlantInfoLabel,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Tưới nước',
                          style: kPlantInfoLabel,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Nhiệt độ',
                          style: kPlantInfoLabel,
                        ),
                      ],
                    ),
                    // right
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '★★★✩✩',
                          style: kPlantInfo,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'không',
                          style: kPlantInfo,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'trực tiếp',
                          style: kPlantInfo,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'thường xuyên',
                          style: kPlantInfo,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '18 - 26°C',
                          style: kPlantInfo,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bodyLayoutTest() {
    return NestedScrollView(
      controller: this._scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          // INFO
          SliverToBoxAdapter(
            // IMAGE + NAMES
            child: Stack(clipBehavior: Clip.none, children: [
              // IMAGE
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(widget.plantDetailModel.imageUrl),
                  ),
                ),
              ),
              // NAMES
              Positioned(
                top: 265.0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 4.0,
                        color: Colors.white,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                widget.plantDetailModel.commonName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                widget.plantDetailModel.scientificName,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          // NAVIGATE TAB
          SliverAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            expandedHeight: 100,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: TabBar(
                controller: _tabController,
                labelColor: kBottomBarColor,
                isScrollable: false,
                tabs: [
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    child: Tab(
                      text: 'Xem nhanh',
                    ),
                  ),
                  Tab(
                    text: 'Chi tiết',
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body: Container(
        child: TabBarView(
          controller: _tabController,
          children: [
            // INFO QUICK VIEW
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  top: 40.0,
                ),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // left
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '⛏ Độ khó',
                            style: kPlantInfoLabel,
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          Text(
                            '🐶 Thân thiện thú nuôi',
                            style: kPlantInfoLabel,
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          Text(
                            '☀ Ánh sáng',
                            style: kPlantInfoLabel,
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          Text(
                            '💧 Tưới nước',
                            style: kPlantInfoLabel,
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          Text(
                            '🌡️ Nhiệt độ',
                            style: kPlantInfoLabel,
                          ),
                        ],
                      ),
                      // right
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              generateDifficultyStars(
                                  widget.plantDetailModel.difficulty),
                              style: kPlantInfo,
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            Text(
                              widget.plantDetailModel.petFriendly
                                  ? 'có'
                                  : 'không',
                              style: kPlantInfo,
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            Text(
                              sunlightInfo(widget.plantDetailModel.sunLight),
                              style: kPlantInfo,
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            Text(
                              waterInfo(widget.plantDetailModel.waterLevel),
                              style: kPlantInfo,
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            Text(
                              temperatureInfo(
                                  widget.plantDetailModel.temperatureRange),
                              style: kPlantInfo,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // INFO DETAIL
            Container(
              //margin: EdgeInsets.only(left: 5.0, right: 5.0),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  top: 40.0,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 10.0,
                  ),
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // COMMON NAME
                        plantDetailTextRegion(
                            title: 'Tên thường gọi',
                            content: widget.plantDetailModel.commonName),
                        //INFORMATION
                        plantDetailTextRegion(
                          title: 'Thông tin',
                          content: widget.plantDetailModel.information,
                        ),
                        //BÓN PHÂN
                        plantDetailTextRegion(
                          title: 'Bón phân',
                          content: widget.plantDetailModel.feedInformation,
                        ), // COMMON NAME
                        plantDetailTextRegion(
                          title: 'Vấn đề thường gặp',
                          content: widget.plantDetailModel.feedInformation,
                        ),
                        //THÚ NUÔI
                        plantDetailTextRegion(
                            title: 'Thân thiện thú nuôi',
                            content: widget.plantDetailModel.petFriendly
                                ? 'có'
                                : 'không'),
                        //ÁNH SÁNG
                        plantDetailTextRegion(
                          title: 'Ánh sáng',
                          content:
                              sunlightInfo(widget.plantDetailModel.sunLight),
                        ),
                        //ÁNH SÁNG
                        plantDetailTextRegion(
                          title: 'Tưới nước',
                          content:
                              waterInfo(widget.plantDetailModel.waterLevel),
                        ),
                        //NHIỆT ĐỘ
                        plantDetailTextRegion(
                          title: 'Nhiệt độ',
                          content: temperatureInfo(
                              widget.plantDetailModel.temperatureRange),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //PLANT DETAIL COMPONENTS
  plantDetailTextRegion({String title, String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //TITLE COMMON NAME
        Text(
          title,
          style: kPlantDetailLabel,
        ),
        Divider(),
        //COMMON NAME
        Text(
          content,
        ),
        SizedBox(
          height: 30.0,
        ),
      ],
    );
  }

  //DIFFICULTY STARS GENERATE
  generateDifficultyStars(int difficulty) {
    String stars = '';
    for (int i = 0; i < difficulty; i++) {
      stars += '★';
    }
    int emptyStars = 5 - difficulty;
    for (int i = 0; i < emptyStars; i++) {
      stars += '✩';
    }
    return stars;
  }

  //SUN LIGHT INFO
  sunlightInfo(int sunLight) {
    switch (sunLight) {
      case 1:
        return 'ít sáng';
      case 2:
        return 'ít sáng-không trực tiếp';
      case 3:
        return 'không trực tiếp';
      case 4:
        return 'không trực tiếp-ngoài trời';
      case 4:
        return 'ngoài trời';
    }
  }

  //WATERING INFO
  waterInfo(int waterLevel) {
    switch (waterLevel) {
      case 1:
        return 'thỉnh thoảng';
      case 2:
        return 'thỉnh thoảng-thường xuyên';
      case 3:
        return 'thường xuyên';
      case 4:
        return 'thường xuyên-liên tục';
      case 4:
        return 'liên tục';
    }
  }

  //TEMPERATURE INFO
  temperatureInfo(List<dynamic> temperatureRange) {
    int from = temperatureRange[0];
    int to = temperatureRange[1];
    return '$from - $to°C';
  }
}