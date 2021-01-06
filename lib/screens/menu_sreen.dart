import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/pages/feedback_page.dart';
import 'package:luggin/pages/gethelp_page.dart';
import 'package:luggin/pages/profil_verification.dart';
import 'package:luggin/pages/reviews/reviews_list.dart';
import 'package:luggin/pages/safety_center.dart';
import 'package:luggin/pages/user_profil_detail_page.dart';
import 'package:luggin/screens/auth/login/login_screen.dart';
import 'package:luggin/services/preferences_service.dart';
import 'package:luggin/pages/user_request_page.dart';
import 'package:luggin/pages/user_trip_page.dart';
import 'package:luggin/pages/notification_setting_page.dart';
import 'package:luggin/pages/terms_and_conditions_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:luggin/pages/payment_and_payout_page.dart';

import 'package:luggin/models/language_model.dart';
import 'package:easy_localization/easy_localization.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var authUserData;
  String imageUrl = AppEvironement.imageUrl;

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
        print(authUserData);
      });
    });
  }

  _openPage(context, page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  _logOut() {
    PreferenceStorage.cleanReferences('USERDATA');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
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
                          bottom: 8.0,
                          left: 8.0,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              "cancel".tr(),
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Palette.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 30.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 30.0,
                                    child: Image.asset(
                                      "assets/images/log-out.png",
                                      width: 30.0,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "log-out".tr(),
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50.0,
                                  ),
                                  Text("log-out-confirmation-text".tr())
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          right: 0.0,
                          child: InkWell(
                            onTap: () => _logOut(),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(100.0),
                                ),
                                color: Colors.redAccent,
                              ),
                              child: Shimmer.fromColors(
                                baseColor: Colors.white60,
                                highlightColor: Colors.white,
                                child: Container(
                                  height: 40.0,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 10.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "log-out".tr(),
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 20.0,
                                          )
                                        ],
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Column(
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
                      ),
                      height: 140.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () => _openPage(
                                context,
                                UserProfilDetails(
                                  authUserData: authUserData,
                                ),
                              ),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: Colors.white12,
                                          radius: 48,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.black12,
                                            radius: 45.0,
                                            backgroundImage: authUserData !=
                                                    null
                                                ? NetworkImage(
                                                    imageUrl +
                                                        'storage/' +
                                                        authUserData['avatar'],
                                                  )
                                                : null,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              authUserData != null
                                                  ? authUserData['pseudo']
                                                  : 'userName',
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19.0,
                                              ),
                                            ),
                                            if (authUserData != null) ...[
                                              if (authUserData[
                                                      'userId_isVerified'] ==
                                                  'false') ...[
                                                Icon(
                                                  Icons.verified,
                                                  color: Colors.greenAccent,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfilVerification(
                                                          authUserData:
                                                              authUserData,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "complete-profile".tr(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ),
                                              ]
                                            ]
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8.0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white12,
                                ),
                                height: 170.0,
                                width: 30.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 10.0,
                                    top: 5.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () => Navigator.pop(context),
                                        child: Icon(Icons.clear,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 125.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.0),
                                      onTap: () =>
                                          _openPage(context, UserTripsPage()),
                                      dense: true,
                                      title: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/trip2.png",
                                            height: 25.0,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'your-trips'.tr(),
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.0),
                                      onTap: () =>
                                          _openPage(context, UserRequestPage()),
                                      title: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/request.png",
                                            height: 20.0,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'your-requests'.tr(),
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.0),
                                      onTap: () => _openPage(
                                        context,
                                        PaymentAndPayoutPage(),
                                      ),
                                      title: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/business.png",
                                            height: 25.0,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'payments-and-payouts'.tr(),
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.0),
                                      onTap: () => _openPage(
                                        context,
                                        NotificationSettingPage(),
                                      ),
                                      title: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/notification.png",
                                            height: 25.0,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Notifications',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      onTap: () => _openPage(
                                        context,
                                        ReviewsListPage(),
                                      ),
                                      contentPadding: EdgeInsets.all(0.0),
                                      title: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/review.png",
                                            height: 27.0,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'reviews'.tr(),
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.0),
                                      title: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.language,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              DropdownButton(
                                                onChanged: (Language language) {
                                                  setState(() {
                                                    if (language.languageCode ==
                                                        'fr') {
                                                      EasyLocalization.of(
                                                                  context)
                                                              .locale =
                                                          Locale('fr', 'CA');
                                                    } else if (language
                                                            .languageCode ==
                                                        'en') {
                                                      EasyLocalization.of(
                                                                  context)
                                                              .locale =
                                                          Locale('en', 'EN');
                                                    }
                                                  });
                                                },
                                                underline: SizedBox(),
                                                hint: Text(
                                                  "Language".tr(),
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                items: Language.getLanguages()
                                                    .map<
                                                        DropdownMenuItem<
                                                            Language>>(
                                                      (lang) =>
                                                          DropdownMenuItem(
                                                        value: lang,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(lang
                                                                .languageFlag),
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
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.0),
                                      onTap: () => _openPage(
                                        context,
                                        FeedBackPage(),
                                      ),
                                      dense: true,
                                      title: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/feedback.png",
                                            height: 25.0,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'feedbacks'.tr(),
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      onTap: () => _openPage(
                                        context,
                                        GetHelpPage(),
                                      ),
                                      contentPadding: EdgeInsets.all(0.0),
                                      title: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/technical-support.png",
                                            height: 20.0,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'get-help'.tr(),
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      onTap: () => _openPage(
                                        context,
                                        SafetyCenter(),
                                      ),
                                      contentPadding: EdgeInsets.all(0.0),
                                      title: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/business.png",
                                            height: 25.0,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'safety-centre'.tr(),
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.0),
                                      title: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/technical-support.png",
                                            height: 25.0,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'community-centre'.tr(),
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0.0),
                                      onTap: () => _openPage(
                                        context,
                                        TermsAndConditionsPage(),
                                      ),
                                      title: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/icon-terms.png",
                                            height: 27.0,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'terms-and-conditions'.tr(),
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      onTap: () => _showMyDialog(),
                                      contentPadding: EdgeInsets.all(0.0),
                                      title: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/log-out.png",
                                            height: 27.0,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'log-out'.tr(),
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3.0,
                                    ),
                                    Center(
                                      child: Text("version 1.0"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
