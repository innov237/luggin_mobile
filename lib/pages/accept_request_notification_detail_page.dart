import 'package:flutter/material.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/pages/user_profil_detail_page.dart';
import 'package:luggin/screens/write_review_screen.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/config/style.dart';
import 'package:luggin/services/preferences_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class AcceptRequestNotificationDetailPage extends StatefulWidget {
  final idRequest;
  final transmitterId;
  final notificationType;
  AcceptRequestNotificationDetailPage(
      {@required this.idRequest,
      @required this.notificationType,
      @required this.transmitterId,
      Key key})
      : super(key: key);

  @override
  _AcceptRequestNotificationDetailPageState createState() =>
      _AcceptRequestNotificationDetailPageState(
          this.idRequest, this.transmitterId, this.notificationType);
}

class _AcceptRequestNotificationDetailPageState
    extends State<AcceptRequestNotificationDetailPage> {
  final idRequest;
  final transmitterId;
  final notificationType;
  var responseData;
  var authUserData;

  bool isLoard = true;
  bool isLoardDelivery = false;

  HttpService httpService = HttpService();

  _AcceptRequestNotificationDetailPageState(
      this.idRequest, this.transmitterId, this.notificationType);

  _openPage(page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  void initState() {
    super.initState();
    getPreferencesData();
    getUserDeliveryRequest();
  }

  getUserDeliveryRequest() async {
    var postData = {
      'idRequest': idRequest,
      'transmitterId': transmitterId,
    };

    print(postData);

    var response =
        await httpService.postData("getUserDeliveryRequest", postData);
    print(response);
    setState(() {
      isLoard = false;
      responseData = response;
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
      });
    });
  }

  _confirmDelivery() async {
    setState(() {
      isLoardDelivery = true;
    });
    var response = await httpService.postData("confirmDelivery", responseData);
    print(responseData);

    if (response['success']) {
      Fluttertoast.showToast(
        msg: "confirmation ok",
        backgroundColor: Colors.white24,
      );
      responseData['senderId'] = authUserData['id'];
      setState(() {
        isLoardDelivery = false;
      });
      _openPage(
        WriteReviewScreen(
          requestData: responseData,
        ),
      );
    } else {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: isLoard ? Colors.white : null,
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: !isLoard
            ? Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Stack(
                          children: [
                            Container(
                              decoration: Style.gradientDecoration,
                              height: 100.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 30.0,
                                left: 8.0,
                                right: 8.0,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    elevation: 0.3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ListTile(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserProfilDetails(
                                                        responseData:
                                                            responseData[
                                                                'userData']),
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.all(0.0),
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                AppEvironement.imageUrl +
                                                    'storage/' +
                                                    responseData['userData']
                                                        ['avatar'],
                                              ),
                                            ),
                                            title: Text(responseData['userData']
                                                ['pseudo']),
                                            subtitle: Text(
                                              responseData['userData']
                                                          ['city'] !=
                                                      null
                                                  ? "Lives in " +
                                                      responseData['userData']
                                                          ['city']
                                                  : "",
                                            ),
                                            trailing:
                                                Icon(Icons.arrow_forward_ios),
                                          ),
                                          Divider(),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                responseData['kilos_delivery']
                                                        .toString() +
                                                    " kg-",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              Text(
                                                responseData['price_delivery']
                                                        .toString() +
                                                    "€",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            responseData['cityDepartureTrip'] !=
                                                    null
                                                ? responseData['cityDepartureTrip'] +
                                                    "-" +
                                                    responseData[
                                                        'cityArrivalTrip'] +
                                                    " " +
                                                    responseData[
                                                        'dateDepartureTrip']
                                                : responseData['cityDepartureParcel'] +
                                                    "-" +
                                                    responseData[
                                                        'cityArrivalParcel'] +
                                                    " " +
                                                    responseData[
                                                        'dateDepartureParcel'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      color: Colors.white,
                                      height: 50.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "Request status: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(responseData['requestStatus']
                                                .toString()),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      color: Colors.white,
                                      height: 50.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "Payment status: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(responseData['payment_status']
                                                .toString()),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child:
                                        responseData['transactionCode'] != null
                                            ? Container(
                                                color: Colors.white,
                                                height: 50.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "Transaction Code: ",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      Text(responseData[
                                                          'transactionCode']),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                  ),
                                  if (responseData['isTripOrExpedition'] ==
                                      'expedition') ...[
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Recipient Name: ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    responseData[
                                                                'recipientParcelName'] !=
                                                            null
                                                        ? responseData[
                                                            'recipientParcelName']
                                                        : "",
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Recipient Phone Number: ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    responseData[
                                                                'recipientParcelPhoneNumber'] !=
                                                            null
                                                        ? responseData[
                                                            'recipientParcelPhoneNumber']
                                                        : "",
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Recipient Address: ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(responseData[
                                                              'recipientParcelAddress'] !=
                                                          null
                                                      ? responseData[
                                                          'recipientParcelAddress']
                                                      : ""),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40.0,
                    child: Column(
                      children: <Widget>[
                        if (responseData['payment_status'] == "pending") ...[
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => !isLoardDelivery
                                      ? _confirmDelivery()
                                      : null,
                                  child: Container(
                                    color: Palette.primaryColor,
                                    width: double.infinity,
                                    height: 40.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          !isLoardDelivery
                                              ? "Confirm transaction"
                                              : "please wait...",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => null,
                                  child: Container(
                                    color: Colors.red,
                                    width: double.infinity,
                                    height: 40.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          "Cancel Trasaction",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]
                      ],
                    ),
                  )
                ],
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
}
