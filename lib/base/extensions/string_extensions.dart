extension StringExtensions on String {
  bool isEmail() {
    final emailRegExp = RegExp(r'^[\w- \.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(this);
  }

  bool isPassword() {
    // Add your password validation logic here
    return length >= 8;
  }

  bool isPhoneNumber() {
    final phoneRegExp = RegExp(r'^[0-9]{10}$');
    return phoneRegExp.hasMatch(this);
  }

  bool containsOnlyDigits() {
    final digitRegExp = RegExp(r'^[0-9]+$');
    return digitRegExp.hasMatch(this);
  }

  bool containsOnlyLetters() {
    final letterRegExp = RegExp(r'^[a-zA-Z]+$');
    return letterRegExp.hasMatch(this);
  }

  bool containsOnlyAlphaNumeric() {
    final alphaNumericRegExp = RegExp(r'^[a-zA-Z0-9]+$');
    return alphaNumericRegExp.hasMatch(this);
  }

  bool containsWhitespace() {
    return contains(RegExp(r'\s'));
  }

  bool isLowerCase() {
    return this == toLowerCase();
  }

  bool isUpperCase() {
    return this == toUpperCase();
  }

  bool isNumeric() {
    return double.tryParse(this) != null;
  }

  bool isInteger() {
    final number = int.tryParse(this);
    return number != null && !contains('.');
  }

  bool isDouble() {
    return double.tryParse(this) != null;
  }

  bool isNotEmpty() {
    return this.isNotEmpty;
  }

  bool isURL() => startsWith('https://') || startsWith('http://');

  Uri toUri() {
    return Uri.parse(this);
  }

  bool isValidDate() {
    final dateRegExp = RegExp(
        r'^(0?[1-9]|1[012])[- /.](0?[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d$');
    return dateRegExp.hasMatch(this);
  }
}
