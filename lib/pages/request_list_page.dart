import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/pages/post_detail.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/forms/search_form.dart';

import 'package:http/http.dart' as http;

class RequestList extends StatefulWidget {
  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  var responseData;

  String imageUrl = AppEvironement.imageUrl;
  String apiUrl = AppEvironement.apiUrl;

  getRecentRequest() async {
    try {
      var response = await http.get(apiUrl + 'getAllExpedition');
      if (response.statusCode == 200) {
        setState(() {
          responseData = json.decode(response.body);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getRecentRequest();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: responseData == null ? Colors.white : null,
        floatingActionButton: responseData != null
            ? FloatingActionButton.extended(
                elevation: 1.0,
                icon: Icon(Icons.filter_list),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchForm(),
                  ),
                ),
                backgroundColor: Palette.primaryColor,
                label: Text("Filter"),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: Text("Request"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: responseData != null
              ? ListView.builder(
                  itemCount: responseData.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildCard(context, index),
                )
              : Center(
                  child: Container(
                    child: Image.asset(
                      "assets/images/loader.gif",
                      height: 60.0,
                      width: 60.0,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, int index) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostDetailPage(
            parcelDetail: responseData[index],
            isTripOrExpedition: 'expedition',
          ),
        ),
      ),
      child: Card(
        elevation: 0.2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 15.0),
                    child: Container(
                      height: 77.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "Date",
                                style: TextStyle(
                                  color: Palette.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                              Text(
                                responseData[index]['dateDepartureParcel'],
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 12.0,
                          backgroundColor: Palette.primaryColor,
                          child: Icon(
                            Icons.flight_takeoff,
                            size: 14.0,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          height: 38.0,
                          width: 3.0,
                          color: Palette.primaryColor,
                        ),
                        CircleAvatar(
                          radius: 12.0,
                          backgroundColor: Palette.primaryColor,
                          child: Icon(
                            Icons.flight_land,
                            size: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Container(
                        height: 77.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              responseData[index]['cityDepartureParcel'],
                              style: TextStyle(
                                color: Palette.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    responseData[index]['weightParcel']
                                            .toString() +
                                        "Kg",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              responseData[index]['cityArrivalParcel'],
                              style: TextStyle(
                                color: Palette.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.black12,
                        backgroundImage: NetworkImage(
                          imageUrl + "storage/" + responseData[index]['avatar'],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 23.0, left: 23.0),
                        child: CircleAvatar(
                          radius: 10.0,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.verified_user,
                            color: Colors.white,
                            size: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          responseData[index]['pseudo'],
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withOpacity(0.7)),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              size: 15.0,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              "3.5",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.7)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black12,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
