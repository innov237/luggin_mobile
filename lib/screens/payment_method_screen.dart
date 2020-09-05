import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/screens/payment_screen.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/services/preferences_service.dart';

class PaymentMethodScreen extends StatefulWidget {
  final requestData;
  PaymentMethodScreen({this.requestData});

  @override
  _PaymentMethodScreenState createState() =>
      _PaymentMethodScreenState(this.requestData);
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final requestData;
  _PaymentMethodScreenState(this.requestData);

  HttpService httpService = HttpService();
  var authUserData;
  var userCashData;
  bool cashInsufficient = false;

  _getuserLugginPay() async {
    var response =
        await httpService.getPostByKey("getUserCash", authUserData['id']);
    setState(() {
      userCashData = response;
      print(userCashData);
    });
  }

  _openPayementScreen(requestData, paymentMethod) {
    if (requestData == null) {
      return;
    }

    if (paymentMethod == 'lugginpay') {
      if (requestData['price_delivery'] > userCashData['cashAmount']) {
        setState(() {
          cashInsufficient = true;
        });
        return;
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          requestData: requestData,
          paymentMethod: paymentMethod,
        ),
      ),
    );
  }

  getPreferencesData() {
    PreferenceStorage.getDataFormPreferences('USERDATA').then((data) {
      if (null == data) {
        return;
      }
      setState(() {
        var storageValue = json.decode(data);
        authUserData = storageValue;
        print(authUserData);
        _getuserLugginPay();
      });
    });
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
          title: Text("Payment method"),
        ),
        body: buildPaymentMethod(),
      ),
    );
  }

  Widget buildPaymentMethod() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () => _openPayementScreen(requestData, 'card'),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      "assets/images/bank-card.png",
                      height: 35.0,
                      color: Palette.primaryColor,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "Credit card",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          InkWell(
            onTap: () => _openPayementScreen(requestData, 'paypal'),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      "assets/images/paypal.png",
                      height: 40.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Paypal",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          InkWell(
            onTap: () => _openPayementScreen(requestData, 'lugginpay'),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/logo2.png",
                                height: 40.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "Luggin Pay",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Text("Balance"),
                            SizedBox(
                              height: 3.0,
                            ),
                            Text(
                              userCashData != null
                                  ? userCashData['cashAmount'].toString() + "€"
                                  : '...',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (cashInsufficient) ...[
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Center(
                          child: Text(
                            "Your luggin Pay balance is insufficient",
                            style: TextStyle(
                              color: Color(0xFFFF5B38),
                            ),
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
