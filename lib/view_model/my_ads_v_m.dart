import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';

import '../models/setting_item_model.dart';
import '../res/assets_res.dart';

class MyAdsVM extends BaseViewModel {
  List<SettingItemModel> favItemList = [
    SettingItemModel(
        imageList: [
          AssetsRes.DUMMY_IPHONE_IMAGE1,
          AssetsRes.DUMMY_IPHONE_IMAGE2,
          AssetsRes.DUMMY_IPHONE_IMAGE3,
          AssetsRes.DUMMY_IPHONE_IMAGE4,
        ],
        title: 'EGP300',
        subTitle: 'Apple iPhone 15 Pro',
        likes: '5',
        views: '10',
        description:
            'Open Box iPhone 15 & 14 Plus Pro Max 128GB 256GB 512GB 1TB Warranty 76',
        location: 'New York City',
        timeStamp: 'Today',
        isFav: true,
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
        likes: '5',
        views: '10',
        timeStamp: 'Today',
        isFav: true,
        longDescription:
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
  ];

  int _selectIndex = 0;

  int get selectIndex => _selectIndex;

  set selectIndex(int index) {
    _selectIndex = index;
    notifyListeners();
  }
}
