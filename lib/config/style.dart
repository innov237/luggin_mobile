import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';

class Style {
  static const textStyleInputLg = TextStyle(
    fontSize: 18.0,
    fontStyle: FontStyle.italic,
  );

  static var inputBoxDecorationLg = BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(100.0),
    ),
    color: Color(0xFFEFF0F1),
  );

  static var inputBoxDecorationRectangle = BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    color: Color(0xFFEFF0F1),
  );

  static var gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Palette.primaryColor,
        Colors.cyan.withOpacity(0.4),
      ],
    ),
  );

  static var shapeCard = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  );

  static double cardElevation = 0.3;

  static double inputHeight = 46.0;

  static Container inputContainerCircle(
      String hintText, TextEditingController controller) {
    return Container(
      height: 55.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        border: Border.all(color: Colors.white, width: 5.0),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: 18.0,
          fontStyle: FontStyle.italic,
        ),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
            hintText: hintText,
            prefixIcon: Icon(Icons.account_circle),
            border: InputBorder.none),
      ),
    );
  }
}
