import 'inbox_model.dart';

class MessageDataModel {
  Pagination? pagination;
  List<MessageModel>? list;
  CheckBlock? checkBlock;

  MessageDataModel({this.pagination, this.list, this.checkBlock});

  MessageDataModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['list'] != null) {
      list = <MessageModel>[];
      json['list'].forEach((v) {
        list!.add(MessageModel.fromJson(v));
      });
    }
    checkBlock = json['checkBlock'] != null
        ? CheckBlock.fromJson(json['checkBlock'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    if (checkBlock != null) {
      data['checkBlock'] = checkBlock!.toJson();
    }
    return data;
  }
}

class MessageModel {
  int? id;
  int? senderId;
  int? receiverId;
  String? roomId;
  dynamic productId;
  String? message;
  int? messageType;
  int? isRead;
  String? createdAt;
  String? updatedAt;
  MessageModel? isDeleted;
  dynamic messageId;

  MessageModel(
      {this.id,
      this.senderId,
      this.receiverId,
      this.roomId,
      this.message,
      this.messageType,
      this.productId,
      this.isRead,
      this.createdAt,
      this.updatedAt,
      this.messageId,
        this.isDeleted
      });

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    roomId = json['room_id'];
    message = json['message'];
    messageType = json['message_type'];
    productId = json['product_id'];
    isRead = json['is_read'];
    createdAt = json['createdAt'];
    messageId = json['message_id'];
    updatedAt = json['updatedAt'];
    isDeleted = json['is_deleted'] != null
        ? MessageModel.fromJson(json['is_deleted'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['room_id'] = roomId;
    data['message'] = message;
    data['message_type'] = messageType;
    data['is_read'] = isRead;
    data['createdAt'] = createdAt;
    data['message_id'] = messageId;
    data['product_id'] = productId;
    data['updatedAt'] = updatedAt;
    if (isDeleted != null) {
      data['is_deleted'] = isDeleted!.toJson();
    }
    return data;
  }
}

class CheckBlock {
  int? blockMe;
  int? blockByMe;

  CheckBlock({this.blockMe, this.blockByMe});

  CheckBlock.fromJson(Map<String, dynamic> json) {
    blockMe = json['block_me'];
    blockByMe = json['block_by_me'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['block_me'] = blockMe;
    data['block_by_me'] = blockByMe;
    return data;
  }
}
