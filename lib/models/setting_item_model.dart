import 'package:flutter/material.dart';

class SettingItemModel {
  final String? icon;

  final List<String>? imageList;
  final bool? isArrow;
  final bool? isFav;
  final String? title;
  final String? subTitle;
  final String? description;
  final String? longDescription;
  final String? location;
  final String? timeStamp;
  final VoidCallback? onTap;
  final String? likes;
  final String? views;
  SettingItemModel(
      {this.icon,
      this.title,
      this.isFav,
      this.subTitle,
      this.description,
      this.longDescription,
      this.location,
      this.timeStamp,
      this.onTap,
      this.imageList,
      this.likes,
      this.views,
      this.isArrow = false});
}
