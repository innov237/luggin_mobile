import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Widget buildloader() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
            100.0,
          ),
          child: Image.asset(
            "assets/images/loader.gif",
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Text(
          "loader-text".tr(),
        )
      ],
    );
