import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/config/style.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/services/preferences_service.dart';
import 'package:separated_number_input_formatter/separated_number_input_formatter.dart';

class PayoutPage extends StatefulWidget {
  @override
  _PayoutPageState createState() => _PayoutPageState();
}

class _PayoutPageState extends State<PayoutPage> {
  var userCashData;
  var authUserData;
  bool isLoad = true;
  bool transferLoad = false;
  HttpService httpService = HttpService();
  TextEditingController _amountController;
  TextEditingController _recipientController;
  TextEditingController _cardNumberController;

  _getuserLugginPay() async {
    setState(() {
      isLoad = true;
    });
    var response =
        await httpService.getPostByKey("getUserCash", authUserData['id']);
    setState(() {
      userCashData = response;
      print(userCashData);
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
        print(authUserData);
        _getuserLugginPay();
      });
    });
  }

  _transfert() async {
    if (_cardNumberController.text.isEmpty ||
        _recipientController.text.isEmpty ||
        _amountController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "All fields are required",
        backgroundColor: Colors.white24,
      );
      return;
    }

    if (userCashData['cashAmount'] < int.parse(_amountController.text)) {
      Fluttertoast.showToast(
        msg: "Insufficient amount",
        backgroundColor: Colors.white24,
      );
      return;
    }

    var postData = {
      'idUser': authUserData['id'],
      'recipient': _recipientController.text,
      'cardNumber': _cardNumberController.text,
      'amount': _amountController.text,
    };

    setState(() {
      transferLoad = true;
    });

    var response = await httpService.postData("transferCash", postData);
    if (response['success']) {
      setState(() {
        transferLoad = false;
        getPreferencesData();
        _amountController.text = '';
        _cardNumberController.text = '';
        _recipientController.text = '';
      });
      Fluttertoast.showToast(
        msg: "Successfully transferred",
        backgroundColor: Colors.white24,
      );
    } else {
      transferLoad = false;
    }
  }

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController();
    _recipientController = TextEditingController();
    _cardNumberController = TextEditingController();
    getPreferencesData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Payout"),
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Cash Aviable",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    !isLoad
                        ? userCashData['cashAmount'].toString() + '€'
                        : '...',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Card(
                                  color: Colors.white,
                                  elevation: 0.3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Recipient"),
                                        ),
                                        Container(
                                          decoration:
                                              Style.inputBoxDecorationRectangle,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: TextField(
                                              controller: _recipientController,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    "Write the name of recipient",
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("IBAN"),
                                        ),
                                        Container(
                                          decoration:
                                              Style.inputBoxDecorationRectangle,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: TextField(
                                              controller: _cardNumberController,
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
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                SeparatedNumberInputFormatter(4,
                                                    separator: ' '),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Transfer Amount"),
                                        ),
                                        Container(
                                          decoration:
                                              Style.inputBoxDecorationRectangle,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: TextField(
                                              controller: _amountController,
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Amount",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  color: Colors.black,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Transfer",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () => !transferLoad ? _transfert() : '',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  color: Palette.primaryColor,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        !transferLoad
                                            ? "Transfer"
                                            : "In progress...",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
