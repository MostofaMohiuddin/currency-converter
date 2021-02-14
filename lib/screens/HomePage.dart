import 'package:currency_converter/widgets/Calculator.dart';
import 'package:currency_converter/widgets/CurrencyPicker.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String fromCountryISO = 'US',
      toCountryISO = 'BD',
      fromCountryCurrency = 'USD',
      toCountryCurrency = 'BDT',
      result = "",
      amount = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 1),
              child: Card(
                child: Container(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CurrencyPicker(
                        "From",
                        fromCountryISO,
                        result,
                        (String isFrom, String country, String currency) => {
                          isFrom.contains("From")
                              ? setState(() => fromCountryISO = country)
                              : setState(() => toCountryISO = country),
                          isFrom.contains("From")
                              ? setState(() => fromCountryCurrency = currency)
                              : setState(() => toCountryCurrency = currency)
                        },
                        (String amount) =>
                            {setState(() => this.amount = amount)},
                      ),
                      SizedBox(
                        height: 25.0,
                        width: 25.0,
                        child: new IconButton(
                          padding: new EdgeInsets.all(0.0),
                          tooltip: 'Reverse',
                          onPressed: () {
                            // print(fromCountryISO);
                            setState(() {
                              String temp = fromCountryISO;
                              fromCountryISO = toCountryISO;
                              toCountryISO = temp;
                              temp = fromCountryCurrency;
                              fromCountryCurrency = toCountryCurrency;
                              toCountryCurrency = temp;
                            });
                          },
                          icon: Icon(Icons.autorenew_rounded, size: 25.0),
                        ),
                      ),
                      CurrencyPicker(
                        "To",
                        toCountryISO,
                        result,
                        (String isFrom, String country, String currency) => {
                          isFrom.contains("From")
                              ? setState(() => fromCountryISO = country)
                              : setState(() => toCountryISO = country),
                          isFrom.contains("From")
                              ? setState(() => fromCountryCurrency = currency)
                              : setState(() => toCountryCurrency = currency)
                        },
                        (String amount) =>
                            {setState(() => this.amount = amount)},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: Calculator(
                    this.amount,
                    fromCountryCurrency,
                    toCountryCurrency,
                    (String result) => {setState(() => this.result = result)}))
          ],
        ),
      ),
    );
  }
}
