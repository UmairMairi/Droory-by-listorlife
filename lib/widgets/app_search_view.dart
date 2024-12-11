import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/widgets/app_empty_widget.dart';
import 'package:list_and_life/widgets/app_loading_widget.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/common_grid_view.dart';

import '../base/helpers/db_helper.dart';
import '../models/common/list_response.dart';
import '../models/search_item_model.dart';
import '../res/assets_res.dart';
import '../routes/app_routes.dart';
import 'app_product_item_widget.dart';
import 'image_view.dart';

class AppSearchView extends StatefulWidget {
  final String? value;
  const AppSearchView({super.key, this.value});

  @override
  State<AppSearchView> createState() => _AppSearchViewState();
}

class _AppSearchViewState extends State<AppSearchView> {

  final StreamController<List<SearchHistoryModel>?> _searchHistoryStreamController =
      StreamController<List<SearchHistoryModel>?>();

  final StreamController<List<ProductDetailModel>?> _productStreamController =
      StreamController<List<ProductDetailModel>?>();
  final StreamController<List<CategoryModel?>> _categoryStreamController =
      StreamController<List<CategoryModel?>>();
  Timer? _debounce;
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    textEditingController.text = widget.value ?? '';

    searchItem(text: widget.value ?? '');
    if(!DbHelper.getIsGuest()){
      getSearches();
    }
    super.initState();
  }

  Future<void> searchItem({required String text}) async {
    if (text.isEmpty) {
      _categoryStreamController.add([]);
      _productStreamController.add([]);
      return;
    }
    try {
      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getSearchProductUrl(search: text),
        requestType: RequestType.get,
      );

      var response = await BaseClient.handleRequest(apiRequest);
      MapResponse<SearchItemModel> model = MapResponse.fromJson(
          response, (json) => SearchItemModel.fromJson(json));

      _productStreamController
          .add(model.body?.products ?? []); // Send data to stream if found
      _categoryStreamController
          .add(model.body?.categories ?? []); // Send data to stream if found
    } catch (e) {
      _productStreamController.addError("Failed to fetch search results.");
    }
  }

  Future<void> getSearches() async {
    try {
      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getSearchesUrl(),
        requestType: RequestType.get,
      );

      var response = await BaseClient.handleRequest(apiRequest);
      ListResponse<SearchHistoryModel> model = ListResponse.fromJson(
          response, (json) => SearchHistoryModel.fromJson(json));
      _searchHistoryStreamController.add(model.body ?? []);
    } catch (e) {
      _searchHistoryStreamController.addError("Failed to fetch search results.");
    }
  }

  Future<void> storeSearches({dynamic id,dynamic name,dynamic type}) async {
    Map<String,dynamic> body = {
      "id": id,
      "name":name,
      "type":type
    };
    try {
      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.storeSearchesUrl(),
        requestType: RequestType.post,
        body: {"obj":jsonEncode(body)},
      );
      var response = await BaseClient.handleRequest(apiRequest);
      MapResponse<Object> model = MapResponse.fromJson(
          response, (json) => SearchItemModel.fromJson(json));
      if(model.body!=null){
        getSearches();
      }
    } catch (e) {
     debugPrint("Failed to fetch search results.");
    }
  }

  Future<void> deleteSearches({dynamic searchId}) async {
    Map<String,dynamic> body = {};
    if(searchId !=null){
      body["search_id"] = searchId;
    }

    try {
      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.deleteSearchesUrl(),
        requestType: RequestType.get,
      );
      var response = await BaseClient.handleRequest(apiRequest);
      MapResponse<Object> model = MapResponse.fromJson(
          response, (json) => SearchItemModel.fromJson(json));
      if(model.body!=null){
        getSearches();
      }
    } catch (e) {
     debugPrint("Failed to fetch search results.");
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _productStreamController
        .close(); // Close the stream controller to prevent memory leaks
    _categoryStreamController.close();
    _searchHistoryStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTextField(
          controller: textEditingController,
          onChanged: (String data) {
            if (_debounce?.isActive ?? false) _debounce?.cancel();

            // Set a new debounce timer
            _debounce = Timer(const Duration(milliseconds: 300), () {
              searchItem(
                  text: data); // Trigger search after debounce delay
            });
          },
          prefix: Icon(Icons.search),
          validator: (value) {
            return null;
          },
          hint: "Search...",
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ListTile(
            //   leading: GestureDetector(
            //     onTap: () => Navigator.pop(context),
            //     child: Icon(Icons.arrow_back_ios),
            //   ),
            //   title: AppTextField(
            //     controller: textEditingController,
            //     onChanged: (String data) {
            //       if (_debounce?.isActive ?? false) _debounce?.cancel();
            //
            //       // Set a new debounce timer
            //       _debounce = Timer(const Duration(milliseconds: 300), () {
            //         searchItem(
            //             text: data); // Trigger search after debounce delay
            //       });
            //     },
            //     prefix: Icon(Icons.search),
            //     validator: (value) {
            //       return null;
            //     },
            //     hint: "Search...",
            //   ),
            // ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    searchHistoryWidget(context),
                    searchedDataWidget(context)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  searchedDataWidget(BuildContext context){
    return StreamBuilder<List<CategoryModel?>>(
      stream: _categoryStreamController.stream,
      builder: (context, categorySnapshot) {
        return StreamBuilder<List<ProductDetailModel>?>(
          stream: _productStreamController.stream,
          builder: (context, productSnapshot) {
            return _buildStreamState(context, categorySnapshot, productSnapshot);
          },
        );
      },
    );
  }

  Widget _buildStreamState(
      BuildContext context,
      AsyncSnapshot<List<CategoryModel?>> categorySnapshot,
      AsyncSnapshot<List<ProductDetailModel>?> productSnapshot,
      ) {
    if (categorySnapshot.connectionState == ConnectionState.waiting ||
        productSnapshot.connectionState == ConnectionState.waiting) {
      return AppLoadingWidget(); // Show loading widget
    }

    if (categorySnapshot.hasError || productSnapshot.hasError) {
      return Center(
        child: Text("Error loading data", style: TextStyle(color: Colors.red)),
      );
    }

    final categories = categorySnapshot.data ?? [];
    final products = productSnapshot.data ?? [];

    if (categories.isEmpty && products.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppEmptyWidget(),
          Text("No results found."),
        ],
      );
    }

    return Column(
      children: [
        categoryWidget(context, categories),
        SizedBox(height: 20,),
        productWidget(context, products),
      ],
    );
  }

  Widget oldData(BuildContext context, List<CategoryModel?> categories, List<ProductDetailModel> products) {
     return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: categories.length + products.length,
      itemBuilder: (context, index) {
        if (index < categories.length) {
          final category = categories[index];
          return ListTile(
            leading: Icon(Icons.search),
            title: Text(category?.name ?? "No name"),
            onTap: () {
              Navigator.pop(context, category);
            },
          );
        } else {
          final product = products[index - categories.length];
          return ListTile(
            leading: Icon(Icons.search),
            title: Text(product.name ?? "No name"),
            onTap: () {
              Navigator.pop(context, product);
            },
          );
        }
      },
    );
  }

  Widget categoryWidget(BuildContext context, List<CategoryModel?> categories,) {
    return CommonGridView(
        shrinkWrap: true,
        mainAxisExtent: 90,
        crossAxisCount: 3,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categories.length, itemBuilder: (context,index){
      final category = categories[index];
      return GestureDetector(
        onTap: () {
          if(!DbHelper.getIsGuest()){
            storeSearches(
                id: category?.id,
                name: DbHelper.getLanguage() == 'en'
                ? category?.name ?? ''
                : category?.nameAr ?? '',
              type: "category"
            );
          }
          context.push(Routes.subCategoryView,
              extra: category);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
          CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white70,
              radius: 30,
              child: ImageView.rect(
                image:
                "${ApiConstants.imageUrl}/${category?.image??""}",
                height: 35,
                placeholder:
                AssetsRes.IC_IMAGE_PLACEHOLDER,
                width: 35,
                fit: BoxFit.contain,
              ),
            ),
            const Gap(10),
            Text(
              DbHelper.getLanguage() == 'en'
                  ? category?.name ?? ''
                  : category?.nameAr ?? '',
              style: context.textTheme.labelSmall
                  ?.copyWith(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    });
  }

  Widget productWidget(BuildContext context, List<ProductDetailModel> products) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            if(!DbHelper.getIsGuest()){
              storeSearches(
                  id: product.id,
                  name: product.name ?? '',
                  type: "product"
              );
            }
            if (product.userId ==
                DbHelper.getUserModel()?.id) {
              context.push(Routes.myProduct,
                  extra: product);
              return;
            }

            context.push(Routes.productDetails,
                extra: product);
          },
          child: AppProductItemWidget(
            data: product,
            onLikeTapped: () {
              if (product.isFavourite == 1) {
                product.isFavourite = 0;
                return;
              }
              product.isFavourite = 1;
            },
          ),
        );
      }, separatorBuilder: (BuildContext context, int index) {
      return const Gap(20);
    },
    );
  }

  searchHistoryWidget(context) {
    return StreamBuilder<List<SearchHistoryModel>?>(
      stream: _searchHistoryStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ) {
          return Container(); // Show loading widget
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error loading data"),
          );
        }

        final categories = snapshot.data ?? [];

        if (categories.isEmpty ) {
          return Container();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recent Search",
                  style: context.textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
                GestureDetector(
                  onTap: (){
                    deleteSearches();
                  },
                  child: Text("Clear All",
                    style: context.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
              spacing: 8.0,
              runSpacing: 8.0,
              children: categories.map(
                    (item) => Visibility(
                  visible: (item.searchData?.name??"").isNotEmpty,
                  child: GestureDetector(
                    onTap: (){
                      if(item.searchData?.type == "category"){
                        CategoryModel category = CategoryModel(id: item.searchData?.id,name: item.searchData?.name);
                        context.push(Routes.subCategoryView,
                            extra: category);
                        return;
                      }
                      if(item.searchData?.type == "product"){
                        ProductDetailModel product = ProductDetailModel(id: item.searchData?.id,name: item.searchData?.name);
                        if (item.userId == DbHelper.getUserModel()?.id) {
                          context.push(Routes.myProduct,
                              extra: product);
                          return;
                        }

                        context.push(Routes.productDetails,
                            extra: product);
                        return;
                      }
                    },
                    child: Chip(
                      label: Text(item.searchData?.name??"",
                        style: context.textTheme.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ).toList(),
            ),
          ],
        );
      },
    );
  }
}
