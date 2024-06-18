class UserModel {
  String? phoneNo;
  dynamic latitude;
  int? notificationStatus;
  dynamic bio;
  int? deviceType;
  int? type;
  String? createdAt;
  dynamic password;
  int? socialType;
  dynamic referBy;
  int? id;
  dynamic email;
  int? isApprove;
  dynamic longitude;
  String? updatedAt;
  dynamic address;
  String? deviceId;
  String? profilePic;
  String? lastName;
  dynamic otp;
  dynamic deletedAt;
  String? token;
  String? countryCode;
  String? socialId;
  dynamic referralCode;
  String? deviceToken;
  String? name;
  int? status;

  UserModel(
      {this.phoneNo,
      this.latitude,
      this.notificationStatus,
      this.bio,
      this.deviceType,
      this.type,
      this.createdAt,
      this.password,
      this.socialType,
      this.referBy,
      this.id,
      this.email,
      this.isApprove,
      this.longitude,
      this.updatedAt,
      this.address,
      this.deviceId,
      this.profilePic,
      this.lastName,
      this.otp,
      this.deletedAt,
      this.token,
      this.countryCode,
      this.socialId,
      this.referralCode,
      this.deviceToken,
      this.name,
      this.status});

  UserModel.fromJson(Map<String, dynamic> json) {
    phoneNo = json['phone_no'];
    latitude = json['latitude'];
    notificationStatus = json['notification_status'];
    bio = json['bio'];
    deviceType = json['device_type'];
    type = json['type'];
    createdAt = json['createdAt'];
    password = json['password'];
    socialType = json['social_type'];
    referBy = json['refer_by'];
    id = json['id'];
    email = json['email'];
    isApprove = json['is_approve'];
    longitude = json['longitude'];
    updatedAt = json['updatedAt'];
    address = json['address'];
    deviceId = json['device_id'];
    profilePic = json['profile_pic'];
    lastName = json['last_name'];
    otp = json['otp'];
    deletedAt = json['deleted_at'];
    token = json['token'];
    countryCode = json['country_code'];
    socialId = json['social_id'];
    referralCode = json['referral_code'];
    deviceToken = json['device_token'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone_no'] = this.phoneNo;
    data['latitude'] = this.latitude;
    data['notification_status'] = this.notificationStatus;
    data['bio'] = this.bio;
    data['device_type'] = this.deviceType;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['password'] = this.password;
    data['social_type'] = this.socialType;
    data['refer_by'] = this.referBy;
    data['id'] = this.id;
    data['email'] = this.email;
    data['is_approve'] = this.isApprove;
    data['longitude'] = this.longitude;
    data['updatedAt'] = this.updatedAt;
    data['address'] = this.address;
    data['device_id'] = this.deviceId;
    data['profile_pic'] = this.profilePic;
    data['last_name'] = this.lastName;
    data['otp'] = this.otp;
    data['deleted_at'] = this.deletedAt;
    data['token'] = this.token;
    data['country_code'] = this.countryCode;
    data['social_id'] = this.socialId;
    data['referral_code'] = this.referralCode;
    data['device_token'] = this.deviceToken;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
