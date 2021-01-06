import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';

class NotificationSettingPage extends StatefulWidget {
  @override
  _NotificationSettingPageState createState() =>
      _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  bool ativateEmailForPolicy = false;
  bool ativatePushForPolicy = false;
  bool ativateTextForPolicy = false;

  bool ativateEmailForSupport = false;
  bool ativatePushForSupport = false;
  bool ativateTextForSupport = false;

  onclick({String catagory, String type}) {
    if (catagory == 'Policy') {
      if (type == 'email') {
        setState(() {
          ativateEmailForPolicy = !ativateEmailForPolicy;
        });
      }
      if (type == 'push') {
        setState(() {
          ativatePushForPolicy = !ativatePushForPolicy;
        });
      }
      if (type == 'text') {
        setState(() {
          ativateTextForPolicy = !ativateTextForPolicy;
        });
      }
    }

    if (catagory == 'Support') {
      if (type == 'email') {
        setState(() {
          ativateEmailForSupport = !ativateEmailForSupport;
        });
      }
      if (type == 'push') {
        setState(() {
          ativatePushForSupport = !ativatePushForSupport;
        });
      }
      if (type == 'text') {
        setState(() {
          ativateTextForSupport = !ativateTextForSupport;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Updates from LuggIn"),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 5.0),
            buildItem(
              title: "Policy and community",
              subtitle:
                  "Receive updates on home sharing regulations and stay informed about advocacy efforts to create...",
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () => onclick(catagory: "Policy", type: 'email'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "E-mail",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        isActiveOrInactive(ativateEmailForPolicy),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Divider(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  InkWell(
                    onTap: () => onclick(catagory: "Policy", type: 'push'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Push notifications",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        isActiveOrInactive(ativatePushForPolicy),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  InkWell(
                    onTap: () => onclick(catagory: "Policy", type: 'text'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Text Messages",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        isActiveOrInactive(ativateTextForPolicy),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(
                    height: 5.0,
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
            buildItem(
              title: "Account support",
              subtitle:
                  "Receive message about your account, your trips, lega notification, security matters, and customer support requests.For your security...",
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () => onclick(catagory: "Support", type: 'email'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "E-mail",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        isActiveOrInactive(ativateEmailForSupport),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Divider(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  InkWell(
                    onTap: () => onclick(catagory: "Support", type: 'push'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Push notifications",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        isActiveOrInactive(ativatePushForSupport),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  InkWell(
                    onTap: () => onclick(catagory: "Support", type: 'text'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Text Messages",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        isActiveOrInactive(ativateTextForSupport),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(
                    height: 5.0,
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem({String title, String subtitle}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 16.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget isActiveOrInactive(value) {
    return Container(
      child: value
          ? Icon(
              Icons.toggle_on,
              size: 42.0,
              color: Palette.primaryColor,
            )
          : Icon(
              Icons.toggle_off,
              size: 42.0,
              color: Colors.black12,
            ),
    );
  }
}
