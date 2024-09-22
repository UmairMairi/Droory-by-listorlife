class NotificationListModel {
  Pagination? pagination;
  List<NotificationDataModel>? data;

  NotificationListModel({this.pagination, this.data});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <NotificationDataModel>[];
      json['data'].forEach((v) {
        data!.add(NotificationDataModel.fromJson(v));
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

class NotificationDataModel {
  int? id;
  int? senderId;
  int? receiverId;
  int? productId;
  String? title;
  String? body;
  String? notificationType;
  Null data;
  String? createdAt;
  String? updatedAt;
  SenderDetail? senderDetail;

  NotificationDataModel(
      {this.id,
      this.senderId,
      this.receiverId,
      this.productId,
      this.title,
      this.body,
      this.notificationType,
      this.data,
      this.createdAt,
      this.updatedAt,
      this.senderDetail});

  NotificationDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    productId = json['product_id'];
    title = json['title'];
    body = json['body'];
    notificationType = json['notification_type'];
    data = json['data'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    senderDetail = json['sender_detail'] != null
        ? SenderDetail.fromJson(json['sender_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['product_id'] = productId;
    data['title'] = title;
    data['body'] = body;
    data['notification_type'] = notificationType;
    data['data'] = this.data;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (senderDetail != null) {
      data['sender_detail'] = senderDetail!.toJson();
    }
    return data;
  }
}

class SenderDetail {
  int? id;
  String? name;
  Null lastName;
  Null userName;
  String? profilePic;
  String? email;

  SenderDetail(
      {this.id,
      this.name,
      this.lastName,
      this.userName,
      this.profilePic,
      this.email});

  SenderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastName = json['last_name'];
    userName = json['user_name'];
    profilePic = json['profile_pic'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['last_name'] = lastName;
    data['user_name'] = userName;
    data['profile_pic'] = profilePic;
    data['email'] = email;
    return data;
  }
}
