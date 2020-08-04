import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/config/style.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/screens/tabs_screen.dart';
import 'package:luggin/services/http_service.dart';

class WriteReviewScreen extends StatefulWidget {
  final requestData;
  WriteReviewScreen({@required this.requestData});
  @override
  _WriteReviewScreenState createState() =>
      _WriteReviewScreenState(this.requestData);
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final requestData;
  _WriteReviewScreenState(this.requestData);

  HttpService httpService = HttpService();
  TextEditingController _comment;
  int _star;
  String responseMessage = '';
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    _comment = TextEditingController();
  }

  _saveUserReview() async {
    setState(() {
      responseMessage = '';
    });

    if (_comment.text.isEmpty && _star == null) {
      setState(() {
        responseMessage = "Enter a note or comment";
      });
      return;
    }

    setState(() {
      this.isLoad = true;
      this.requestData['comment'] = _comment.text.toString();
      this.requestData['star'] = _star;
    });

    print(requestData);

    var response =
        await this.httpService.postData("saveUserReview", requestData);
    if (response['success']) {
      Fluttertoast.showToast(
        msg: "Evaluation sent",
        backgroundColor: Colors.white24,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TabsScreen(),
        ),
      );
    } else {
      setState(() {
        isLoad = false;
        responseMessage = "NetWork error";
      });
    }
  }

  setStar(star) {
    setState(() {
      this._star = star;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 200.0,
                      decoration: Style.gradientDecoration,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "How was the transaction ? ",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Chip(
                              backgroundColor: Colors.white,
                              avatar: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  AppEvironement.imageUrl +
                                      'storage/' +
                                      requestData['userData']['avatar'],
                                ),
                              ),
                              label: Text(requestData['userData']['pseudo']),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 125.0,
                        left: 5.0,
                        right: 5.0,
                      ),
                      child: Card(
                        elevation: 0.3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20.0,
                                  bottom: 20.0,
                                ),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () => setStar(1),
                                        child: Column(
                                          children: <Widget>[
                                            Icon(
                                              Icons.sentiment_very_dissatisfied,
                                              color: _star == 1
                                                  ? Palette.primaryColor
                                                  : Colors.black12,
                                              size: 40.0,
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "To be avoided",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: _star == 1
                                                    ? Palette.primaryColor
                                                    : Colors.black12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => setStar(2),
                                        child: Column(
                                          children: <Widget>[
                                            Icon(
                                              Icons.sentiment_dissatisfied,
                                              color: _star == 2
                                                  ? Palette.primaryColor
                                                  : Colors.black12,
                                              size: 40.0,
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "Disappointing",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: _star == 2
                                                    ? Palette.primaryColor
                                                    : Colors.black12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => setStar(3),
                                        child: Column(
                                          children: <Widget>[
                                            Icon(
                                              Icons.sentiment_neutral,
                                              color: _star == 3
                                                  ? Palette.primaryColor
                                                  : Colors.black12,
                                              size: 40.0,
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "Good",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: _star == 3
                                                    ? Palette.primaryColor
                                                    : Colors.black12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => setStar(4),
                                        child: Column(
                                          children: <Widget>[
                                            Icon(
                                              Icons.sentiment_satisfied,
                                              color: _star == 4
                                                  ? Palette.primaryColor
                                                  : Colors.black12,
                                              size: 40.0,
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "Very good",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: _star == 4
                                                    ? Palette.primaryColor
                                                    : Colors.black12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => setStar(5),
                                        child: Column(
                                          children: <Widget>[
                                            Icon(
                                              Icons.sentiment_very_satisfied,
                                              color: _star == 5
                                                  ? Palette.primaryColor
                                                  : Colors.black12,
                                              size: 40.0,
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "Perfect",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: _star == 5
                                                    ? Palette.primaryColor
                                                    : Colors.black12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  color: Palette.ligth,
                                  child: TextField(
                                    controller: _comment,
                                    autofocus: true,
                                    maxLines: 4,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 12.0, 10.0, 12.0),
                                      hintText: 'Write a review ',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (responseMessage != '') ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        responseMessage,
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  )
                ],
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () => !isLoad ? _saveUserReview() : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        color: Palette.primaryColor.withOpacity(0.8),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              isLoad ? 'please wait...' : "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
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
          ],
        ),
      ),
    );
  }
}
