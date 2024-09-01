class NotificationListModel {
  Pagination? pagination;
  List<NotificationDataModel>? data;

  NotificationListModel({this.pagination, this.data});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <NotificationDataModel>[];
      json['data'].forEach((v) {
        data!.add(new NotificationDataModel.fromJson(v));
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

class NotificationDataModel {
  int? id;
  int? senderId;
  int? receiverId;
  int? productId;
  String? title;
  String? body;
  String? notificationType;
  Null? data;
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
        ? new SenderDetail.fromJson(json['sender_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['product_id'] = this.productId;
    data['title'] = this.title;
    data['body'] = this.body;
    data['notification_type'] = this.notificationType;
    data['data'] = this.data;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.senderDetail != null) {
      data['sender_detail'] = this.senderDetail!.toJson();
    }
    return data;
  }
}

class SenderDetail {
  int? id;
  String? name;
  Null? lastName;
  Null? userName;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['last_name'] = this.lastName;
    data['user_name'] = this.userName;
    data['profile_pic'] = this.profilePic;
    data['email'] = this.email;
    return data;
  }
}
