import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';

import '../../../../helpers/db_helper.dart';
import '../../../../view_model/sell_v_m.dart';
import '../../../../widgets/unauthorised_view.dart';

class SellCategoryView extends BaseView<SellVM> {
  const SellCategoryView({super.key});

  @override
  Widget build(BuildContext context, SellVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell'),
        centerTitle: true,
      ),
      body: DbHelper.getIsGuest()
          ? UnauthorisedView()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                children: [
                  Text(
                    "What are you offering?",
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.categoryData.length,
                      padding: const EdgeInsets.only(bottom: 50),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15.0,
                              mainAxisSpacing: 15.0,
                              mainAxisExtent: 130),
                      itemBuilder: (buildContext, index) {
                        return GestureDetector(
                          onTap: () {
                            viewModel.handelSellCat(
                                item: viewModel.categoryData[index]);
                          },
                          child: Card(
                            color: const Color(0xffFCFCFD),
                            elevation: 0.3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    viewModel.categoryData[index].image ?? '',
                                    height: 38,
                                    width: 46,
                                  ),
                                  const SizedBox(
                                    height: 13,
                                  ),
                                  Text(
                                    viewModel.categoryData[index].title ?? '',
                                    textAlign: TextAlign.center,
                                    style: context.textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                ],
              ),
            ),
    );
  }
}
