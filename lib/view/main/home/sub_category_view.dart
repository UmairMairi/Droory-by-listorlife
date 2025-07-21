import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/view_model/home_vm.dart';
import 'package:list_and_life/base/helpers/filter_cache_manager.dart';
import 'package:provider/provider.dart';

import '../../../base/helpers/dialog_helper.dart';
import '../../../models/filter_model.dart';
import '../../../routes/app_routes.dart';
import '../../../skeletons/sub_category_loading_widget.dart';
import '../../../widgets/app_error_widget.dart';

class SubCategoryView extends BaseView<HomeVM> {
  final CategoryModel? category;
  const SubCategoryView({super.key, this.category});

  @override
  Widget build(BuildContext context, HomeVM viewModel) {
    return _SubCategoryWidget(category: category, viewModel: viewModel);
  }
}

class _SubCategoryWidget extends StatefulWidget {
  final CategoryModel? category;
  final HomeVM viewModel;

  const _SubCategoryWidget({required this.category, required this.viewModel});

  @override
  State<_SubCategoryWidget> createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<_SubCategoryWidget> {
  List<CategoryModel>? subCategories;
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSubCategories();
  }

  Future<void> _loadSubCategories() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final cacheManager = FilterCacheManager();
      String cacheKey =
          cacheManager.getSubCategoriesKey("${widget.category?.id}");

      // Check cache first
      List<CategoryModel>? cachedData = cacheManager.getFromCache(cacheKey);

      if (cachedData != null) {
        print("Using cached subcategories for category ${widget.category?.id}");
        if (mounted) {
          setState(() {
            subCategories = cachedData;
            isLoading = false;
          });
        }
        return;
      }

      // If not cached, fetch from API
      print(
          "Fetching subcategories from API for category ${widget.category?.id}");
      List<CategoryModel> data = await widget.viewModel
          .getSubCategoryListApi(category: widget.category);

      // Save to cache
      cacheManager.saveToCache(cacheKey, data);

      if (mounted) {
        setState(() {
          subCategories = data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading subcategories: $e");
      if (mounted) {
        setState(() {
          hasError = true;
          isLoading = false;
          errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category?.name ?? ''),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading) {
      return const SubCategoryLoadingWidget(isLoading: true);
    }

    if (hasError) {
      return const AppErrorWidget();
    }

    if (subCategories == null || subCategories!.isEmpty) {
      return const Center(
        child: Text('No subcategories found'),
      );
    }

    List<CategoryModel> displayList = subCategories!.reversed.toList();
    displayList.insert(0, CategoryModel(name: StringHelper.seeAll));

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            DialogHelper.showLoading();
            widget.viewModel.getSubSubCategoryListApi(
              category: widget.category,
              subCategory: displayList[index],
            );
          },
          title: Text(
            displayList[index].name ?? '',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: displayList.length,
    );
  }
}

class SubSubCategoryView extends StatelessWidget {
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final List<CategoryModel>? subSubCategory;

  final String? latitude;
  final String? longitude;
  const SubSubCategoryView({
    super.key,
    required this.category,
    this.subSubCategory,
    this.subCategory,
    this.latitude,
    this.longitude,
  });
  String _getTranslatedName(String name) {
    if (name == "Rent") {
      return StringHelper.rent;
    } else if (name == "Sell") {
      return StringHelper.sell;
    } else {
      return name; // Return original name for other categories
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subCategory?.name ?? ''),
      ),
      body: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemBuilder: (context, index) {
            var subSubCat = subSubCategory?[index];
            return ListTile(
              onTap: () {
                context.push(Routes.filterDetails,
                    extra: FilterModel(
                      categoryId: "${category?.id}",
                      subcategoryId: "${subCategory?.id ?? ""}",
                      subSubCategoryId: "${subSubCat?.id ?? ""}",
                      latitude: "$latitude",
                      longitude: "$longitude",
                      propertyFor: (subSubCat?.name == "Rent" ||
                              subSubCat?.name == "Sell")
                          ? subSubCat?.name
                          : "",
                    ));
              },
              title: Text(
                _getTranslatedName(subSubCat?.name ?? ''),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: subSubCategory?.length ?? 0),
    );
  }
}
