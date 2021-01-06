import 'package:flutter/material.dart';
import 'package:luggin/config/palette.dart';
import 'package:luggin/config/style.dart';
import 'package:separated_number_input_formatter/separated_number_input_formatter.dart';
import 'package:luggin/services/http_service.dart';
import 'package:luggin/widgets/success_widget.dart';

class PaymentScreen extends StatefulWidget {
  final requestData;
  final paymentMethod;

  PaymentScreen({@required this.requestData, @required this.paymentMethod});

  @override
  _PaymentScreenState createState() =>
      _PaymentScreenState(this.requestData, this.paymentMethod);
}

class _PaymentScreenState extends State<PaymentScreen> {
  final requestData;
  final paymentMethod;

  String currentPaymentMethod = '';

  _PaymentScreenState(this.requestData, this.paymentMethod);
  String responseMessage = '';

  TextEditingController _cardNumber;
  TextEditingController _cardExpiryDate;
  TextEditingController _cardHolder;
  TextEditingController _cardCvv;

  HttpService httservice = HttpService();
  bool isLoard = false;

  @override
  void initState() {
    super.initState();
    _cardNumber = TextEditingController();
    _cardExpiryDate = TextEditingController();
    _cardHolder = TextEditingController();
    _cardCvv = TextEditingController();

    print(requestData);

    currentPaymentMethod = paymentMethod;
  }

  _validateCard() async {
    // setState(() {
    //   responseMessage = '';
    //   requestData['cardNumber'] = _cardNumber.text.toString();
    //   requestData['cardExpiryDate'] = _cardExpiryDate.text.toString();
    //   requestData['cardHolder'] = _cardHolder.text.toString();
    //   requestData['cardCvv'] = _cardCvv.text.toString();
    //   requestData['method'] = paymentMethod.toString();
    // });

    // if (_cardNumber.text.isEmpty ||
    //     _cardHolder.text.isEmpty ||
    //     _cardCvv.text.isEmpty ||
    //     _cardExpiryDate.text.isEmpty) {
    //   setState(() {
    //     responseMessage = "All fields are required";
    //   });
    //   return;
    // }

    var response =
        await httservice.postData("sendDeliveryRequest", requestData);

    if (response['success']) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SaveSuccessWidget(),
        ),
      );
    } else {
      setState(() {
        responseMessage =
            "An error occurred during the operation please try again";
      });
    }
  }

  changePaymentMethode() {
    if (currentPaymentMethod == 'savedCard') {
      setState(() {
        currentPaymentMethod = 'card';
      });
    } else {
      setState(() {
        currentPaymentMethod = 'savedCard';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.security,
                                      color: Colors.white60,
                                      size: 15.0,
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      "You are on a secure payment server",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 3.0,
                                        color: Colors.white60,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "That's it,\nyou can pay !",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              if (currentPaymentMethod == 'card' ||
                                  currentPaymentMethod == 'paypal') ...[
                                buildPayementForm(),
                              ],
                              if (paymentMethod == 'lugginpay') ...[
                                Card(
                                  child: Container(
                                    height: 100.0,
                                    child: Center(
                                      child: ListTile(
                                        leading: Image.asset(
                                          "assets/images/logo2.png",
                                          height: 30.0,
                                        ),
                                        title: Text("LugginPay"),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                              if (currentPaymentMethod == 'savedCard') ...[
                                buildSavePaymentScreen(),
                              ],
                              if (responseMessage != '') ...[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      responseMessage.toString(),
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                              SizedBox(
                                height: 10.0,
                              ),
                              GestureDetector(
                                onTap: () => changePaymentMethode(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Use another payment method",
                                    style: TextStyle(
                                      color: Palette.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 75.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () => !isLoard ? _validateCard() : null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      color: Palette.primaryColor,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            !isLoard
                                ? "Pay ${requestData['price_delivery']}€"
                                    .toString()
                                : "Please waite...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPayementForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.white,
            elevation: 0.3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Card Number"),
                  ),
                  Container(
                    decoration: Style.inputBoxDecorationRectangle,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _cardNumber,
                        maxLength: 19,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                        decoration: InputDecoration(
                          hintText: 'XXXX XXXX XXXX XXXX',
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          SeparatedNumberInputFormatter(4, separator: ' '),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Expiry Date"),
                  ),
                  Container(
                    decoration: Style.inputBoxDecorationRectangle,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _cardExpiryDate,
                        maxLength: 5,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                        decoration: InputDecoration(
                          hintText: 'MM/YY',
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          // Use with digits and separator parameters.
                          SeparatedNumberInputFormatter(2, separator: '/'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Card Holder"),
                  ),
                  Container(
                    decoration: Style.inputBoxDecorationRectangle,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _cardHolder,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Ex. John innov",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("CVV"),
                  ),
                  Container(
                    decoration: Style.inputBoxDecorationRectangle,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _cardCvv,
                        maxLength: 3,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                        decoration: InputDecoration(
                          hintText: 'XXX',
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSavePaymentScreen() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(
              Icons.credit_card,
            ),
            title: Text(
              "Methode de paiement enregistrée",
            ),
            subtitle: Text("**** *** *** 0733"),
          ),
          Divider(),
        ],
      ),
    );
  }
}
