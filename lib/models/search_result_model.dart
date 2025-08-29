import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/product_detail_model.dart';

class SearchResultModel {
  List<ProductDetailModel>? products;
  List<CategoryModel>? categories;

  SearchResultModel({this.products, this.categories});

  SearchResultModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <ProductDetailModel>[];
      json['products'].forEach((v) {
        products!.add(ProductDetailModel.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <CategoryModel>[];
      json['categories'].forEach((v) {
        categories!.add(CategoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
