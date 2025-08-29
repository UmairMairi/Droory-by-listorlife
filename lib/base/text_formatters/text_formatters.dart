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

  static List<TextInputFormatter> withCardFormatter() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(
          19), // Maximum length for card numbers including spaces
      TextInputFormatter.withFunction(
        (oldValue, newValue) {
          String text = newValue.text.replaceAll(' ', '');
          if (text.length > 16) {
            text = text.substring(0, 16);
          }

          StringBuffer buffer = StringBuffer();
          for (int i = 0; i < text.length; i++) {
            if (i % 4 == 0 && i != 0) {
              buffer.write(' ');
            }
            buffer.write(text[i]);
          }

          return TextEditingValue(
            text: buffer.toString(),
            selection: TextSelection.collapsed(offset: buffer.length),
          );
        },
      ),
    ];
  }

  static List<TextInputFormatter> withCVVFormatter() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(4), // Limit CVV length to 4 digits
    ];
  }

  static List<TextInputFormatter> withExpiryDateFormatter() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
      LengthLimitingTextInputFormatter(
          5), // Limit expiry date length to 5 characters (MM/YY)
      TextInputFormatter.withFunction(
        (oldValue, newValue) {
          String text = newValue.text;
          if (text.length == 1 && int.parse(text) > 1) {
            text = '0$text'; // Add leading zero if first digit is more than 1
          }
          if (text.length == 2 && oldValue.text.length == 1) {
            text += '/'; // Add slash after the first two digits
          }
          if (text.length == 3 && !text.contains('/')) {
            text = '${text.substring(0, 2)}/${text.substring(2)}';
          }
          return TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          );
        },
      ),
    ];
  }
}
