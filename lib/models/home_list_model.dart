import 'package:list_and_life/models/prodect_detail_model.dart';

class HomeListModel {
  Pagination? pagination;
  List<ProductDetailModel>? data;

  HomeListModel({this.pagination, this.data});

  HomeListModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <ProductDetailModel>[];
      json['data'].forEach((v) {
        data!.add(ProductDetailModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? limit;
  int? offset;
  int? totalPages;
  int? page;

  Pagination({this.limit, this.offset, this.totalPages, this.page});

  Pagination.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    offset = json['offset'];
    totalPages = json['totalPages'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['offset'] = offset;
    data['totalPages'] = totalPages;
    data['page'] = page;
    return data;
  }
}


