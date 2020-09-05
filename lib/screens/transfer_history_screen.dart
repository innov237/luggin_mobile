import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/services/preferences_service.dart';
import 'package:luggin/utils/date_format.dart';
import 'dart:math' as math;

class TransfertHistoryScreen extends StatefulWidget {
  @override
  _TransfertHistoryScreenState createState() => _TransfertHistoryScreenState();
}

class _TransfertHistoryScreenState extends State<TransfertHistoryScreen> {
  HttpService httpService = HttpService();
  var authUserData;
  var userCashData;
  bool isLoad = true;

  _getuserLugginPay() async {
    var response =
        await httpService.getPostByKey("getUserCash", authUserData['id']);
    setState(() {
      userCashData = response;
      setState(() {
        isLoad = false;
      });
    });
  }

  getPreferencesData() {
    PreferenceStorage.getDataFormPreferences('USERDATA').then((data) {
      if (null == data) {
        return;
      }
      setState(() {
        var storageValue = json.decode(data);
        authUserData = storageValue;
        _getuserLugginPay();
      });
    });
  }

  _translateStatus(value) {
    if (value == 'in') {
      return 'Recieve';
    } else {
      return 'Send';
    }
  }

  @override
  void initState() {
    super.initState();
    getPreferencesData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Transfer history"),
        ),
        body: !isLoad
            ? ListView.builder(
                itemCount: userCashData['cashInOutData'].length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 10.0,
                      ),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Transform.rotate(
                                          angle: math.pi + math.pi / 2,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                            ),
                                            child: Container(
                                              height: 20.0,
                                              width: 50.0,
                                              color:
                                                  userCashData['cashInOutData']
                                                                  [index]
                                                              ['status'] ==
                                                          'in'
                                                      ? Palette.primaryColor
                                                      : Color(0xFFFF8F4E),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5.0,
                                                  top: 3.0,
                                                ),
                                                child: Text(
                                                  _translateStatus(userCashData[
                                                          'cashInOutData']
                                                      [index]['status']),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 2.0),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              ChangeFormatDate.toDateTimeEn(
                                                      userCashData[
                                                              'cashInOutData']
                                                          [index]['created_at'])
                                                  .toString(),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(userCashData['cashInOutData']
                                                        [index]['origin'] !=
                                                    null
                                                ? userCashData['cashInOutData']
                                                        [index]['origin']
                                                    .toString()
                                                : '--//--'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text("Amount"),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      userCashData['cashInOutData'][index]
                                                  ['amount']
                                              .toString() +
                                          "€",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
