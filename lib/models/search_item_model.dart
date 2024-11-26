import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/product_detail_model.dart';

class SearchItemModel {
  List<ProductDetailModel>? products;
  List<CategoryModel>? categories;

  SearchItemModel({this.products, this.categories});

  SearchItemModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <ProductDetailModel>[];
      json['products'].forEach((v) {
        products!.add(new ProductDetailModel.fromJson(v));
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



class SearchHistoryModel {
  int? id;
  int? userId;
  SearchData? searchData;
  String? createdAt;
  String? updatedAt;

  SearchHistoryModel(
      {this.id, this.userId, this.searchData, this.createdAt, this.updatedAt});

  SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    searchData = json['obj'] != null ? new SearchData.fromJson(json['obj']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    if (this.searchData != null) {
      data['obj'] = this.searchData!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class SearchData {
  int? id;
  String? name;
  String? type;

  SearchData({this.id, this.name, this.type});

  SearchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}
