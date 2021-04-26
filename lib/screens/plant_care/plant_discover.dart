import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/models/plant_detail_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PlantDiscoverScreen extends StatefulWidget {
  @override
  _PlantDiscoverScreenState createState() => _PlantDiscoverScreenState();
}

class _PlantDiscoverScreenState extends State<PlantDiscoverScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // SEARCH
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  String keyword = '';
  // SCROLL CONTROLLER
  ScrollController _scrollController = new ScrollController();
  // Biến phục vụ cho infinite scroll của cây cảnh
  int skipPlant = 0;
  int takePlant = 6;
  bool isLoadingPlant = false;
  bool stillSendApiPlant = true;
  List<PlantDetailModel> plants = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        leading: _isSearching ? const BackButton() : Container(),
        title: _isSearching ? _buildSearchField() : Text('🌷  Cây cảnh'),
        actions: _buildActions(),
      ),
      body: bodyLayout(),
      bottomNavigationBar: buildBottomNavigationBar(
          context: context, index: kBottomBarIndexPlant),
    );
  }

  //1. HÀM GỌI API LẤY DS PLANT THEO CỤM
  fetchPlants() async {
    setState(() {
      isLoadingPlant = true;
    });
    var data = {
      'skip': this.skipPlant,
      'take': takePlant,
      'keyword': keyword,
    };
    var res =
        await Network().postData(data, '/server_plant/get_plant_list_by_chunk');
    var body = json.decode(res.body);

    // Nếu có kết quả trả về
    if (body['plants'].isEmpty == false) {
      List<PlantDetailModel> fetchedPlants = [];
      for (var plant in body['plants']) {
        PlantDetailModel plantDetailModel = new PlantDetailModel(
          id: plant['id'],
          commonName: plant['common_name'],
          scientificName: plant['scientific_name'],
          imageUrl: plant['image_url'],
        );
        fetchedPlants.add(plantDetailModel);
      }
      setState(() {
        this.skipPlant += takePlant;
        this.plants.addAll(fetchedPlants);
        isLoadingPlant = false;
      });
    }
    // Nếu kết quả trả về không còn
    else {
      setState(() {
        stillSendApiPlant = false;
        isLoadingPlant = false;
      });
    }
  }

  // 2. GỌI HÀM LẤY DS PLANT + CHECK CUỘN BOTTOM ĐỂ GỌI TIẾP
  @override
  void initState() {
    super.initState();
    // get plant
    fetchPlants();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // FOR POSTS
        if (isLoadingPlant == false) {
          if (stillSendApiPlant == true) {
            fetchPlants();
          }
        }
      }
    });
  }

  bodyLayout() {
    //return infinitePlantListView();
    return testInfinitePlantView();
  }

  // LIST DS CÂY CẢNH THEO TỪ KHÓA
  infinitePlantListView() {
    return Column(
      children: [
        // NEWSFEED
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            controller: this._scrollController,
            itemCount: plants.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Text(plants[index].commonName),
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
        isLoadingPlant == true
            ? SpinKitRing(
                color: Colors.teal,
                lineWidth: 3.0,
                size: 40.0,
              )
            : SizedBox(),
      ],
    );
  }

  testInfinitePlantView() {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        physics: ScrollPhysics(),
        itemCount: plants.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            plants[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Text(
                          plants[index].scientificName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(plants[index].commonName),
                      ],
                    ),
                  )
                ]),
            onTap: () {
              print('hee');
            },
          );
        });
  }

  // BUILD SEARCH FIELD
  Widget _buildSearchField() {
    return TextField(
      cursorColor: Colors.white,
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Tìm kiếm cây cảnh",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  // A. LIST WIDGET TRÊN APP BAR
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
      // SEARCH ICON
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
      // ADD NEW PLANT ICON
      IconButton(
        icon: const Icon(
          Icons.add,
          color: Color(0xffffffff),
          size: 30.0,
        ),
        onPressed: () {
          print('add new');
        },
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
      // stillSendApi = true;
      // stillSendApiUser = true;
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
      // // FOR POSTS
      // posts.clear();
      // skip = 0;
      // // FOR USERS
      // users.clear();
      // skipUser = 0;

      searchQuery = newQuery;
    });
    // fetchPosts();
    // fetchUsers();
  }
}
