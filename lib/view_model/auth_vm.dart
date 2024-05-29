import 'package:ccp_dialog/country_picker/flutter_country_picker.dart';
import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';

class AuthVM extends BaseViewModel {
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController otpTextController = TextEditingController();

  final FocusNode nodeText = FocusNode();

  String countryCode = "+91";
  Country selectedCountry = Country.IN;

  void updateCountry(Country country) {
    selectedCountry = country;
    countryCode = "+${country.dialingCode}";
    notifyListeners();
  }
}
