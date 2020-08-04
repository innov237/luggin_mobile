import 'package:flutter/material.dart';

class LinesHeaderWidget extends StatefulWidget {
  final title;
  LinesHeaderWidget({@required this.title, Key key}) : super(key: key);
  @override
  _LinesHeaderWidgetState createState() => _LinesHeaderWidgetState(this.title);
}

class _LinesHeaderWidgetState extends State<LinesHeaderWidget> {
  final title;
  _LinesHeaderWidgetState(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25.0,
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white54,
              ),
              height: 5.0,
            ),
          )
        ],
      ),
    );
  }
}
