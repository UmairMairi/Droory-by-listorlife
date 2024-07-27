import 'inbox_model.dart';

class MessageDataModel {
  Pagination? pagination;
  List<MessageModel>? list;
  CheckBlock? checkBlock;

  MessageDataModel({this.pagination, this.list, this.checkBlock});

  MessageDataModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['list'] != null) {
      list = <MessageModel>[];
      json['list'].forEach((v) {
        list!.add(MessageModel.fromJson(v));
      });
    }
    checkBlock = json['checkBlock'] != null
        ? new CheckBlock.fromJson(json['checkBlock'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    if (this.checkBlock != null) {
      data['checkBlock'] = this.checkBlock!.toJson();
    }
    return data;
  }
}

class MessageModel {
  int? id;
  int? senderId;
  int? receiverId;
  String? roomId;
  String? message;
  int? messageType;
  int? isRead;
  String? createdAt;
  String? updatedAt;

  MessageModel(
      {this.id,
      this.senderId,
      this.receiverId,
      this.roomId,
      this.message,
      this.messageType,
      this.isRead,
      this.createdAt,
      this.updatedAt});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    roomId = json['room_id'];
    message = json['message'];
    messageType = json['message_type'];
    isRead = json['is_read'];
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
    data['is_read'] = this.isRead;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['block_me'] = this.blockMe;
    data['block_by_me'] = this.blockByMe;
    return data;
  }
}
