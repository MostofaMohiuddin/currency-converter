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

  bool isValid(String amount) {
    final number = num.tryParse(amount);
    if (number == null) {
      return false;
    }
    return true;
  }

  calculate(String amount) async {
    if (!isValid(amount)) {
      print("given : " + amount);
      setState(() {
        error = "Give a valid amount!!!";
      });
      return;
    }
    print("ok");
    final double multiplier = await getCurrencyConvert();
    final result = multiplier * double.parse(amount);
    print(result);
    widget.setResult(double.parse((result).toStringAsFixed(2)).toString());
  }

  Future<double> getCurrencyConvert() async {
    // print("hey");
    final url =
        'https://free.currconv.com/api/v7/convert?q=${widget.from}_${widget.to}&compact=ultra&apiKey=ec1dbd1e5c25a2584a97';
    // 'https://free.currconv.com/api/v7/convert?q=${widget.from}_${widget.to}&compact=ultra&apiKey=ec1dbd1e5c25a2584a97';
    // print(url);
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

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          onPressed: () {
            // print("pressed");
            // print(widget.amount+" "+widget.from+" " +widget.to);
            calculate(this.widget.amount);
            // getCurrencyConvert();
          },
          child: Container(
            color: Color(0xFFD4EDDA),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: const Text('Calculate',
                style: TextStyle(
                  fontSize: 20,
                )),
          ),
        ),
      ],
    ));
  }
}
