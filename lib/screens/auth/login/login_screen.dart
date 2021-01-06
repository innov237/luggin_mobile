import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/screens/auth/register/register_screen.dart';
import 'package:luggin/screens/auth/loader.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/screens/tabs_screen.dart';
import 'package:luggin/services/preferences_service.dart';
import 'package:luggin/models/language_model.dart';
import 'dart:convert';

import 'dart:math' as math;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  bool showPassWord = false;
  bool isLoard = false;
  String responseMessage = '';

  TextEditingController _pseudoController;
  TextEditingController _passwordController;

  // String apiUrl = AppEvironement.apiUrl;
  final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animationController.forward();

    _pseudoController = TextEditingController();
    _passwordController = TextEditingController();
  }

  startLoarder() {
    setState(() {
      isLoard = true;
    });
  }

  stopLoarder() {
    setState(() {
      isLoard = false;
    });
  }

  setResponseMessage(message) {
    setState(() {
      responseMessage = message;
    });
  }

  clearResponseMessage() {
    setState(() {
      responseMessage = '';
    });
  }

  signIn() async {
    startLoarder();
    clearResponseMessage();

    var postData = {
      'pseudo': _pseudoController.text,
      'password': _passwordController.text
    };

    if (_passwordController.text.isNotEmpty &&
        _pseudoController.text.isNotEmpty) {
      httpService.postData("login", postData).then((result) {
        if (result['success']) {
          setState(() {
            PreferenceStorage.saveDataToPreferences(
                'USERDATA', json.encode(result['data']));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TabsScreen(
                  selectedPage: 2,
                ),
              ),
            );
          });
        } else {
          setResponseMessage(result['message']);
          stopLoarder();
        }
      }).catchError(
        (e) {
          stopLoarder();
          setResponseMessage("Network error");
        },
      );
    } else {
      setResponseMessage("required-input");
      stopLoarder();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () =>
            SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop'),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    height: 200.0,
                    color: Palette.primaryColor,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        DropdownButton(
                          onChanged: (Language language) {
                            setState(() {
                              if (language.languageCode == 'fr') {
                                EasyLocalization.of(context).locale =
                                    Locale('fr', 'CA');
                              } else if (language.languageCode == 'en') {
                                EasyLocalization.of(context).locale =
                                    Locale('en', 'EN');
                              }
                            });
                          },
                          hint: Text(
                            "Language".tr(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          underline: SizedBox(),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Palette.primaryColor,
                          ),
                          items: Language.getLanguages()
                              .map<DropdownMenuItem<Language>>(
                                (lang) => DropdownMenuItem(
                                  value: lang,
                                  child: Row(
                                    children: <Widget>[
                                      Text(lang.languageFlag),
                                      SizedBox(
                                        width: 2.0,
                                      ),
                                      Text(lang.name)
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.0),
                          topRight: Radius.circular(35.0),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 80.0,
                          ),
                          Text(
                            "sign-in".tr(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'login-subtitle'.tr(),
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                responseMessage != ''
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          responseMessage.tr(),
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 15.0,
                                      ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    100.0,
                                  ),
                                  child: Container(
                                    color: Color(0xFFEFF0F1),
                                    height: 46.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextField(
                                        controller: _pseudoController,
                                        decoration: InputDecoration(
                                          hintText: 'pseudo-input'.tr() + "*",
                                          icon: CircleAvatar(
                                            backgroundColor:
                                                Palette.primaryColor,
                                            child: Icon(
                                              Icons.account_circle,
                                              color: Colors.white,
                                            ),
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.only(
                                            bottom: 13.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 25.0,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    100.0,
                                  ),
                                  child: Container(
                                    color: Color(0xFFEFF0F1),
                                    height: 46.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: TextField(
                                              controller: _passwordController,
                                              obscureText:
                                                  !showPassWord ? true : false,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'password-input'.tr() + "*",
                                                icon: CircleAvatar(
                                                  backgroundColor:
                                                      Palette.primaryColor,
                                                  child: Icon(
                                                    Icons.lock,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                  bottom: 13.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (!this.showPassWord) {
                                                setState(() {
                                                  this.showPassWord = true;
                                                });
                                              } else {
                                                setState(() {
                                                  this.showPassWord = false;
                                                });
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 3.0,
                                              ),
                                              child: Icon(
                                                !showPassWord
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Colors.black.withOpacity(
                                                  0.3,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 17.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      'forgot-password'.tr(),
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 45.0,
                                  child: RaisedButton(
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                    onPressed: () {
                                      signIn();
                                    },
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.all(0.0),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              Color(0xFF2288B9),
                                              Color(0xFF2288B9),
                                              Color(0xFF42A5F5),
                                            ],
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: !isLoard
                                              ? Text(
                                                  'sign-in'.tr(),
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                )
                                              : buildloader(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 35.0,
                                ),
                                InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterScreen(),
                                    ),
                                  ),
                                  child: Text(
                                    'sign-up'.tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Palette.primaryColor,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 56.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.white,
                          child: Card(
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) => Transform.rotate(
                                  angle:
                                      _animationController.value * math.pi * 2,
                                  child: Container(
                                    child: Image.asset(
                                      "assets/images/logo.png",
                                      height: 60.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
