import 'package:list_and_life/models/user_model.dart';

class BlockedListModel {
  Pagination? pagination;
  List<BlockedUserModel>? data;

  BlockedListModel({this.pagination, this.data});

  BlockedListModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <BlockedUserModel>[];
      json['data'].forEach((v) {
        data!.add(new BlockedUserModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    data['totalPages'] = this.totalPages;
    data['page'] = this.page;
    return data;
  }
}

class BlockedUserModel {
  int? id;
  int? blockBy;
  int? blockTo;
  String? createdAt;
  String? updatedAt;
  UserModel? user;

  BlockedUserModel(
      {this.id,
      this.blockBy,
      this.blockTo,
      this.createdAt,
      this.updatedAt,
      this.user});

  BlockedUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    blockBy = json['block_by'];
    blockTo = json['block_to'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['block_by'] = this.blockBy;
    data['block_to'] = this.blockTo;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
