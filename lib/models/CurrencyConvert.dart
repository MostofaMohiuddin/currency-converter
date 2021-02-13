import 'dart:ffi';

class CurrencyConvert {
  Float convert;
  CurrencyConvert({this.convert});
  factory CurrencyConvert.fromJson(final json, String key) {
    return CurrencyConvert(convert: json[key]);
  }
}
