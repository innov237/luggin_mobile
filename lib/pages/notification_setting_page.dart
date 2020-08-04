import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';

class NotificationSettingPage extends StatefulWidget {
  @override
  _NotificationSettingPageState createState() =>
      _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  String userRequestNotificationOption;
  String userReminderOption;

  setuserRequestNotificationOption(option) {
    setState(() {
      userRequestNotificationOption = option;
    });
  }

  setuserReminderOption(option) {
    setState(() {
      userReminderOption = option;
    });
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Messages from members \nincluding requests",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () => setuserRequestNotificationOption('email'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "E-mail",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        CircleAvatar(
                          radius: 10.0,
                          backgroundColor: Colors.black12,
                          child: CircleAvatar(
                            radius: 8.0,
                            backgroundColor:
                                userRequestNotificationOption == 'email'
                                    ? Palette.primaryColor
                                    : Colors.black12,
                          ),
                        ),
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
                    onTap: () => setuserRequestNotificationOption('push'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Push notifications",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        CircleAvatar(
                          radius: 10.0,
                          backgroundColor: Colors.black12,
                          child: CircleAvatar(
                            radius: 8.0,
                            backgroundColor:
                                userRequestNotificationOption == 'push'
                                    ? Palette.primaryColor
                                    : Colors.black12,
                          ),
                        ),
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
                    onTap: () => setuserRequestNotificationOption('sms'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Text Messages",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        CircleAvatar(
                          radius: 10.0,
                          backgroundColor: Colors.black12,
                          child: CircleAvatar(
                            radius: 8.0,
                            backgroundColor:
                                userRequestNotificationOption == 'sms'
                                    ? Palette.primaryColor
                                    : Colors.black12,
                          ),
                        ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Reminders",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () => setuserReminderOption('email'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "E-mail",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        CircleAvatar(
                          radius: 10.0,
                          backgroundColor: Colors.black12,
                          child: CircleAvatar(
                            radius: 8.0,
                            backgroundColor:
                                userReminderOption == 'email'
                                    ? Palette.primaryColor
                                    : Colors.black12,
                          ),
                        ),
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
                    onTap: () => setuserReminderOption('push'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Push notifications",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        CircleAvatar(
                          radius: 10.0,
                          backgroundColor: Colors.black12,
                          child: CircleAvatar(
                            radius: 8.0,
                            backgroundColor:
                                userReminderOption == 'push'
                                    ? Palette.primaryColor
                                    : Colors.black12,
                          ),
                        ),
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
                    onTap: () => setuserReminderOption('sms'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Text Messages",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        CircleAvatar(
                          radius: 10.0,
                          backgroundColor: Colors.black12,
                          child: CircleAvatar(
                            radius: 8.0,
                            backgroundColor:
                                userReminderOption == 'sms'
                                    ? Palette.primaryColor
                                    : Colors.black12,
                          ),
                        ),
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
}
