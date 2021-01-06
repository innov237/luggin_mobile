import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/screens/tabs_screen.dart';

class ReviewSuccessPage extends StatefulWidget {
  @override
  _ReviewSuccessPageState createState() => _ReviewSuccessPageState();
}

class _ReviewSuccessPageState extends State<ReviewSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: null,
          elevation: 0.0,
          actions: [
            GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TabsScreen(selectedPage: 2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "ok",
                  style: TextStyle(
                    color: Palette.primaryColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 10.0,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.greenAccent,
                          width: 5.0,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.done,
                          size: 40.0,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Merçi pour votre avis.",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Celui-ci est en cours de modélisation.',
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                bottom: 10.0,
              ),
              child: Text(
                "Et maintenant",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 10.0,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.greenAccent,
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: Text("1"),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Innov a 14jours pour vous laisser un avis",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 10.0,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.greenAccent,
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: Text("2"),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Votre  vis sera publié une fois qu'elle l'aura fait,\nou lorsque les 14 jours seront écoules",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    )
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
