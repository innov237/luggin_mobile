import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/services/http_service.dart';
import 'package:intl/intl.dart';

class UserProfilDetails extends StatefulWidget {
  final responseData;
  UserProfilDetails({@required this.responseData, Key key}) : super(key: key);
  @override
  _UserProfilDetailsState createState() =>
      _UserProfilDetailsState(this.responseData);
}

class _UserProfilDetailsState extends State<UserProfilDetails> {
  final responseData;
  _UserProfilDetailsState(this.responseData);

  String imageUrl = AppEvironement.imageUrl;

  HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
    print(this.responseData);
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
      'userId': responseData['idUser'] !=null ? responseData['idUser'] : responseData['id'] ,
    };
    var response = await httpService.getPostByKey("getUserReviews", postData);
    print(response);
    return response;
  }

  getDateTime(timestamp) {
    String formattedDate =
        DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(timestamp));
    return formattedDate;
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
                                              : Colors.red,
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
                                " years"
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
                Padding(
                  padding: const EdgeInsets.only(
                    top: 180.0,
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Card(
                    elevation: 0.2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "0",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6.0,
                                    ),
                                    Text(
                                      "Trips Proposal",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "0",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6.0,
                                    ),
                                    Text(
                                      "Delivery Request",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "0",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 6.0,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Color(0xFFFFA618),
                                          size: 15.0,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Reviews",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Divider(),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Image.asset(
                                    responseData['userId_isVerified'] == 'true'
                                        ? "assets/images/doneIcon.png"
                                        : "assets/images/notDone.png",
                                    height: 20.0,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    "Identity",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 25.0,
                              ),
                              Column(
                                children: <Widget>[
                                  Image.asset(
                                    responseData['phoneNumber_isVerified'] ==
                                            'true'
                                        ? "assets/images/doneIcon.png"
                                        : "assets/images/notDone.png",
                                    height: 20.0,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    "Phone",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 25.0,
                              ),
                              Column(
                                children: <Widget>[
                                  Image.asset(
                                    responseData['email_isVerified'] == 'true'
                                        ? "assets/images/doneIcon.png"
                                        : "assets/images/notDone.png",
                                    height: 20.0,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    "E-mail",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
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
                                                      Text(snapShot.data[index]
                                                          ['pseudo']),
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
                                                  top: 5.0,
                                                  left: 50.0,
                                                ),
                                                child: Text(
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
                                      height: 50.0,
                                      width: 50.0,
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
                          "Other",
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
}
