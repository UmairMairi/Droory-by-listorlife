class ApiConstants {
  static const String _baseUrl = "https://app.listorlift.com/api";
  static const String imageUrl = "https://app.listorlift.com/uploads/img/users";

  /*----------------------------------------------- End Point Urls ---------------------------------------*/

  static String loginUrl() => "$_baseUrl/login";
  static String socialLoginUrl() => "$_baseUrl/social/login";
  static String verifyOtpUrl() => "$_baseUrl/verify/otp";
  static String signupUrl() => "$_baseUrl/signup";
  static String editProfileUrl() => "$_baseUrl/edit/profile";
  static String deleteAccountUrl() => "$_baseUrl/delete/account";
  static String logoutUrl() => "$_baseUrl/logout";
  static String getProfileUrl() => "$_baseUrl/get/profile/detail";
  static String getCmsUrl({String? id}) => "$_baseUrl/get/cms/$id";
  static String getCategoriesUrl() => "$_baseUrl/get/categories";
  static String uploadMediaUrl() => "$_baseUrl/upload/media";
  static String getSubCategoriesUrl({String? id}) =>
      "$_baseUrl/get/sub/categories?category_id=$id";
  static String getSubSubCategoriesUrl({String? id}) =>
      "$_baseUrl/get/sub/sub/categories?sub_category_id=$id";
  static String getBrandsUrl({String? id}) =>
      "$_baseUrl/get/brands?sub_category_id=$id";
  static String getProductUrl({String? id}) => "$_baseUrl/get/product/$id";
  static String addProductsUrl() => "$_baseUrl/add/products";
  static String editProductsUrl() => "$_baseUrl/edit/product";
  static String storeSearchesUrl() => "$_baseUrl/store/searches";
  static String getSearchesUrl() => "$_baseUrl/get/searches";
  static String deleteSearchesUrl() => "$_baseUrl/delete/searches";
  static String getProductsUrl({
    int? limit = 10,
    int? page = 1,
    double? latitude,
    double? longitude,
    String? search,
    required String? sellStatus,
  }) {
    final Map<String, dynamic> queryParams = {
      'limit': limit,
      'page': page,
      'latitude': latitude,
      'longitude': longitude,
      'search': search,
      'sell_status': sellStatus,
    };

    queryParams.removeWhere((key, value) => value == null || value.toString().isEmpty);

    final queryString = queryParams.entries.map((entry) => '${entry.key}=${entry.value}').join('&');

    return "$_baseUrl/get/products?$queryString";
  }

  static String getUsersProductsUrl({
    int? limit = 10,
    int? page = 1,
    String? userId,
  }) {
    final Map<String, dynamic> queryParams = {
      'limit': limit,
      'page': page,
      'user_id': userId,
    };

    queryParams.removeWhere((key, value) => value == null || value.toString().isEmpty);

    final queryString = queryParams.entries.map((entry) => '${entry.key}=${entry.value}').join('&');

    return "$_baseUrl/get/products?$queryString";
  }


  static String getFavouritesUrl({int? limit = 10, int? page = 1}) {
    final Map<String, dynamic> queryParams = {
      'limit': limit,
      'page': page,
      'favourite': true,
    };
    queryParams.removeWhere((key, value) => value == null || value.toString().isEmpty);

    final queryString = queryParams.entries.map((entry) => '${entry.key}=${entry.value}').join('&');

    return "$_baseUrl/get/products?$queryString";
  }


  static String addFavouriteUrl() => "$_baseUrl/add/favourite";
  static String getModelsUrl({String? brandId}) =>
      "$_baseUrl/get/models?brand_id=$brandId";

  static String getSearchProductUrl({String? search}) =>
      "$_baseUrl/serach/category/product?search=$search";

  static String getNotificationUrl({
    int? limit = 1000,
    int? page = 1,
  }) =>
      "$_baseUrl/notification/list?limit=$limit&page=$page";
  static String productViewUrl() => "$_baseUrl/product/view";
  static String callOnUrl({required String productId}) =>
      "$_baseUrl/call/on/$productId ";
  static String buyPackageUrl() => "$_baseUrl/buy/package";
  static String getFashionSizeUrl({required String id}) =>
      "$_baseUrl/get/fashion/sizes?sub_sub_category_id=$id";
  static String productAddFeatureBoostUrl() =>
      "$_baseUrl/product/add/feature/boost";
  static String markAsSoldUrl() => "$_baseUrl/mark/as/sold";
  static String getAmnitiesUrl() => "$_baseUrl/get/amnities";
  static String deleteProductUrl() => "$_baseUrl/delete/product";
  static String deactivateProductUrl() => "$_baseUrl/edit/product";
  static String getFaqUrl() => "$_baseUrl/get/faqs";
  static String getBlockListUrl() => "$_baseUrl/block/list?limit=1000&page=1";
  static String sendMailForVerifyUrl() => "$_baseUrl/send/mail/for/verify";
  static String verifyOtpMobileUrl() => "$_baseUrl/verify/otp/mobile";
  static String sendOtpMobileUrl() => "$_baseUrl/send/otp/mobile";
  static String getFilteredProduct({
    int? limit = 10,
    int? page = 1,
  }) {
    final Map<String, dynamic> queryParams = {
      'limit': limit,
      'page': page,
    };

    queryParams.removeWhere((key, value) => value == null || value.toString().isEmpty);

    final queryString = queryParams.entries.map((entry) => '${entry.key}=${entry.value}').join('&');

    return "$_baseUrl/get/products?$queryString";
  }

}
