import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:luggin/screens/auth/login/login_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:luggin/config/style.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/screens/tabs_screen.dart';
import 'package:luggin/services/preferences_service.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/services/http_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:luggin/pages/contry_list_page.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool termsIsAgree = false;

  bool isLoard = false;
  String responseMessage = '';
  int currentstape = 1;
  String _selectedContryCode;
  String apiUrl = AppEvironement.apiUrl;
  double activeHiegth = 10.0;

  final HttpService httService = HttpService();

  String verificationId;
  String smsCode;
  String phoneNo;

  TextEditingController _emailController;
  TextEditingController _firstNameController;
  TextEditingController _surNameController;
  TextEditingController _dateBirthdayController;
  TextEditingController _phoneNumberController;
  TextEditingController _cityController;
  TextEditingController _pseudoController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;
  TextEditingController _emailIsVerified;
  TextEditingController _phoneNumberIsVerified;
  TextEditingController _contryController;

  DateTime pickedDate;
  String _currentPageTitle;
  bool showPassWord = false;
  bool hasError = false;
  var currentContryData;
  HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _firstNameController = TextEditingController();
    _surNameController = TextEditingController();
    _dateBirthdayController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _cityController = TextEditingController();
    _pseudoController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _emailIsVerified = TextEditingController();
    _phoneNumberIsVerified = TextEditingController();
    _contryController = TextEditingController();

    pickedDate = new DateTime(
        DateTime.now().year - 17, DateTime.january, DateTime.monday);

    setState(() {
      _selectedContryCode = "+1";
      _currentPageTitle = "personal-information";
    });
  }

  _pickDate(context) async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 80),
      lastDate: pickedDate,
      initialDate: pickedDate,
    );

    if (date != null) {
      _dateBirthdayController.text = date.month.toString().padLeft(2, '0') +
          '/' +
          date.day.toString().padLeft(2, '0') +
          '/' +
          date.year.toString();
    }
  }

  startLoarder() {
    setState(() {
      isLoard = true;
    });
  }

  stopLoarder() {
    setState(() {
      isLoard = false;
    });
  }

  setPageTitle(int stepe) {
    setState(() {
      if (stepe == 1) {
        this._currentPageTitle = "personal-information";
      }

      if (stepe == 2) {
        this._currentPageTitle = "account-information";
      }

      if (stepe == 3) {
        this._currentPageTitle = "terms-title";
      }

      if (stepe == 4) {
        this._currentPageTitle = "phone-email-validate-msg";
      }
    });
  }

  setResponseMessage(message) {
    setState(() {
      responseMessage = message;
    });
  }

  clearResponseMessage() {
    setState(() {
      responseMessage = '';
    });
  }

  nextStep() async {
    startLoarder();
    clearResponseMessage();
    validateDataStepe(currentstape);
    print(currentstape);
  }

  validateDataStepe(stepe) async {
    if (stepe == 1) {
      if (_emailController.text.isEmpty ||
          _firstNameController.text.isEmpty ||
          _surNameController.text.isEmpty ||
          _dateBirthdayController.text.isEmpty ||
          _contryController.text.isEmpty ||
          _cityController.text.isEmpty) {
        setResponseMessage("required-input");
        stopLoarder();
        return;
      }

      if (!_validateEmail(_emailController.text)) {
        setResponseMessage("email-invalid");
        stopLoarder();
        return;
      }

      if (await emailExitEmail(_emailController.text) == true) {
        setResponseMessage("email-is-use");
        stopLoarder();
        return;
      }

      if (_phoneNumberController.text.isNotEmpty) {
        if (!_phoneNumberIsValid(_phoneNumberController.text)) {
          setResponseMessage("phoneNumber-invalid");
          stopLoarder();
          return;
        }
      }

      if (await phoneNumberExit(
              _selectedContryCode + _phoneNumberController.text) ==
          true) {
        setResponseMessage("phone-number-is-use");
        stopLoarder();
        return;
      }

      this.phoneNo = _selectedContryCode + _phoneNumberController.text;
    }

    if (stepe == 2) {
      if (_pseudoController.text.isEmpty || _passwordController.text.isEmpty) {
        setResponseMessage("required-input");
        stopLoarder();
        return;
      }

      if (!_validatePassword(_passwordController.text)) {
        setResponseMessage("password-invalid-length");
        stopLoarder();
        return;
      }

      if (await isSameValue(
              _passwordController.text, _confirmPasswordController.text) !=
          true) {
        setResponseMessage("password-match-invalid");
        stopLoarder();
        return;
      }

      if (await pseudoExit(_pseudoController.text) == true) {
        setResponseMessage("taken-pseudo");
        stopLoarder();
        return;
      }
    }

    if (stepe == 3) {
      if (termsIsAgree == false) {
        setResponseMessage("agree-terms-invalid");
        stopLoarder();
        return;
      }
    }

    if (stepe == 4) {
      return;
    }

    if (currentstape < 4) {
      setState(() {
        currentstape = currentstape + 1;
        stopLoarder();
        setPageTitle(currentstape);
      });
    }
  }

  prevStepe() {
    clearResponseMessage();
    if (currentstape > 1) {
      setState(() {
        currentstape = currentstape - 1;
        setPageTitle(currentstape);
        stopLoarder();
      });
      return;
    }
    if (currentstape == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  signIn() async {
    var postData = {
      'pseudo': _pseudoController.text,
      'password': _passwordController.text
    };

    if (_passwordController.text.isNotEmpty &&
        _pseudoController.text.isNotEmpty) {
      httService.postData("login", postData).then((result) {
        if (result['success']) {
          signOutFireBase(); //REMOVE THIS LINE IF
          PreferenceStorage.saveDataToPreferences(
              'USERDATA', json.encode(result['data']));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CreateAccountSuccessWidget(),
            ),
          );
        } else {
          setResponseMessage(result['message']);
          stopLoarder();
        }
      });
    } else {
      setResponseMessage("required-input");
      stopLoarder();
      return;
    }
  }

  _register() async {
    startLoarder();
    clearResponseMessage();

    var postData = {
      'email': _emailController.text,
      'firstName': _firstNameController.text,
      'surName': _surNameController.text,
      'dateOfBirthDay': _dateBirthdayController.text,
      'phoneNumber': _phoneNumberController.text.isNotEmpty
          ? _selectedContryCode + _phoneNumberController.text
          : null,
      'contry': _contryController.text,
      'city': _cityController.text,
      'pseudo': _pseudoController.text,
      'password': _passwordController.text,
      'email_isVerified': _emailIsVerified.text,
      'phoneNumber_isVerified': _phoneNumberIsVerified.text,
    };

    print(postData);

    httService.postData("register", postData).then(
      (result) {
        if (result['success']) {
          print("000");
          signIn();
        } else {
          setResponseMessage(result['message']);
          stopLoarder();
        }
      },
    );
  }

  Future<bool> emailExitEmail(email) async {
    var response = await httService.postData('checkEmail', {'email': email});
    if (response > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> phoneNumberExit(phoneNumbre) async {
    var response = await httpService.postData(
      'checkPhoneNumber',
      {'phoneNumber': phoneNumbre},
    );

    if (response > 0) {
      return true;
    } else {
      return false;
    }
  }

  //Methode pour valider l'adresse email
  bool _validateEmail(email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    return emailValid;
  }

  //Methode pour valider l'adresse email
  bool _phoneNumberIsValid(input) {
    bool phoneNumber = RegExp(r'(^(?:[+0]9)?[0-9]{8,15}$)').hasMatch(input);

    return phoneNumber;
  }

  bool _validatePassword(password) {
    var passWordValid = password.length;
    if (passWordValid > 5) {
      return true;
    }
    return false;
  }

  pseudoExit(pseudo) async {
    var response = await httService.postData('checkPseudo', {'pseudo': pseudo});
    if (response > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isSameValue(value1, value2) async {
    if (value1 == value2) {
      return true;
    } else {
      return false;
    }
  }

  _sendVerificationCodeEmail(modalIsOpen, setState) async {
    setState(() {
      isLoard = true;
      responseMessage = '';
    });

    var postData = {
      'email': _emailController.text.toString(),
    };

    print(postData);
    var response =
        await httService.postData("sendVerificationCodeEmail", postData);
    if (response['success']) {
      setState(() {
        isLoard = false;
      });
      if (modalIsOpen == "false") {
        _verificationCodeModal(context, "email");
      }
    } else {
      setState(() {
        isLoard = false;
      });
    }
  }

  _checkVerificationCodeEmail(setState) async {
    setState(() {
      isLoard = true;
      hasError = false;
    });
    var postData = {
      'email': _emailController.text,
      'code': this.smsCode,
    };

    var response =
        await httpService.postData("checkVerificationEmailCode", postData);
    if (response > 0) {
      setState(() {
        _emailIsVerified.text = 'true';
        _phoneNumberIsVerified.text = 'false';
        _register();
      });
    } else {
      setState(() {
        responseMessage = "code-invalid";
        isLoard = false;
        hasError = true;
      });
    }
  }

  _checkVerificationCodeFirebase(setState) async {
    FirebaseAuth.instance.currentUser().then((user) {
      signInFireBaseSms(setState);

      //REMOVE IF ERROR*********/
      if (user != null) {
        _register();
      } else {
        signInFireBaseSms(setState);
      }
      //********************** */
    });
  }

  signInFireBaseSms(setState) async {
    setState(() {
      isLoard = true;
    });
    final AuthCredential authCredential = PhoneAuthProvider.getCredential(
      verificationId: this.verificationId,
      smsCode: this.smsCode,
    );

    await FirebaseAuth.instance
        .signInWithCredential(authCredential)
        .then((user) {
      setState(() {
        _emailIsVerified.text = 'false';
        _phoneNumberIsVerified.text = 'false';
      });
      _register();
    }).catchError((onError) {
      setState(() {
        this.isLoard = false;
        setResponseMessage("code-invalid");
      });
    });
  }

  signOutFireBase() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _verifyCodeSmsFirebase(setState, isOpen) async {
    setState(() {
      isLoard = true;
      responseMessage = "";
    });

    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      setState(() {
        isLoard = false;
        responseMessage = "";
      });
      if (isOpen == "false") {
        _verificationCodeModal(context, 'phoneNumber');
      }
    };

    final PhoneVerificationCompleted verifiedSuccess = (user) {
      Fluttertoast.showToast(
        msg: "automatic verification ok".tr(),
        backgroundColor: Colors.white24,
      );
      setState(() {
        isLoard = true;
        _phoneNumberIsVerified.text = 'true';
        _emailIsVerified.text = 'false';
        _register();
      });
    };

    final PhoneVerificationFailed verifiFailed = (AuthException exception) {
      if (isOpen == "false") {
        setState(() {
          isLoard = false;
          responseMessage = "code-invalid";
        });
        _verificationCodeModal(context, 'phoneNumber');
      }
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: this.phoneNo,
      timeout: const Duration(seconds: 10),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifiFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  _verificationCodeModal(context, type) {
    setState(() {
      responseMessage = "";
      isLoard = false;
    });
    showModalBottomSheet(
      backgroundColor: Palette.primaryColor,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height - 110.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: type == 'phoneNumber'
                          ? Text(
                              "verification-code-send-msg".tr() +
                                  _selectedContryCode +
                                  _phoneNumberController.text +
                                  "enter-verification-code-msg".tr(),
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "verification-code-send-msg".tr() +
                                  _emailController.text +
                                  "enter-verification-code-msg".tr(),
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    SizedBox(
                      height: 38.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: PinCodeTextField(
                        backgroundColor: Colors.transparent,
                        textInputType: TextInputType.number,
                        length: 6,
                        obsecureText: false,
                        animationType: AnimationType.fade,
                        validator: (v) {
                          if (v.length < 3) {
                            return "I'm from validator";
                          } else {
                            return null;
                          }
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          inactiveFillColor: Colors.white12,
                          inactiveColor: Colors.white12,
                          activeFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          borderWidth: 0.3,
                        ),
                        animationDuration: Duration(milliseconds: 300),
                        enableActiveFill: true,
                        onCompleted: (code) {
                          if (type == 'phoneNumber') {
                            _checkVerificationCodeFirebase(setState);
                          } else {
                            _checkVerificationCodeEmail(setState);
                          }
                        },
                        onChanged: (value) {
                          this.smsCode = value;
                          if (value == '') {
                            setState(() {
                              responseMessage = '';
                              isLoard = false;
                            });
                          }
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    isLoard
                        ? Container(
                            height: 30.0,
                            width: 30.0,
                            child: CircularProgressIndicator(),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: responseMessage != ''
                                  ? Colors.white12
                                  : Colors.transparent,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    responseMessage,
                                    style: TextStyle(
                                      color: Color(0xFFFFA618),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 35.0,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "code-not-received".tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'resend-code-in'.tr() + " 10s",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isLoard = false;
                            Navigator.of(context).pop();
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => prevStepe(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: <Widget>[
              Container(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 120.0,
                            color: Palette.primaryColor,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () => prevStepe(),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Container(
                                          width: 50.0,
                                          height: 30.0,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  _currentPageTitle.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 90.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              child: Container(
                                color: Colors.white,
                                child: currentstape == 1
                                    ? personnalInfoWidget()
                                    : currentstape == 2
                                        ? accountInfoWidget()
                                        : currentstape == 3
                                            ? buildTermAndCondition()
                                            : currentstape == 4
                                                ? buildVerivicationMode()
                                                : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget personnalInfoWidget() => Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 2.0,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      color: Color(0xFF3C5A99),
                      height: 40.0,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "register-facebook".tr(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.black45,
                          ),
                        ),
                        Text(
                          "OR",
                          style: TextStyle(color: Colors.black45),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (responseMessage != '') ...[
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Center(
                            child: Text(
                          responseMessage.tr(),
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ),
                    ),
                  ],
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 46.0,
                    decoration: Style.inputBoxDecorationLg,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: _emailController,
                        style: Style.textStyleInputLg,
                        decoration: InputDecoration(
                          hintText: 'email-input'.tr() + "*",
                          icon: CircleAvatar(
                            radius: 18.0,
                            backgroundColor: Palette.primaryColor,
                            child: Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 46.0,
                    decoration: Style.inputBoxDecorationLg,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: _firstNameController,
                        style: Style.textStyleInputLg,
                        decoration: InputDecoration(
                          hintText: 'first-name-input'.tr() + "*",
                          icon: CircleAvatar(
                            radius: 18.0,
                            backgroundColor: Palette.primaryColor,
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 46.0,
                    decoration: Style.inputBoxDecorationLg,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: _surNameController,
                        style: Style.textStyleInputLg,
                        decoration: InputDecoration(
                          hintText: 'last-name-input'.tr() + "*",
                          icon: CircleAvatar(
                            radius: 18.0,
                            backgroundColor: Palette.primaryColor,
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  InkWell(
                    onTap: () => _pickDate(context),
                    child: Container(
                      height: 46.0,
                      decoration: Style.inputBoxDecorationLg,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          controller: _dateBirthdayController,
                          enabled: false,
                          style: Style.textStyleInputLg,
                          decoration: InputDecoration(
                            hintText: 'date-of-birth-input'.tr() + "*",
                            icon: CircleAvatar(
                              radius: 18.0,
                              backgroundColor: Palette.primaryColor,
                              child: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  InkWell(
                    onTap: () async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContryListPage(),
                        ),
                      );
                      setState(() {
                        if (result != null) {
                          _contryController.text = result['name'];
                          currentContryData = result;
                          _selectedContryCode = result['dial_code'];
                        }
                      });
                    },
                    child: Container(
                      height: 46.0,
                      decoration: Style.inputBoxDecorationLg,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          controller: _contryController,
                          style: Style.textStyleInputLg,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: 'country-of-residence-input'.tr() + "*",
                            icon: CircleAvatar(
                              radius: 18.0,
                              backgroundColor: Palette.primaryColor,
                              child: Icon(
                                Icons.pin_drop,
                                color: Colors.white,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 46.0,
                    decoration: Style.inputBoxDecorationLg,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: _cityController,
                        style: Style.textStyleInputLg,
                        decoration: InputDecoration(
                          hintText: 'city-of-residence-input'.tr() + "*",
                          icon: CircleAvatar(
                            radius: 18.0,
                            backgroundColor: Palette.primaryColor,
                            child: Icon(
                              Icons.pin_drop,
                              color: Colors.white,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  if (currentContryData != null)
                    Container(
                      height: 46.0,
                      decoration: Style.inputBoxDecorationLg,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 18.0,
                              backgroundColor: Palette.primaryColor,
                              child: Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              child: InkWell(
                                onTap: () async {
                                  var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ContryListPage(),
                                    ),
                                  );

                                  setState(() {
                                    if (result != null) {
                                      currentContryData = result;
                                      _selectedContryCode =
                                          result['callingCode'];
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        _selectedContryCode != null
                                            ? _selectedContryCode.toString()
                                            : "Code",
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
                            Expanded(
                              child: TextField(
                                controller: _phoneNumberController,
                                keyboardType: TextInputType.phone,
                                style: Style.textStyleInputLg,
                                decoration: InputDecoration(
                                  hintText: 'phone-number-input'.tr(),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Palette.primaryColor,
                            radius: 15.0,
                            child: Text(
                              "1",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black12,
                            radius: 10.0,
                            child: Text(
                              "2",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black12,
                            radius: 10.0,
                            child: Text(
                              "3",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black12,
                            radius: 10.0,
                            child: Text(
                              "4",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => !isLoard ? nextStep() : null,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFF2288B9),
                      child: !isLoard
                          ? Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            )
                          : CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              ),
              child: Text(
                'sign-in'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Palette.primaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      );

  Widget accountInfoWidget() => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Center(
                        child: Text(
                      responseMessage.tr(),
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  height: 46.0,
                  decoration: Style.inputBoxDecorationLg,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                      controller: _pseudoController,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.italic,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Pseudo*',
                        icon: CircleAvatar(
                          backgroundColor: Palette.primaryColor,
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: 46.0,
                  decoration: Style.inputBoxDecorationLg,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _passwordController,
                            obscureText: !showPassWord ? true : false,
                            decoration: InputDecoration(
                              hintText: 'password-input'.tr(),
                              icon: CircleAvatar(
                                backgroundColor: Palette.primaryColor,
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                bottom: 13.0,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (!this.showPassWord) {
                              setState(() {
                                this.showPassWord = true;
                              });
                            } else {
                              setState(() {
                                this.showPassWord = false;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 3.0,
                            ),
                            child: Icon(
                              !showPassWord
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black.withOpacity(
                                0.3,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: 46.0,
                  decoration: Style.inputBoxDecorationLg,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _confirmPasswordController,
                            obscureText: !showPassWord ? true : false,
                            decoration: InputDecoration(
                              hintText: 're-enter-password-input'.tr(),
                              icon: CircleAvatar(
                                backgroundColor: Palette.primaryColor,
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                bottom: 13.0,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (!this.showPassWord) {
                              setState(() {
                                this.showPassWord = true;
                              });
                            } else {
                              setState(() {
                                this.showPassWord = false;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 3.0,
                            ),
                            child: Icon(
                              !showPassWord
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black.withOpacity(
                                0.3,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    currentstape = 1;
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor: Palette.primaryColor,
                                  radius: 10.0,
                                  child: Text(
                                    "1",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Palette.primaryColor,
                                radius: 15.0,
                                child: Text(
                                  "2",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.black12,
                                radius: 10.0,
                                child: Text(
                                  "3",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.black12,
                                radius: 10.0,
                                child: Text(
                                  "4",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => !isLoard ? nextStep() : null,
                        child: CircleAvatar(
                          backgroundColor: Color(0xFF2288B9),
                          child: !isLoard
                              ? Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                )
                              : CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      );

  Widget buildTermAndCondition() {
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
                    child: Center(
                        child: Text(
                      responseMessage.tr(),
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ),
                Text(
                  "terms-msg".tr(),
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                InkWell(
                  onTap: () {
                    if (termsIsAgree == false) {
                      setState(() {
                        termsIsAgree = true;
                      });
                    } else {
                      setState(() {
                        termsIsAgree = false;
                      });
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: termsIsAgree ? Colors.white : Colors.black12,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          color: termsIsAgree ? Colors.green : null,
                        ),
                        child: termsIsAgree
                            ? Center(
                                child: Icon(
                                  Icons.done,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "terms-greement-text".tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              currentstape = 1;
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: Palette.primaryColor,
                            radius: 10.0,
                            child: Text(
                              "1",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              currentstape = 2;
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: Palette.primaryColor,
                            radius: 10.0,
                            child: Text(
                              "2",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Palette.primaryColor,
                          radius: 15.0,
                          child: Text(
                            "3",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.black12,
                          radius: 10.0,
                          child: Text(
                            "4",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => !isLoard ? nextStep() : null,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF2288B9),
                    child: !isLoard
                        ? Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          )
                        : CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildVerivicationMode() {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: _phoneNumberController.text.isNotEmpty
                ? Text(
                    "security-reasons-msg".tr(),
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    "security-reasons-msg2".tr(),
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_phoneNumberController.text.isNotEmpty)
                RaisedButton.icon(
                  onPressed: () => _verifyCodeSmsFirebase(setState, "false"),
                  disabledColor: Palette.primaryColor,
                  color: Palette.primaryColor,
                  icon: Row(
                    children: <Widget>[
                      Transform.rotate(
                        angle: 50,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.phone_android,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  label: Text(
                    "send-text-btn".tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              SizedBox(
                width: 5.0,
              ),
              RaisedButton.icon(
                disabledColor: Palette.primaryColor,
                color: Palette.primaryColor,
                onPressed: () => _sendVerificationCodeEmail("false", setState),
                icon: Row(
                  children: <Widget>[
                    Transform.rotate(
                      angle: 50,
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.mail,
                      color: Colors.white,
                    ),
                  ],
                ),
                label: Text(
                  "send-email-btn".tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 35.0,
          ),
          Container(
            child: isLoard
                ? CircleAvatar(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                : null,
          ),
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Palette.primaryColor,
                          radius: 10.0,
                          child: Text(
                            "1",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Palette.primaryColor,
                          radius: 10.0,
                          child: Text(
                            "2",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              currentstape = 3;
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: Palette.primaryColor,
                            radius: 10.0,
                            child: Text(
                              "3",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Palette.primaryColor,
                          radius: 15.0,
                          child: Text(
                            "4",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CreateAccountSuccessWidget extends StatefulWidget {
  @override
  _CreateAccountSuccessWidgetState createState() =>
      _CreateAccountSuccessWidgetState();
}

class _CreateAccountSuccessWidgetState
    extends State<CreateAccountSuccessWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TabsScreen(
              selectedPage: 2,
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: Palette.primaryColor,
          body: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(500.0),
              ),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 30.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/plane-pause2.jpg",
                                height: 200.0,
                                width: 200.0,
                              ),
                              SizedBox(
                                height: 50.0,
                              ),
                              Text(
                                "welcome-text".tr(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0,
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "profil-78-text".tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      bottom: 20.0,
                      left: 0.0,
                      child: Center(
                        child: InkWell(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TabsScreen(
                                selectedPage: 2,
                              ),
                            ),
                          ),
                          child: Shimmer.fromColors(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "go-home-btn".tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 20.0,
                                  ),
                                ],
                              ),
                            ),
                            baseColor: Colors.black,
                            highlightColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
