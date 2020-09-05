import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/services/preferences_service.dart';

class PendingTransferPage extends StatefulWidget {
  @override
  _PendingTransferPageState createState() => _PendingTransferPageState();
}

class _PendingTransferPageState extends State<PendingTransferPage> {
  HttpService httpservice = HttpService();
  var authUserData;
  var pendingTransferData;
  bool isLoad = true;

  _getUserPindingRequest(userId) async {
    var responseData = await httpservice
        .getPostByKey("getUserPendingRequest", {'key': userId});

    setState(() {
      pendingTransferData = responseData;
      isLoad = false;
    });
  }

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
        _getUserPindingRequest(authUserData['id']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Pending transfer"),
        ),
        body: !isLoad
            ? pendingTransferData.length > 0
                ? ListView.builder(
                    itemCount: pendingTransferData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 5.0,
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    pendingTransferData[index]['price_delivery']
                                            .toString() +
                                        "€",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "From: " +
                                            pendingTransferData[index]
                                                ['pseudo'],
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        "ID-Delevery: " +
                                            pendingTransferData[index]
                                                    ['idDelevery']
                                                .toString(),
                                        style: TextStyle(
                                          color: Colors.black38,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "No  pending transfer ",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  )
            : Center(
                child: Container(
                  height: 15.0,
                  width: 15.0,
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
