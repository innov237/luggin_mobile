import 'package:flutter/material.dart';
import 'package:luggin/environment/environment.dart';

class PopularDestinationWidget extends StatefulWidget {
  final destinationData;
  PopularDestinationWidget({@required this.destinationData});

  @override
  _PopularDestinationWidgetState createState() =>
      _PopularDestinationWidgetState(this.destinationData);
}

class _PopularDestinationWidgetState extends State<PopularDestinationWidget> {
  final destinationData;

  _PopularDestinationWidgetState(this.destinationData);

  String imageUrl = AppEvironement.imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 3.0),
      child: Card(
        elevation: 0.3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 140.0,
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  color: Colors.black12,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    "https://picsum.photos/seed/picsum/200/300",
                    fit: BoxFit.cover,
                  ),
                  height: 140.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Column(
                children: <Widget>[
                  Text(
                    destinationData['cityArrivalTrip'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    destinationData['count'].toString() + ' trips',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
