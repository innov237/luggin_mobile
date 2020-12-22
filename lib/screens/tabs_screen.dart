import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/pages/notification_page.dart';
import 'package:luggin/pages/post_trip_page.dart';
import 'package:luggin/pages/send_parcel_page.dart';
import 'package:luggin/screens/home_screen.dart';
import 'package:luggin/pages/chat_list_page.dart';
import 'package:luggin/screens/menu_sreen.dart';
import 'package:luggin/screens/search_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _currentIndex = 2;

  final List _screens = [
    TakeParcelPage(),
    SendParcelPage(),
    HomeScreen(),
    SearchScreen(),
    ChatListPage(),
  ];

  _setIndex(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _openPage(context, page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  //DOUBLE CLIK CLOSE APP
  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "press-to-exit".tr(),
        backgroundColor: Colors.white24,
      );
      return Future.value(false);
    } else {
      Fluttertoast.cancel();
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return Future.value(true);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => onWillPop(),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: InkWell(
              onTap: () => _openPage(
                context,
                MenuScreen(),
              ),
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: InkWell(
                  onTap: () => _openPage(context, NotificationPage()),
                  child: CircleAvatar(
                    radius: 21.0,
                    backgroundColor: Colors.white10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white12,
                      radius: 18.0,
                      child: Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: _screens[_currentIndex],
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: Container(
              height: 61.0,
              color: Color(0xFFFFFFFF),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () => _setIndex(0),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/trip.png",
                            height: 25.0,
                            color: _currentIndex == 4
                                ? Palette.primaryColor
                                : Colors.black.withOpacity(0.7),
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            "new-trip".tr(),
                            style: TextStyle(
                              color: _currentIndex == 0
                                  ? Palette.primaryColor
                                  : Colors.black.withOpacity(0.7),
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _setIndex(1),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/export.png",
                            height: 25.0,
                            color: _currentIndex == 4
                                ? Palette.primaryColor
                                : Colors.black.withOpacity(0.7),
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            "request".tr(),
                            style: TextStyle(
                              color: _currentIndex == 1
                                  ? Palette.primaryColor
                                  : Colors.black.withOpacity(0.7),
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _setIndex(2),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/logo.png",
                            height: 45.0,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _setIndex(3),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/search.png",
                            height: 25.0,
                            color: _currentIndex == 3
                                ? Palette.primaryColor
                                : Colors.black.withOpacity(0.7),
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            "search".tr(),
                            style: TextStyle(
                              color: _currentIndex == 3
                                  ? Palette.primaryColor
                                  : Colors.black.withOpacity(0.7),
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _setIndex(4),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/communications.png",
                            height: 25.0,
                            color: _currentIndex == 4
                                ? Palette.primaryColor
                                : Colors.black.withOpacity(0.7),
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            "message".tr(),
                            style: TextStyle(
                              color: _currentIndex == 4
                                  ? Palette.primaryColor
                                  : Colors.black.withOpacity(0.7),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
