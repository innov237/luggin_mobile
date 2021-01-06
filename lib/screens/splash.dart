import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luggin/screens/auth/login/login_screen.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/screens/tabs_screen.dart';
import 'package:luggin/services/preferences_service.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var userData;
  Timer _timeDilationTimer;

  getPreferencesData() {
    PreferenceStorage.getDataFormPreferences('USERDATA').then((data) {
      if (null == data) {
        return;
      }
      setState(() {
        userData = data;
      });
    });
  }

  int currentIndex = 0;

  var textList = [
    "Pool luggages together",
    "Share costs",
    "Reduce footprint for a better world"
  ];

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
  void initState() {
    super.initState();
    _timeDilationTimer =
        Timer.periodic(Duration(seconds: 2), (Timer t) => setText());
    getPreferencesData();
    Timer(
      Duration(seconds: 6),
      () => userData == null
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            )
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => 
                TabsScreen(
                  selectedPage: 2,
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _timeDilationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/homebg3.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Palette.primaryColor,
                  Colors.cyan.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white70,
                          radius: 60,
                          child: Card(
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(
                                "assets/images/logo.png",
                                height: 70.0,
                                width: 70.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.white60,
                          highlightColor: Colors.white,
                          child: Container(
                            child: Text(
                              "Luggin",
                              style: TextStyle(
                                fontSize: 35.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: 200.0,
                          child: Text(
                            textList[currentIndex],
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
