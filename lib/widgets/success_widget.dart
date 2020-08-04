import 'package:flutter/material.dart';
import 'package:luggin/screens/tabs_screen.dart';
import 'package:luggin/config/palette.dart';

class SaveSuccessWidget extends StatefulWidget {
  @override
  _SaveSuccessWidgetState createState() => _SaveSuccessWidgetState();
}

class _SaveSuccessWidgetState extends State<SaveSuccessWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              height: 220.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "It is strictly forbidden to have illicit packages transported. LuggIn will not hesitate to collaborate with the authorities to denounce any abuse.",
                    style: TextStyle(fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Container(
                  height: 170.0,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Your Request is sent \n Congratulations",
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      InkWell(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (conext) => TabsScreen(),
                          ),
                        ),
                        child: Image.asset(
                          "assets/images/doneIcon.png",
                          height: 50.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (conext) => TabsScreen(),
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Palette.primaryColor,
                        child: Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 45.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
