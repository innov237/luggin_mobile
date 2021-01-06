import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';

class ChatRoomPage extends StatefulWidget {
  final requestData;

  ChatRoomPage({@required this.requestData});

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("innov"),
          actions: [
            Icon(Icons.more_vert),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      "https://picsum.photos/seed/picsum/200/300",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Jeans dolce & alphy",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Text(
                                    "Yaoundé-Paris",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Text(
                                    "28.00€",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            height: 35.0,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Palette.primaryColor,
                                      ),
                                    ),
                                    child: RaisedButton(
                                      onPressed: () => null,
                                      color: Colors.white,
                                      elevation: 0.3,
                                      child: Text(
                                        "Réserver",
                                        style: TextStyle(
                                          color: Palette.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Palette.primaryColor,
                                      ),
                                    ),
                                    child: RaisedButton(
                                      onPressed: () => null,
                                      color: Colors.white,
                                      elevation: 0.3,
                                      child: Text(
                                        "Faire une offre",
                                        style: TextStyle(
                                          color: Palette.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "https://picsum.photos/seed/picsum/200/300",
                                ),
                              ),
                              Column(
                                children: [
                                  Card(
                                    elevation: 0.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Bonjour ! Moi c'est innov",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 12.0,
                                                color: Colors.yellow[800],
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 12.0,
                                                color: Colors.yellow[800],
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 12.0,
                                                color: Colors.yellow[800],
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 12.0,
                                                color: Colors.yellow[800],
                                              ),
                                              Text(
                                                "60 évaluations",
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.pin_drop,
                                                color: Colors.black54,
                                              ),
                                              Text(
                                                "Yaoundé cameroun",
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Container(
              height: 60.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: Colors.black38,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          color: Colors.black12,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Envoyer un message",
                                    ),
                                    minLines: 2,
                                    maxLines: 5,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
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
          ],
        ),
      ),
    );
  }
}
