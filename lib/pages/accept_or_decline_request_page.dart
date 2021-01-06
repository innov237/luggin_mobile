import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/config/style.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/pages/user_public_profil_page.dart';
import 'package:luggin/screens/tabs_screen.dart';
import 'package:luggin/services/preferences_service.dart';
import 'package:luggin/services/http_service.dart';

class AcceptOrDeclineRequestPage extends StatefulWidget {
  final idRequest;
  final transmitterId;
  final notificationType;
  AcceptOrDeclineRequestPage(
      {@required this.idRequest,
      @required this.notificationType,
      @required this.transmitterId,
      Key key})
      : super(key: key);

  @override
  _AcceptOrDeclineRequestPageState createState() =>
      _AcceptOrDeclineRequestPageState(
          this.idRequest, this.transmitterId, this.notificationType);
}

class _AcceptOrDeclineRequestPageState
    extends State<AcceptOrDeclineRequestPage> {
  final idRequest;
  final transmitterId;
  final notificationType;
  var authUserData;

  _AcceptOrDeclineRequestPageState(
      this.idRequest, this.transmitterId, this.notificationType);
  String imageUrl = AppEvironement.imageUrl;

  var responseData;
  bool isLoard = true;
  String headerNotificationMessage;
  HttpService httpService = HttpService();

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

  @override
  void initState() {
    super.initState();
    print(notificationType);
    print(idRequest);
    getUserDeliveryRequest();
    getPreferencesData();
  }

  getUserDeliveryRequest() async {
    var postData = {
      'idRequest': idRequest,
      'transmitterId': transmitterId,
    };

    print(postData);
    var response =
        await httpService.postData("getUserDeliveryRequest", postData);

    setState(() {
      responseData = response;
      isLoard = false;
    });

    print(responseData);
  }

  _acceptOrDecline(value) async {
    var mypostData = {
      'status': value,
      'idDeliveryRequest': responseData['idDeliveryRequest'],
      'isTripOrExpedition': responseData['isTripOrExpedition'],
      'idTripOrIdexpedition': responseData['idTripOrIdexpedition'],
      'numberKilos': responseData['kilos_delivery'],
      'idSender': responseData['idSender'],
      'idReceiver': responseData['idReceiver'],
      'transmitterName': authUserData['pseudo']
    };

    print(mypostData);

    var response =
        await httpService.postData("acceptOrDeclineRequest", mypostData);

    if (response['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessWidget(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("Accept or Decline"),
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
                              height: 110.0,
                              color: Palette.primaryColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30.0, left: 8.0, right: 8.0),
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    shape: Style.shapeCard,
                                    elevation: Style.cardElevation,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserPublicProfil(
                                                  responseData:
                                                      responseData['userData'],
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Stack(
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          Colors.black12,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        imageUrl +
                                                            "storage/" +
                                                            responseData[
                                                                    'userData']
                                                                ['avatar'],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 23.0,
                                                              left: 23.0),
                                                      child: CircleAvatar(
                                                        radius: 10.0,
                                                        backgroundColor:
                                                            Color(0XFFF2F5F5),
                                                        child: Icon(
                                                          Icons.verified_user,
                                                          color: responseData[
                                                                          'userData']
                                                                      [
                                                                      'userId_isVerified'] ==
                                                                  'true'
                                                              ? Colors.green
                                                              : Colors.black12,
                                                          size: 15.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        responseData['userData']
                                                            ['pseudo'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7)),
                                                      ),
                                                      SizedBox(
                                                        height: 2.0,
                                                      ),
                                                      Text(
                                                        responseData['userData']
                                                                    ['city'] !=
                                                                null
                                                            ? "Lives in " +
                                                                responseData[
                                                                        'userData']
                                                                    ['city']
                                                            : "",
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.black12,
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Divider(),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                responseData['kilos_delivery']
                                                        .toString() +
                                                    "Kg -",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              Text(
                                                responseData['price_delivery']
                                                        .toString() +
                                                    "€",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.0,
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
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          Divider(),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            responseData[
                                                        'deliveryParcelDescription'] !=
                                                    null
                                                ? responseData[
                                                    'deliveryParcelDescription']
                                                : "",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black
                                                    .withOpacity(0.7)),
                                          ),
                                          SizedBox(
                                            height: 10.0,
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
                                              "Request Date: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(responseData['created_at']),
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
                                              "Request Status: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(responseData['requestStatus']),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (responseData['transactionCode'] != null)
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
                                                "Transaction Code: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                responseData['transactionCode'],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (responseData['isTripOrExpedition'] ==
                                          'expedition' &&
                                      responseData['requestStatus'] !=
                                          'pending') ...[
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
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        if (responseData['requestStatus'] != 'delivered')
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (responseData['requestStatus'] ==
                                  'pending') ...[
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _acceptOrDecline('accepted'),
                                    child: Container(
                                      color: Palette.primaryColor,
                                      height: 40.0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: 10.0,
                                          bottom: 10.0,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Accept",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _acceptOrDecline('declined'),
                                    child: Container(
                                      color: Colors.redAccent,
                                      height: 40.0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: 10.0,
                                          bottom: 10.0,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Decline",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                              if (responseData['requestStatus'] ==
                                  'accepted') ...[
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _acceptOrDecline('declined'),
                                    child: Container(
                                      color: Colors.redAccent,
                                      height: 40.0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: 10.0,
                                          bottom: 10.0,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Cancel",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          )
                      ],
                    ),
                  )
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class SuccessWidget extends StatefulWidget {
  @override
  _SuccessWidgetState createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              height: 220.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "It is strictly forbidden to have illicit packages transported. LuggIn will not hesitate to collaborate with the authorities to denounce any abuse.",
                    style: TextStyle(fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Container(
                  height: 170.0,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Your Request is send \n Congratulations",
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Image.asset(
                        "assets/images/doneIcon.png",
                        height: 50.0,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (conext) => TabsScreen(
                            selectedPage: 2,
                          ),
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Palette.primaryColor,
                        child: Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 45.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
