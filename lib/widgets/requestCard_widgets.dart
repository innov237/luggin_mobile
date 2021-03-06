import 'package:flutter/material.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/pages/post_detail.dart';
import 'package:luggin/config/palette.dart';

class RequestCardWidget extends StatefulWidget {
  final responseData;
  RequestCardWidget({@required this.responseData, Key key}) : super(key: key);
  @override
  _RequestCardWidgetState createState() =>
      _RequestCardWidgetState(this.responseData);
}

class _RequestCardWidgetState extends State<RequestCardWidget> {
  final responseData;
  _RequestCardWidgetState(this.responseData);

  String imageUrl = AppEvironement.imageUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailPage(
              parcelDetail: responseData,
              isTripOrExpedition: 'expedition',
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 15.0),
                    child: Container(
                      height: 77.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "Date",
                                style: TextStyle(
                                  color: Palette.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                              Text(
                                responseData['dateDepartureParcel'],
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 12.0,
                          backgroundColor: Palette.primaryColor,
                          child: Icon(
                            Icons.flight_takeoff,
                            size: 14.0,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          height: 38.0,
                          width: 3.0,
                          color: Palette.primaryColor,
                        ),
                        CircleAvatar(
                          radius: 12.0,
                          backgroundColor: Palette.primaryColor,
                          child: Icon(
                            Icons.flight_land,
                            size: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Container(
                        height: 77.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              responseData['cityDepartureParcel'],
                              style: TextStyle(
                                color: Palette.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    responseData['weightParcel'].toString() +
                                        "Kg",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              responseData['cityArrivalParcel'],
                              style: TextStyle(
                                color: Palette.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.black12,
                        backgroundImage: NetworkImage(
                          imageUrl + "storage/" + responseData['avatar'],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 23.0, left: 23.0),
                        child: CircleAvatar(
                          radius: 10.0,
                          backgroundColor: Color(0XFFF2F5F5),
                          child: Icon(
                            Icons.verified_user,
                            color: responseData['userId_isVerified'] == 'true'
                                ? Colors.green
                                : Colors.black12,
                            size: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          responseData['pseudo'],
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              size: 15.0,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              responseData['star'] != null
                                  ? responseData['star'].toString()
                                  : '0',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.7)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black12,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
