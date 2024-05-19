import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/setting_item_model.dart';

class ActivePlanVM extends BaseViewModel {
  List<SettingItemModel> plansList = [
    SettingItemModel(title: 'Featured Ad for 30 Days', subTitle: 'EGP55.00'),
    SettingItemModel(title: 'Featured Ad for 07 Days', subTitle: 'EGP150.00'),
  ];
  List<SettingItemModel> boosterList = [
    SettingItemModel(title: 'Boost to top 50 ads', subTitle: 'EGP55.00'),
    SettingItemModel(title: 'Boost to top 10 ads', subTitle: 'EGP55.00'),
  ];
}
