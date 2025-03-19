import 'dart:math';

import 'package:intl/intl.dart';

///Utility class for formatting number
class MyNumberUtils {
  ///returns formatted currency in indian format eg: 10000 ->  ₹ 10,000
  String formatCurrency(dynamic value, {int decimalDigits = 2, bool addSpaceAfterNegSign = false}) {
    num? formattedValue;

    if (value == null) {
      formattedValue = null;
    } else if (value is String) {
      formattedValue = num.tryParse(value);
    } else {
      formattedValue = num.tryParse(value.toString());
    }

    if (formattedValue == null) {
      return '\$ 0';
    } else {
      final currencyFormatter = NumberFormat(_getFormat(decimalDigits), "en_IN");
      var _formattedCurrency = currencyFormatter.format(formattedValue);
      if (addSpaceAfterNegSign && formattedValue.isNegative) {
        return _addSpaceBetweenSymbolAndSign(_formattedCurrency);
      }
      return _formattedCurrency;
    }
  }

  String _getFormat(int decimalDigits) {
    var _decimalSymbol = "0" * decimalDigits;
    var decimal = _formatDecimalSeparator(_decimalSymbol);
    return "₹ ##,##,##0$decimal";
  }

  _addSpaceBetweenSymbolAndSign(String value) {
    return "${value.substring(0, 1)} ${value.substring(1)}";
  }

  String _formatDecimalSeparator(String? decimalString) {
    return decimalString == null || decimalString.isEmpty ? "" : ".$decimalString";
  }

  ///checks if number if valid or not
  bool isValidNumber(String value) {
    var result = num.tryParse(value);
    return result != null;
  }

  ///parse String value to num value
  num parseStringValue(String value) {
    var result = num.tryParse(value);
    return result ?? 0;
  }

  ///converts bytes to Kb or Mb
  ///for adding decimal points use [decimals] parameter
  ///[decimals] values is number of decimal points to show
  String formatBytes(int? bytes, {int decimals = 0}) {
    if (bytes == null || bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
  }
}
