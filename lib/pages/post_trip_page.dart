import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/config/style.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/pages/airport_list_page.dart';
import 'package:luggin/pages/city_list_page.dart';
import 'package:luggin/screens/tabs_screen.dart';
import 'package:luggin/services/preferences_service.dart';

class TakeParcelPage extends StatefulWidget {
  @override
  _TakeParcelPageState createState() => _TakeParcelPageState();
}

class _TakeParcelPageState extends State<TakeParcelPage> {
  var authUserData;
  bool isLoard = false;
  bool addflightNumberField = false;

  var _currentCity;
  String _departureCity;
  String _departureAirport;
  String _departureDate;
  String _departureTime;
  String _arrivalCity;
  String _arrivalAirport;
  String _arrivalDate;
  String _arrivalTime;
  int _offeredKilos = 1;
  TextEditingController _offeredKolosPrice;
  TextEditingController _parcelDescription;
  TextEditingController _flightNumber;

  HttpService httpService = HttpService();

  int suggetedPriceUnit = 5;

  String responseMessage = '';

  int step = 1;
  DateTime pickedDate;

  var titleData = [
    '',
    'Choose option 1 or option 2',
    'Where are you leaving from?',
    'Where are you going?',
    'When are you leaving?',
    'When are you arriving?',
    'How many kilos do you have to offer?',
    'Review',
    'Informations'
  ];

  setLoarder() {
    setState(() {
      isLoard = true;
    });
  }

  cleanLoader() {
    setState(() {
      isLoard = false;
    });
  }

  getPreferencesData() {
    PreferenceStorage.getDataFormPreferences('USERDATA').then((data) {
      if (null == data) {
        return;
      }
      setState(() {
        var storageValue = json.decode(data);
        authUserData = storageValue;
        print(authUserData);
      });
    });
  }

  calculatesuggestedPrice() {
    setState(() {
      _offeredKolosPrice.text =
          (((_offeredKilos * 100) / 23).ceil()).toString();
    });
  }

  nextStep() {
    cleanMessage();
    if (step == 2) {
      if (_departureCity == null || _departureAirport == null) {
        setMessage("All fields are required");
        return;
      }
    }
    if (step == 3) {
      if (_arrivalCity == null || _arrivalAirport == null) {
        setMessage("All fields are required");
        return;
      }

      if (_arrivalCity == _departureCity) {
        setMessage(
          "The city of departure must be different from the city of arrival",
        );
        return;
      }
    }
    if (step == 4) {
      if (addflightNumberField == true && _flightNumber.text.isEmpty) {
        setMessage("Flight number is required");
        return;
      }

      if (_departureDate == null || _departureTime == null) {
        setMessage("All fields are required");
        return;
      }
    }
    if (step == 5) {
      if (_arrivalDate == null || _arrivalTime == null) {
        setMessage("All fields are required");
        return;
      }
    }

    if (step == 6) {
      if (_offeredKolosPrice == null || _offeredKilos == null) {
        setMessage("All fields are required");
        return;
      }
    }
    setState(() {
      setState(() {
        step = step + 1;
      });
    });
  }

  prevStep() {
    cleanMessage();
    setState(() {
      setState(() {
        if (step == 1) {
          Navigator.pop(context);
          return;
        }
        step = step - 1;
      });
    });
  }

  setMessage(message) {
    setState(() {
      responseMessage = message;
    });
  }

  cleanMessage() {
    setState(() {
      responseMessage = '';
    });
  }

  _addKilos() {
    setState(() {
      _offeredKilos = _offeredKilos + 1;
      calculatesuggestedPrice();
    });
  }

  _removeKilos() {
    setState(() {
      if (_offeredKilos > 1) {
        _offeredKilos = _offeredKilos - 1;
        calculatesuggestedPrice();
      }
    });
  }

  setStep(mystep) {
    setState(() {
      step = mystep;
    });
  }

  @override
  void initState() {
    super.initState();
    getPreferencesData();
    _offeredKolosPrice = TextEditingController();
    _parcelDescription = TextEditingController();
    _flightNumber = TextEditingController();
    calculatesuggestedPrice();
    pickedDate = DateTime.now();
  }

  _pickDate(context, typeInput) async {
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
      setState(() {
        String mydate = date.month.toString().padLeft(2, '0') +
            '/' +
            date.day.toString().padLeft(2, '0') +
            '/' +
            date.year.toString();

        if (typeInput == 'departure') {
          _departureDate = mydate;
        }

        if (typeInput == 'arrival') {
          _arrivalDate = mydate;
        }
      });
    }
  }

  _pickTime(context, typeInput) async {
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        String myTime = time.hour.toString() + ':' + time.minute.toString();
        if (typeInput == 'departure') {
          _departureTime = myTime;
        }

        if (typeInput == 'arrival') {
          _arrivalTime = myTime;
        }
      });
    }
  }

  _saveTrip() async {
    setLoarder();
    var postData = {
      'idUser': authUserData['id'].toString(),
      'cityDepartureTrip': _departureCity,
      'departureAirportTrip': _departureAirport,
      'dateDepartureTrip': _departureDate,
      'timeDepartureTrip': _departureTime,
      'cityArrivalTrip': _arrivalCity,
      'arrivalAirportTrip': _arrivalAirport,
      'dateArrivalTrip': _arrivalDate,
      'timeArrivalTrip': _arrivalTime,
      'offeredKilosTrip': _offeredKilos,
      'offeredKilosPriceTrip': _offeredKolosPrice.text.toString(),
      'parcelDescription': _parcelDescription.text.toString(),
      'flightNumber': _flightNumber.text.toString(),
    };

    var response = await httpService.postData("saveTrip", postData);
    if (response['success']) {
      cleanLoader();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SaveTripSuccessWidget(),
        ),
      );
    } else {
      cleanLoader();
      setState(() {
        responseMessage = response['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => prevStep(),
        child: Scaffold(
          body: Stack(
            children: [
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 68.0),
                    child: Text(
                      titleData[step].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                onTap: () => prevStep(),
                                child: Container(
                                  width: 60.0,
                                  height: 40.0,
                                  child: Row(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          color: Color(0xFFD9D9D9),
                                        ),
                                      ),
                                      Text(
                                        "Back",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 24.0,
                                backgroundColor: Colors.white10,
                                child: CircleAvatar(
                                  radius: 19.0,
                                  backgroundColor: Colors.white12,
                                  child: Text(
                                    step.toString() +
                                        '/' +
                                        (titleData.length - 1).toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 60.0),
                          child: Card(
                            elevation: Style.cardElevation,
                            shape: Style.shapeCard,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 32.0,
                                  left: 10.0,
                                  right: 10.0,
                                  bottom: 40.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: step == 1
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                addflightNumberField = true;

                                                nextStep();
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Palette.primaryColor,
                                                  width: 2.0,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                color: Color(0xFFEFF0F1),
                                              ),
                                              height: 95.0,
                                              child: Center(
                                                child: Text(
                                                  "Only accept parcels from \n senders on the same flight you\n are",
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15.0,
                                          ),
                                          Text(
                                            "Or",
                                            style: TextStyle(
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold,
                                              color: Palette.primaryColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15.0,
                                          ),
                                          InkWell(
                                            onTap: () => nextStep(),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Palette.primaryColor,
                                                  width: 2.0,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                color: Color(0xFFEFF0F1),
                                              ),
                                              height: 95.0,
                                              child: Center(
                                                child: Text(
                                                  "Parcels from Any  LuggIn\n Sender",
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : step == 2
                                        ? buildDepartureInfoWidget(context)
                                        : step == 3
                                            ? buildGoingInfoWidget(context)
                                            : step == 4
                                                ? buildDepartureTimeInfoWidget(
                                                    context)
                                                : step == 5
                                                    ? buildArrivingTimeInfoWidget(
                                                        context)
                                                    : step == 6
                                                        ? buildOfferKilosInfoWidget()
                                                        : step == 7
                                                            ? buildPreviewWidget(
                                                                context)
                                                            : step == 8
                                                                ? buildDescriptionPostWidget(
                                                                    context)
                                                                : null,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60.0,
                        ),
                        Container(
                          child: (step != 8 && step != 1 && step != 7)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () => nextStep(),
                                      child: CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: Palette.primaryColor,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : null,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDepartureInfoWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        buildErrMessage(context),
        InkWell(
          onTap: () async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CityListPage(),
              ),
            );
            setState(() {
              if (result != null) {
                _currentCity = result['name'];
                _departureCity = result['name'];
                _departureAirport = null;
              }
            });
          },
          child: Container(
            decoration: Style.inputBoxDecorationLg,
            height: Style.inputHeight,
            child: Center(
              child: Text(
                _departureCity != null
                    ? _departureCity
                    : "Enter your city of departure*",
                style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 35.0,
        ),
        Container(
          child: _departureCity != null
              ? InkWell(
                  onTap: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AirportListPage(
                          city: _currentCity,
                        ),
                      ),
                    );
                    setState(() {
                      if (result != null) {
                        _departureAirport = result['name'];
                      }
                    });
                  },
                  child: Container(
                    decoration: Style.inputBoxDecorationLg,
                    height: Style.inputHeight,
                    child: Center(
                      child: Text(
                        _departureAirport != null
                            ? _departureAirport
                            : "Enter departure Airport*",
                        style: TextStyle(
                            fontSize: 18.0, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ],
    );
  }

  Widget buildGoingInfoWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        buildErrMessage(context),
        InkWell(
          onTap: () async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CityListPage(),
              ),
            );
            setState(() {
              if (result != null) {
                _currentCity = result['name'];
                _arrivalCity = result['name'];
                _arrivalAirport = null;
              }
            });
          },
          child: Container(
            decoration: Style.inputBoxDecorationLg,
            height: Style.inputHeight,
            child: Center(
              child: Text(
                _arrivalCity != null
                    ? _arrivalCity
                    : "Enter your city of arrival*",
                style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 35.0,
        ),
        Container(
          child: _arrivalCity != null
              ? InkWell(
                  onTap: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AirportListPage(
                          city: _currentCity,
                        ),
                      ),
                    );
                    setState(() {
                      if (result != null) {
                        _arrivalAirport = result['name'];
                      }
                    });
                  },
                  child: Container(
                    decoration: Style.inputBoxDecorationLg,
                    height: Style.inputHeight,
                    child: Center(
                      child: Text(
                        _arrivalAirport != null
                            ? _arrivalAirport
                            : "Enter arrival Airport*",
                        style: TextStyle(
                            fontSize: 18.0, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ],
    );
  }

  Widget buildDepartureTimeInfoWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        buildErrMessage(context),
        InkWell(
          onTap: () => _pickDate(context, 'departure'),
          child: Container(
            decoration: Style.inputBoxDecorationLg,
            height: Style.inputHeight,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Center(
                child: Text(
                  _departureDate != null
                      ? _departureDate
                      : "Enter date of departure*",
                  style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 35.0,
        ),
        if (_departureDate != null) ...[
          Container(
            child: InkWell(
              onTap: () => _pickTime(context, 'departure'),
              child: Container(
                decoration: Style.inputBoxDecorationLg,
                height: Style.inputHeight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Center(
                    child: Text(
                      _departureTime != null
                          ? _departureTime
                          : "Enter time of departure*",
                      style: TextStyle(
                          fontSize: 18.0, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        if (_departureDate != null && addflightNumberField == true) ...[
          SizedBox(
            height: 35.0,
          ),
          Container(
            decoration: Style.inputBoxDecorationLg,
            height: Style.inputHeight,
            child: Center(
              child: TextField(
                controller: _flightNumber,
                style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 12.0),
                  hintText: 'flight Number*',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget buildArrivingTimeInfoWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        buildErrMessage(context),
        InkWell(
          onTap: () => _pickDate(context, 'arrival'),
          child: Container(
            decoration: Style.inputBoxDecorationLg,
            height: Style.inputHeight,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Center(
                child: Text(
                  _arrivalDate != null
                      ? _arrivalDate
                      : "Enter date of arrival*",
                  style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 35.0,
        ),
        Container(
          child: _arrivalDate != null
              ? InkWell(
                  onTap: () => _pickTime(context, 'arrival'),
                  child: Container(
                    decoration: Style.inputBoxDecorationLg,
                    height: Style.inputHeight,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Center(
                        child: Text(
                          _arrivalTime != null
                              ? _arrivalTime
                              : "Enter Time of arrival*",
                          style: TextStyle(
                              fontSize: 18.0, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ],
    );
  }

  Widget buildOfferKilosInfoWidget() {
    return Column(
      children: <Widget>[
        Container(
          decoration: Style.inputBoxDecorationLg,
          height: Style.inputHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                onTap: () => _removeKilos(),
                child: Icon(
                  Icons.remove_circle,
                  color: Colors.black.withOpacity(0.5),
                  size: 30.0,
                ),
              ),
              Text(
                _offeredKilos.toString(),
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () => _addKilos(),
                child: Icon(
                  Icons.add_circle,
                  color: Colors.black.withOpacity(0.5),
                  size: 30.0,
                ),
              )
            ],
          ),
        ),
        Container(
          height: 80.0,
          child: Center(
            child: Text(
              "This is our suggested price",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
        ),
        Container(
          decoration: Style.inputBoxDecorationLg,
          height: Style.inputHeight,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _offeredKolosPrice,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'price*',
                    contentPadding: EdgeInsets.only(top: 0.0),
                    border: InputBorder.none,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "€",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPreviewWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 18,
                    height: 18,
                    decoration: new BoxDecoration(
                      color: Palette.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(""),
                  ),
                  Container(
                    width: 3,
                    height: 100,
                    decoration: new BoxDecoration(
                      color: Palette.primaryColor,
                      shape: BoxShape.rectangle,
                    ),
                    child: Text(""),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _offeredKilos.toString() + "kilos",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            _offeredKolosPrice.text.toString() + "€",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      InkWell(
                        onTap: () => setStep(6),
                        child: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: Colors.white.withOpacity(0.5),
                          child: Icon(
                            Icons.create,
                            size: 20.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 30,
                    decoration: new BoxDecoration(
                      color: Palette.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.flight_takeoff,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                  ),
                  Container(
                    width: 3,
                    height: 100,
                    decoration: new BoxDecoration(
                      color: Palette.primaryColor,
                      shape: BoxShape.rectangle,
                    ),
                    child: Text(""),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    children: <Widget>[
                      Text(
                        _departureCity +
                            " \n" +
                            _departureDate +
                            " at " +
                            _departureTime,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      InkWell(
                        onTap: () => setStep(2),
                        child: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: Colors.white.withOpacity(0.5),
                          child: Icon(
                            Icons.create,
                            size: 20.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 30,
                    decoration: new BoxDecoration(
                      color: Palette.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.flight_land,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                  ),
                  Container(
                    width: 3,
                    height: 100,
                    decoration: new BoxDecoration(
                      color: Palette.primaryColor,
                      shape: BoxShape.rectangle,
                    ),
                    child: Text(""),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    children: <Widget>[
                      Text(
                        _arrivalCity +
                            "\n" +
                            _arrivalDate +
                            " at " +
                            _arrivalTime,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      InkWell(
                        onTap: () => setStep(3),
                        child: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: Colors.white.withOpacity(0.5),
                          child: Icon(
                            Icons.create,
                            size: 20.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () => nextStep(),
          child: CircleAvatar(
            radius: 25.0,
            backgroundColor: Palette.primaryColor,
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget buildDescriptionPostWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        buildErrMessage(context),
        Container(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFEFF0F1),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: TextField(
              controller: _parcelDescription,
              maxLines: 5,
              style: TextStyle(
                fontSize: 18.0,
                fontStyle: FontStyle.italic,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                hintText:
                    'Enter information to be added for the journey, place and time of appointments, packages accepted (type, details or whole package etc.) delivery terms  and conditions',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        InkWell(
          onTap: () => !isLoard ? _saveTrip() : null,
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(100.0),
            ),
            child: Container(
              color: Palette.primaryColor,
              width: 120.0,
              height: 50.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    !isLoard ? "Post the trip" : "Please wait...",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildErrMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
      child: Text(
        responseMessage,
        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class SaveTripSuccessWidget extends StatefulWidget {
  @override
  _SaveTripSuccessWidgetState createState() => _SaveTripSuccessWidgetState();
}

class _SaveTripSuccessWidgetState extends State<SaveTripSuccessWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: null,
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Container(
                height: 200.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      "do not accept closed packages, always check the contents",
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
                          "Your Trip is online \n Congratulations",
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
      ),
    );
  }
}
