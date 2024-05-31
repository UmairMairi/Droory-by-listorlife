import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/setting_item_model.dart';

class ActivePlanVM extends BaseViewModel {
  int selectedFeaturePlan = 0;
  int selectedBoosterPlan = -1;

  List<SettingItemModel> plansList = [
    SettingItemModel(
        title: 'Featured Ad\nfor 30 Days',
        subTitle: 'EGP 55.00',
        description: 'Reach up to 10 times\nmore buyers'),
    SettingItemModel(
        title: 'Featured Ad\nfor 07 Days',
        subTitle: 'EGP 150.00',
        description: 'Reach up to 4 times\nmore buyers'),
  ];
  List<SettingItemModel> boosterList = [
    SettingItemModel(
        title: 'Boost to top\n50 ads',
        subTitle: 'EGP 55.00',
        description: 'Reach up to 2 times\nmore buyers'),
    SettingItemModel(
        title: 'Boost to top\n10 ads',
        subTitle: 'EGP 55.00',
        description: 'Reach up to 2 times\nmore buyers'),
  ];

  void activateFeaturePlan(int index) {
    selectedFeaturePlan = index;
    selectedBoosterPlan = -1;
    notifyListeners();
  }

  void activateBoosterPlan(int index) {
    selectedFeaturePlan = -1;
    selectedBoosterPlan = index;
    notifyListeners();
  }
}
