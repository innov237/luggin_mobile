import 'package:flutter/material.dart';
import 'package:luggin/config/style.dart';
import 'package:luggin/environment/environment.dart';

import 'package:luggin/widgets/linesHeader_widgets.dart';
import 'package:luggin/widgets/requestCard_widgets.dart';
import 'package:luggin/widgets/tripCard_widgets.dart';

class SearchResultScreen extends StatefulWidget {
  final isTripOrRequest;
  final responseData;

  SearchResultScreen(
      {@required this.isTripOrRequest, @required this.responseData});
  @override
  _SearchResultScreenState createState() =>
      _SearchResultScreenState(this.isTripOrRequest, this.responseData);
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  String apiUrl = AppEvironement.apiUrl;
  String imageUrl = AppEvironement.imageUrl;

  final isTripOrRequest;
  final responseData;

  _SearchResultScreenState(this.isTripOrRequest, this.responseData);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: 150.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/word-map.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                height: 60.0,
                width: double.infinity,
                decoration: Style.gradientDecoration,
              ),
            ),
            LinesHeaderWidget(
              title: "Search Result",
            ),
            Padding(
              padding: const EdgeInsets.only(top: 85.0),
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView.builder(
                    itemCount: responseData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return isTripOrRequest == 'trip'
                          ? TripCardWidget(responseData: responseData[index])
                          : RequestCardWidget(
                              responseData: responseData[index],
                            );
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
