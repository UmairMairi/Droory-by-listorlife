import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/smart_search_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
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
  // Use separate stream controllers with broadcast capability
  late StreamController<List<SearchHistoryModel>?>
      _searchHistoryStreamController;
  late StreamController<List<ProductDetailModel>?> _productStreamController;
  late StreamController<List<CategoryModel?>> _categoryStreamController;
  late StreamController<List<CategoryModel>?>
      _popularCategoriesStreamController;

  Timer? _debounce;
  TextEditingController textEditingController = TextEditingController();
  bool _isSearching = false;

  // Cache for data to prevent duplicates
  List<SearchHistoryModel>? _cachedSearchHistory;
  List<CategoryModel>? _cachedPopularCategories;

  @override
  void initState() {
    super.initState();

    // Initialize stream controllers with broadcast capability
    _searchHistoryStreamController =
        StreamController<List<SearchHistoryModel>?>.broadcast();
    _productStreamController =
        StreamController<List<ProductDetailModel>?>.broadcast();
    _categoryStreamController =
        StreamController<List<CategoryModel?>>.broadcast();
    _popularCategoriesStreamController =
        StreamController<List<CategoryModel>?>.broadcast();

    textEditingController.text = widget.value ?? '';
    searchItem(text: widget.value ?? '');

    if (!DbHelper.getIsGuest()) {
      getSearches();
    }

    // Load popular categories
    getPopularCategories();
  }

  Future<void> searchItem({required String text}) async {
    if (!mounted) return;

    setState(() {
      _isSearching = text.isNotEmpty;
    });

    if (text.isEmpty) {
      if (!_categoryStreamController.isClosed) {
        _categoryStreamController.add([]);
      }
      if (!_productStreamController.isClosed) {
        _productStreamController.add([]);
      }
      return;
    }

    try {
      // Clear previous results immediately to prevent image caching issues
      if (!_productStreamController.isClosed) {
        _productStreamController.add([]);
      }
      if (!_categoryStreamController.isClosed) {
        _categoryStreamController.add([]);
      }

      // 🔥 UPDATED: Let backend handle smart translation
      print("Searching for: $text"); // Simple logging

      ApiRequest apiRequest = ApiRequest(
        url:
            ApiConstants.getSearchProductUrl(search: text), // Use original text
        requestType: RequestType.get,
      );

      var response = await BaseClient.handleRequest(apiRequest);
      MapResponse<SearchItemModel> model = MapResponse.fromJson(
          response, (json) => SearchItemModel.fromJson(json));

      if (mounted) {
        // Add a small delay to ensure UI clears before showing new results
        await Future.delayed(const Duration(milliseconds: 50));

        if (!_productStreamController.isClosed) {
          _productStreamController.add(model.body?.products ?? []);
        }
        if (!_categoryStreamController.isClosed) {
          _categoryStreamController.add(model.body?.categories ?? []);
        }
      }
    } catch (e) {
      if (mounted) {
        if (!_productStreamController.isClosed) {
          _productStreamController.add([]);
        }
        if (!_categoryStreamController.isClosed) {
          _categoryStreamController.add([]);
        }
      }
      debugPrint("Search error: $e");
    }
  }

  Future<void> getPopularCategories() async {
    if (!mounted) return;

    try {
      // Get your actual categories from API
      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getCategoriesUrl(),
        requestType: RequestType.get,
      );

      var response = await BaseClient.handleRequest(apiRequest);
      ListResponse<CategoryModel> model = ListResponse.fromJson(
          response, (json) => CategoryModel.fromJson(json));

      // Get first 8 categories as popular ones
      List<CategoryModel> popularCategories =
          (model.body ?? []).take(8).toList();

      _cachedPopularCategories = popularCategories;

      if (mounted && !_popularCategoriesStreamController.isClosed) {
        _popularCategoriesStreamController.add(popularCategories);
      }
    } catch (e) {
      debugPrint("Popular categories error: $e");
      if (mounted && !_popularCategoriesStreamController.isClosed) {
        _popularCategoriesStreamController.add([]);
      }
    }
  }

  Future<void> getSearches() async {
    if (!mounted) return;

    try {
      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getSearchesUrl(),
        requestType: RequestType.get,
      );

      var response = await BaseClient.handleRequest(apiRequest);
      ListResponse<SearchHistoryModel> model = ListResponse.fromJson(
          response, (json) => SearchHistoryModel.fromJson(json));

      // Remove duplicates and limit to recent 6 searches
      Set<String> seenSearches = {};
      List<SearchHistoryModel> uniqueSearches = [];

      for (var search in model.body ?? []) {
        String searchKey = "${search.searchData?.name}-${search.searchData?.type}";
        if (!seenSearches.contains(searchKey) && uniqueSearches.length < 6 && (search.searchData?.name?.isNotEmpty == true)) {
          seenSearches.add(searchKey);
          uniqueSearches.add(search);
        }
      }

      _cachedSearchHistory = uniqueSearches;

      if (mounted && !_searchHistoryStreamController.isClosed) {
        _searchHistoryStreamController.add(uniqueSearches);
      }
    } catch (e) {
      debugPrint("Search history error: $e");
      if (mounted && !_searchHistoryStreamController.isClosed) {
        _searchHistoryStreamController.add([]);
      }
    }
  }

  Future<void> storeSearches(
      {dynamic id,
      dynamic name,
      dynamic type,
      dynamic userId,
      String? communicationChoice}) async {
    if (DbHelper.getIsGuest()) return;

    Map<String, dynamic> body = {
      "id": id,
      "name": name,
      "type": type,
    };
    if (userId != null) {
      body.addAll({"user_id": userId});
    }
    if (communicationChoice != null) {
      body.addAll({"communication_choice": communicationChoice});
    }

    try {
      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.storeSearchesUrl(),
        requestType: RequestType.post,
        body: {"obj": jsonEncode(body)},
      );
      await BaseClient.handleRequest(apiRequest);
      getSearches(); // Refresh search history
    } catch (e) {
      debugPrint("Failed to store search: $e");
    }
  }

  Future<void> deleteSearches({dynamic searchId}) async {
    try {
      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.deleteSearchesUrl(),
        requestType: RequestType.get,
      );
      await BaseClient.handleRequest(apiRequest);
      getSearches();
    } catch (e) {
      debugPrint("Failed to delete searches: $e");
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();

    // Close stream controllers safely
    if (!_productStreamController.isClosed) {
      _productStreamController.close();
    }
    if (!_categoryStreamController.isClosed) {
      _categoryStreamController.close();
    }
    if (!_searchHistoryStreamController.isClosed) {
      _searchHistoryStreamController.close();
    }
    if (!_popularCategoriesStreamController.isClosed) {
      _popularCategoriesStreamController.close();
    }

    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: AppTextField(
            controller: textEditingController,
            onChanged: (String data) {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 300), () {
                searchItem(text: data);
              });
            },
            prefix: Icon(Icons.search, color: Colors.grey[600]),
            suffix: textEditingController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      textEditingController.clear();
                      searchItem(text: '');
                      setState(() {});
                    },
                    child: Icon(Icons.close, color: Colors.grey[600], size: 20),
                  )
                : null,
            validator: (value) => null,
            hint: StringHelper.findCarsMobilePhonesAndMore,
          ),
        ),
      ),
      body: SafeArea(
        child: _isSearching ? _buildSearchResults() : _buildSearchHome(),
      ),
    );
  }

  Widget _buildSearchHome() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          _buildSearchHistorySection(),
          const Gap(30),
          _buildPopularCategoriesSection(),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: _buildSearchedDataWidget(),
    );
  }

  Widget _buildSearchHistorySection() {
    return StreamBuilder<List<SearchHistoryModel>?>(
      stream: _searchHistoryStreamController.stream,
      builder: (context, snapshot) {
        final searches = snapshot.data ?? _cachedSearchHistory ?? [];

        if (searches.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringHelper.recentSearches.toUpperCase(),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (searches.isNotEmpty)
                    GestureDetector(
                      onTap: deleteSearches,
                      child: Icon(
                        Icons.close,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                ],
              ),
              const Gap(16),
              ...searches.map((item) {
                if ((item.searchData?.name ?? "").isEmpty) {
                  return const SizedBox.shrink();
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => _handleSearchHistoryTap(item),
                    child: Row(
                      children: [
                        Text(
                          item.searchData?.name ?? "",
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.close,
                          color: Colors.grey[500],
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopularCategoriesSection() {
    return StreamBuilder<List<CategoryModel>?>(
      stream: _popularCategoriesStreamController.stream,
      builder: (context, snapshot) {
        final categories = snapshot.data ?? _cachedPopularCategories ?? [];

        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringHelper.category.toUpperCase(),
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
              const Gap(16),
              ...categories.map((category) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      // Don't store popular category clicks in search history
                      context.push(Routes.subCategoryView, extra: category);
                    },
                    child: Row(
                      children: [
                        Text(
                          category.name ?? "",
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchedDataWidget() {
    return StreamBuilder<List<CategoryModel?>>(
      stream: _categoryStreamController.stream,
      builder: (context, categorySnapshot) {
        return StreamBuilder<List<ProductDetailModel>?>(
          stream: _productStreamController.stream,
          builder: (context, productSnapshot) {
            return _buildStreamState(
                context, categorySnapshot, productSnapshot);
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
      return const Center(child: AppLoadingWidget());
    }

    if (categorySnapshot.hasError || productSnapshot.hasError) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const Gap(16),
            Text(
              StringHelper.somethingWantWrong,
              style:
                  context.textTheme.headlineSmall?.copyWith(color: Colors.red),
            ),
          ],
        ),
      );
    }

    final categories = categorySnapshot.data ?? [];
    final products = productSnapshot.data ?? [];

    if (categories.isEmpty && products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppEmptyWidget(),
            const Gap(16),
            Text(
              "${StringHelper.noData} '${textEditingController.text}'",
              style: context.textTheme.bodyLarge
                  ?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (categories.isNotEmpty) ...[
          _buildSectionHeader(StringHelper.category,
              "${categories.length} ${StringHelper.category.toLowerCase()}"),
          const Gap(16),
          _buildCategoryGrid(categories),
          const Gap(32),
        ],
        if (products.isNotEmpty) ...[
          _buildSectionHeader(StringHelper.ads,
              "${products.length} ${StringHelper.ads.toLowerCase()}"),
          const Gap(16),
          _buildProductList(products),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          subtitle,
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(List<CategoryModel?> categories) {
    return CommonGridView(
      shrinkWrap: true,
      mainAxisExtent: 120,
      crossAxisCount: 3,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            if (!DbHelper.getIsGuest()) {
              storeSearches(
                  id: category?.id,
                  name: category?.name ?? '',
                  type: "category");
            }
            context.push(Routes.subCategoryView, extra: category);
          },
          child: Container(
            // Add unique key to force widget rebuild and prevent image caching
            key: ValueKey(
                "${category?.id}_${category?.name}_${DateTime.now().millisecondsSinceEpoch}"),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: ImageView.rect(
                      // Add cache-busting parameter to prevent image caching
                      image:
                          "${ApiConstants.imageUrl}/${category?.image ?? ""}?t=${DateTime.now().millisecondsSinceEpoch}",
                      height: 50,
                      placeholder: AssetsRes.IC_IMAGE_PLACEHOLDER,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Gap(12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    category?.name ?? '',
                    style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductList(List<ProductDetailModel> products) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Container(
          // Add unique key to force widget rebuild and prevent image caching
          key: ValueKey(
              "${product.id}_${product.name}_${DateTime.now().millisecondsSinceEpoch}"),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppProductItemWidget(
            data: product,
            onLikeTapped: () {
              setState(() {
                product.isFavourite = product.isFavourite == 1 ? 0 : 1;
              });
            },
            onItemTapped: () {
              if (!DbHelper.getIsGuest()) {
                storeSearches(
                    id: product.id,
                    name: product.name ?? '',
                    userId: product.userId,
                    communicationChoice: product.communicationChoice,
                    type: "product");
              }

              if (product.userId == DbHelper.getUserModel()?.id) {
                context.push(Routes.myProduct, extra: product);
              } else {
                context.push(Routes.productDetails, extra: product);
              }
            },
          ),
        );
      },
      separatorBuilder: (context, index) => const Gap(16),
    );
  }

  void _handleSearchHistoryTap(SearchHistoryModel item) {
    // Set the search text and trigger search (exactly like user typing)
    textEditingController.text = item.searchData?.name ?? '';
    searchItem(text: item.searchData?.name ?? '');
  }
}
