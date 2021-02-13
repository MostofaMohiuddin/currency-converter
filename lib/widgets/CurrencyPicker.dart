import 'package:currency_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:currency_pickers/currency_pickers.dart';

class CurrencyPicker extends StatefulWidget {
  Country _selectedDialogCountry;
  String title, initialCountry = "", result;
  var setCountry, setAmount;
  CurrencyPicker(@required title, @required initial, result,
      @required setCountry, @required setAmount) {
    this.title = title;
    this.initialCountry = initial;
    this.result = result;
    this.setCountry = setCountry;
    this.setAmount = setAmount;
    _selectedDialogCountry =
        CurrencyPickerUtils.getCountryByIsoCode(initialCountry);
  }
  @override
  _CurrencyPickerState createState() => _CurrencyPickerState();
}

class _CurrencyPickerState extends State<CurrencyPicker> {
  // Country _selectedDialogCountry =
  //     CurrencyPickerUtils.getCountryByIsoCode('BD');
  TextEditingController amountController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: (MediaQuery.of(context).size.width) / 2 + 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                InkWell(
                  onTap: _openCurrencyPickerDialog,
                  child: _buildCardItem(widget._selectedDialogCountry),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
            width: (MediaQuery.of(context).size.width) / 2 - 80,
            child: widget.title.contains("From")
                ? TextField(
                    onChanged: (text) {
                      widget.setAmount(text);
                    },
                    // controller: amountController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 2),
                      isDense: true,
                      hintText: 'Amount',
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))),
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 2),
                    child: Text(
                      widget.result == ""
                          ? widget._selectedDialogCountry.currencyName
                          : widget.result,
                      style: TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildCardItem(Country country) => Container(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
        child: Row(
          children: <Widget>[
            CurrencyPickerUtils.getDefaultFlagImage(country),
            SizedBox(width: 8.0),
            Container(
              width: (MediaQuery.of(context).size.width) / 2 - 50,
              child: Column(
                children: [
                  Text(
                    "+${country.currencyCode}",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    country.name,
                    style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CurrencyPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Text("+${country.currencyCode}"),
          SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      );

  void _openCurrencyPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CurrencyPickerDialog(
                titlePadding: EdgeInsets.all(8.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration: InputDecoration(hintText: 'Search...'),
                isSearchable: true,
                title: Text('Select your Currency'),
                onValuePicked: (Country country) => {
                      setState(() => widget._selectedDialogCountry = country),
                      widget.setCountry(
                          widget.title, country.isoCode, country.currencyCode),
                    },
                itemBuilder: _buildDialogItem)),
      );
}
