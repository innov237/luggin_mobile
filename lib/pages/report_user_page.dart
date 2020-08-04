import 'package:flutter/material.dart';

class ReportUserPage extends StatefulWidget {
  @override
  _ReportUserPageState createState() => _ReportUserPageState();
}

class _ReportUserPageState extends State<ReportUserPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Report offer"),
        ),
        body: Center(
          child: Text("reason of report list..."),
        ),
      ),
    );
  }
}
