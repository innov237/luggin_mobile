import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/pages/user_public_profil_page.dart';
import 'package:luggin/screens/payment_method_screen.dart';
import 'package:luggin/services/preferences_service.dart';
import 'dart:convert';
import 'package:luggin/services/http_service.dart';
import 'dart:async';

class ChatRoomPage extends StatefulWidget {
  final requestData;

  ChatRoomPage({@required this.requestData, Key key}) : super(key: key);
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState(this.requestData);
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final requestData;
  int proposalKilos;
  int initialKilo;
  var authUserData;
  String responseMessage = '';
  String imageApiUrl = AppEvironement.imageUrl;
  String headerNotificationMessage;

  TextEditingController proposalPrice;
  TextEditingController _messageController;
  ScrollController _controller;

  HttpService httpService = HttpService();

  _ChatRoomPageState(this.requestData);

  var conversationData = [];
  Timer _timeDilationTimer;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();

    getPreferencesData();
    setHeaderMessageForNotification();

    setState(() {
      conversationData = requestData['messageData'];
    });

    if (requestData['tripData']['offeredKilosTrip'] != null) {
      setState(() {
        initialKilo = requestData['tripData']['offeredKilosTrip'];
        proposalKilos = initialKilo;
      });
    } else {
      setState(() {
        initialKilo = requestData['tripData']['weightParcel'];
        proposalKilos = initialKilo;
      });
    }

    proposalPrice = TextEditingController();
    _messageController = TextEditingController();

    Timer(
      Duration(seconds: 1),
      () => _scrollEnd(),
    );

    _timeDilationTimer = Timer.periodic(
      Duration(seconds: 5),
      (Timer t) {
        loardMessage();
      },
    );
  }

  @override
  void dispose() {
    _timeDilationTimer?.cancel();
    super.dispose();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        print("reach the bottom");
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        print("reach the top");
      });
    }
  }

  _scrollEnd() {
    if (_controller.hasClients) {
      _controller.animateTo(_controller.position.maxScrollExtent,
          curve: Curves.linear, duration: Duration(milliseconds: 50));
    }
  }

  _addKilos() {
    if (proposalKilos < initialKilo) {
      setState(() {
        proposalKilos = proposalKilos + 1;
      });
    }
  }

  _removeKilo() {
    if (proposalKilos > 1) {
      setState(() {
        proposalKilos = proposalKilos - 1;
      });
    }
  }

  _sendProposal() {
    if (proposalPrice.text == '') {
      setState(() {
        responseMessage = "Enter price";
      });
      return;
    }

    setState(() {
      responseMessage = "";
      proposalPrice.text = proposalPrice.text.toString();
      proposalKilos = proposalKilos;
    });
    _sendMessage(null);
    Navigator.pop(context);
  }

  _sendMessage(String type) async {
    var postData = {
      'idUser': authUserData['id'],
      'body': _messageController.text.toString().trim() != ''
          ? _messageController.text.toString()
          : proposalKilos.toString() +
              'Kg - ' +
              proposalPrice.text.toString() +
              "€",
      'idConversation': requestData['idConversation'],
    };

    if (type != 'text') {
      postData['proposalPrice'] = proposalPrice.text.toString();
      postData['proposalKilos'] = proposalKilos.toString();
    }

    conversationData.add(postData);
    setState(() {
      _messageController.text = '';
    });

    _scrollEnd();

    print(postData);

    var response = await httpService.postData("sendMessage", postData);

    if (response['success']) {
      print('ok');
      setState(() {
        conversationData = response['data'];
      });
      _scrollEnd();
    } else {
      print('err');
    }
  }

  _openPage(page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  _bookInitialTripRequest() {
    var postData = {
      'idTripOrIdexpedition': requestData['idTripOrIdexpedition'],
      'isTripOrExpedition': requestData['isTripOrExpedition'].toString(),
      'idSender': requestData['userData']['id'], //celui qui envoie le colis
      'idReceiver': requestData['tripData']
          ['idUser'], // celui qui transporte le colis
      'senderPseudo': requestData['tripData']['pseudo'],
      'headerNotification': headerNotificationMessage,
      'deliveryParcelDescription': null,
      'kilos_delivery': requestData['tripData']['offeredKilosPriceTrip'],
      'price_delivery': requestData['tripData']['offeredKilosPriceTrip'],
    };
    _openPage(
      PaymentMethodScreen(requestData: postData),
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
      });
    });
  }

  setHeaderMessageForNotification() {
    if (requestData['isTripOrExpedition'] == 'trip') {
      setState(() {
        headerNotificationMessage = requestData['tripData']
                ["cityDepartureTrip"] +
            '-' +
            requestData['tripData']["cityArrivalTrip"] +
            ' ' +
            requestData['tripData']["dateDepartureTrip"];
      });
    }
    if (requestData['isTripOrExpedition'] == 'expedition') {
      setState(() {
        headerNotificationMessage = requestData['tripData']
                ["cityDepartureParcel"] +
            '-' +
            requestData['tripData']["cityArrivalParcel"] +
            ' ' +
            requestData['tripData']["dateDepartureParcel"];
      });
    }
  }

  _accepOffer(data) {
    if ((requestData['isTripOrExpedition'] == 'trip' &&
            authUserData['id'] == requestData['tripData']['idUser']) ||
        (requestData['isTripOrExpedition'] == 'expedition' &&
            authUserData['id'] != requestData['tripData']['idUser'])) {
      print("je suis le transporteur");
      setState(() {
        proposalKilos = data['proposalKilos'];
        proposalPrice.text = data['proposalPrice'].toString();
        _sendMessage(null);
      });
    } else {
      print("je suis celui qui envoi");

      var postData = {
        'idTripOrIdexpedition': requestData['idTripOrIdexpedition'],
        'isTripOrExpedition': requestData['isTripOrExpedition'].toString(),
        'senderPseudo': requestData['userData']['pseudo'],
        'headerNotification': headerNotificationMessage,
        'deliveryParcelDescription': null,
        'kilos_delivery': data['proposalKilos'],
        'price_delivery': data['proposalPrice'],
      };

      if (requestData['isTripOrExpedition'] == "trip") {
        postData['idSender'] = requestData['idUser'];
        postData['idReceiver'] = requestData['idSecondUser'];
      }

      if (requestData['isTripOrExpedition'] == "expedition") {
        postData['idSender'] = requestData['idUser'];
        postData['idReceiver'] = requestData['idSecondUser'];
      }

      print(postData);
      _messageController.text = "accepted";
      _sendMessage('text');
      _openPage(
        PaymentMethodScreen(requestData: postData),
      );
    }
  }

  _refuseOffer(data) {
    setState(() {
      _messageController.text = "refused";
      _sendMessage('text');
    });
  }

  loardMessage() async {
    var response = await httpService.getPostByKey(
      "getConversationMessage",
      requestData['idConversation'],
    );

    setState(() {
      conversationData = response;
      print(conversationData);
    });
  }

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );

    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color(0xFFDCF8C6),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );

    return SafeArea(
      child: Scaffold(
        body: authUserData != null
            ? Column(
                children: <Widget>[
                  Container(
                    height: 50.0,
                    color: Palette.primaryColor,
                    child: Card(
                      elevation: 0.5,
                      color: Palette.primaryColor,
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: GestureDetector(
                              onTap: () => _openPage(
                                UserPublicProfil(
                                  responseData: requestData['userData'],
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () => Navigator.pop(context),
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.0,
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.black12,
                                        backgroundImage: NetworkImage(
                                          imageApiUrl +
                                              'storage/' +
                                              requestData['userData']['avatar'],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            requestData['userData']['pseudo'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          Text(
                                            requestData['userData']['city'] !=
                                                    null
                                                ? requestData['userData']
                                                    ['city']
                                                : "",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildDetails(),
                  Flexible(
                    child: conversationData.length > 0 && authUserData != null
                        ? Container(
                            child: Column(
                              children: [
                                ListView.builder(
                                  controller: _controller,
                                  itemCount: conversationData.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          if (conversationData[index]
                                                      ['idUser'] !=
                                                  authUserData['id'] &&
                                              conversationData[index]
                                                      ['proposalKilos'] ==
                                                  null) ...[
                                            Bubble(
                                              style: styleSomebody,
                                              child: Text(
                                                  conversationData[index]
                                                      ['body']),
                                            ),
                                          ],
                                          if (conversationData[index]
                                                  ['idUser'] ==
                                              authUserData['id']) ...[
                                            Bubble(
                                              style: styleMe,
                                              child: Text(
                                                conversationData[index]['body'],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                          if (conversationData[index]
                                                      ['proposalKilos'] !=
                                                  null &&
                                              conversationData[index]
                                                      ['idUser'] !=
                                                  authUserData['id']) ...[
                                            buildOfferCard(
                                                conversationData, index)
                                          ],
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ),
                  Container(
                    height: 72.0,
                    color: Palette.scaffoldBg,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextField(
                                    controller: _messageController,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 0.0, 10.0, 0.0),
                                      hintText: 'message...',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () => _sendMessage('text'),
                                    child: CircleAvatar(
                                      backgroundColor: Palette.primaryColor,
                                      radius: 20.0,
                                      child: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
      ),
    );
  }

  Widget buildOfferCard(conversationData, int index) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    return Container(
      child: Bubble(
        nip: BubbleNip.leftTop,
        elevation: 1 * px,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (conversationData[index]['proposalKilos'] != null &&
                  conversationData[index]['proposalPrice'] != null) ...[
                Text(
                  conversationData[index]['proposalKilos'].toString() +
                      " Kg" +
                      " - " +
                      conversationData[index]['proposalPrice'].toString() +
                      "€",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
              SizedBox(
                height: 10.0,
              ),
              Divider(
                color: Colors.black.withOpacity(0.2),
                height: 0.5,
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    if (conversationData[index]['proposalStatus'] == null) ...[
                      Container(
                        height: 20.0,
                        child: Row(
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () =>
                                  _accepOffer(conversationData[index]),
                              padding: EdgeInsets.all(0.0),
                              child: Text(
                                "Accept",
                                style: TextStyle(
                                  color: Palette.primaryColor,
                                ),
                              ),
                              elevation: 0.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            MaterialButton(
                              onPressed: () =>
                                  _refuseOffer(conversationData[index]),
                              padding: EdgeInsets.all(0.0),
                              child: Text(
                                "Refuse",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                              elevation: 0.0,
                            )
                          ],
                        ),
                      ),
                    ],
                    if (conversationData[index]['proposalStatus'] == 0) ...[
                      Text("refused"),
                    ],
                    if (conversationData[index]['proposalStatus'] == 1) ...[
                      Text("accepted"),
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetails() {
    _openOfferModal() {
      setState(() {
        proposalPrice.text = '';
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0)), //this right here
                child: Container(
                  height: 210,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _removeKilo();
                                });
                              },
                              child: Container(
                                color: Colors.black12,
                                child: Center(
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              proposalKilos != null
                                  ? proposalKilos.toString() + "Kg"
                                  : "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _addKilos();
                                });
                              },
                              child: Container(
                                color: Colors.black12,
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          child: Container(
                            color: Colors.black12,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 5.0,
                                right: 15.0,
                              ),
                              child: TextField(
                                controller: proposalPrice,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Price',
                                    suffixText: "€"),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 1.0),
                          child: Text(
                            responseMessage.toString(),
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            width: 60.0,
                            height: 40.0,
                            child: RaisedButton(
                              elevation: 0.0,
                              onPressed: () {
                                setState(() {
                                  _sendProposal();
                                });
                              },
                              child: Text(
                                "Ok",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Palette.primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return Container(
      height: 100.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          requestData['tripData']['cityDepartureTrip'] != null
                              ? requestData['tripData']['cityDepartureTrip']
                              : requestData['tripData']['cityDepartureParcel'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "-",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          requestData['tripData']['cityArrivalTrip'] != null
                              ? requestData['tripData']['cityArrivalTrip']
                              : requestData['tripData']['cityArrivalParcel'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          requestData['tripData']['dateDepartureTrip'] != null
                              ? requestData['tripData']['dateDepartureTrip']
                              : requestData['tripData']['dateDepartureParcel'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "-",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          requestData['tripData']['dateArrivalTrip'] != null
                              ? requestData['tripData']['dateArrivalTrip']
                              : "",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if ((requestData['tripData']['offeredKilosTrip'] != null &&
                        requestData['tripData']['offeredKilosTrip'] > 0) ||
                    (requestData['tripData']['weightParcel'] != null &&
                        requestData['tripData']['weightParcel'] > 0)) ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            requestData['tripData']['offeredKilosTrip'] != null
                                ? requestData['tripData']['offeredKilosTrip']
                                        .toString() +
                                    "kg"
                                : requestData['tripData']['weightParcel']
                                        .toString() +
                                    "kg",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            requestData['tripData']['offeredKilosPriceTrip'] !=
                                    null
                                ? requestData['tripData']
                                            ['offeredKilosPriceTrip']
                                        .toString() +
                                    "€"
                                : "",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            if ((requestData['tripData']['offeredKilosTrip'] != null &&
                    requestData['tripData']['offeredKilosTrip'] > 0) ||
                (requestData['tripData']['weightParcel'] != null &&
                    requestData['tripData']['weightParcel'] > 0)) ...[
              Container(
                height: 20.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if ((requestData['isTripOrExpedition'] == 'trip' &&
                        authUserData['id'] !=
                            requestData['tripData']['idUser']))
                      Expanded(
                        child: MaterialButton(
                          onPressed: () => _bookInitialTripRequest(),
                          color: Palette.ligth,
                          child: Text("Book"),
                          height: 25.0,
                          elevation: 0.0,
                        ),
                      ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () => _openOfferModal(),
                        color: Palette.ligth,
                        child: Text("Make an offer"),
                        height: 25.0,
                        elevation: 0.0,
                      ),
                    )
                  ],
                ),
              )
            ],
            Divider(),
          ],
        ),
      ),
    );
  }
}
