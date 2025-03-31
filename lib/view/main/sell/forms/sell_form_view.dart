import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/view/main/sell/forms/cars_sell_form.dart';
import 'package:list_and_life/view/main/sell/forms/common_sell_form.dart';
import 'package:list_and_life/view/main/sell/forms/pets_sell_form.dart';
import 'package:list_and_life/view/main/sell/forms/property_sell_form.dart';
import 'package:list_and_life/view/main/sell/forms/vehicles_sell_form.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:provider/provider.dart';

import '../../../../base/helpers/string_helper.dart';
import '../../../../base/network/api_constants.dart';
import '../../../../base/network/api_request.dart';
import '../../../../base/network/base_client.dart';
import '../../../../models/common/list_response.dart';
import '../../../../models/product_detail_model.dart';
import '../../../../skeletons/sell_form_skeleton.dart';
import '../../../../view_model/sell_forms_vm.dart';
import 'education_sell_form.dart';
import 'job_sell_form.dart';

class SellFormView extends StatefulWidget {
  final String? type;
  final String? screenType;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final ProductDetailModel? item;

  const SellFormView({
    super.key,
    required this.category,
    required this.subCategory,
    this.subSubCategory,
    this.screenType,
    this.item,
    required this.type,
  });

  @override
  State<SellFormView> createState() => _SellFormViewState();
}

class _SellFormViewState extends State<SellFormView> {
  @override
  void initState() {
    log("${widget.type}", name: "SellFormView");
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      context.read<SellFormsVM>().updateTextFieldsItems(item: widget.item);
    });
    super.initState();
  }

  Future<List<CategoryModel>> getBrands({CategoryModel? data}) async {
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.getBrandsUrl(id: "${data?.id}"),
      requestType: RequestType.get,
    );
    var response = await BaseClient.handleRequest(apiRequest);
    ListResponse<CategoryModel> model =
        ListResponse.fromJson(response, (json) => CategoryModel.fromJson(json));
    return model.body ?? [];
  }

  Future<List<CategoryModel>> getSizes({CategoryModel? data}) async {
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.getFashionSizeUrl(id: "${data?.id}"),
      requestType: RequestType.get,
    );
    var response = await BaseClient.handleRequest(apiRequest);
    ListResponse<CategoryModel> model =
        ListResponse.fromJson(response, (json) => CategoryModel.fromJson(json));
    return model.body ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.type != 'real estate'
          ? AppBar(
              title: Text(StringHelper.includeSomeDetails),
            )
          : null,
      body: FutureBuilder<List<List<CategoryModel>>>(
        future: Future.wait([
          getBrands(data: widget.subCategory),
          getSizes(data: widget.subSubCategory),
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final brands = snapshot.data![0];
            final sizes = snapshot.data![1];
            return _buildBody(context, brands, sizes);
          }
          if (snapshot.hasError) {
            return const AppErrorWidget();
          }
          return SellFormSkeleton(
            isLoading: snapshot.connectionState == ConnectionState.waiting,
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<CategoryModel>? brands,
      List<CategoryModel>? sizes) {
    debugPrint(" widget.type ${widget.type}");
    switch (widget.type) {
      case 'jobs':
        return JobSellForm(
          type: widget.type,
          category: widget.category,
          subSubCategory: widget.subSubCategory,
          brands: brands,
          // sizes: sizes,
          subCategory: widget.subCategory,
          item: widget.item,
        );
      case 'services':
        if (widget.subCategory?.type == 'services') {
          return EducationSellForm(
            type: widget.type,
            category: widget.category,
            subSubCategory: widget.subSubCategory,
            brands: brands,
            // sizes: sizes,
            subCategory: widget.subCategory,
            item: widget.item,
          );
        }
        return PetsSellForm(
          type: widget.type,
          category: widget.category,
          subSubCategory: widget.subSubCategory,
          brands: brands,
          sizes: sizes,
          item: widget.item,
          subCategory: widget.subCategory,
        );
      case 'pets':
        return PetsSellForm(
          type: widget.type,
          category: widget.category,
          brands: brands,
          sizes: sizes,
          subSubCategory: widget.subSubCategory,
          subCategory: widget.subCategory,
          item: widget.item,
        );
      case 'vehicles':
        if (widget.subCategory?.type?.toLowerCase().contains('parts') ??
            false) {
          return CommonSellForm(
            type: widget.type,
            category: widget.category,
            subSubCategory: widget.subSubCategory,
            brands: brands,
            sizes: sizes,
            subCategory: widget.subCategory,
            item: widget.item,
          );
        }
        if (widget.subCategory?.type?.toLowerCase().contains('cars') ?? false) {
          return CarsSellForm(
            type: widget.type,
            category: widget.category,
            subSubCategory: widget.subSubCategory,
            brands: brands,
            // sizes: sizes,
            subCategory: widget.subCategory,
            item: widget.item,
          );
        }
        return VehiclesSellForm(
          type: widget.type,
          category: widget.category,
          subSubCategory: widget.subSubCategory,
          brands: brands,
          // sizes: sizes,
          subCategory: widget.subCategory,
          item: widget.item,
        );
      case 'real estate':
        if (widget.screenType != null) {
          return PropertySellForm(
            type: widget.type,
            category: widget.category,
            subSubCategory: widget.subSubCategory,
            brands: brands,
            subCategory: widget.subCategory,
            item: widget.item,
          );
        }
        return PropertyType(
          type: widget.type,
          category: widget.category,
          subSubCategory: widget.subSubCategory,
          brands: brands,
          subCategory: widget.subCategory,
          item: widget.item,
        );
      default:
        return CommonSellForm(
          type: widget.type,
          category: widget.category,
          subSubCategory: widget.subSubCategory,
          brands: brands,
          sizes: sizes,
          item: widget.item,
          subCategory: widget.subCategory,
        );
    }
  }
}
