import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';

class CurrencyPage extends StatefulWidget {
  @override
  _CurrencyPageState createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  String defaulCurrency = "EUR";

  setDefaultCurrency(currency) {
    setState(() {
      this.defaulCurrency = currency;
    });
  }

  Widget isActiveOrInactive(value) {
    return Container(
      child: value
          ? Icon(
              Icons.toggle_on,
              size: 42.0,
              color: Palette.primaryColor,
            )
          : Icon(
              Icons.toggle_off,
              size: 42.0,
              color: Colors.black12,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Currency"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () => setDefaultCurrency('EUR'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "EUR - €",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          isActiveOrInactive(defaulCurrency == "EUR"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Divider(
                      height: 5.0,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    InkWell(
                      onTap: () => setDefaultCurrency('USD'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "USD - \$",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          isActiveOrInactive(defaulCurrency == "USD"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(
                      height: 5.0,
                    ),
                    InkWell(
                      onTap: () => setDefaultCurrency('XAF'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "XAF",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          isActiveOrInactive(defaulCurrency == "XAF"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(
                      height: 5.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: () => setDefaultCurrency('Yuan'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Yuan",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          isActiveOrInactive(defaulCurrency == "Yuan"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(
                      height: 5.0,
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
