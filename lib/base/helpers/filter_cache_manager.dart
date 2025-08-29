import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';

class FilterCacheManager {
  // Singleton pattern
  static final FilterCacheManager _instance = FilterCacheManager._internal();
  factory FilterCacheManager() => _instance;
  FilterCacheManager._internal();

  // Cache storage - now language aware
  final Map<String, List<CategoryModel>> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};

  // Cache duration (30 minutes)
  final Duration cacheDuration = const Duration(minutes: 30);

  // Get current language
  String get currentLanguage => DbHelper.getLanguage();

  // Cache keys - now include language (FIXED)
  String get categoriesKey => 'categories_$currentLanguage';
  String get subCategoriesKey => 'subcategories_$currentLanguage';
  String get subSubCategoriesKey => 'subsubcategories_$currentLanguage';
  String get brandsKey => 'brands_$currentLanguage';
  String get modelsKey => 'models_$currentLanguage';
  String get sizesKey => 'sizes_$currentLanguage';

  // Check if cache is valid
  bool _isCacheValid(String key) {
    if (!_cacheTimestamps.containsKey(key)) return false;

    final timestamp = _cacheTimestamps[key]!;
    return DateTime.now().difference(timestamp) < cacheDuration;
  }

  // Get from cache
  List<CategoryModel>? getFromCache(String key) {
    if (_isCacheValid(key)) {
      print("Cache HIT for key: $key");
      return _cache[key];
    }
    print("Cache MISS for key: $key");
    return null;
  }

  // Save to cache
  void saveToCache(String key, List<CategoryModel> data) {
    _cache[key] = data;
    _cacheTimestamps[key] = DateTime.now();
    print("Saved to cache: $key with ${data.length} items");
  }

  // Clear all cache
  void clearAllCache() {
    _cache.clear();
    _cacheTimestamps.clear();
    print("All cache cleared");
  }

  // Clear specific cache
  void clearCache(String key) {
    _cache.remove(key);
    _cacheTimestamps.remove(key);
    print("Cache cleared for key: $key");
  }

  // Generate cache keys - now include language (FIXED)
  String getSubCategoriesKey(String categoryId) =>
      '${subCategoriesKey}_$categoryId';
  String getSubSubCategoriesKey(String subcategoryId) =>
      '${subSubCategoriesKey}_$subcategoryId';
  String getBrandsKey(String subcategoryId) => '${brandsKey}_$subcategoryId';
  String getModelsKey(String brandId) => '${modelsKey}_$brandId';
  String getSizesKey(String subSubCategoryId) =>
      '${sizesKey}_$subSubCategoryId';

  // Clear cache when language changes
  void clearCacheForLanguageChange() {
    // This will clear all cache when language changes
    clearAllCache();
  }
}
