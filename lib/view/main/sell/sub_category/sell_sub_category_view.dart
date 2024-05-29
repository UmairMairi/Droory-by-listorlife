import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view/main/sell/forms/sell_form_view.dart';
import 'package:list_and_life/view/main/sell/mobile/mobile_category_view.dart';
import 'package:list_and_life/view/main/sell/sub_sub_category/sell_sub_sub_category_view.dart';

import '../../../../view_model/sell_v_m.dart';

class SellSubCategoryView extends StatelessWidget {
  final Item? category;
  const SellSubCategoryView({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category?.title ?? ''),
        centerTitle: true,
      ),
      body: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                if (category?.subCategories?[index].subCategories?.isNotEmpty ??
                    false) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellSubSubCategoryView(
                              category: category,
                              subCategory: category?.subCategories?[index])));
                  return;
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SellFormView(
                              category: category,
                              subCategory: category?.subCategories?[index],
                              type: index,
                            )));
              },
              title: Text(
                category?.subCategories?[index].title ?? '',
                style: context.textTheme.titleSmall,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: category?.subCategories?.length ?? 0),
    );
  }
}
