import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/skeletons/sub_category_loading_widget.dart';
import 'package:list_and_life/view/main/sell/forms/sell_form_view.dart';
import 'package:list_and_life/view/main/sell/sub_sub_category/sell_sub_sub_category_view.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/mobile_sell_v_m.dart';
import '../../../../view_model/sell_v_m.dart';

class SellSubCategoryView extends BaseView<SellVM> {
  final CategoryModel? category;
  const SellSubCategoryView({super.key, this.category});

  @override
  Widget build(BuildContext context, SellVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category?.name ?? ''),
        centerTitle: true,
      ),
      body: FutureBuilder<List<CategoryModel>>(
          future: viewModel.getSubCategoryListApi(category: category),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CategoryModel> subCategoriesList = snapshot.data ?? [];

              return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        subCategoriesList[index].name ?? '',
                        style: context.textTheme.titleSmall,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
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
