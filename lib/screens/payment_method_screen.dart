import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/services/http_service.dart';

class PaymentMethodScreen extends StatefulWidget {
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  HttpService httpService = HttpService();
  var userData;
  var userCashData;

  _getuserLugginPay() async {
    var response = await httpService.getPostByKey("getUserCash", 3);

    setState(() {
      userCashData = response;
      print(userCashData);
    });
  }

  @override
  void initState() {
    super.initState();
    _getuserLugginPay();
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
          Card(
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
          SizedBox(
            height: 5.0,
          ),
          Card(
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
          SizedBox(
            height: 5.0,
          ),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
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
            ),
          ),
        ],
      ),
    );
  }
}
