import 'package:list_and_life/models/message_model.dart';
import 'package:list_and_life/models/product_detail_model.dart';

class InboxDataModel {
  Pagination? pagination;
  List<InboxModel>? list;

  InboxDataModel({this.pagination, this.list});

  InboxDataModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['list'] != null) {
      list = <InboxModel>[];
      json['list'].forEach((v) {
        list!.add(InboxModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['offset'] = offset;
    data['totalPages'] = totalPages;
    data['page'] = page;
    return data;
  }
}

class InboxModel {
  num? id;
  num? senderId;
  num? receiverId;
  num? productId;
  num? lastMessageId;
  num? unread_count;
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
      this.unread_count,
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
    unread_count = json['unread_count'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    receiverName = json['receiver_name'];
    senderDetail = json['sender_detail'] != null
        ? SenderDetail.fromJson(json['sender_detail'])
        : null;
    receiverDetail = json['receiver_detail'] != null
        ? SenderDetail.fromJson(json['receiver_detail'])
        : null;
    productDetail = json['product_detail'] != null
        ? ProductDetailModel.fromJson(json['product_detail'])
        : null;
    lastMessageDetail = json['last_message_detail'] != null
        ? MessageModel.fromJson(json['last_message_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['product_id'] = productId;
    data['last_message_id'] = lastMessageId;
    data['unread_count'] = unread_count;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['receiver_name'] = receiverName;
    if (senderDetail != null) {
      data['sender_detail'] = senderDetail!.toJson();
    }
    if (receiverDetail != null) {
      data['receiver_detail'] = receiverDetail!.toJson();
    }
    if (productDetail != null) {
      data['product_detail'] = productDetail!.toJson();
    }
    if (lastMessageDetail != null) {
      data['last_message_detail'] = lastMessageDetail!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['last_name'] = lastName;
    data['profile_pic'] = profilePic;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['room_id'] = roomId;
    data['message'] = message;
    data['message_type'] = messageType;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
