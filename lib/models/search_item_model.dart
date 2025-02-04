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
    searchData = json['obj'] != null ? SearchData.fromJson(json['obj']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    if (searchData != null) {
      data['obj'] = searchData!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class SearchData {
  int? id;
  String? name;
  String? type;
  dynamic userId;
  String? communicationChoice;

  SearchData({this.id, this.name, this.type});

  SearchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    userId = json['user_id'];
    communicationChoice = json['communication_choice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['user_id'] = userId;
    data['communication_choice'] = communicationChoice;
    return data;
  }
}
