import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/core/loader/loader.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/services/preferences_service.dart';

class PendingTransferPage extends StatefulWidget {
  @override
  _PendingTransferPageState createState() => _PendingTransferPageState();
}

class _PendingTransferPageState extends State<PendingTransferPage> {
  HttpService httpservice = HttpService();
  var authUserData;
  var pendingTransferData;
  bool isLoad = true;

  _getUserPendingRequest(userId) async {
    var responseData = await httpservice
        .getPostByKey("getUserPendingRequest", {'key': userId});

    setState(() {
      pendingTransferData = responseData;
      print(pendingTransferData);
      isLoad = false;
    });
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
        _getUserPendingRequest(authUserData['id']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                right: 5.0,
              ),
              child: Text("Configurer"),
            ),
          ],
        ),
        body: !isLoad
            ? ListView(
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 0.2,
                          child: Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Montant en attente"),
                                      Text(
                                        "0.00€",
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Text(
                                  "0.0€",
                                  style: TextStyle(
                                    fontSize: 27.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "Montant dispinible",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 45.0,
                                    width: double.infinity,
                                    child: RaisedButton(
                                      onPressed: () => null,
                                      elevation: 0.0,
                                      color: Palette.primaryColor,
                                      child: Text(
                                        "Transférer vers un compte bancaire",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Contrôle tes dépenses et revenus sur Luggin: après chaque transaction,la somme débitée ou créditée apparaitra ici",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Card(
                          elevation: 0.2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 20.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Solde initial",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3.0,
                                      ),
                                      Text("1 oct 2020")
                                    ],
                                  ),
                                ),
                                Text(
                                  "0.00 €",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            : loader(),
      ),
    );
  }
}
