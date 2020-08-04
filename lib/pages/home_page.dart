import 'package:flutter/material.dart';
import 'package:luggin/pages/chat_list_page.dart';
import 'package:luggin/pages/notification_page.dart';
import 'package:luggin/pages/post_trip_page.dart';
import 'package:luggin/pages/recent_request_and_trip_page.dart';
import 'package:luggin/pages/send_parcel_page.dart';
import 'package:luggin/screens/menu_sreen.dart';
import 'package:luggin/screens/choose_search_option_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

_openPage(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/homebg3.jpg",
              ),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50.0,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () => _openPage(context, MenuScreen()),
                        child: Icon(
                          Icons.menu,
                          size: 30,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      InkWell(
                        onTap: () => _openPage(
                          context,
                          NotificationPage(),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Icon(
                              Icons.notifications,
                              size: 30.0,
                              color: Colors.black.withOpacity(0.6),
                            ),
                            CircleAvatar(
                              radius: 10.0,
                              backgroundColor: Colors.red,
                              child: Text(
                                "1",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 300.0,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () => _openPage(
                              context,
                              TakeParcelPage(),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFF2488B9).withOpacity(0.8),
                                  width: 8.0,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              height: 95.0,
                              child: Center(
                                child: Text(
                                  "Spare kilos at disposal ?",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            "Or",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          InkWell(
                            onTap: () => _openPage(
                              context,
                              SendParcelPage(),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFF2488B9).withOpacity(0.8),
                                  width: 8.0,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              height: 95.0,
                              child: Center(
                                child: Text(
                                  "Have you parcel shipped ?",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 50.0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,  
                  ),
                  child: InkWell(
                    onTap: () => _openPage(
                      context,
                      RecentRequestAndTripPage(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Recent",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2488B9),
                          ),
                        ),
                        Container(
                          height: 40.0,
                          child: Image.asset(
                            "assets/images/transportation.png",
                            color: Color(0xFF2488B9),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
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
                          onTap: () => _openPage(
                            context,
                            TakeParcelPage(),
                          ),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/trip.png",
                                height: 25.0,
                                color: Colors.black.withOpacity(0.7),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "New trip",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => _openPage(
                            context,
                            SendParcelPage(),
                          ),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/export.png",
                                height: 25.0,
                                color: Colors.black.withOpacity(0.7),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Request",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () => _openPage(
                                context,
                                RecentRequestAndTripPage(),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100.0),
                                ),
                                child: Container(
                                  height: 45.0,
                                  width: 45.0,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color(0xFF1F84B8),
                                        Color(0xFF1F84B8)
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      "assets/images/logo2.jpg",
                                      height: 25.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () =>
                              _openPage(context, ChooseSearchOptionPage()),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/search.png",
                                height: 25.0,
                                color: Colors.black.withOpacity(0.7),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Search",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => _openPage(context, ChatListPage()),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/communications.png",
                                height: 25.0,
                                color: Colors.black.withOpacity(0.7),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Message",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
