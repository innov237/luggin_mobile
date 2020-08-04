import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/pages/accept_or_decline_request_page.dart';
import 'package:luggin/screens/write_review_screen.dart';
import 'package:luggin/services/preferences_service.dart';
import 'package:luggin/pages/accept_request_notification_detail_page.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var authUserData;
  bool isLoard = true;

  String apiUrl = AppEvironement.apiUrlDev;
  String imageUrl = AppEvironement.imageUrl;

  var responseData = [];

  getUserNotification() async {
    Dio dio = Dio();
    var response = await dio.get(
      apiUrl + "getUserNotification",
      queryParameters: {
        'idUser': authUserData['id'],
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        responseData = response.data;
        isLoard = false;
      });

      print(responseData);
    } else {
      print("err");
      setState(() {
        isLoard = false;
      });
    }
  }

  getDateTime(timestamp) {
    String formattedDate =
        DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(timestamp));
    return formattedDate;
  }

  @override
  void initState() {
    getPreferencesData();
    super.initState();
  }

  getPreferencesData() {
    PreferenceStorage.getDataFormPreferences('USERDATA').then((data) {
      if (null == data) {
        return;
      }
      setState(() {
        var storageValue = json.decode(data);
        authUserData = storageValue;
        getUserNotification();
      });
    });
  }

  _openPage(page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  redirectNotification(notificationtype, idRequest, transmitterId) {
    if (notificationtype == 'trip') {
      _openPage(
        AcceptOrDeclineRequestPage(
          idRequest: idRequest,
          transmitterId: transmitterId,
          notificationType: notificationtype,
        ),
      );
    }

    if (notificationtype == 'request') {
      _openPage(
        AcceptOrDeclineRequestPage(
          idRequest: idRequest,
          transmitterId: transmitterId,
          notificationType: notificationtype,
        ),
      );
    }

    if (notificationtype == 'expedition') {
      _openPage(
        AcceptOrDeclineRequestPage(
          idRequest: idRequest,
          transmitterId: transmitterId,
          notificationType: notificationtype,
        ),
      );
    }

    if (notificationtype == 'accepted-request') {
      _openPage(
        AcceptRequestNotificationDetailPage(
          idRequest: idRequest,
          transmitterId: transmitterId,
          notificationType: notificationtype,
        ),
      );
    }

    if (notificationtype == 'reviews') {
      print(responseData);

      // responseData[0]['idDeliveryRequest'] = responseData[0]['id_request'];
      // responseData[0]['idReceiver'] = responseData[0]['transmitterId'];
      // responseData[0]['idSender'] = responseData[0]['receiverId'];
      // responseData[0]['userData'] = {
      //   'pseudo': responseData[0]['pseudo'],
      //   'avatar': responseData[0]['avatar']
      // };

      // _openPage(WriteReviewScreen(requestData: responseData[0]));
    }

    if (notificationtype == 'message') {
      _openPage(
        AcceptRequestNotificationDetailPage(
          idRequest: idRequest,
          transmitterId: transmitterId,
          notificationType: notificationtype,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: isLoard ? Colors.white : null,
        appBar: AppBar(
          title: Text("Notifications"),
        ),
        body: (responseData.length > 0)
            ? ListView.builder(
                itemCount: responseData.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildNotificationCard(context, index),
              )
            : (responseData.length == 0 && !isLoard)
                ? Center(
                    child: Text(
                      "No notification",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      child: Image.asset(
                        "assets/images/loader.gif",
                        height: 60.0,
                        width: 60.0,
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget buildNotificationCard(BuildContext context, int index) {
    return InkWell(
      onTap: () => redirectNotification(
          responseData[index]['notification_type'],
          responseData[index]['id_request'],
          responseData[index]['transmitterId']),
      child: Card(
        elevation: 0.2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.black12,
                        radius: 15.0,
                        child: responseData[index]['notification_type'] ==
                                'trip'
                            ? Icon(
                                Icons.flight,
                                color: Colors.green,
                                size: 19.0,
                              )
                            : responseData[index]['notification_type'] ==
                                    'request'
                                ? Icon(
                                    Icons.input,
                                    color: Colors.cyan,
                                    size: 19.0,
                                  )
                                : responseData[index]['notification_type'] ==
                                        'reviews'
                                    ? Icon(
                                        Icons.star,
                                        color: Colors.blueGrey,
                                        size: 19.0,
                                      )
                                    : Icon(
                                        Icons.mail,
                                        color: Colors.white,
                                        size: 19.0,
                                      ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        responseData[index]['notification_type'],
                        style: TextStyle(
                          color:
                              responseData[index]['notification_type'] == 'trip'
                                  ? Colors.green
                                  : responseData[index]['notification_type'] ==
                                          'request'
                                      ? Colors.cyan
                                      : Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    getDateTime(responseData[index]['created_at']).toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 50.0,
                          width: 2.0,
                          color: Colors.black12,
                        ),
                        CircleAvatar(
                          radius: 5.0,
                          backgroundColor: Colors.black12,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        responseData[index]['notification_header'] != null
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Text(
                                  responseData[index]['notification_header'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Container(),
                        Text(
                          responseData[index]['notification_message'],
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  radius: 15.0,
                  backgroundColor: Colors.black12,
                  backgroundImage: NetworkImage(
                    imageUrl + "storage/" + responseData[index]['avatar'],
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
