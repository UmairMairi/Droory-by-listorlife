class NotificationEntity {
  NotificationEntity(
      {this.title,
      this.priority,
      this.body,
      this.entityId,
      this.entityName,
      this.dataId,
      this.dataName,
      this.dataEmail,
      this.dataImage,
      this.sender_type,
      this.doctype,
      this.subcatgoeryid,
      this.group_id});

  String? title;
  String? priority;
  String? body;
  String? entityId;
  String? entityName;
  dynamic dataId;
  String? dataName;
  String? dataEmail;
  String? dataImage;
  String? otherUserId;
  String? otherUserImage;
  String? jobImage;
  dynamic notificationType;
  dynamic type;
  dynamic sender_type;
  dynamic doctype;
  dynamic categoryid;
  dynamic subcatgoeryid;

  dynamic group_id;

  NotificationEntity.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    priority = json['priority'];
    otherUserId = json['otherUserId'];
    body = json['body'];
    entityId = json['entityId'];
    entityName = json['entityName'];
    dataId = json['dataId'];
    dataEmail = json['dataEmail'];
    otherUserImage = json['otherUserImage'];
    dataImage = json['dataImage'];
    dataName = json['dataName'];
    type = json['type'];
    jobImage = json['jobImage'];
    sender_type = json['datasendertype'];
    doctype = json['doctype'];
    categoryid = json['categoryid'];
    subcatgoeryid = json['subcategoryid'];
    notificationType = json['notification_type'];
    group_id = json['group_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null && value.toString().isNotEmpty) {
        data[key] = value;
      }
    }

    writeNotNull('title', title);
    writeNotNull('priority', priority);
    writeNotNull('body', body);
    writeNotNull('entityId', entityId);
    writeNotNull('entityName', entityName);
    writeNotNull('dataId', dataId);
    writeNotNull('jobImage', jobImage);
    writeNotNull('dataName', dataName);
    writeNotNull('dataEmail', dataEmail);
    writeNotNull('dataImage', dataImage);
    writeNotNull('otherUserImage', otherUserImage);
    writeNotNull('type', type);
    writeNotNull('datasendertype', sender_type);
    writeNotNull('doctype', doctype);
    writeNotNull('categoryid', categoryid);
    writeNotNull('subcategoryid', subcatgoeryid);
    writeNotNull('group_id', group_id);
    writeNotNull('notification_type', notificationType);
    writeNotNull('otherUserId', otherUserId);

    return data;
  }
}
