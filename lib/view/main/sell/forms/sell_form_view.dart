import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/view/main/sell/forms/common_sell_form.dart';
import 'package:list_and_life/view/main/sell/forms/pets_sell_form.dart';
import 'package:list_and_life/view/main/sell/forms/vehicles_sell_form.dart';
import 'package:list_and_life/view_model/sell_v_m.dart';

import '../../../../view_model/mobile_sell_v_m.dart';
import 'education_sell_form.dart';
import 'job_sell_form.dart';

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
    switch (type) {
      case 'jobs':
        return JobSellForm(
          type: type,
          category: category,
          brands: brands,
          subCategory: subCategory,
        );
      case 'services':
        print(subCategory?.title);
        if (subCategory?.title == 'Education') {
          return EducationSellForm(
            type: type,
            category: category,
            brands: brands,
            subCategory: subCategory,
          );
        }
        return PetsSellForm(
          type: type,
          category: category,
          brands: brands,
          subCategory: subCategory,
        );
      case 'pets':
        return PetsSellForm(
          type: type,
          category: category,
          brands: brands,
          subCategory: subCategory,
        );

      case 'vehicles':
        print(subCategory?.subCategories);
        if (subCategory?.title?.contains('Parts') ?? false) {
          return CommonSellForm(
            type: type,
            category: category,
            brands: brands,
            subCategory: subCategory,
          );
        }

        return VehiclesSellForm(
          type: type,
          category: category,
          brands: brands,
          subCategory: subCategory,
        );
      default:
        return CommonSellForm(
          type: type,
          category: category,
          brands: brands,
          subCategory: subCategory,
        );
    }
  }
}
