import 'package:list_and_life/models/message_model.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';

class InboxDataModel {
  Pagination? pagination;
  List<InboxModel>? list;

  InboxDataModel({this.pagination, this.list});

  InboxDataModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['list'] != null) {
      list = <InboxModel>[];
      json['list'].forEach((v) {
        list!.add(new InboxModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  num? limit;
  num? offset;
  num? totalPages;
  num? page;

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

class InboxModel {
  num? id;
  num? senderId;
  num? receiverId;
  num? productId;
  num? lastMessageId;
  String? createdAt;
  String? updatedAt;
  String? receiverName;
  SenderDetail? senderDetail;
  SenderDetail? receiverDetail;
  ProductDetailModel? productDetail;
  MessageModel? lastMessageDetail;

  InboxModel(
      {this.id,
      this.senderId,
      this.receiverId,
      this.productId,
      this.lastMessageId,
      this.createdAt,
      this.updatedAt,
      this.receiverName,
      this.senderDetail,
      this.receiverDetail,
      this.productDetail,
      this.lastMessageDetail});

  InboxModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    productId = json['product_id'];
    lastMessageId = json['last_message_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    receiverName = json['receiver_name'];
    senderDetail = json['sender_detail'] != null
        ? new SenderDetail.fromJson(json['sender_detail'])
        : null;
    receiverDetail = json['receiver_detail'] != null
        ? new SenderDetail.fromJson(json['receiver_detail'])
        : null;
    productDetail = json['product_detail'] != null
        ? ProductDetailModel.fromJson(json['product_detail'])
        : null;
    lastMessageDetail = json['last_message_detail'] != null
        ? new MessageModel.fromJson(json['last_message_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['product_id'] = this.productId;
    data['last_message_id'] = this.lastMessageId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['receiver_name'] = this.receiverName;
    if (this.senderDetail != null) {
      data['sender_detail'] = this.senderDetail!.toJson();
    }
    if (this.receiverDetail != null) {
      data['receiver_detail'] = this.receiverDetail!.toJson();
    }
    data['product_detail'] = this.productDetail;
    if (this.lastMessageDetail != null) {
      data['last_message_detail'] = this.lastMessageDetail!.toJson();
    }
    return data;
  }
}

class SenderDetail {
  num? id;
  String? name;
  String? lastName;
  String? profilePic;

  SenderDetail({this.id, this.name, this.lastName, this.profilePic});

  SenderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastName = json['last_name'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['last_name'] = this.lastName;
    data['profile_pic'] = this.profilePic;
    return data;
  }
}

class LastMessageDetail {
  num? id;
  num? senderId;
  num? receiverId;
  String? roomId;
  String? message;
  num? messageType;
  String? createdAt;
  String? updatedAt;

  LastMessageDetail(
      {this.id,
      this.senderId,
      this.receiverId,
      this.roomId,
      this.message,
      this.messageType,
      this.createdAt,
      this.updatedAt});

  LastMessageDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    roomId = json['room_id'];
    message = json['message'];
    messageType = json['message_type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['room_id'] = this.roomId;
    data['message'] = this.message;
    data['message_type'] = this.messageType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
