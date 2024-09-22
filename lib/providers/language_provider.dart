import 'package:flutter/material.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';

import '../base/helpers/string_helper.dart';
import '../base/lang/locale_service.dart';
import '../widgets/restart_widget.dart';

class LanguageProvider extends ChangeNotifier {
  Future<void> updateLanguage(
      {required BuildContext context, required String lang}) async {
    await LocaleService.load(lang); // Load default language
    DbHelper.saveLanguage(lang);
    StringHelper.refresh();
    notifyListeners();
    RestartWidget.restartApp(context);
  }
}
