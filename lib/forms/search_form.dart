import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/config/style.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/pages/city_list_page.dart';
import 'package:luggin/screens/searche_result._screen.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/widgets/linesHeader_widgets.dart';
import 'package:luggin/services/preferences_service.dart';
import 'dart:convert';

class SearchForm extends StatefulWidget {
  final inputData;
  SearchForm({this.inputData});
  @override
  _SearchFormState createState() => _SearchFormState(this.inputData);
}

class _SearchFormState extends State<SearchForm> {
  final inputData;
  _SearchFormState(this.inputData);

  TextEditingController _isTripOrRequest;
  TextEditingController _departureCity;
  TextEditingController _arrivalCity;
  TextEditingController _departureDate;
  TextEditingController _flightNumber;
  TextEditingController _spareKilosMax;
  TextEditingController _spareKilosMin;
  TextEditingController _onlySameFlight;

  String apiUrl = AppEvironement.apiUrl;
  DateTime pickedDate;

  bool isLoard = false;
  String responseData = '';
  var searchResultData;
  HttpService httpService = HttpService();
  var searchData = [];

  @override
  void initState() {
    super.initState();

    _departureCity = TextEditingController();
    _arrivalCity = TextEditingController();
    _departureDate = TextEditingController();
    _flightNumber = TextEditingController();
    _spareKilosMax = TextEditingController();
    _spareKilosMin = TextEditingController();
    _onlySameFlight = TextEditingController();
    _isTripOrRequest = TextEditingController();

    pickedDate = DateTime.now();

    if (inputData != null) {
      _departureCity.text = inputData['departureCity'];
      _departureCity.text = inputData['departureCity'];
      _arrivalCity.text = inputData['arrivalCity'];
      _departureDate.text = inputData['departureDate'];
      _flightNumber.text = inputData['flightNumber'];
      _spareKilosMax.text = inputData['spareKilosMax'];
      _spareKilosMin.text = inputData['spareKilosMin'];
      _onlySameFlight.text = inputData['onlySameFlight'];
      _isTripOrRequest.text = inputData['isTripOrRequest'];
    }
  }

  _search() async {
    if (_isTripOrRequest.text.isEmpty) {
      setState(() {
        responseData = 'Please select trip or request';
      });
      return;
    }

    setState(() {
      isLoard = true;
      responseData = '';
    });

    var postData = {
      'departureCity': _departureCity.text,
      'arrivalCity': _arrivalCity.text,
      'departureDate': _departureDate.text,
      'flightNumber': _flightNumber.text,
      'spareKilosMax': _spareKilosMax.text,
      'spareKilosMin': _spareKilosMax.text,
      'onlySameFlight': _onlySameFlight.text,
      'isTripOrRequest': _isTripOrRequest.text,
    };

    _saveRecentSearch(postData);

    if (_isTripOrRequest.text == 'trip') {
      var response = await httpService.postData("searchTrip", postData);
      if (response.length > 0) {
        print(response);
        setState(() {
          isLoard = false;
        });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SearchResultScreen(
                isTripOrRequest: 'trip', responseData: response),
          ),
        );
      } else {
        setState(() {
          isLoard = false;
          responseData = 'no result found';
        });
      }
    } else {
      var response = await httpService.postData("searchExpedition", postData);
      if (response.length > 0) {
        setState(() {
          isLoard = false;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SearchResultScreen(
                isTripOrRequest: 'request', responseData: response),
          ),
        );
      } else {
        setState(() {
          isLoard = false;
          responseData = 'no result found';
        });
      }
    }
  }

  _setIsTripOrRequest(value) {
    setState(() {
      _isTripOrRequest.text = value;
    });
  }

  _pickDate(context) async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDate: pickedDate,
    );

    if (date != null) {
      _departureDate.text = date.month.toString().padLeft(2, '0') +
          '/' +
          date.day.toString().padLeft(2, '0') +
          '/' +
          date.year.toString();
    }
  }

  _setonlySameFlight(value) {
    setState(() {
      _onlySameFlight.text = value;
    });
  }

  _saveRecentSearch(data) async {
    var result = await PreferenceStorage.getDataFormPreferences("R_SEARCH");
    print(result);

    if (result != null) {
      setState(() {
        searchData.add(json.decode(result)[0]);
      });
    }

    setState(() {
      searchData.add(data);
    });

    PreferenceStorage.saveDataToPreferences(
      "R_SEARCH",
      json.encode(searchData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: 190.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/word-map.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                height: 60.0,
                width: double.infinity,
                decoration: Style.gradientDecoration,
              ),
            ),
            LinesHeaderWidget(
              title: "Search",
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 120.0,
                left: 8.0,
                right: 8.0,
              ),
              child: ListView(
                children: [
                  Card(
                    elevation: Style.cardElevation,
                    shape: Style.shapeCard,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: () => _setIsTripOrRequest('trip'),
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 10.0,
                                        backgroundColor:
                                            _isTripOrRequest.text == 'trip'
                                                ? Colors.greenAccent
                                                : Colors.black12,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Search Trip',
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _setIsTripOrRequest('request'),
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 10.0,
                                        backgroundColor:
                                            _isTripOrRequest.text == 'request'
                                                ? Colors.greenAccent
                                                : Colors.black12,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Expanded(
                                        child: Text('Search Request'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CityListPage(),
                                      ),
                                    );

                                    if (result != null) {
                                      setState(() {
                                        _departureCity.text = result['name'];
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.flight_takeoff,
                                        color: Palette.primaryColor,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _departureCity,
                                          enabled: false,
                                          decoration:
                                              InputDecoration(hintText: 'From'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CityListPage(),
                                      ),
                                    );

                                    if (result != null) {
                                      setState(() {
                                        _arrivalCity.text = result['name'];
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.flight_land,
                                        color: Palette.primaryColor,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _arrivalCity,
                                          enabled: false,
                                          decoration:
                                              InputDecoration(hintText: 'To'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                                color: Palette.primaryColor,
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _pickDate(context),
                                  child: TextField(
                                    controller: _departureDate,
                                    enabled: false,
                                    decoration:
                                        InputDecoration(hintText: 'Date'),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() {
                                  _departureDate.text = '';
                                }),
                                child: Text(
                                  "reset",
                                  style: TextStyle(color: Palette.primaryColor),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.confirmation_number,
                                color: Palette.primaryColor,
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _flightNumber,
                                  decoration: InputDecoration(
                                    hintText: 'Flight Number',
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.explore,
                                      color: Palette.primaryColor,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _spareKilosMax,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: 'Spare kilos max',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _spareKilosMin,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: 'Spare kilos min',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: () => _setonlySameFlight('true'),
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 10.0,
                                        backgroundColor:
                                            _onlySameFlight.text == 'true'
                                                ? Colors.greenAccent
                                                : Colors.black12,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Carrier  on same flight',
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _setonlySameFlight('false'),
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 10.0,
                                        backgroundColor:
                                            _onlySameFlight.text == 'false'
                                                ? Colors.greenAccent
                                                : Colors.black12,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Any Carrier',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            responseData,
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          InkWell(
                            onTap: () => _search(),
                            child: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Palette.primaryColor,
                              child: !isLoard
                                  ? Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 55.0,
                left: 10.0,
                right: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      color: Colors.white12,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.map,
                              color: Colors.white,
                            ),
                            Text(
                              "Use map to search",
                              style: TextStyle(
                                color: Colors.white,
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
          ],
        ),
      ),
    );
  }
}
