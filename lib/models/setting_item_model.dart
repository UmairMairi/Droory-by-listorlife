import 'package:flutter/material.dart';

class SettingItemModel {
  final String? icon;

  final List<String>? imageList;
  final bool? isArrow;
  final bool? isFav;
  final String? title;
  final String? subTitle;
  final String? description;
  final String? location;
  final String? timeStamp;
  final VoidCallback? onTap;
  SettingItemModel(
      {this.icon,
      this.title,
      this.isFav,
      this.subTitle,
      this.description,
      this.location,
      this.timeStamp,
      this.onTap,
      this.imageList,
      this.isArrow = false});
}
