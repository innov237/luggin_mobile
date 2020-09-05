import 'package:flutter/material.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/services/preferences_service.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:luggin/widgets/requestCard_widgets.dart';

class UserRequestPage extends StatefulWidget {
  @override
  _UserRequestPageState createState() => _UserRequestPageState();
}

class _UserRequestPageState extends State<UserRequestPage> {
  var authUserData;
  var userRequestData = [];
  bool isLoard = true;

  String apiUrl = AppEvironement.apiUrl;

  getUserTrip() async {
    Dio dio = Dio();
    var response = await dio.get(
      apiUrl + "getUserExpedition",
      queryParameters: {
        'userId': authUserData['id'].toString(),
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        userRequestData = response.data;
        print(userRequestData);
        isLoard = false;
      });
    } else {
      print("erreur");
      setState(() {
        isLoard = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPreferencesData();
  }

  getPreferencesData() {
    PreferenceStorage.getDataFormPreferences('USERDATA').then((data) {
      if (null == data) {
        return;
      }
      setState(() {
        var storageValue = json.decode(data);
        authUserData = storageValue;
        getUserTrip();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My requests"),
        ),
        body: (!isLoard && userRequestData.length > 0)
            ? ListView.builder(
                itemCount: userRequestData.length,
                itemBuilder: (BuildContext context, int index) =>
                    RequestCardWidget(
                  responseData: userRequestData[index],
                ),
              )
            : (userRequestData.length == 0 && !isLoard)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/empty.png",
                          width: 100.0,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "No requests found",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }
}
