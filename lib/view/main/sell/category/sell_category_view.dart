import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:list_and_life/widgets/image_view.dart';

import '../../../../helpers/db_helper.dart';
import '../../../../network/api_constants.dart';
import '../../../../skeletons/sell_loading_widget.dart';
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
          ? const UnauthorisedView()
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
                  FutureBuilder<List<CategoryModel>>(
                      future: viewModel.getCategoryListApi(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<CategoryModel> categoryData =
                              snapshot.data ?? [];
                          return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: categoryData.length,
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
                                        item: categoryData[index]);
                                  },
                                  child: Card(
                                    color: const Color(0xffFCFCFD),
                                    elevation: 0.3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ImageView.rect(
                                            image:
                                                "${ApiConstants.imageUrl}/${categoryData[index].image}",
                                            height: 50,
                                            placeholder:
                                                AssetsRes.IC_IMAGE_PLACEHOLDER,
                                            width: 50,
                                          ),
                                          const SizedBox(
                                            height: 13,
                                          ),
                                          Text(
                                            categoryData[index].name ?? '',
                                            textAlign: TextAlign.center,
                                            style: context.textTheme.titleSmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                        if (snapshot.hasError) {
                          return const AppErrorWidget();
                        }
                        return SellLoadingWidget(
                          isLoading: snapshot.connectionState ==
                              ConnectionState.waiting,
                        );
                      })
                ],
              ),
            ),
    );
  }
}
