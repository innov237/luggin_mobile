import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:luggin/environment/environment.dart';
import 'package:dio/dio.dart';
import 'package:luggin/pages/post_detail.dart';

class SearchPage extends StatefulWidget {
  final isTripOrExpedition;
  SearchPage({@required this.isTripOrExpedition, Key key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState(this.isTripOrExpedition);
}

class _SearchPageState extends State<SearchPage> {
  final isTripOrExpedition;

  _SearchPageState(this.isTripOrExpedition);

  String apiUrl = AppEvironement.apiUrl;
  String imageUrl = AppEvironement.imageUrl;

  var resultData;


  getRecentTrip() async {
    Dio dio = Dio();
    try {
      var response = await dio.get(apiUrl + 'getAllTrips');
      if (response.statusCode == 200) {
        setState(() {
          resultData = response.data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getRecentRequest() async {
    Dio dio = Dio();
    try {
      var response = await dio.get(apiUrl + 'getAllExpedition');
      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          resultData = response.data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    if (isTripOrExpedition == 'trip') {
      getRecentTrip();
    } else {
      getRecentRequest();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              color: Color(0xFF2288B9),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: Container(
                          color: Color(0xFFD9D9D9),
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Search",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                                Icon(
                                  Icons.search,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ],
                            ),
                          )),
                          height: 40.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        RotatedBox(
                          quarterTurns: -1,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  "Cities",
                                  style: TextStyle(
                                    color: Color(0xFF2488B6),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                  ),
                                ),
                              ),
                            ),
                            width: 150.0,
                          ),
                        ),
                        Expanded(
                          child: Container(
                              height: 100.0,
                              child: StaggeredGridView.countBuilder(
                                shrinkWrap: true,
                                primary: false,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.all(5),
                                crossAxisCount: 6,
                                mainAxisSpacing: 1.0,
                                crossAxisSpacing: 1.0,
                                itemCount: 3,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        buildCityCard(),
                                staggeredTileBuilder: (int index) =>
                                    new StaggeredTile.fit(2),
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 5.0,
                    color: Color(0xFFF2F5F5),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RotatedBox(
                          quarterTurns: -1,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  isTripOrExpedition == 'trip'
                                      ? "Recent Trips"
                                      : "Recent Requests",
                                  style: TextStyle(
                                    color: Color(0xFF2488B6),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                  ),
                                ),
                              ),
                            ),
                            width: MediaQuery.of(context).size.height / 2 - 24,
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: resultData != null
                                ? Container(
                                    height: 300.0,
                                    child: StaggeredGridView.countBuilder(
                                      shrinkWrap: true,
                                      primary: false,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.all(5),
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 3.0,
                                      crossAxisSpacing: 4.0,
                                      itemCount: resultData.length,
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              Container(
                                        child: isTripOrExpedition == 'trip'
                                            ? buildTripCard(context, index)
                                            : buildExpedidionCard(
                                                context, index),
                                      ),
                                      staggeredTileBuilder: (int index) =>
                                          new StaggeredTile.fit(1),
                                    ),
                                  )
                                : Container(
                                    child: Center(
                                      child: Text('please wait...'),
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCityCard() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 90.0,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/images/bg.jpg",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 2.0,
            ),
            Text(
              "City Name",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTripCard(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailPage(
              isTripOrExpedition: 'trip',
              parcelDetail: resultData[index],
            ),
          ),
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 100.0,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  imageUrl +
                      'storage/' +
                      resultData[index]['departureCityImage'],
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 6.0,
              ),
              Text(
                resultData[index]['cityDepartureTrip'].toString() +
                    ' (' +
                    resultData[index]['offeredKilosTrip'].toString() +
                    'kg)',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildExpedidionCard(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailPage(
              isTripOrExpedition: 'expedition',
              parcelDetail: resultData[index],
            ),
          ),
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 100.0,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  imageUrl +
                      'storage/' +
                      resultData[index]['departureCityImage'],
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 6.0,
              ),
              Text(
                resultData[index]['cityDepartureParcel'].toString() +
                    ' (' +
                    resultData[index]['weightParcel'].toString() +
                    'kg)',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
