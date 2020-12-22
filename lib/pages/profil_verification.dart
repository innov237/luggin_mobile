import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luggin/config/palette.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggin/core/toast/toast.dart';
import 'package:luggin/core/validations/Input_validation.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/services/camera_service.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/services/preferences_service.dart';

class ProfilVerification extends StatefulWidget {
  final authUserData;
  ProfilVerification({@required this.authUserData});

  @override
  _ProfilVerificationState createState() => _ProfilVerificationState();
}

class _ProfilVerificationState extends State<ProfilVerification> {
  TextEditingController _emailController;
  TextEditingController _phoneNumberController;

  bool isLord = false;

  File file;
  File userAvatarfile;
  String imagepath;
  String _newFileNameData;
  var userIDCardData = [];
  var userIDcardNameData = [];

  CameraService cameraService = CameraService();
  HttpService httpService = HttpService();

  getImageAndCrop(ImageSource imageSource, bool mutiple) async {
    //Importation de l'image
    File imageFile = await cameraService.pickImage(imageSource);
    //Rogner l'image
    File imageCropFile = await cameraService.cropImage(imageFile);
    Navigator.pop(context);
    setState(() {
      file = imageCropFile;
      _newFileNameData = cameraService.createFileName();
      if (mutiple) {
        //is Id Card
        userIDCardData.add(file);
        userIDcardNameData.add(_newFileNameData);
      } else {
        // is avatar
        userAvatarfile = file;
        imagepath = file.path;
      }
    });
  }

  void _settingModalBottomSheet(context, bool multiple) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.image),
                title: new Text('Choose from library'),
                onTap: () async {
                  getImageAndCrop(ImageSource.gallery, multiple);
                },
              ),
              new ListTile(
                leading: new Icon(Icons.camera),
                title: new Text('Take a photo'),
                onTap: () async {
                  getImageAndCrop(ImageSource.camera, multiple);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  removeImage(index) {
    setState(() {
      userIDcardNameData.removeAt(index);
      userIDCardData.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();

    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();

    print(widget.authUserData);

    setState(() {
      _emailController.text = widget.authUserData['email'];
      _phoneNumberController.text = widget.authUserData['phoneNumber'];
    });
  }

  _saveUserId() async {
    var postData = {
      'idUser': widget.authUserData['id'],
      'email': _emailController.text,
      'firstName': widget.authUserData['firstName'],
      'surName': widget.authUserData['surName'],
      'dateOfBirthDay': widget.authUserData['dateOfBirthDay'],
      'phoneNumber': _phoneNumberController.text,
      'placeOfResidence': widget.authUserData['placeOfResidence'],
      'pseudo': widget.authUserData['pseudo'],
      'biography': widget.authUserData['biography'],
      'documentPicture': userIDcardNameData,
    };

    if (userIDCardData.length == 0) {
      ShowToast().show("Veuillez ajouter votre pièce d'identité", Colors.red);
      return;
    }

    if (!InputValidation().validateEmail(_emailController.text)) {
      ShowToast().show("Email invalide", Colors.red);
      return;
    }

    if (!InputValidation().validatePhoneNumber(_phoneNumberController.text)) {
      ShowToast().show("Téléphone invalide", Colors.red);
      return;
    }

    setState(() {
      isLord = true;
    });

    if (userIDcardNameData.length > 0) {
      for (var i = 0; i < userIDcardNameData.length; i++) {
        httpService.uploadImage(
          userIDCardData[i].path,
          userIDcardNameData[i],
        );
        print(userIDCardData[i].path);
      }
    }

    Dio dio = Dio();

    var response = await dio.post(AppEvironement.apiUrl + "updateUserProfil",
        data: postData);
    if (response.statusCode == 200) {
      var userData = response.data;
      setState(() {
        isLord = false;
      });

      PreferenceStorage.saveDataToPreferences(
        'USERDATA',
        json.encode(userData['data'][0]),
      );
      ShowToast().show("Envoyé avec succès", Colors.greenAccent);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/word-map.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.verified,
                                size: 70.0,
                                color: Colors.greenAccent,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Un profil vérifié ou certifié = plus de confiance des autres utilisateurs et plus de chance de faire des transactions",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "La collecte et le traitement des données personnelles permettent de vérifier votre profil et sont conformes aux principes de la réglementation générale sur la protection des données",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pièce d'identité *",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ),
                        child: Column(
                          children: [
                            if (userIDCardData.length > 0) ...[
                              Container(
                                height: 100.0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: userIDCardData.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Stack(
                                      children: [
                                        Card(
                                          elevation: 0.3,
                                          child: Image.file(
                                            userIDCardData[index] ?? null,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () => removeImage(index),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                            if (userIDCardData.length < 4) ...[
                              Container(
                                height: 100.0,
                                color: Color(0xFFEFF0F1),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () =>
                                        _settingModalBottomSheet(context, true),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Palette.primaryColor,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 7.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      100.0,
                    ),
                    child: Container(
                      color: Color(0xFFEFF0F1),
                      height: 46.0,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            hintText: 'phone-number-input'.tr() + " *",
                            icon: CircleAvatar(
                              backgroundColor: Palette.primaryColor,
                              child: Icon(
                                Icons.phone,
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
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      100.0,
                    ),
                    child: Container(
                      color: Color(0xFFEFF0F1),
                      height: 46.0,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'email-input'.tr() + " *",
                            icon: CircleAvatar(
                              backgroundColor: Palette.primaryColor,
                              child: Icon(
                                Icons.email,
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
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 43.0,
                    child: RaisedButton(
                      elevation: 0.0,
                      color: Palette.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      onPressed: () => _saveUserId(),
                      child: Text(
                        "Envoyer",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
