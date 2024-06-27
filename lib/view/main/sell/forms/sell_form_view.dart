import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/view/main/sell/forms/common_sell_form.dart';
import 'package:list_and_life/view/main/sell/forms/pets_sell_form.dart';
import 'package:list_and_life/view/main/sell/forms/vehicles_sell_form.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';

import '../../../../skeletons/sell_form_skeleton.dart';
import '../../../../view_model/mobile_sell_v_m.dart';
import 'education_sell_form.dart';
import 'job_sell_form.dart';

class SellFormView extends BaseView<SellFormsVM> {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;

  const SellFormView(
      {super.key,
      required this.category,
      required this.subCategory,
      this.subSubCategory,
      required this.type});

  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Include some details'),
      ),
      body: FutureBuilder<List<CategoryModel>>(
          future: viewModel.getBrands(data: subCategory),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildBody(context, snapshot.data ?? []);
            }
            if (snapshot.hasError) {
              return const AppErrorWidget();
            }
            return SellFormSkeleton(
              isLoading: snapshot.connectionState == ConnectionState.waiting,
            );
          }),
    );
  }

  Widget _buildBody(BuildContext context, List<CategoryModel>? brands) {
    print(type);
    switch (type) {
      case 'jobs':
        return JobSellForm(
          type: type,
          category: category,
          subSubCategory: subSubCategory,
          brands: brands,
          subCategory: subCategory,
        );
      case 'services':
        if (subCategory?.name == 'Education') {
          return EducationSellForm(
            type: type,
            category: category,
            subSubCategory: subSubCategory,
            brands: brands,
            subCategory: subCategory,
          );
        }
        return PetsSellForm(
          type: type,
          category: category,
          subSubCategory: subSubCategory,
          brands: brands,
          subCategory: subCategory,
        );
      case 'pets':
        return PetsSellForm(
          type: type,
          category: category,
          brands: brands,
          subSubCategory: subSubCategory,
          subCategory: subCategory,
        );

      case 'vehicles':
        if (subCategory?.name?.contains('Parts') ?? false) {
          return CommonSellForm(
            type: type,
            category: category,
            subSubCategory: subSubCategory,
            brands: brands,
            subCategory: subCategory,
          );
        }

        return VehiclesSellForm(
          type: type,
          category: category,
          subSubCategory: subSubCategory,
          brands: brands,
          subCategory: subCategory,
        );
      default:
        return CommonSellForm(
          type: type,
          category: category,
          subSubCategory: subSubCategory,
          brands: brands,
          subCategory: subCategory,
        );
    }
  }
}
