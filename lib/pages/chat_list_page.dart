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
    String formattedDate =
        DateFormat('kk:mm').format(DateTime.parse(timestamp));
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Inbox",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.9),
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35.0),
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
          ],
        ),
      ),
    );
  }

  buildChatList(BuildContext context, int index, data) {
    print(data[index]);
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      userData['avatar'] != 'defaultUserAvatar.jpg'
                          ? CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Colors.black12,
                              backgroundImage: NetworkImage(
                                imageApiUrl + 'storage/' + userData['avatar'],
                              ),
                            )
                          : CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Palette.primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Text(
                                  userData['pseudo'][0].toString(),
                                  style: TextStyle(
                                    fontSize: 36.0,
                                    color: Colors.white,
                                  ),
                                ),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData['pseudo'],
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  data[index]['isTripOrExpedition'] == 'trip'
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.flight_takeoff,
                                              size: 15.0,
                                              color: Palette.primaryColor,
                                            ),
                                            Text('Trip'),
                                            Text(
                                              data[index]['tripData']
                                                          ['cityDepartureTrip']
                                                      .toString() +
                                                  '-' +
                                                  data[index]['tripData']
                                                          ['cityArrivalTrip']
                                                      .toString(),
                                              style: TextStyle(
                                                color: Palette.primaryColor,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            data[index]['tripData']
                                                        ['offeredKilosTrip'] !=
                                                    0
                                                ? Text(
                                                    data[index]['tripData'][
                                                                'offeredKilosTrip']
                                                            .toString() +
                                                        'kg' +
                                                        '-' +
                                                        data[index]['tripData'][
                                                                'offeredKilosPriceTrip']
                                                            .toString() +
                                                        '€',
                                                    style: TextStyle(
                                                      color:
                                                          Palette.primaryColor,
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Icon(
                                              Icons.flight_takeoff,
                                              size: 15.0,
                                              color: Palette.primaryColor,
                                            ),
                                            Text('Expedition'),
                                            data[index]['tripData'][
                                                        'offeredKilosParcel'] !=
                                                    0
                                                ? Text(
                                                    data[index]['tripData'][
                                                                'cityDepartureParcel']
                                                            .toString() +
                                                        '-' +
                                                        data[index]['tripData'][
                                                                'cityArrivalParcel']
                                                            .toString(),
                                                    style: TextStyle(
                                                      color:
                                                          Palette.primaryColor,
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              lastMessage != null
                                  ? lastMessage['body']
                                  : 'No message',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
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
