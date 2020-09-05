import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/utils/date_format.dart';

class ShowOneReviews extends StatefulWidget {
  final reviewsData;
  ShowOneReviews({@required this.reviewsData});
  @override
  _ShowOneReviewsState createState() => _ShowOneReviewsState(this.reviewsData);
}

class _ShowOneReviewsState extends State<ShowOneReviews> {
  final reviewsData;
  _ShowOneReviewsState(this.reviewsData);

  @override
  void initState() {
    super.initState();
    print(reviewsData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(reviewsData[0]['pseudo'] + " reviews"),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.black12,
                              radius: 30.0,
                              backgroundImage: NetworkImage(
                                AppEvironement.imageUrl +
                                    "storage/" +
                                    reviewsData[0]['avatar'],
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  reviewsData[0]['pseudo'],
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 1.0,
                                ),
                                Text(
                                  ChangeFormatDate.toDateTimeEn(
                                    reviewsData[0]['created_at'],
                                  ),
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            left: 60.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (reviewsData[0]['star'] != null) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    for (var i = 0;
                                        i < reviewsData[0]['star'];
                                        i++) ...[
                                      Icon(
                                        Icons.star,
                                        color: Color(0xFFFFA618),
                                        size: 23.0,
                                      )
                                    ],
                                  ],
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                              ],
                              Text(
                                reviewsData[0]['comment'] != null
                                    ? reviewsData[0]['comment']
                                    : '',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
