import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/environment/environment.dart';
import 'package:luggin/pages/user_profil_edit_page.dart';
import 'package:luggin/pages/user_public_profil_page.dart';

class UserProfilDetails extends StatefulWidget {
  final authUserData;
  UserProfilDetails({@required this.authUserData});
  @override
  _UserProfilDetailsState createState() => _UserProfilDetailsState();
}

class _UserProfilDetailsState extends State<UserProfilDetails> {
  @override
  void initState() {
    super.initState();
    print(widget.authUserData);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
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
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfilEditPage(),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black12,
                        radius: 30.0,
                        backgroundImage: NetworkImage(
                          AppEvironement.imageUrl +
                              "storage/" +
                              widget.authUserData['avatar'],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              color: Color(0xFFABABAB).withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(widget.authUserData['biography'] ?? ''),
                    SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserPublicProfil(
                              responseData: widget.authUserData,
                            ),
                          ),
                        ),
                        child: Text(
                          "See your public profil",
                          style: TextStyle(
                            color: Palette.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            ListTile(
              title: Text("Verified ID"),
              trailing: widget.authUserData['userId_isVerified'] == 'true'
                  ? Image.asset("assets/images/doneIcon.png", width: 20.0)
                  : Image.asset("assets/images/notDone.png", width: 20.0),
            ),
            ListTile(
              title: Text(widget.authUserData['phoneNumber'] ?? 'Phone number'),
              trailing: widget.authUserData['phoneNumber_isVerified'] == 'true'
                  ? Image.asset("assets/images/doneIcon.png", width: 20.0)
                  : Image.asset("assets/images/notDone.png", width: 20.0),
            ),
            ListTile(
              title: Text(widget.authUserData['email'] ?? 'Email'),
              trailing: widget.authUserData['email_isVerified'] == 'true'
                  ? Image.asset("assets/images/doneIcon.png", width: 20.0)
                  : Image.asset("assets/images/notDone.png", width: 20.0),
            ),
            Divider(),
            ListTile(
              title: Text("Password"),
              trailing: Icon(
                Icons.arrow_forward_ios,
              ),
            ),
            ListTile(
              title: Text("PO BOX"),
              trailing: Icon(
                Icons.arrow_forward_ios,
              ),
            ),
            Divider(),
            SizedBox(
              height: 5.0,
            ),
            GestureDetector(
              onTap: () => null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Reviews",
                  style: TextStyle(
                    color: Palette.primaryColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
