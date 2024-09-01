import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';

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
        categories!.add(new CategoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
