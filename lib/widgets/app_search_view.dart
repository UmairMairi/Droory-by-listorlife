import 'dart:async';

import 'package:flutter/material.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/widgets/app_empty_widget.dart';
import 'package:list_and_life/widgets/app_loading_widget.dart';
import 'package:list_and_life/widgets/app_text_field.dart';

import '../models/search_item_model.dart';

class AppSearchView extends StatefulWidget {
  final String? value;
  const AppSearchView({super.key, this.value});

  @override
  State<AppSearchView> createState() => _AppSearchViewState();
}

class _AppSearchViewState extends State<AppSearchView> {
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

  @override
  void dispose() {
    _debounce?.cancel();
    _productStreamController
        .close(); // Close the stream controller to prevent memory leaks
    _categoryStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back),
              ),
              title: AppTextField(
                controller: textEditingController,
                onChanged: (String data) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();

                  // Set a new debounce timer
                  _debounce = Timer(const Duration(milliseconds: 300), () {
                    searchItem(
                        text: data); // Trigger search after debounce delay
                  });
                },
                prefix: Icon(Icons.search),
                validator: (value) {},
                hint: "Search...",
              ),
            ),
            Expanded(
              child: StreamBuilder<List<CategoryModel?>>(
                stream: _categoryStreamController.stream,
                builder: (context, categorySnapshot) {
                  return StreamBuilder<List<ProductDetailModel>?>(
                    stream: _productStreamController.stream,
                    builder: (context, productSnapshot) {
                      if (categorySnapshot.connectionState ==
                              ConnectionState.waiting ||
                          productSnapshot.connectionState ==
                              ConnectionState.waiting) {
                        return AppLoadingWidget(); // Show loading widget
                      }
                      if (categorySnapshot.hasError ||
                          productSnapshot.hasError) {
                        return Center(
                          child: Text("Error loading data"),
                        );
                      }

                      final categories = categorySnapshot.data ?? [];
                      final products = productSnapshot.data ?? [];

                      if (categories.isEmpty && products.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppEmptyWidget(),
                              Text("No results found."),
                            ],
                          ),
                        );
                      }

                      // Combine categories and products in a single list
                      return ListView.builder(
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
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
