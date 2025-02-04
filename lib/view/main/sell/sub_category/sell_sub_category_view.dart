import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
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
  @override
  void initState() {
    viewModel = context.read<SellVM>();
    viewModel.getSubCategoryListApi(category: widget.category);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category?.name ?? ''),
        centerTitle: true,
      ),
      body: StreamBuilder<List<CategoryModel>>(
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
