import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/pages/reviews/reviews_success.dart';

class WriteReviewsPage extends StatefulWidget {
  @override
  _WriteReviewsPageState createState() => _WriteReviewsPageState();
}

class _WriteReviewsPageState extends State<WriteReviewsPage> {
  List<String> _locations = [
    'Parfait',
    'Très bien',
    'Bien',
    'Décevant',
    'A éviter'
  ];
  String _selectedLocation;

  bool activatePreviewbutton = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Palette.primaryColor, //change your color here
          ),
          backgroundColor: Colors.transparent,
        ),
        body: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 40.0,
                backgroundImage: NetworkImage(
                  "https://picsum.photos/seed/picsum/200/300",
                ),
              ),
              title: Text("Cedric djiele"),
              subtitle: Text("20ans"),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Votre avis pour cedric",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              color: Palette.primaryColor,
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star),
                        Text(
                          'Expérience globale',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text(
                          'Sélectionnez',
                        ), // Not necessary for Option 1
                        value: _selectedLocation,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedLocation = newValue;
                            activatePreviewbutton = true;
                          });
                        },
                        items: _locations.map((location) {
                          return DropdownMenuItem(
                            child: new Text(location),
                            value: location,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Icon(Icons.chat_bubble),
                        Text(
                          'Commentaire',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      child: TextField(
                        onChanged: (e) {
                          if (e.length > 0) {
                            setState(() {
                              activatePreviewbutton = true;
                            });
                          } else {
                            setState(() {
                              activatePreviewbutton = false;
                            });
                          }
                        },
                        decoration: InputDecoration(border: InputBorder.none),
                        minLines: 3,
                        maxLines: 3,
                        maxLength: 100,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        elevation: 0.0,
                        color:
                            activatePreviewbutton ? Palette.primaryColor : null,
                        onPressed: () => activatePreviewbutton
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewsPreview(),
                                ),
                              )
                            : null,
                        child: Text(
                          "Prévisualiser mon avis",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
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
    );
  }
}

class ReviewsPreview extends StatefulWidget {
  @override
  _ReviewsPreviewState createState() => _ReviewsPreviewState();
}

class _ReviewsPreviewState extends State<ReviewsPreview> {
  postReview() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewSuccessPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Palette.primaryColor, //change your color here
          ),
          backgroundColor: Colors.transparent,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Vérifiez votre avis avant de publier.',
                style: TextStyle(
                  color: Palette.primaryColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(
                      "https://picsum.photos/seed/picsum/200/300",
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8 - 4.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 0.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 20.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Très bien"),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "lorem upum lorem upumlorem upumlorem upumlorem upum lorem upum lorem upumlorem upumlorem upumlorem upum",
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40.0,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        onPressed: () => Navigator.pop(context),
                        elevation: 0.2,
                        color: Colors.white,
                        highlightColor: Palette.primaryColor,
                        child: Text(
                          "Modifier",
                          style: TextStyle(
                            color: Palette.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 0.2,
                      color: Palette.primaryColor,
                      child: Text(
                        "Publier",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => postReview(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
