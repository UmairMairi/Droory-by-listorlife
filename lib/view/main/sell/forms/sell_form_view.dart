import 'package:flutter/material.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/view/main/sell/forms/cars_sell_form.dart';
import 'package:list_and_life/view/main/sell/forms/common_sell_form.dart';
import 'package:list_and_life/view/main/sell/forms/pets_sell_form.dart';
import 'package:list_and_life/view/main/sell/forms/vehicles_sell_form.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:provider/provider.dart';

import '../../../../base/helpers/string_helper.dart';
import '../../../../base/network/api_constants.dart';
import '../../../../base/network/api_request.dart';
import '../../../../base/network/base_client.dart';
import '../../../../models/common/list_response.dart';
import '../../../../models/prodect_detail_model.dart';
import '../../../../skeletons/sell_form_skeleton.dart';
import '../../../../view_model/sell_forms_vm.dart';
import 'education_sell_form.dart';
import 'job_sell_form.dart';

class SellFormView extends StatefulWidget {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final ProductDetailModel? item;

  const SellFormView(
      {super.key,
      required this.category,
      required this.subCategory,
      this.subSubCategory,
      this.item,
      required this.type});

  @override
  State<SellFormView> createState() => _SellFormViewState();
}

class _SellFormViewState extends State<SellFormView> {
  @override
  void initState() {
    context.read<SellFormsVM>().updateTextFieldsItems(item: widget.item);
    super.initState();
  }

  Future<List<CategoryModel>> getBrands({CategoryModel? data}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getBrandsUrl(id: "${data?.id}"),
        requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model =
        ListResponse.fromJson(response, (json) => CategoryModel.fromJson(json));

    return model.body ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.includeSomeDetails),
      ),
      body: FutureBuilder<List<CategoryModel>>(
          future: getBrands(data: widget.subCategory),
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
    switch (widget.type) {
      case 'jobs':
        return JobSellForm(
          type: widget.type,
          category: widget.category,
          subSubCategory: widget.subSubCategory,
          brands: brands,
          subCategory: widget.subCategory,
        );
      case 'services':
        if (widget.subCategory?.name == 'Education') {
          return EducationSellForm(
            type: widget.type,
            category: widget.category,
            subSubCategory: widget.subSubCategory,
            brands: brands,
            subCategory: widget.subCategory,
          );
        }
        return PetsSellForm(
          type: widget.type,
          category: widget.category,
          subSubCategory: widget.subSubCategory,
          brands: brands,
          item: widget.item,
          subCategory: widget.subCategory,
        );
      case 'pets':
        return PetsSellForm(
          type: widget.type,
          category: widget.category,
          brands: brands,
          subSubCategory: widget.subSubCategory,
          subCategory: widget.subCategory,
        );

      case 'vehicles':
        if (widget.subCategory?.name?.toLowerCase().contains('parts') ??
            false) {
          return CommonSellForm(
            type: widget.type,
            category: widget.category,
            subSubCategory: widget.subSubCategory,
            brands: brands,
            subCategory: widget.subCategory,
          );
        }
        if (widget.subCategory?.name?.toLowerCase().contains('cars') ?? false) {
          return CarsSellForm(
            type: widget.type,
            category: widget.category,
            subSubCategory: widget.subSubCategory,
            brands: brands,
            subCategory: widget.subCategory,
          );
        }

        return VehiclesSellForm(
          type: widget.type,
          category: widget.category,
          subSubCategory: widget.subSubCategory,
          brands: brands,
          subCategory: widget.subCategory,
        );
      default:
        return CommonSellForm(
          type: widget.type,
          category: widget.category,
          subSubCategory: widget.subSubCategory,
          brands: brands,
          item: widget.item,
          subCategory: widget.subCategory,
        );
    }
  }
}
