import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';

class GetHelpPage extends StatefulWidget {
  @override
  _GetHelpPageState createState() => _GetHelpPageState();
}

class _GetHelpPageState extends State<GetHelpPage> {
  int currentindex;

  setView(index) {
    setState(() {
      currentindex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      currentindex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("GetHelp"),
        ),
        body: Column(
          children: [
            Container(
              color: Palette.primaryColor,
              height: 60.0,
              child: Center(
                child: DefaultTabController(
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
                        Text("Hosting"),
                        Text("Travelling"),
                      ],
                      onTap: (index) {
                        setView(index);
                      },
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 200.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      currentindex == 0 ? _hostingView() : _travellingView()
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hostingView() {
    return Center(
      child: Text("Content of hosting"),
    );
  }

  Widget _travellingView() {
    return Center(
      child: Text("Content of travelling"),
    );
  }
}
