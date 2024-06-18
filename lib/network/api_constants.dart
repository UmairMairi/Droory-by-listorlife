class ApiConstants {
  static const String _baseUrl = "https://app.listorlift.com/api";
  static const String imageUrl = "https://app.listorlift.com/uploads/img/users";

  /*----------------------------------------------- End Point Urls ---------------------------------------*/

  static String loginUrl() => "$_baseUrl/login";
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
  static String getBrandsUrl({String? id}) =>
      "$_baseUrl/get/brands?category_id=$id";
  static String addProductsUrl() => "$_baseUrl/add/products";
  static String getProductsUrl(
          {int? limit = 10,
          int? page = 1,
          double? latitude,
          double? longitude}) =>
      "$_baseUrl/{{live}}get/products?limit=$limit&page=$page&latitude=$latitude&longitude=$longitude";
  static String addFavouriteUrl() => "$_baseUrl/add/favourite";
  static String getNotificationUrl({
    int? limit = 10,
    int? page = 1,
  }) =>
      "$_baseUrl/notification/list?limit=$limit&page=$page";
  static String productViewUrl() => "$_baseUrl/product/view";
  static String buyPackageUrl() => "$_baseUrl/buy/package";
  static String productAddFeatureBoostUrl() =>
      "$_baseUrl/product/add/feature/boost";
}
