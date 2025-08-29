import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/filter_cache_manager.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../../base/helpers/db_helper.dart';
import '../../../../base/helpers/string_helper.dart';
import '../../../../base/network/api_constants.dart';
import '../../../../routes/app_routes.dart';
import '../../../../skeletons/sell_loading_widget.dart';
import '../../../../view_model/profile_vm.dart';
import '../../../../view_model/sell_v_m.dart';
import '../../../../view_model/home_vm.dart';
import '../../../../widgets/unauthorised_view.dart';

class SellCategoryView extends StatefulWidget {
  const SellCategoryView({super.key});

  @override
  State<SellCategoryView> createState() => _SellCategoryViewState();
}

class _SellCategoryViewState extends State<SellCategoryView> {
  final FilterCacheManager _cacheManager = FilterCacheManager();

  Future<List<CategoryModel>> _getCachedCategories() async {
    // Check cache first
    List<CategoryModel>? cachedCategories =
        _cacheManager.getFromCache(_cacheManager.categoriesKey);

    if (cachedCategories != null) {
      return cachedCategories;
    }

    // If not cached, fetch from HomeVM (which also caches)
    var homeVM = context.read<HomeVM>();
    return await homeVM.getCategoryListApi();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("DbHelper.getIsGuest() ${DbHelper.getIsGuest()}");
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.sell),
        centerTitle: true,
      ),
      body:  DbHelper.getIsGuest()
          ? UnauthorisedView(onSuccess: (){setState(() {});},)
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                children: [
                  Text(
                    StringHelper.whatAreYouOffering,
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<List<CategoryModel>>(
                      future: _getCachedCategories(),
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
                                    context.push(Routes.sellSubCategoryView, extra: categoryData[index]);
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
                        return const SellLoadingWidget(
                          isLoading: true,
                        );
                      })
                ],
              ),
            ),
    );
  }
}
