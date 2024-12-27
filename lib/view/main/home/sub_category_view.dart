import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/view_model/home_vm.dart';

import '../../../models/filter_model.dart';
import '../../../routes/app_routes.dart';
import '../../../skeletons/sub_category_loading_widget.dart';
import '../../../widgets/app_error_widget.dart';

class SubCategoryView extends BaseView<HomeVM> {
  final CategoryModel? category;
  const SubCategoryView({super.key, this.category});

  @override
  Widget build(BuildContext context, HomeVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category?.name ?? ''),
        centerTitle: true,
      ),
      body: FutureBuilder<List<CategoryModel>>(
          future: viewModel.getSubCategoryListApi(category: category),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CategoryModel> subCategoriesList =
                  snapshot.data?.reversed.toList() ?? [];
              subCategoriesList.insert(0, CategoryModel(name: StringHelper.seeAll));
              return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        context.push(Routes.filterDetails,
                            extra: FilterModel(
                              categoryId: "${category?.id}",
                              subcategoryId: "${subCategoriesList[index].id??""}",
                              latitude: "${viewModel.latitude}",
                              longitude: "${viewModel.longitude}",
                            ));
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
