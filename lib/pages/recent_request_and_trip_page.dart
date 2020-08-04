import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/pages/post_detail.dart';
import 'package:luggin/pages/trip_list_page.dart';
import 'package:luggin/pages/request_list_page.dart';

class RecentRequestAndTripPage extends StatefulWidget {
  @override
  _RecentRequestAndTripPageState createState() =>
      _RecentRequestAndTripPageState();
}

class _RecentRequestAndTripPageState extends State<RecentRequestAndTripPage> {
  String apiUrl = AppEvironement.apiUrl;
  String imageUrl = AppEvironement.imageUrl;
  var tripData = [];
  var expeditionData = [];

  getRecentTrip() async {
    Dio dio = Dio();
    try {
      var response = await dio.get(apiUrl + 'getAllTrips');
      if (response.statusCode == 200) {
        setState(() {
          tripData = response.data;
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
          expeditionData = response.data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getRecentTrip();
    getRecentRequest();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Recent post"),
        ),
        body: ListView(
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
                            "Recent trips",
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
                  Expanded(
                    child: tripData.length > 0
                        ? Column(
                            children: <Widget>[
                              Container(
                                height: 270.0,
                                child: StaggeredGridView.countBuilder(
                                  shrinkWrap: false,
                                  primary: false,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.all(5),
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 3.0,
                                  crossAxisSpacing: 4.0,
                                  itemCount: tripData.length >= 4
                                      ? 4
                                      : tripData.length,
                                  itemBuilder: (context, int index) =>
                                      buildTripCard(context, index),
                                  staggeredTileBuilder: (int index) =>
                                      new StaggeredTile.fit(2),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TripListPage(),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 15.0,
                                        right: 10.0,
                                      ),
                                      child: Text(
                                        tripData.length > 4 ? "see more" : "",
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : Container(
                            child: Center(child: Text("please wait...")),
                          ),
                  )
                ],
              ),
            ),
            Container(
              height: 5.0,
              color: Color(0xFFF2F5F5),
            ),
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
                            "Recent Requests",
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
                  Expanded(
                    child: expeditionData.length > 0
                        ? Column(
                            children: <Widget>[
                              Container(
                                height: 270.0,
                                child: StaggeredGridView.countBuilder(
                                  shrinkWrap: true,
                                  primary: false,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.all(5),
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 3.0,
                                  crossAxisSpacing: 4.0,
                                  itemCount: expeditionData.length >= 4
                                      ? 4
                                      : expeditionData.length,
                                  itemBuilder: (context, int index) =>
                                      buildExpeditionCard(context, index),
                                  staggeredTileBuilder: (int index) =>
                                      new StaggeredTile.fit(2),
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RequestList(),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 15.0,
                                        right: 10.0,
                                        bottom: 5.0,
                                      ),
                                      child: Text(
                                        expeditionData.length > 4
                                            ? "see more"
                                            : "",
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        : Container(
                            child: Center(child: Text("please wait...")),
                          ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTripCard(BuildContext context, int index) => Card(
        elevation: 0.2,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailPage(
                parcelDetail: tripData[index],
                isTripOrExpedition: 'trip',
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                    imageUrl + 'storage/' + tripData[index]['avatar'],
                  ),
                ),
                SizedBox(
                  height: 6.0,
                ),
                Text(
                  tripData[index]['cityDepartureTrip'] +
                      '-' +
                      tripData[index]['cityArrivalTrip'],
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  tripData[index]['offeredKilosTrip'].toString() + "kg",
                  style: TextStyle(
                    color: Color(0xFF92B557),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ),
  );

  Widget buildExpeditionCard(BuildContext context, int index) => Card(
        elevation: 0.2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailPage(
                    parcelDetail: expeditionData[index],
                    isTripOrExpedition: 'expedition',
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                    imageUrl + 'storage/' + expeditionData[index]['avatar'],
                  ),
                ),
                SizedBox(
                  height: 6.0,
                ),
                Text(
                  expeditionData[index]['cityDepartureParcel'] +
                      '-' +
                      expeditionData[index]['cityArrivalParcel'],
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  expeditionData[index]['weightParcel'].toString() + "kg",
                  style: TextStyle(
                    color: Color(0xFF92B557),
                    fontWeight: FontWeight.bold,
                  ),
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
