import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/view_model/sell_forms_vm.dart';
import 'package:provider/provider.dart';

import '../forms/sell_form_view.dart';

class SellSubSubCategoryView extends StatelessWidget {
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final List<CategoryModel>? subSubCategory;
  const SellSubSubCategoryView({
    super.key,
    required this.category,
    this.subSubCategory,
    this.subCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subCategory?.name ?? ''),
      ),
      body: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                context.read<SellFormsVM>().allModels.clear();
                if (subSubCategory?[index].name?.contains('Parts') ?? false) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellFormView(
                                category: category,
                                subCategory: subCategory,
                                subSubCategory: subSubCategory?[index],
                                type: 'abcd',
                              )));
                  return;
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SellFormView(
                              category: category,
                              subSubCategory: subSubCategory?[index],
                              subCategory: subCategory,
                              type: category?.name?.toLowerCase(),
                            )));
              },
              title: Text(
                subSubCategory?[index].name ?? '',
                style: context.textTheme.titleSmall,
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
