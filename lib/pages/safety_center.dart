import 'package:flutter/material.dart';

class SafetyCenter extends StatefulWidget {
  @override
  _SafetyCenterState createState() => _SafetyCenterState();
}

class _SafetyCenterState extends State<SafetyCenter> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Safety Center",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Get support, tools, and information you need to be safe.",
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Card(
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 10.0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.red,
                                size: 18.0,
                              ),
                              SizedBox(
                                width: 3.0,
                              ),
                              Text(
                                'Call local emergency services',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Text(
                              "Get the phone numbers you need if someone is in  danger or injured.",
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 3.0,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/bag.png",
                                  width: 100.0,
                                  height: 150.0,
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  "Guests: advice on\ntravelling safety",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          elevation: 3.0,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/home-safety.png",
                                  width: 100.0,
                                  height: 150.0,
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  "Guests: advice on\ntravelling safety",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      "Host Resources",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  buildItem(
                    title: "Host Guarantee",
                    icon: Icons.security,
                    subtitle:
                        "Property domage protection of up to \$1 million USD for every host andevery listing",
                  ),
                  buildItem(
                    title: "Host Protection insurancé",
                    icon: Icons.card_travel,
                    subtitle:
                        "Free liability insurance of up to \$1 million USD to protect against personal injury or property domage claims.",
                  ),
                  buildItem(
                    title: "Learn more about Luggin",
                    icon: Icons.hail,
                    subtitle:
                        "Use of spare kilos of a traveler to send your parcels",
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Read more",
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem({String title, String subtitle, IconData icon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),
                ),
                Icon(icon, color: Colors.purple),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(subtitle),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
