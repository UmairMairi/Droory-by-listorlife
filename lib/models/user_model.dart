class UserModel {
  String? phoneNo;
  dynamic latitude;
  num? notificationStatus;
  dynamic bio;
  num? deviceType;
  num? type;
  num? emailVerified;
  num? phoneVerified;
  String? createdAt;
  dynamic password;
  num? socialType;
  dynamic referBy;
  num? id;
  dynamic email;
  num? isApprove;
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
  String? communicationChoice;
  num? status;

  UserModel(
      {this.phoneNo,
      this.latitude,
      this.notificationStatus,
      this.bio,
      this.deviceType,
      this.type,
      this.emailVerified,
      this.phoneVerified,
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
      this.communicationChoice,
      this.status});

  UserModel.fromJson(Map<String, dynamic> json) {
    phoneNo = json['phone_no'];
    latitude = json['latitude'];
    notificationStatus = json['notification_status'];
    bio = json['bio'];
    deviceType = json['device_type'];
    type = json['type'];
    emailVerified = json['email_verified'];
    phoneVerified = json['phone_verified'];
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
    communicationChoice = json['communication_choice'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone_no'] = phoneNo;
    data['latitude'] = latitude;
    data['notification_status'] = notificationStatus;
    data['bio'] = bio;
    data['device_type'] = deviceType;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['password'] = password;
    data['social_type'] = socialType;
    data['refer_by'] = referBy;
    data['id'] = id;
    data['email'] = email;
    data['is_approve'] = isApprove;
    data['longitude'] = longitude;
    data['email_verified'] = emailVerified;
    data['phone_verified'] = phoneVerified;
    data['updatedAt'] = updatedAt;
    data['address'] = address;
    data['device_id'] = deviceId;
    data['profile_pic'] = profilePic;
    data['last_name'] = lastName;
    data['otp'] = otp;
    data['deleted_at'] = deletedAt;
    data['token'] = token;
    data['country_code'] = countryCode;
    data['social_id'] = socialId;
    data['referral_code'] = referralCode;
    data['device_token'] = deviceToken;
    data['name'] = name;
    data['communication_choice'] = communicationChoice;
    data['status'] = status;
    return data;
  }
}
