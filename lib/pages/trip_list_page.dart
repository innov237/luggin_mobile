import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/forms/search_form.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/widgets/tripCard_widgets.dart';

class TripListPage extends StatefulWidget {
  final params;
  TripListPage({this.params});
  @override
  _TripListPageState createState() => _TripListPageState(this.params);
}

class _TripListPageState extends State<TripListPage> {
  final params;

  _TripListPageState(this.params);

  var responseData;

  String imageUrl = AppEvironement.imageUrl;

  HttpService httpService = HttpService();

  bool isLord = true;

  getAllTrip() async {
    var response = await httpService.getPosts("getAllTrips");
    setState(() {
      isLord = false;
    });
    return response;
  }

  getTripByCity() async {
    var response = await httpService.getPostByKey(
        "getTripByDestination", params['cityArrivalTrip']);
    setState(() {
      isLord = false;
    });
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: isLord ? Colors.white : null,
        floatingActionButton: !isLord
            ? FloatingActionButton.extended(
                elevation: 1.0,
                icon: Icon(Icons.filter_list),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchForm(),
                  ),
                ),
                backgroundColor: Palette.primaryColor,
                label: Text("Filter"),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: Text("Trips"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FutureBuilder(
              future: this.params != null ? getTripByCity() : getAllTrip(),
              builder: (BuildContext context, AsyncSnapshot snapShot) {
                if (snapShot.hasData) {
                  if (snapShot.data.length > 0) {
                    return ListView.builder(
                      itemCount: snapShot.data.length,
                      itemBuilder: (BuildContext context, int index) =>
                          TripCardWidget(
                        responseData: snapShot.data[index],
                      ),
                    );
                  } else {
                    return Center(
                      child: Text("No result"),
                    );
                  }
                } else if (snapShot.hasError) {
                  return Center(
                    child: Text("NetWork Error"),
                  );
                } else {
                  return Center(
                    child: Container(
                      child: Image.asset(
                        "assets/images/loader.gif",
                        height: 60.0,
                        width: 60.0,
                      ),
                    ),
                  );
                }
              },
            )),
      ),
    );
  }
}
