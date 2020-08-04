import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/config/style.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/pages/airport_list_page.dart';
import 'package:luggin/pages/city_list_page.dart';
import 'package:luggin/screens/tabs_screen.dart';
import 'package:luggin/services/preferences_service.dart';
import 'package:luggin/services/http_service.dart';

class SendParcelPage extends StatefulWidget {
  @override
  _SendParcelPageState createState() => _SendParcelPageState();
}

class _SendParcelPageState extends State<SendParcelPage> {
  String apiUrl = AppEvironement.apiUrl;
  var authUserData;
  bool isLoard = false;
  bool addflightNumberField = false;

  var _currentCity;
  String _departureCity;
  String _departureAirport;
  String _departureDate;
  String _arrivalCity;
  String _arrivalAirport;
  int _weightParcel = 4;
  TextEditingController _recipientParcelName;
  TextEditingController _recipientParcelAddress;
  TextEditingController _recipientParcelPhoneNumber;
  TextEditingController _parcelDescription;
  TextEditingController _flightNumber;

  String responseMessage = '';

  int step = 1;
  DateTime pickedDate;
  String selectedContryCode;

  HttpService httpService = HttpService();

  var titleData = [
    '',
    'Choose option 1 or option 2',
    'Where does the parcel comes from?',
    'What is the shipping city?',
    'Desired date of shipment?',
    'How many kilos do you need?',
    'Recipient information',
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

  nextStep() {
    cleanMessage();

    if (step == 2) {
      if (addflightNumberField == true && _flightNumber.text.isEmpty) {
        setMessage("Flight number is required");
        return;
      }

      if (_departureCity == null || _departureAirport == null) {
        setMessage("Required fields");
        return;
      }
    }

    if (step == 3) {
      if (_arrivalCity == null || _arrivalAirport == null) {
        setMessage("Required fields");
        return;
      }
      if (_arrivalCity == _departureCity) {
        setMessage("Arrival city must be different from the departure city");
        return;
      }
    }

    if (step == 4) {
      if (_departureDate == null) {
        setMessage("Departure date is required");
        return;
      }
    }

    if (step == 6) {
      if (_recipientParcelName.text.isEmpty ||
          _recipientParcelPhoneNumber.text.isEmpty) {
        setMessage("Name and phone number required");
        return;
      }

      // if (!_phoneNumberIsValid(_recipientParcelPhoneNumber.text)) {
      //   setMessage("Enter valid phone number");
      //   return;
      // }
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

  _addKilos() {
    setState(() {
      _weightParcel = _weightParcel + 1;
    });
  }

  _removeKilos() {
    setState(() {
      if (_weightParcel > 1) {
        _weightParcel = _weightParcel - 1;
      }
    });
  }

  setStep(mystep) {
    setState(() {
      step = mystep;
    });
  }

  //Methode pour valider l'adresse email
  // bool _phoneNumberIsValid(input) {
  //   bool phoneNumber = RegExp(r'(^(?:[+0]9)?[0-9]{8,15}$)').hasMatch(input);

  //   return phoneNumber;
  // }

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedContryCode = '1';
    });
    _recipientParcelName = TextEditingController();
    _recipientParcelPhoneNumber = TextEditingController();
    _recipientParcelAddress = TextEditingController();
    _parcelDescription = TextEditingController();
    _flightNumber = TextEditingController();

    getPreferencesData();
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
      });
    }
  }

  _saveExpedition() async {
    if (_parcelDescription.text.isEmpty) {
      setMessage("Please Add description");
      return;
    }

    setLoarder();
    var postData = {
      'idUser': authUserData['id'].toString(),
      'cityDepartureParcel': _departureCity,
      'dateDepartureParcel': _departureDate,
      'departureAirportParcel': _departureAirport,
      'cityArrivalParcel': _arrivalCity,
      'arrivalAirportParcel': _arrivalAirport,
      'weightParcel': _weightParcel,
      'parcelDescription': _parcelDescription.text,
      'recipientParcelName': _recipientParcelName.text,
      'recipientParcelAddress': _recipientParcelAddress.text,
      'recipientParcelPhoneNumber': addflightNumberField != null
          ? _recipientParcelPhoneNumber.text
          : authUserData['phoneNumber'],
      'flightNumber': _flightNumber.text.toString(),
    };

    var response = await httpService.postData("saveExpedition", postData);
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
                                                _recipientParcelName.text =
                                                    authUserData['firstName'] +
                                                        ' ' +
                                                        authUserData['surName'];
                                                _recipientParcelPhoneNumber
                                                        .text =
                                                    authUserData['phoneNumber'];
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
                                        ? buildDepartureInfoWidget()
                                        : step == 3
                                            ? buildGoingInfoWidget()
                                            : step == 4
                                                ? buildDepartureTimeInfoWidget(
                                                    context)
                                                : step == 5
                                                    ? buildOfferKilosInfoWidget()
                                                    : step == 6
                                                        ? buildRecipientInfoWidget()
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

  Widget buildDepartureInfoWidget() {
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
                    : "Enter  city of origin*",
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
        if (addflightNumberField == true && _departureAirport != null) ...[
          SizedBox(
            height: 35.0,
          ),
          Container(
            decoration: Style.inputBoxDecorationLg,
            height: Style.inputHeight,
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
          SizedBox(
            height: 15.0,
          ),
        ],
      ],
    );
  }

  Widget buildGoingInfoWidget() {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            "What is the shipping city ?",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
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
                _arrivalCity != null ? _arrivalCity : "Enter delivery city*",
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
                      : "Enter date of  shipment*",
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
      ],
    );
  }

  Widget buildOfferKilosInfoWidget() {
    return Column(
      children: <Widget>[
        buildErrMessage(context),
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
                _weightParcel.toString(),
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
      ],
    );
  }

  Widget buildRecipientInfoWidget() {
    return Column(
      children: <Widget>[
        buildErrMessage(context),
        Container(
          decoration: Style.inputBoxDecorationLg,
          height: Style.inputHeight,
          child: TextField(
            controller: _recipientParcelName,
            style: TextStyle(
              fontSize: 18.0,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 12.0),
              hintText: 'Enter the name of recipient*',
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(
          height: 35.0,
        ),
        Container(
          decoration: Style.inputBoxDecorationLg,
          height: Style.inputHeight,
          child: Row(
            children: <Widget>[
              if (addflightNumberField == false) ...[
                Container(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "+237",
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black38,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              Expanded(
                child: TextField(
                  controller: _recipientParcelPhoneNumber,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 12.0),
                    hintText: 'Enter phone number *',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 35.0,
        ),
        Container(
          decoration: Style.inputBoxDecorationLg,
          height: Style.inputHeight,
          child: TextField(
            controller: _recipientParcelAddress,
            style: TextStyle(
              fontSize: 18.0,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 12.0),
              hintText: 'Enter address of recipient',
              border: InputBorder.none,
            ),
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
                      Text(
                        _weightParcel.toString() + "kilos",
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
                        onTap: () => setStep(5),
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
                  Row(
                    children: <Widget>[
                      Text(
                        _departureCity +
                            " \n" +
                            _departureDate +
                            " at " +
                            _departureDate,
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
                  Row(
                    children: <Widget>[
                      Text(
                        _arrivalCity,
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
                    'Add description of your goods, additional destination info, picture of the parcel*',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        InkWell(
          onTap: () => !isLoard ? _saveExpedition() : null,
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
                    !isLoard ? "Post request" : "please wait...",
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
                          "Your Request is online \n Congratulations",
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
