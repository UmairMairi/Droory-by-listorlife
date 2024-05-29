import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/view/main/sell/car/choose_location_view.dart';

import '../../../../view_model/sell_v_m.dart';
import '../forms/sell_form_view.dart';

class SellSubSubCategoryView extends StatelessWidget {
  final Item? category;
  final String? type;
  final Item? subCategory;
  const SellSubSubCategoryView(
      {super.key, this.subCategory, required this.category, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subCategory?.title ?? ''),
      ),
      body: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemBuilder: (context, index) {
            return ListTile(
              onTap: ()
              {
                print(subCategory?.title);
                if(subCategory?.title == 'Cars'){
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>const ChooseLocationView()));
                  return;
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SellFormView(
                              category: category,
                              brands:
                                  subCategory?.subCategories?[index].brands ??
                                      [],
                              subCategory: subCategory,
                              type: type,
                            )));
              },
              title: Text(
                subCategory?.subCategories?[index].title ?? '',
                style: context.textTheme.titleSmall,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: subCategory?.subCategories?.length ?? 0),
    );
  }
}
