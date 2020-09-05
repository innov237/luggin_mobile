import 'package:flutter/material.dart';
import 'package:luggin/pages/payout_page.dart';
import 'package:luggin/pages/pending_transfer_page.dart';
import 'package:luggin/screens/payment_method_screen.dart';
import 'package:luggin/screens/transfer_history_screen.dart';

class PaymentAndPayoutPage extends StatefulWidget {
  @override
  _PaymentAndPayoutPageState createState() => _PaymentAndPayoutPageState();
}

class _PaymentAndPayoutPageState extends State<PaymentAndPayoutPage> {
  _openPage(page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => page),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Payment & Payouts"),
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      dense: true,
                      onTap: () => _openPage(PendingTransferPage()),
                      title: Row(
                        children: <Widget>[
                          Text(
                            'Pending transfer',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          )
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      onTap: () => _openPage(TransfertHistoryScreen()),
                      title: Row(
                        children: <Widget>[
                          Text(
                            'Transfer history',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          )
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      onTap: () => _openPage(PaymentMethodScreen()),
                      title: Row(
                        children: <Widget>[
                          Text(
                            'Payment methods',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          )
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      onTap: () => _openPage(PayoutPage()),
                      title: Row(
                        children: <Widget>[
                          Text(
                            'Payout',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          )
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      title: Row(
                        children: <Widget>[
                          Text(
                            'Currency',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          )
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
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
