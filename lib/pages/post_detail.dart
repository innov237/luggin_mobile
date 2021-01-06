import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/config/style.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/pages/user_profil_detail_page.dart';
import 'package:luggin/screens/payment_method_screen.dart';
import 'package:luggin/screens/payment_screen.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/services/preferences_service.dart';

import 'package:luggin/pages/user_public_profil_page.dart';
import 'package:luggin/pages/chat_room_page.dart';
import 'package:luggin/pages/report_user_page.dart';
import 'package:luggin/widgets/linesHeader_widgets.dart';

import 'dart:math' as math;

class PostDetailPage extends StatefulWidget {
  final parcelDetail;
  final isTripOrExpedition;

  PostDetailPage(
      {@required this.parcelDetail, @required this.isTripOrExpedition, Key key})
      : super(key: key);
  @override
  _PostDetailPageState createState() =>
      _PostDetailPageState(this.parcelDetail, this.isTripOrExpedition);
}

class _PostDetailPageState extends State<PostDetailPage> {
  final parceDetail;
  final isTripOrExpedition;
  _PostDetailPageState(this.parceDetail, this.isTripOrExpedition);

  String imageUrl = AppEvironement.imageUrl;
  String apiUrl = AppEvironement.apiUrl;
  var authUserData;
  String headerNotificationMessage;
  TextEditingController _parcelDescription;
  bool isLoard = false;
  String responseMessage = '';
  String currentView;
  int kilos;
  int price;
  bool creationprocess = true;

  HttpService httpService = HttpService();

  _openPage(page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  void initState() {
    super.initState();
    getPreferencesData();
    _parcelDescription = TextEditingController();
    setState(() {
      currentView = 'detailsView';
    });
  }

  _setMessage(message) {
    setState(() {
      responseMessage = message;
    });
  }

  _cleanMessage() {
    setState(() {
      responseMessage = '';
    });
  }

  _openPayementPage() async {
    _cleanMessage();

    if (isTripOrExpedition == 'trip') {
      setState(() {
        price = parceDetail['offeredKilosPriceTrip'];
        kilos = parceDetail['offeredKilosTrip'];
      });
      if (_parcelDescription.text.isEmpty) {
        _setMessage("this field is required");
        return;
      }
    }

    var postData = {
      'idTripOrIdexpedition': parceDetail['id'],
      'isTripOrExpedition': isTripOrExpedition.toString(),
      'idSender': authUserData['id'], //celui qui envoie le colis
      'idReceiver': parceDetail['idUser'], // celui qui transporte le colis
      'senderPseudo': authUserData['pseudo'],
      'headerNotification': headerNotificationMessage,
      'deliveryParcelDescription': _parcelDescription.text.toString(),
      'kilos_delivery': kilos,
      'price_delivery': price,
    };

    //Create conversation
    await httpService.postData("createConversation", postData);

    //Open payment page
    _openPage(PaymentScreen(
      requestData: postData,
      paymentMethod: 'savedCard',
    ));
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Palette.primaryColor.withOpacity(0.8),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    height: 300.0,
                    width: double.infinity,
                    color: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 30.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/loader2.gif",
                                    width: 100.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "Please wait...",
                                    style: TextStyle(
                                      color: Palette.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50.0,
                                  ),
                                  Text(
                                    "Creating the conversation in progress...",
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _createAndOpenConversation() async {
    _showMyDialog();

    var postData = {
      'idTripOrIdexpedition': parceDetail['id'],
      'isTripOrExpedition': isTripOrExpedition,
    };

    if (isTripOrExpedition == 'trip') {
      postData['idSender'] = authUserData['id'];
      postData['idReceiver'] = parceDetail['idUser'];
    } else {
      postData['idSender'] = parceDetail['idUser'];
      postData['idReceiver'] = authUserData['id'];
    }

    print(postData);

    var response = await httpService.postData("createConversation", postData);

    if (response['success']) {
      var response =
          await httpService.postData("getUserConversationByRequest", postData);
      Navigator.pop(context);
      print(response);
      _openPage(
        ChatRoomPage(
          requestData: response[0],
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
        bottomNavigationBar: (authUserData['id'] != parceDetail['idUser'])
            ? Container(
                height: 40.0,
                child: Row(
                  children: <Widget>[
                    isTripOrExpedition == 'trip'
                        ? Expanded(
                            child: InkWell(
                              onTap: () => {
                                setState(() {
                                  currentView = 'moreInfo';
                                })
                              },
                              child: Container(
                                height: 40.0,
                                color: Color(0xFF2488B9),
                                child: Center(
                                  child: Text(
                                    "Book",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: InkWell(
                        onTap: () => _createAndOpenConversation(),
                        child: Container(
                          height: 40.0,
                          color: Colors.cyan,
                          child: Center(
                            child: Text(
                              "Make an offer",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                height: 0.0,
              ),
        body: currentView == 'detailsView'
            ? authUserData != null
                ? ListView(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 300.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/word-map.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: Style.gradientDecoration,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 70.0, left: 15.0, right: 15.0),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 12.0,
                                            bottom: 60.0,
                                          ),
                                          child: Container(
                                            width: 1.0,
                                            height: 150.0,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 1.0,
                                            left: 8.0,
                                          ),
                                          child: Transform.rotate(
                                            angle: math.pi,
                                            child: CircleAvatar(
                                              radius: 5.0,
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10.0,
                                            left: 1.0,
                                          ),
                                          child: Transform.rotate(
                                            angle: math.pi,
                                            child: Icon(
                                              Icons.local_airport,
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 120.0,
                                            left: 8.0,
                                          ),
                                          child: Transform.rotate(
                                            angle: math.pi,
                                            child: CircleAvatar(
                                              radius: 5.0,
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          isTripOrExpedition == 'trip'
                                              ? Text(
                                                  parceDetail[
                                                      "cityDepartureTrip"],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              : Text(
                                                  parceDetail[
                                                      "cityDepartureParcel"],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                          isTripOrExpedition == 'trip'
                                              ? Text(
                                                  parceDetail[
                                                      "dateDepartureTrip"],
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Text(
                                                  parceDetail[
                                                      'dateDepartureParcel'],
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          isTripOrExpedition == 'trip'
                                              ? Row(
                                                  children: <Widget>[
                                                    Text(
                                                      parceDetail[
                                                          "timeDepartureTrip"],
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      " - ",
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      parceDetail[
                                                          "timeArrivalTrip"],
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Text(""),
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          isTripOrExpedition == 'trip'
                                              ? Text(
                                                  parceDetail[
                                                      "cityArrivalTrip"],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Text(
                                                  parceDetail[
                                                      "cityArrivalParcel"],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                          isTripOrExpedition == 'trip'
                                              ? Text(
                                                  parceDetail[
                                                      "dateArrivalTrip"],
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Text(""),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: LinesHeaderWidget(
                              title: "Post detail",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 250.0,
                              left: 0.0,
                              right: 0.0,
                            ),
                            child: Card(
                              shape: Style.shapeCard,
                              elevation: Style.cardElevation,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          isTripOrExpedition == 'trip'
                                              ? "Desired Amount of kilos"
                                              : "Proposed amount of kilos",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                          ),
                                        ),
                                        isTripOrExpedition == 'trip'
                                            ? Text(
                                                parceDetail["offeredKilosTrip"]
                                                        .toString() +
                                                    "Kg",
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Palette.primaryColor,
                                                ),
                                              )
                                            : Text(
                                                parceDetail["weightParcel"]
                                                        .toString() +
                                                    "Kg",
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Palette.primaryColor,
                                                ),
                                              )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    isTripOrExpedition == 'trip'
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Price",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              Text(
                                                parceDetail["offeredKilosPriceTrip"]
                                                        .toString() +
                                                    "€",
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Palette.primaryColor,
                                                ),
                                              )
                                            ],
                                          )
                                        : Container(),
                                    Divider(),
                                    if (parceDetail["parcelDescription"] !=
                                        null) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15.0,
                                        ),
                                        child: Text(
                                          parceDetail["parcelDescription"],
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                    if (authUserData['id'] !=
                                        parceDetail['idUser']) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                parceDetail["pseudo"],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              Container(
                                                height: 30.0,
                                                width: 5.0,
                                                color: Palette.scaffoldBg,
                                              ),
                                              InkWell(
                                                onTap: () =>
                                                    _createAndOpenConversation(),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Palette.scaffoldBg,
                                                  child: Icon(
                                                    Icons.chat_bubble_outline,
                                                    color: Colors.purple,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  _openPage(
                                                    UserPublicProfil(
                                                      responseData:
                                                          authUserData,
                                                    ),
                                                  );
                                                },
                                                child: Stack(
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          Palette.scaffoldBg,
                                                      radius: 27.0,
                                                      child: CircleAvatar(
                                                        radius: 25.0,
                                                        backgroundColor:
                                                            Colors.black12,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          imageUrl +
                                                              "storage/" +
                                                              parceDetail[
                                                                  'avatar'],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 38.0,
                                                              left: 30.0),
                                                      child: CircleAvatar(
                                                        radius: 10.0,
                                                        backgroundColor:
                                                            Color(0XFFF2F5F5),
                                                        child: Icon(
                                                          Icons.verified_user,
                                                          color: parceDetail[
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
                                              ),
                                              SizedBox(
                                                width: 5.0,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Divider(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          InkWell(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReportUserPage(),
                                              ),
                                            ),
                                            child: Text(
                                              isTripOrExpedition == 'trip'
                                                  ? "report this offer"
                                                  : "report this request",
                                              style: TextStyle(
                                                color: Color(0xFF2488B9),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                        ],
                                      )
                                    ],
                                    if (authUserData['id'] ==
                                        parceDetail['idUser']) ...[
                                      isTripOrExpedition == 'trip'
                                          ? postParameterTrip()
                                          : postParameterRequest()
                                    ]
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                  )
            : buildMoreInFobox(),
      ),
    );
  }

  Widget buildMoreInFobox() {
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          currentView = 'detailsView';
                        });
                      },
                      child:
                          Icon(Icons.arrow_back, color: Palette.primaryColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Enter your parcel \ndescription',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
              Text(
                responseMessage.toString(),
                style: TextStyle(
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  child: Container(
                    color: Color(0xFFF2F2F2),
                    child: TextField(
                      controller: _parcelDescription,
                      autofocus: true,
                      maxLines: 4,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.italic,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
                        hintText: 'Parcel description*',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () => _openPayementPage(),
                      child: CircleAvatar(
                        backgroundColor: Palette.primaryColor,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget postParameterTrip() {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text("Edit your trip"),
            trailing: Icon(Icons.arrow_forward_ios),
            contentPadding: EdgeInsets.all(0.0),
          ),
          ListTile(
            title: Text("Duplicate your trip"),
            contentPadding: EdgeInsets.all(0.0),
          ),
          ListTile(
            title: Text("Publish your Return trip"),
            trailing: Icon(Icons.arrow_forward_ios),
            contentPadding: EdgeInsets.all(0.0),
          ),
          ListTile(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CancelTripOrRequest(
                  isTripOrExpedition: 'trip',
                  id: 1,
                ),
              ),
            ),
            title: Text("Cancel your trip"),
            contentPadding: EdgeInsets.all(0.0),
          )
        ],
      ),
    );
  }

  Widget postParameterRequest() {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text("Edit your request "),
            trailing: Icon(Icons.arrow_forward_ios),
            contentPadding: EdgeInsets.all(0.0),
          ),
          ListTile(
            title: Text("Duplicate your request"),
            contentPadding: EdgeInsets.all(0.0),
          ),
          ListTile(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CancelTripOrRequest(
                  isTripOrExpedition: 'trip',
                  id: 1,
                ),
              ),
            ),
            title: Text("Cancel your request"),
            contentPadding: EdgeInsets.all(0.0),
          )
        ],
      ),
    );
  }
}

class CancelTripOrRequest extends StatefulWidget {
  final isTripOrExpedition;
  final id;
  CancelTripOrRequest({@required this.isTripOrExpedition, @required this.id});

  @override
  _CancelTripOrRequestState createState() => _CancelTripOrRequestState();
}

class _CancelTripOrRequestState extends State<CancelTripOrRequest> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette.primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 100.0,
              ),
              Expanded(
                  child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.add_alert,
                      size: 80.0,
                      color: Colors.redAccent,
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      "Vous etes sur le point d'annuler votre trajet. Celui-ci sera supprimé et les passagers ne pourront plus voyager avec vous",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              )),
              Container(
                color: Palette.primaryColor,
                height: 100.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.close,
                          color: Palette.primaryColor,
                        ),
                      ),
                    ),
                    RaisedButton(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      onPressed: () => null,
                      color: Colors.redAccent,
                      child: Text(
                        'Cancel trip',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
