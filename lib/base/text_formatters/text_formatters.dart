import 'package:flutter/services.dart';

class AppTextInputFormatters {
  static List<TextInputFormatter> withNameFormatter() {
    return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))];
  }

  static List<TextInputFormatter> withEmailFormatter() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._@-]')),
      LengthLimitingTextInputFormatter(255), // Limit email length (optional)
    ];
  }

  static List<TextInputFormatter> withUsernameFormatter() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_.]')),
      LengthLimitingTextInputFormatter(30), // Limit username length (optional)
    ];
  }

  // Additional formatters

  static List<TextInputFormatter> withPhoneNumberFormatter() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(10), // Limit phone number length
    ];
  }

  static List<TextInputFormatter> withNumericFormatter() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      LengthLimitingTextInputFormatter(10),
    ];
  }

  static List<TextInputFormatter> withDecimalFormatter() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      LengthLimitingTextInputFormatter(10),
    ];
  }

  static List<TextInputFormatter> withAlphanumericFormatter() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
    ];
  }

  static List<TextInputFormatter> withCustomFormatter(
      RegExp regExp, int maxLength) {
    return [
      FilteringTextInputFormatter.allow(regExp),
      LengthLimitingTextInputFormatter(maxLength),
    ];
  }
}
