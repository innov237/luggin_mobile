import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/services/http_service.dart';
import 'package:intl/intl.dart';

class UserPublicProfil extends StatefulWidget {
  final responseData;
  UserPublicProfil({@required this.responseData, Key key}) : super(key: key);
  @override
  _UserPublicProfilState createState() =>
      _UserPublicProfilState(this.responseData);
}

class _UserPublicProfilState extends State<UserPublicProfil> {
  final responseData;
  _UserPublicProfilState(this.responseData);

  String imageUrl = AppEvironement.imageUrl;

  HttpService httpService = HttpService();
  var statData;

  @override
  void initState() {
    super.initState();
    getuserStat();
  }

  getAgeInDate(timestamp) {
    var now = new DateTime.now();
    var currentYear = now.year;

    DateTime formattedDate = DateFormat.yMd().parse(timestamp);
    var userYear = formattedDate.year;

    return currentYear - userYear;
  }

  _getUserReviews() async {
    var postData = {
      'userId': responseData['idUser'] != null
          ? responseData['idUser']
          : responseData['id'],
    };
    var response = await httpService.getPostByKey("getUserReviews", postData);
    return response;
  }

  getDateTime(timestamp) {
    String formattedDate =
        DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(timestamp));
    return formattedDate;
  }

  getuserStat() async {
    var userId = responseData['idUser'] != null
        ? responseData['idUser']
        : responseData['id'];
    var response = await httpService.getPostByKey("getuserStat", userId);
    setState(() {
      statData = response;
    });
    return response;
  }

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: ListView(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Palette.primaryColor,
                        Colors.cyan.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 55.0,
                                backgroundColor: Colors.white12,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: CircleAvatar(
                                    maxRadius: 50.0,
                                    minRadius: 50.0,
                                    backgroundImage: NetworkImage(
                                      imageUrl +
                                          "storage/" +
                                          responseData['avatar'],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 70.0, left: 72.0),
                                child: CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Colors.white12,
                                  child: CircleAvatar(
                                    radius: 18.0,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.verified_user,
                                      color:
                                          responseData['userId_isVerified'] ==
                                                  'true'
                                              ? Colors.green
                                              : Colors.black12,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        responseData['pseudo'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        responseData['dateOfBirthDay'] != null
                            ? getAgeInDate(responseData['dateOfBirthDay'])
                                    .toString() +
                                " years old"
                            : "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 38.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Card(
              elevation: 0.0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Biography",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Palette.primaryColor,
                              fontSize: 16.0),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.black12,
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      responseData['biography'] != null
                          ? responseData['biography']
                          : "",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 0.0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Reviews",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Palette.primaryColor,
                              fontSize: 16.0),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.black12,
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      child: FutureBuilder(
                        future: _getUserReviews(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapShot) {
                          return snapShot.hasData
                              ? snapShot.data.length > 0
                                  ? ListView.builder(
                                      itemCount: snapShot.data.length,
                                      primary: false,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext conext, int index) {
                                        return Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.black12,
                                                    radius: 20.0,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      imageUrl +
                                                          "storage/" +
                                                          snapShot.data[index]
                                                              ['avatar'],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        snapShot.data[index]
                                                            ['pseudo'],
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 1.0,
                                                      ),
                                                      Text(
                                                        getDateTime(
                                                            snapShot.data[index]
                                                                ['created_at']),
                                                        style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10.0,
                                                  left: 43.0,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (snapShot.data[index]
                                                            ['star'] !=
                                                        null) ...[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          for (var i = 0;
                                                              i <
                                                                  snapShot.data[
                                                                          index]
                                                                      ['star'];
                                                              i++) ...[
                                                            Icon(
                                                              Icons.star,
                                                              color: Color(
                                                                  0xFFFFA618),
                                                              size: 15.0,
                                                            )
                                                          ],
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 3.0,
                                                      ),
                                                    ],
                                                    Text(
                                                      snapShot.data[index]
                                                                  ['comment'] !=
                                                              null
                                                          ? snapShot.data[index]
                                                              ['comment']
                                                          : '',
                                                      style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8.0,
                                              ),
                                              Divider(),
                                              SizedBox(
                                                height: 8.0,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      child: Center(
                                        child: Text(
                                          "No Reviews",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    )
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: 15.0,
                                      width: 15.0,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: [
                    listCostum(
                      title: "Verified ID",
                      icon: widget.responseData['userId_isVerified'] == 'true'
                          ? Image.asset("assets/images/doneIcon.png",
                              width: 20.0)
                          : Image.asset("assets/images/notDone.png",
                              width: 20.0),
                    ),
                    listCostum(
                      title: "Phone number",
                      icon: widget.responseData['phoneNumber_isVerified'] ==
                              'true'
                          ? Image.asset("assets/images/doneIcon.png",
                              width: 20.0)
                          : Image.asset("assets/images/notDone.png",
                              width: 20.0),
                    ),
                    listCostum(
                      title: 'Email',
                      icon: widget.responseData['email_isVerified'] == 'true'
                          ? Image.asset("assets/images/doneIcon.png",
                              width: 20.0)
                          : Image.asset("assets/images/notDone.png",
                              width: 20.0),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Card(
              elevation: 0.0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder(
                      future: getuserStat(),
                      builder: (BuildContext context, AsyncSnapshot snapShot) {
                        return snapShot.hasData
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          snapShot.data['countProposalTrip']
                                              .toString(),
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 6.0,
                                        ),
                                        Text(
                                          "Trips Proposal",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                    child: Text(","),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          snapShot.data['countDeliveryRequest']
                                              .toString(),
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 6.0,
                                        ),
                                        Text(
                                          "Delivery Requests",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                height: 15.0,
                                width: 15.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "Member since " + getDateTime(responseData['created_at']),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listCostum({String title, icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          icon,
          SizedBox(width: 5),
          Text(
            title,
          ),
        ],
      ),
    );
  }
}
