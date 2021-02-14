import 'dart:convert';

import 'package:currency_converter/models/CurrencyConvert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  String amount, from, to;
  var setResult;
  Calculator(amount, from, to, setResult) {
    this.amount = amount;
    this.from = from;
    this.to = to;
    this.setResult = setResult;
  }

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String error = "";
  bool isDisable = false;

  bool isValid(String amount, context) {
    final number = num.tryParse(amount);
    if (number == null) {
      showSnackbar(context, "Give a valid amount!!!");
      return false;
    } else if (number < 0) {
      showSnackbar(context, "Give a valid amount!!!");
      return false;
    }
    return true;
  }

  calculate(String amount, context) async {
    if (!isValid(amount, context)) {
      print("given : " + amount);
      setState(() {
        error = "Give a valid amount!!!";
      });
      setState(() {
        isDisable = false;
      });
      return;
    }
    print("ok");
    final double multiplier = await getCurrencyConvert();
    final result = multiplier * double.parse(amount);
    print(result);
    widget.setResult(double.parse((result).toStringAsFixed(2)).toString());
    setState(() {
      isDisable = false;
    });
  }

  Future<double> getCurrencyConvert() async {
    final url =
        'https://free.currconv.com/api/v7/convert?q=${widget.from}_${widget.to}&compact=ultra&apiKey=ec1dbd1e5c25a2584a97';

    final response = await http.get(Uri.encodeFull(url));
    print(response.body);
    if (response.statusCode == 200) {
      Map jsonData = jsonDecode(response.body);

      print(jsonData["${widget.from}_${widget.to}"]);
      return jsonData["${widget.from}_${widget.to}"];
      // return CurrencyConvert.fromJson(json, "${widget.from}_${widget.to}");
    } else
      return -1;
  }

  showSnackbar(context, error) {
    final snackBar = SnackBar(
      content: Text(error),
    );

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: (MediaQuery.of(context).size.width) / 2,
      buttonColor: Color(0xFF0A0E21),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.amber),
        ),
        disabledColor: Color(0xFF0A0E21),
        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 0),
        onPressed: !isDisable
            ? () {
                setState(() {
                  this.isDisable = true;
                });
                calculate(this.widget.amount, context);
              }
            : null,

        // width: (MediaQuery.of(context).size.width) / 2,
        // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        child: isDisable
            ? SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.greenAccent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              )
            : const Text(
                'Calculate',
                style: TextStyle(
                  fontSize: 21.5,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
