import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/view/main/sell/forms/common_sell_form.dart';
import 'package:list_and_life/view_model/sell_v_m.dart';

import '../../../../helpers/image_picker_helper.dart';
import '../../../../view_model/mobile_sell_v_m.dart';
import '../../../../widgets/app_map_widget.dart';
import 'job_sell_form.dart';
import 'post_added_final_view.dart';

class SellFormView extends BaseView<SellFormsVM> {
  final String? type;
  final Item? category;
  final Item? subCategory;
  final List<String>? brands;
  const SellFormView(
      {super.key,
      required this.category,
      required this.subCategory,
        required this.brands,
      required this.type});

  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Include some details'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch(type){
      case 'jobs':
        return JobSellForm(type: type, category: category, brands: brands, subCategory: subCategory,);
      default:
        return CommonSellForm(type: type, category: category, brands: brands, subCategory: subCategory,);
    }
  }
}
