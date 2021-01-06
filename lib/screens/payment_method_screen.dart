import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/config/style.dart';
import 'package:luggin/screens/payment_screen.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/services/preferences_service.dart';
import 'package:separated_number_input_formatter/separated_number_input_formatter.dart';

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

  getPreferencesData() {
    PreferenceStorage.getDataFormPreferences('USERDATA').then((data) {
      if (null == data) {
        return;
      }
      setState(() {
        var storageValue = json.decode(data);
        authUserData = storageValue;
        print(authUserData);
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
        appBar: AppBar(),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Edit your payment \nmethods",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(),
                  ListTile(
                    leading: Image.asset(
                      "assets/images/paypal.png",
                      width: 30.0,
                    ),
                    title: Text("Paypal didier.bikie@gmail.com"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  Divider(),
                  Divider(),
                  ListTile(
                    leading: Image.asset(
                      "assets/images/paypal.png",
                      width: 30.0,
                    ),
                    title: Text("Paypal didier.bikie@gmail.com"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  Divider(),
                  Divider(),
                  ListTile(
                    leading: Image.asset(
                      "assets/images/visa-icon.png",
                      width: 50.0,
                    ),
                    title: Text("Visa 8069"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  Divider(),
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPaymentMethod(),
                      ),
                    ),
                    child: Text(
                      "Add payment method",
                      style: TextStyle(
                        color: Palette.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EditPaymentMethod extends StatefulWidget {
  @override
  _EditPaymentMethodState createState() => _EditPaymentMethodState();
}

class _EditPaymentMethodState extends State<EditPaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add payment method",
          ),
        ),
        body: buildPayementForm(),
      ),
    );
  }

  Widget buildPayementForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.white,
            elevation: 0.3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Card Number"),
                  ),
                  Container(
                    decoration: Style.inputBoxDecorationRectangle,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: null,
                        maxLength: 19,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                        decoration: InputDecoration(
                          hintText: 'XXXX XXXX XXXX XXXX',
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          SeparatedNumberInputFormatter(4, separator: ' '),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Expiry Date"),
                  ),
                  Container(
                    decoration: Style.inputBoxDecorationRectangle,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: null,
                        maxLength: 5,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                        decoration: InputDecoration(
                          hintText: 'MM/YY',
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          // Use with digits and separator parameters.
                          SeparatedNumberInputFormatter(2, separator: '/'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Card Holder"),
                  ),
                  Container(
                    decoration: Style.inputBoxDecorationRectangle,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: null,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Ex. John innov",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("CVV"),
                  ),
                  Container(
                    decoration: Style.inputBoxDecorationRectangle,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: null,
                        maxLength: 3,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                        decoration: InputDecoration(
                          hintText: 'XXX',
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: double.infinity,
                    height: 40.0,
                    child: RaisedButton(
                      color: Palette.primaryColor,
                      onPressed: () => null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
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
    );
  }
}
