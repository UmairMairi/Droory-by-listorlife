import 'package:flutter/material.dart';
import 'package:list_and_life/view_model/on_boarding_vm.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../view_model/auth_vm.dart';
import '../view_model/chat_vm.dart';
import '../view_model/home_vm.dart';
import '../view_model/main_vm.dart';
import '../view_model/profile_vm.dart';
import '../view_model/setting_v_m.dart';

class Providers {
  static List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider(create: (BuildContext context) => MainVM()),
      ChangeNotifierProvider(create: (BuildContext context) => OnBoardingVM()),
      ChangeNotifierProvider(create: (BuildContext context) => AuthVM()),
      ChangeNotifierProvider(create: (BuildContext context) => ProfileVM()),
      ChangeNotifierProvider(create: (BuildContext context) => SettingVM()),
      ChangeNotifierProvider(create: (BuildContext context) => HomeVM()),
      ChangeNotifierProvider(create: (BuildContext context) => ChatVM()),
    ];
  }
}
