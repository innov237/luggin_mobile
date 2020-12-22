import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:luggin/config/style.dart';
import 'package:luggin/forms/search_form.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/widgets/tripCard_widgets.dart';
import 'package:luggin/widgets/requestCard_widgets.dart';
import 'package:luggin/widgets/linesHeader_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class ResentPostScreen extends StatefulWidget {
  @override
  _ResentPostScreenState createState() => _ResentPostScreenState();
}

class _ResentPostScreenState extends State<ResentPostScreen> {
  HttpService httpService = HttpService();

  bool isLoad = true;

  var tripData;
  var requestData;
  int currentIndex = 0;

  getRecentTrip() async {
    httpService.getPosts('getAllTrips').then((result) {
      setState(() {
        tripData = result;
      });
    });
  }

  getRecentRequest() async {
    httpService.getPosts('getAllExpedition').then((result) {
      setState(() {
        this.requestData = result;
      });
    });
  }

  setView(index) {
    setState(() {
      currentIndex = index;
    });
    if (index == 0) {
      getRecentTrip();
    } else {
      getRecentRequest();
    }
  }

  @override
  void initState() {
    super.initState();
    setView(0);
    getRecentRequest();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            (tripData != null && requestData != null) ? null : Colors.white,
        body: Stack(
          children: [
            Container(
              height: 190.0,
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
              title: "recent-post".tr()
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 50.0,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      DefaultTabController(
                        length: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          height: 42.0,
                          child: TabBar(
                            indicator: BubbleTabIndicator(
                              tabBarIndicatorSize: TabBarIndicatorSize.tab,
                              indicatorHeight: 35.0,
                              indicatorColor: Colors.white,
                            ),
                            labelStyle: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            labelColor: Palette.primaryColor,
                            unselectedLabelColor: Colors.white,
                            isScrollable: true,
                            tabs: <Widget>[
                              Text("Trip"),
                              Text("Request"),
                            ],
                            onTap: (index) {
                              setView(index);
                            },
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.white10,
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchForm(),
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 22.0,
                            backgroundColor: Colors.white30,
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 115.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: (tripData != null && requestData != null)
                    ? ListView.builder(
                        itemCount: currentIndex == 0
                            ? tripData.length
                            : requestData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return currentIndex == 0
                              ? TripCardWidget(responseData: tripData[index])
                              : RequestCardWidget(
                                  responseData: requestData[index],
                                );
                        },
                      )
                    : Center(
                        child: Image.asset(
                          "assets/images/loader.gif",
                          height: 50.0,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
