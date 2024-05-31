import 'package:geolocator/geolocator.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/location_helper.dart';
import 'package:list_and_life/res/assets_res.dart';

import '../models/setting_item_model.dart';

class HomeVM extends BaseViewModel {
  String _currentLocation = "";

  String get currentLocation => _currentLocation;

  List<SettingItemModel> categoryItems = [];

  List<SettingItemModel> homeItemList = [];

  set currentLocation(String value) {
    _currentLocation = value;
    notifyListeners();
  }

  void initCategories() {
    categoryItems = [
      SettingItemModel(icon: AssetsRes.IC_CAT_CAR, title: 'Cars', onTap: () {}),
      SettingItemModel(
          icon: AssetsRes.IC_CAT_MOBILE, title: 'Mobile', onTap: () {}),
      SettingItemModel(
          icon: AssetsRes.IC_CAT_LAPTOP, title: 'Laptops', onTap: () {}),
      SettingItemModel(
          icon: AssetsRes.IC_CAT_FURNITURE, title: 'Furniture', onTap: () {}),
      SettingItemModel(
          icon: AssetsRes.IC_CAT_CLOTHS, title: 'Clothes', onTap: () {}),
    ];
    homeItemList = [
      SettingItemModel(
          imageList: [
            AssetsRes.DUMMY_IPHONE_IMAGE1,
            AssetsRes.DUMMY_IPHONE_IMAGE2,
            AssetsRes.DUMMY_IPHONE_IMAGE3,
            AssetsRes.DUMMY_IPHONE_IMAGE4,
          ],
          title: 'EGP300',
          subTitle: 'Apple iPhone 15 Pro',
          description:
              'Open Box iPhone 15 & 14 Plus Pro Max 128GB 256GB 512GB 1TB Warranty 76',
          location: 'New York City',
          timeStamp: 'Today',
          longDescription:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
      SettingItemModel(
          imageList: [
            AssetsRes.DUMMY_CAR_IMAGE1,
            AssetsRes.DUMMY_CAR_IMAGE2,
            AssetsRes.DUMMY_CAR_IMAGE3,
            AssetsRes.DUMMY_CAR_IMAGE4,
          ],
          title: 'EGP300',
          subTitle: 'Maruti Suzuki Swift 1.2 VXI (O), 2015, Petrol',
          description: '2015 - 48000 km',
          location: 'New York City',
          timeStamp: 'Today',
          longDescription:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
    ];
  }

  Future<String> updateLocation() async {
    Position position = await LocationHelper.getCurrentLocation();
    currentLocation = await LocationHelper.getAddressFromCoordinates(
        position.latitude, position.longitude);
    return currentLocation;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    initCategories();
    super.onInit();
  }
}
