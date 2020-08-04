import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/utils/date_format.dart';
import 'dart:math' as math;

class TransfertHistoryScreen extends StatefulWidget {
  @override
  _TransfertHistoryScreenState createState() => _TransfertHistoryScreenState();
}

class _TransfertHistoryScreenState extends State<TransfertHistoryScreen> {
  HttpService httpService = HttpService();
  var userData;
  var userCashData;

  _getuserLugginPay() async {
    var response = await httpService.getPostByKey("getUserCash", 3);
    return response;
    // setState(() {
    //   userCashData = response;
    //   print(userCashData);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Transfer history"),
        ),
        body: FutureBuilder(
          future: _getuserLugginPay(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data['cashInOutData'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 10.0,
                        ),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Transform.rotate(
                                            angle: math.pi + math.pi / 2,
                                            child: Container(
                                              height: 20.0,
                                              width: 50.0,
                                              color:
                                                  snapshot.data['cashInOutData']
                                                                  [index]
                                                              ['status'] ==
                                                          'in'
                                                      ? Palette.primaryColor
                                                      : Colors.redAccent,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: Text(
                                                  snapshot.data['cashInOutData']
                                                      [index]['status'],
                                                  style: TextStyle(
                                                    color: Colors.white,
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
                                                        snapshot.data[
                                                                'cashInOutData']
                                                            [
                                                            index]['created_at'])
                                                    .toString(),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text("innov237"),
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
                                        snapshot.data['cashInOutData'][index]
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
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text("net work error"),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
