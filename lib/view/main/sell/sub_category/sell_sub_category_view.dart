import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/filter_cache_manager.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/skeletons/sub_category_loading_widget.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/sell_v_m.dart';

class SellSubCategoryView extends StatefulWidget {
  final CategoryModel? category;
  const SellSubCategoryView({super.key, this.category});

  @override
  State<SellSubCategoryView> createState() => _SellSubCategoryViewState();
}

class _SellSubCategoryViewState extends State<SellSubCategoryView> {
  late SellVM viewModel;
  final FilterCacheManager _cacheManager = FilterCacheManager();
  List<CategoryModel>? _initialData;

  @override
  void initState() {
    viewModel = context.read<SellVM>();
    _loadInitialData();
    super.initState();
  }

  void _loadInitialData() {
    // Check cache immediately for initial data
    String cacheKey =
        _cacheManager.getSubCategoriesKey("${widget.category?.id}");
    _initialData = _cacheManager.getFromCache(cacheKey);

    // This will check cache first before making API call
    viewModel.getSubCategoryListApi(category: widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category?.name ?? ''),
        centerTitle: true,
      ),
      body: StreamBuilder<List<CategoryModel>>(
          initialData: _initialData, // Add initial data from cache
          stream: viewModel.subcategoryStream.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CategoryModel> subCategoriesList =
                  snapshot.data?.reversed.toList() ?? [];

              return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        DialogHelper.showLoading();
                        viewModel.getSubSubCategoryListApi(
                            context: context,
                            category: widget.category,
                            subCategory: subCategoriesList[index]);
                      },
                      title: Text(
                        subCategoriesList[index].name ?? '',
                        style: context.textTheme.titleSmall,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: subCategoriesList.length);
            }
            if (snapshot.hasError) {
              return const AppErrorWidget();
            }
            return const SubCategoryLoadingWidget(
              isLoading: true,
            );
          }),
    );
  }
}
