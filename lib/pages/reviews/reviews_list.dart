import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';

class ReviewsListPage extends StatefulWidget {
  @override
  _ReviewsListPageState createState() => _ReviewsListPageState();
}

class _ReviewsListPageState extends State<ReviewsListPage> {
  int activeView;

  setView(index) {
    setState(() {
      activeView = index;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      activeView = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("Tous les Avis"),
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
                        Text("Avis Reçus"),
                        Text("Avis Laissés"),
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
                  if (activeView == 0) ...[
                    _buildReviewsRecieved(),
                  ],
                  if (activeView == 1) ...[
                    SizedBox(
                      height: 5.0,
                    ),
                    _buildReviewsSend(),
                    _buildReviewsSend(),
                    _buildReviewsSend(),
                    _buildReviewsSend(),
                    _buildReviewsSend(),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSend() {
    return Container(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text("Avis laissé à"),
                        SizedBox(
                          width: 2.0,
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://picsum.photos/id/237/200/300',
                          ),
                        ),
                        SizedBox(
                          width: 2.0,
                        ),
                        Text(
                          "Cedric",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text("12 Août"),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: double.infinity,
                child: Card(
                  color: Color(0xFFEDEDED),
                  elevation: 0.1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Très bien",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Trajet sympathique avec les amis de Innov",
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

  Widget _buildReviewsRecieved() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Vous avez reçu 51 avis pour une moyenne de",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Colors.black.withOpacity(0.5),
                size: 50.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                "4.5/5",
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            color: Palette.primaryColor,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "SYTHESE DES AVIS RECUS",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _ratecounterItem(title: "Parfait", value: 30),
                _ratecounterItem(title: "Très bien", value: 17),
                _ratecounterItem(title: "Bien", value: 3),
                _ratecounterItem(title: "Décevant", value: 1),
                _ratecounterItem(title: "ParfaitA éviter", value: 0),
              ],
            ),
          ),
          Container(
            color: Palette.primaryColor,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "HISTORIQUES",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          _reviewCommentbudbleSent(),
          _reviewCommentbudbleSent(),
          _reviewCommentbudbleSent(),
          _reviewCommentbudbleSent(),
        ],
      ),
    );
  }

  Widget _ratecounterItem({String title, int value}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 5.0,
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              value.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  Widget _reviewCommentbudbleSent() {
    return Container(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://picsum.photos/id/237/200/300',
                          ),
                        ),
                        SizedBox(
                          width: 2.0,
                        ),
                        Text(
                          "Cedric",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "12 Août",
                    style: TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  width: double.infinity,
                  child: Card(
                    color: Color(0xFFEDEDED),
                    elevation: 0.1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Très bien",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "Trajet sympathique avec les amis de Innov",
                          )
                        ],
                      ),
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
