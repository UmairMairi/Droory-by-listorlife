import 'package:list_and_life/models/user_model.dart';

class BlockedListModel {
  Pagination? pagination;
  List<BlockedUserModel>? data;

  BlockedListModel({this.pagination, this.data});

  BlockedListModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <BlockedUserModel>[];
      json['data'].forEach((v) {
        data!.add(BlockedUserModel.fromJson(v));
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
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['block_by'] = blockBy;
    data['block_to'] = blockTo;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
