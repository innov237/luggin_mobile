import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/forms/search_form.dart';
import 'package:luggin/pages/trip_list_page.dart';
import 'package:luggin/pages/request_list_page.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/widgets/popularDestinationCard_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggin/services/preferences_service.dart';
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  HttpService httpService = HttpService();
  String imageUrl = AppEvironement.imageUrl;
  var recentSearchData;

  _openPage(page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );

    _getRecentSearch();
  }

  _getPopularDestination() async {
    var response = await httpService.getPosts("getPopularDestination");
    return response;
  }

  _getRecentSearch() async {
    var result = await PreferenceStorage.getDataFormPreferences("R_SEARCH");
    if (result != null) {
      var data = json.decode(result);
      setState(() {
        recentSearchData = data.reversed.toList();
        print(recentSearchData);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getRecentSearch();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              ),
              child: Container(
                height: 150.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Palette.primaryColor,
                      Colors.cyan.withOpacity(0.9),
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          "search-title".tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          color: Colors.white.withOpacity(0.9),
                          height: 35.0,
                          child: InkWell(
                            onTap: () => _openPage(
                              SearchForm(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Center(
                                    child: Text(
                                      "people-need-kilos".tr(),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.search,
                                  color: Colors.black.withOpacity(0.5),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () => null,
                            child: Card(
                              elevation: 0.3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.cyan,
                                      child: Icon(
                                        Icons.star,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "favourites-posts".tr(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => null,
                            child: Card(
                              elevation: 0.3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.orangeAccent,
                                      child: Icon(
                                        Icons.archive,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    SizedBox(
                                      child: Text(
                                        "saved-searches".tr(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "popular-destination".tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Container(
                      height: 200.0,
                      child: FutureBuilder(
                        future: _getPopularDestination(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapShot) {
                          if (snapShot.hasData) {
                            return ListView.builder(
                              itemCount: snapShot.data.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) =>
                                  InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (conext) => TripListPage(
                                      params: snapShot.data[index],
                                    ),
                                  ),
                                ),
                                child: PopularDestinationWidget(
                                  destinationData: snapShot.data[index],
                                ),
                              ),
                            );
                          } else if (snapShot.hasError) {
                            return Text(snapShot.error);
                          } else {
                            return Center(
                              child: Image.asset(
                                "assets/images/loader.gif",
                                height: 20.0,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "recent-search".tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    if (recentSearchData != null)
                      Container(
                        child: ListView.builder(
                          itemCount: recentSearchData.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                print(recentSearchData[index]);
                                _openPage(
                                  SearchForm(
                                    inputData: recentSearchData[index],
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 0.1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 2.0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                CircleAvatar(
                                                  radius: 10.0,
                                                  child: recentSearchData[index]
                                                              [
                                                              'isTripOrRequest'] ==
                                                          "trip"
                                                      ? Icon(
                                                          Icons.local_airport,
                                                          size: 15.0,
                                                        )
                                                      : Icon(
                                                          Icons.archive,
                                                          size: 15.0,
                                                        ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                if (recentSearchData[index]
                                                        ['departureCity'] !=
                                                    null) ...[
                                                  Text(
                                                    recentSearchData[index]
                                                        ['departureCity'],
                                                  ),
                                                ],
                                                if (recentSearchData[index]
                                                        ['arrivalCity'] !=
                                                    null) ...[
                                                  Container(
                                                    width: 20.0,
                                                    height: 2.0,
                                                    color: Colors.black12,
                                                  ),
                                                  Text(
                                                    recentSearchData[index]
                                                        ['arrivalCity'],
                                                  ),
                                                ],
                                              ],
                                            ),
                                            Icon(
                                              Icons.refresh,
                                              color: Colors.black12,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (recentSearchData == null)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Your researchers are posted here",
                            style: TextStyle(
                              color: Colors.black12,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
