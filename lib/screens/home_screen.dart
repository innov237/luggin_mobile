import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luggin/screens/resent_post_screen.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/pages/post_trip_page.dart';
import 'package:luggin/pages/send_parcel_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggin/pages/tabs_page.dart';
import 'package:luggin/screens/tabs_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _openPage(context, page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Timer timer;

  int currentIndex = 0;

  var textList = ["slider-text-1", "slider-text-2", "slider-text-3"];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => setText());
  }

  _openTabs(index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TabsScreen(
          selectedPage: index,
        ),
      ),
    );
  }

  void setText() {
    setState(() {
      if (currentIndex <= 1) {
        currentIndex = currentIndex + 1;
      } else {
        currentIndex = 0;
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 160.0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    15.0,
                  ),
                  bottomRight: Radius.circular(
                    15.0,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 150.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/homebg3.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Palette.primaryColor,
                            Colors.cyan.withOpacity(0.4),
                          ],
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 160.0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 25.0),
                                child: SizedBox(
                                  width: 270.0,
                                  child: Text(
                                    textList[currentIndex].tr(),
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/planeline.jpg",
                                      color: Colors.white.withOpacity(0.4),
                                      height: 150.0,
                                    ),
                                  ],
                                ),
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
            Flexible(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () => _openTabs(0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10.0,
                            ),
                          ),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    10.0,
                                  ),
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 70.0,
                                  color: Palette.primaryColor,
                                  child: Center(
                                    child: Text(
                                      "kilos-at-disposal-input".tr(),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      InkWell(
                        onTap: () => _openTabs(1),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10.0,
                            ),
                          ),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    10.0,
                                  ),
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 70.0,
                                  color: Palette.primaryColor,
                                  child: Center(
                                    child: Text(
                                      "parcel-shipped-input".tr(),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 50.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => _openPage(
                    context,
                    ResentPostScreen(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "recent".tr(),
                        style: TextStyle(
                          color: Palette.primaryColor,
                          fontSize: 15.0,
                        ),
                      ),
                      Image.asset(
                        "assets/images/transportation.png",
                        height: 30.0,
                        color: Palette.primaryColor,
                      ),
                    ],
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
