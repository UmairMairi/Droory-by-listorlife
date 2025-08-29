extension StringExtensions on String {
  bool isEmail() {
    final emailRegExp = RegExp(r'^[\w- \.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(this);
  }

  bool isNotEmail() {
    final emailRegExp = RegExp(r'^[\w- \.]+@([\w-]+\.)+[\w-]{2,4}$');
    return !emailRegExp.hasMatch(this);
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

  ///
  /// Replaces chars of the given String [s] with [replace].
  ///
  /// The default value of [replace] is *.
  /// [begin] determines the start of the 'replacing'. If [begin] is null, it starts from index 0.
  /// [end] defines the end of the 'replacing'. If [end] is null, it ends at [s] length divided by 2.
  /// If [s] is empty or consists of only 1 char, the method returns null.
  ///
  /// Example :
  /// 1234567890 => *****67890
  /// 1234567890 with begin 2 and end 6 => 12****7890
  /// 1234567890 with begin 1 => 1****67890
  ///
  String? hidePartial({int begin = 0, int? end, String replace = '*'}) {
    final buffer = StringBuffer();
    if (length <= 1) {
      return null;
    }
    if (end == null) {
      end = (length / 2).round();
    } else {
      if (end > length) {
        end = length;
      }
    }
    for (var i = 0; i < length; i++) {
      if (i >= end) {
        buffer.write(String.fromCharCode(runes.elementAt(i)));
        continue;
      }
      if (i >= begin) {
        buffer.write(replace);
        continue;
      }
      buffer.write(String.fromCharCode(runes.elementAt(i)));
    }
    return buffer.toString();
  }

  /// from 'foo' to 'Foo'
  String get capitalized => this[0].toUpperCase() + substring(1);
}
