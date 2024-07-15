class MessageModel {
  int? id;
  int? senderId;
  int? receiverId;
  String? roomId;
  String? message;
  int? messageType;
  String? createdAt;
  String? updatedAt;

  MessageModel(
      {this.id,
      this.senderId,
      this.receiverId,
      this.roomId,
      this.message,
      this.messageType,
      this.createdAt,
      this.updatedAt});

  MessageModel.fromJson(Map<String, dynamic> json) {
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
