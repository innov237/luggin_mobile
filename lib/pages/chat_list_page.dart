import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/services/preferences_service.dart';
import 'dart:convert';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/pages/chat_room_page.dart';
import 'package:intl/intl.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  HttpService httpService = HttpService();
  var authUserData;
  String imageApiUrl = AppEvironement.imageUrl;

  @override
  void initState() {
    super.initState();
    getPreferencesData();
  }

  getPreferencesData() {
    PreferenceStorage.getDataFormPreferences('USERDATA').then((data) {
      if (null == data) {
        return;
      }
      setState(() {
        var storageValue = json.decode(data);
        authUserData = storageValue;
        this.getUserConversation();
      });
    });
  }

  getUserConversation() async {
    var response = await httpService.getPostByKey(
        "getUserConversation", authUserData['id']);
    return response;
  }

  getTime(timestamp) {
    String formattedDate = DateFormat('kk:mm').format(DateTime.parse(timestamp));
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
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
              width: double.infinity,
              height: 160.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Chat list",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  color: Color(0xFFF3F5F5),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: FutureBuilder(
                    future: authUserData != null ? getUserConversation() : null,
                    builder: (BuildContext context, AsyncSnapshot snapShot) {
                      return snapShot.hasData
                          ? snapShot.data.length > 0
                              ? ListView.builder(
                                  itemCount: snapShot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          buildChatList(
                                    context,
                                    index,
                                    snapShot.data,
                                  ),
                                )
                              : Center(
                                  child: Text("No conversation"),
                                )
                          : Center(
                              child: CircularProgressIndicator(),
                            );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildChatList(BuildContext context, int index, data) {
    var userData = data[index]['userData'];
    var lastMessage = data[index]['messageData'].length > 0
        ? data[index]['messageData'][data[index]['messageData'].length - 1]
        : null;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatRoomPage(
              requestData: data[index],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 0.5,
          ),
        )),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.black12,
                      backgroundImage: NetworkImage(
                        imageApiUrl + 'storage/' + userData['avatar'],
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              userData['pseudo'],
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                color: Palette.primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    data[index]['isTripOrExpedition'],
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          lastMessage != null
                              ? lastMessage['body']
                              : 'No message',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                lastMessage != null
                    ? getTime(lastMessage['created_at']).toString()
                    : '',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
