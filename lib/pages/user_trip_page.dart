import 'package:flutter/material.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/services/preferences_service.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:luggin/widgets/tripCard_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class UserTripsPage extends StatefulWidget {
  @override
  _UserTripsPageState createState() => _UserTripsPageState();
}

class _UserTripsPageState extends State<UserTripsPage> {
  var authUserData;
  var userTripsData = [];
  bool isLoard = true;

  String apiUrl = AppEvironement.apiUrl;

  getUserTrip() async {
    Dio dio = Dio();
    var response = await dio.get(
      apiUrl + "getUserTrip",
      queryParameters: {
        'userId': authUserData['id'].toString(),
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        userTripsData = response.data;
        print(userTripsData);
        isLoard = false;
      });
    } else {
      print("erreur");
      setState(() {
        isLoard = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPreferencesData();
  }

  getPreferencesData() {
    PreferenceStorage.getDataFormPreferences('USERDATA').then((data) {
      if (null == data) {
        return;
      }
      setState(() {
        var storageValue = json.decode(data);
        authUserData = storageValue;
        getUserTrip();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("your-trips".tr()),
        ),
        body: (!isLoard && userTripsData.length > 0)
            ? ListView.builder(
                itemCount: userTripsData.length,
                itemBuilder: (BuildContext context, int index) =>
                    TripCardWidget(
                  responseData: userTripsData[index],
                ),
              )
            : (userTripsData.length == 0 && !isLoard)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "You don't have a published trip yet",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }

  Widget buildTripCard(BuildContext context, int index) {
    return Card(
      elevation: 0.4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    userTripsData[index]['cityDepartureTrip'] +
                        "-" +
                        userTripsData[index]['cityArrivalTrip'],
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    userTripsData[index]['dateDepartureTrip'],
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    userTripsData[index]['offeredKilosTrip'].toString() + "Kg",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    userTripsData[index]['offeredKilosPriceTrip'].toString(),
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
