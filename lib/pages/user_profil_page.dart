import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:luggin/config/palette.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/screens/menu_sreen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:dio/dio.dart';
import 'package:luggin/services/preferences_service.dart';
import 'dart:convert';

class UserProfilPage extends StatefulWidget {
  @override
  _UserProfilPageState createState() => _UserProfilPageState();
}

class _UserProfilPageState extends State<UserProfilPage> {
  var userData;
  bool isLord = false;
  String responseMessage = '';
  DateTime pickedDate;

  TextEditingController _emailController;
  TextEditingController _firstNameController;
  TextEditingController _surNameController;
  TextEditingController _dateBirthdayController;
  TextEditingController _phoneNumberController;
  TextEditingController _placeResidenceController;
  TextEditingController _pseudoController;
  TextEditingController _passwordController;
  TextEditingController _biographyController;

  String imageApiUrl = AppEvironement.imageUrl;
  String apiUrl = AppEvironement.apiUrl;
  bool isLoarding = false;
  String currentUserAvatar;
  String activeView = "userProfilview";

  File file;
  String imagepath;
  String _newFileNameData;

  _pickImage(ImageSource source) async {
    var picture = await ImagePicker.pickImage(source: source);
    setState(() {
      file = picture;
      imagepath = file.path;
      Navigator.pop(context);
      _cropImage();
    });
  }

  //Cropper image
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: file.path,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Color(0xFF45C5F8),
        toolbarTitle: "Edit image",
        backgroundColor: Color(0xFF45C5F8),
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: false,
        hideBottomControls: true,
      ),
    );
    setState(() {
      file = cropped ?? file;
      imagepath = file.path;
      _newFileNameData = _createFileName();
      currentUserAvatar = _newFileNameData;
      updateUserAvatar();
    });
  }

  uploadImage(imagepath, fileName) async {
    setState(() {
      isLoarding = true;
    });
    var uri = Uri.parse(apiUrl + "upload");
    var request = http.MultipartRequest('POST', uri)
      ..fields['fileName'] = fileName
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          imagepath,
          filename: fileName,
          contentType: MediaType('application', 'x-tar'),
        ),
      );
    var response = await request.send();
    if (response.statusCode == 200) print('Uploaded!');
  }

  String _createFileName() {
    var d = new DateTime.now().millisecondsSinceEpoch.abs(),
        newFileName = d.toString() + ".jpg";
    print(newFileName);
    return newFileName;
  }

  _openPage(context, page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.image),
                    title: new Text('Choose from library'),
                    onTap: () => _pickImage(ImageSource.gallery)),
                new ListTile(
                  leading: new Icon(Icons.camera),
                  title: new Text('Take a photo'),
                  onTap: () => _pickImage(ImageSource.camera),
                ),
              ],
            ),
          );
        });
  }

  changeView(view) {
    setState(() {
      activeView = view;
    });
  }

  initUserData() {
    _firstNameController.text = userData['firstName'];
    _surNameController.text = userData['surName'];
    _phoneNumberController.text = userData['phoneNumber'];
    _emailController.text = userData['email'];
    _pseudoController.text = userData['pseudo'];
    _dateBirthdayController.text = userData['dateOfBirthDay'];
    _placeResidenceController.text = userData['placeOfResidence'];
    _biographyController.text = userData['biography'];
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

  updateUserAvatar() async {
    uploadImage(imagepath, currentUserAvatar);

    var dio = Dio();

    var postData = {'userAvatar': currentUserAvatar, 'userId': userData['id']};

    var response = await dio.post(apiUrl + "updateUserAvatar", data: postData);

    if (response.statusCode == 200) {
      var user = response.data;

      PreferenceStorage.saveDataToPreferences(
        'USERDATA',
        json.encode(user['data'][0]),
      );

      getPreferencesData();
    }
  }

  updateUserProfil() async {
    setState(() {
      isLord = true;
      responseMessage = '';
    });
    var postData = {
      'idUser': userData['id'],
      'email': _emailController.text,
      'firstName': _firstNameController.text,
      'surName': _surNameController.text,
      'dateOfBirthDay': _dateBirthdayController.text,
      'phoneNumber': _phoneNumberController.text,
      'placeOfResidence': _placeResidenceController.text,
      'pseudo': _pseudoController.text,
      'biography': _biographyController.text,
    };

    if (_firstNameController.text.length < 4 ||
        _surNameController.text.length < 0 ||
        _pseudoController.text.length < 4) {
      setState(() {
        responseMessage = "Check that all fields are correct";
        isLord = false;
      });
      return;
    }

    if (userData['pseudo'] != _pseudoController.text) {
      if (pseudoExit(_pseudoController.text) == true) {
        setState(() {
          responseMessage = "Pseudo is taken";
          isLord = false;
        });
        return;
      }
    }

    Dio dio = Dio();

    var response = await dio.post(apiUrl + "updateUserProfil", data: postData);
    if (response.statusCode == 200) {
      var user = response.data;
      setState(() {
        isLord = false;
      });
      PreferenceStorage.saveDataToPreferences(
        'USERDATA',
        json.encode(user['data'][0]),
      );
    }
  }

  getPreferencesData() {
    PreferenceStorage.getDataFormPreferences('USERDATA').then((data) {
      if (null == data) {
        return;
      }
      setState(() {
        var storageValue = json.decode(data);
        userData = storageValue;
        print(userData);
        initUserData();
      });
    });
  }

  pseudoExit(pseudo) async {
    Dio dio = Dio();

    var response =
        await dio.post(apiUrl + 'checkPseudo', data: {'pseudo': pseudo});
    if (response.data > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _firstNameController = TextEditingController();
    _surNameController = TextEditingController();
    _dateBirthdayController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _placeResidenceController = TextEditingController();
    _pseudoController = TextEditingController();
    _passwordController = TextEditingController();
    _biographyController = TextEditingController();

    pickedDate = new DateTime(
        DateTime.now().year - 17, DateTime.january, DateTime.monday);

    getPreferencesData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Palette.primaryColor,
                    Colors.cyan.withOpacity(0.8),
                  ],
                ),
              ),
              height: 110.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () => _openPage(context, MenuScreen()),
                          child: Icon(
                            Icons.close,
                            size: 25.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Container(
                        child: Stack(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.2),
                              backgroundImage: file == null
                                  ? NetworkImage(
                                      imageApiUrl +
                                          "storage/" +
                                          userData["avatar"],
                                    )
                                  : Image.file(file).image,
                              minRadius: 30.0,
                              maxRadius: 30.0,
                            ),
                            Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              child: InkWell(
                                onTap: () => _settingModalBottomSheet(context),
                                child: CircleAvatar(
                                  radius: 10.0,
                                  backgroundColor: Color(0xFF96B1E4),
                                  child: Icon(Icons.camera_alt,
                                      size: 10.0, color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: buildEditUserProfil(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildEditUserProfil(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Frist Name(s)",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF2288B9),
                  ),
                ),
                TextField(
                  controller: _firstNameController,
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    hintText: 'Frist Name(s)',
                    border: InputBorder.none,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Last Name",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF2288B9),
                  ),
                ),
                TextField(
                  controller: _surNameController,
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    hintText: 'Surname',
                    border: InputBorder.none,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Pseudo",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF2288B9),
                  ),
                ),
                TextField(
                  controller: _pseudoController,
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    hintText: 'Pseudo',
                    border: InputBorder.none,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Phone Number",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF2288B9),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _phoneNumberController,
                        enabled: false,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black.withOpacity(0.2),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
            ),
            child: InkWell(
              onTap: () => _pickDate(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Date of birth day",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF2288B9),
                    ),
                  ),
                  TextField(
                    controller: _dateBirthdayController,
                    enabled: false,
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      hintText: 'date of birth day',
                      border: InputBorder.none,
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
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Email address",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF2288B9),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _emailController,
                        enabled: false,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          hintText: 'Email address',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black.withOpacity(0.2),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF2288B9),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _passwordController,
                        enabled: false,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          hintText: '******',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black.withOpacity(0.2),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Address",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF2288B9),
                  ),
                ),
                TextField(
                  controller: _placeResidenceController,
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    hintText: 'Address',
                    border: InputBorder.none,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "About me",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF2288B9),
                  ),
                ),
                TextField(
                  controller: _biographyController,
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    hintText: 'About me',
                    border: InputBorder.none,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(responseMessage),
          SizedBox(
            height: 5.0,
          ),
          Container(
            child: InkWell(
              onTap: () => updateUserProfil(),
              child: CircleAvatar(
                radius: 25.0,
                child: !isLord
                    ? Icon(Icons.done)
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
        ],
      ),
    );
  }
}
