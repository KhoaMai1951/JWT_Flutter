import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login_test_2/constants/bottom_bar_index_constant.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/globals/user_global.dart';
import 'package:flutter_login_test_2/models/user_plant_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';
import 'package:flutter_login_test_2/screens/user_plant/submit_user_plant.dart';
import 'package:flutter_login_test_2/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';

class UserPlantNewsFeedScreen extends StatefulWidget {
  UserPlantNewsFeedScreen({
    this.plantIdYouWantToExchange,
  });
  int plantIdYouWantToExchange;
  @override
  _UserPlantNewsFeedScreenState createState() =>
      _UserPlantNewsFeedScreenState();
}

class _UserPlantNewsFeedScreenState extends State<UserPlantNewsFeedScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();

  // SEARCH
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  String keyword = '';
  // SCROLL CONTROLLER
  ScrollController _scrollController = new ScrollController();
  // Biến phục vụ cho infinite scroll của cây cảnh
  int skipPlant = 0;
  int takePlant = 8;
  bool isLoadingPlant = false;
  bool stillSendApiPlant = true;
  List<UserPlantModel> userPlants = [];

  @override
  void initState() {
    super.initState();
    // get plant
    fetchPlants();
    _scrollController.addListener(() {
      handleScrollBottom();
    });
  }

  handleScrollBottom() {
    //NẾU CHƯA CUỘN XUỐNG BOTTOM, TRẢ NULL
    if (_scrollController.position.pixels !=
        _scrollController.position.maxScrollExtent) return null;
    //NẾU CÒN ĐANG LOAD PLANT, TRẢ NULL
    if (isLoadingPlant == true) return null;
    //NẾU VẪN CÒN DATA Ở BACKEND, GỌI DS PLANT MỚI
    if (stillSendApiPlant == true) fetchPlants();
  }

  //1. HÀM GỌI API LẤY DS PLANT THEO CỤM
  fetchPlants() async {
    setState(() {
      isLoadingPlant = true;
    });
    var data = {
      'skip': this.skipPlant,
      'take': takePlant,
      'user_id': UserGlobal.user['id'],
      'keyword': keyword,
    };
    var res = await Network().postData(data, '/user_plant/get_all_user_plants');
    var body = json.decode(res.body);

    // Nếu có kết quả trả về
    if (body['user_plants'].isEmpty == false) {
      List<UserPlantModel> fetchedPlants = [];
      for (var plant in body['user_plants']) {
        UserPlantModel userPlantModel = new UserPlantModel(
          id: plant['id'],
          commonName: plant['common_name'],
          scientificName: plant['scientific_name'],
          thumbnailImage: plant['image_url'],
        );
        fetchedPlants.add(userPlantModel);
      }
      setState(() {
        this.skipPlant += takePlant;
        this.userPlants.addAll(fetchedPlants);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        leading: _isSearching ? const BackButton() : Container(),
        title: _isSearching ? _buildSearchField() : Text('Cây của bạn'),
        actions: _buildActions(),
      ),
      body: bodyLayout(),
      bottomNavigationBar: buildBottomNavigationBar(
          context: context, index: kBottomBarIndexChat),
    );
  }

  bodyLayout() {
    return GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
        ),
        physics: ScrollPhysics(),
        itemCount: userPlants.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(16.0),
                color: Colors.grey[300],
              ),
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
                              userPlants[index].thumbnailImage,
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Text(
                            userPlants[index].scientificName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(userPlants[index].commonName),
                        ],
                      ),
                    ),
                  ]),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         LoadingServerPlantDetailScreen(id: plants[index].id),
              //   ),
              // );
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
      // POPUP MENU
      PopupMenuButton<int>(
        offset: const Offset(0, -380),
        key: _key,
        itemBuilder: (context) {
          return <PopupMenuEntry<int>>[
            PopupMenuItem(
              child: Text('+ Thêm cây cảnh'),
              value: 0,
            ),
            PopupMenuItem(child: Text('✿ Cây muốn trao đổi với tôi'), value: 1),
            PopupMenuItem(child: Text('✿ Cây tôi muốn trao đổi'), value: 2),
          ];
        },
        onSelected: (value) {
          switch (value) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubmitUserPlantScreen(),
                ),
              );
              break;
          }
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
      // FOR PLANTS
      userPlants.clear();
      skipPlant = 0;

      searchQuery = newQuery;
    });
    fetchPlants();
  }
}
