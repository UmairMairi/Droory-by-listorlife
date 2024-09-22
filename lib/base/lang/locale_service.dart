import 'dart:convert';
import 'package:flutter/services.dart';

class LocaleService {
  static Map<String, dynamic>? _localizedStrings;

  static Future<void> load(String locale) async {
    final jsonString = await rootBundle.loadString('assets/lang/$locale.json');
    _localizedStrings = jsonDecode(jsonString);
  }

  static String? translate(String key) {
    return _localizedStrings?[key];
  }
}
