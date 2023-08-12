import 'package:flutter/services.dart';

class FormFormatters {
  static List<TextInputFormatter> phone = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ];
  static List<TextInputFormatter> email = [
    FilteringTextInputFormatter.allow(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"),
  ];
}
