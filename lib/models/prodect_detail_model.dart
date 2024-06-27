
class ProductDetailModel {
  num? id;
  num? userId;
  num? categoryId;
  num? subCategoryId;
  num? subSubCategoryId;
  num? brandId;
  String? name;
  String? itemCondition;
  String? positionType;
  String? salleryPeriod;
  String? educationType;
  String? salleryFrom;
  String? salleryTo;
  String? price;
  String? description;
  num? year;
  String? fuel;
  String? transmission;
  num? kmDriven;
  num? numberOfOwner;
  String? country;
  String? state;
  String? city;
  String? nearby;
  String? latitude;
  String? longitude;
  num? status;
  String? sellStatus;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  num? countViews;
  num? distance;
  num? isFavourite;
  dynamic isFeaturedOrBoosted;
  List<ProductMedias>? productMedias;
  Category? category;
  Category? subCategory;
  Category? subSubCategory;
  Category? brand;
  User? user;

  ProductDetailModel(
      {this.id,
        this.userId,
        this.categoryId,
        this.subCategoryId,
        this.subSubCategoryId,
        this.brandId,
        this.name,
        this.itemCondition,
        this.positionType,
        this.salleryPeriod,
        this.educationType,
        this.salleryFrom,
        this.salleryTo,
        this.price,
        this.description,
        this.year,
        this.fuel,
        this.transmission,
        this.kmDriven,
        this.numberOfOwner,
        this.country,
        this.state,
        this.city,
        this.nearby,
        this.latitude,
        this.longitude,
        this.status,
        this.sellStatus,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.countViews,
        this.distance,
        this.isFavourite,
        this.isFeaturedOrBoosted,
        this.productMedias,
        this.category,
        this.subCategory,
        this.subSubCategory,
        this.brand,
        this.user});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    subSubCategoryId = json['sub_sub_category_id'];
    brandId = json['brand_id'];
    name = json['name'];
    itemCondition = json['item_condition'];
    positionType = json['position_type'];
    salleryPeriod = json['sallery_period'];
    educationType = json['education_type'];
    salleryFrom = json['sallery_from'];
    salleryTo = json['sallery_to'];
    price = json['price'];
    description = json['description'];
    year = json['year'];
    fuel = json['fuel'];
    transmission = json['transmission'];
    kmDriven = json['km_driven'];
    numberOfOwner = json['number_of_owner'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    nearby = json['nearby'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    sellStatus = json['sell_status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    countViews = json['count_views'];
    distance = json['distance'];
    isFavourite = json['is_favourite'];
    isFeaturedOrBoosted = json['is_featured_or_boosted'];
    if (json['product_medias'] != null) {
      productMedias = <ProductMedias>[];
      if(json['product_medias'].isNotEmpty){
      json['product_medias'].forEach((v) {
        productMedias!.add( ProductMedias.fromJson(v));
      });
      }
    }
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? new Category.fromJson(json['sub_category'])
        : null;
    subSubCategory = json['sub_sub_category'] != null
        ? new Category.fromJson(json['sub_sub_category'])
        : null;
    brand = json['brand'] != null ? new Category.fromJson(json['brand']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['sub_sub_category_id'] = this.subSubCategoryId;
    data['brand_id'] = this.brandId;
    data['name'] = this.name;
    data['item_condition'] = this.itemCondition;
    data['position_type'] = this.positionType;
    data['sallery_period'] = this.salleryPeriod;
    data['education_type'] = this.educationType;
    data['sallery_from'] = this.salleryFrom;
    data['sallery_to'] = this.salleryTo;
    data['price'] = this.price;
    data['description'] = this.description;
    data['year'] = this.year;
    data['fuel'] = this.fuel;
    data['transmission'] = this.transmission;
    data['km_driven'] = this.kmDriven;
    data['number_of_owner'] = this.numberOfOwner;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['nearby'] = this.nearby;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['sell_status'] = this.sellStatus;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['count_views'] = this.countViews;
    data['distance'] = this.distance;
    data['is_favourite'] = this.isFavourite;
    data['is_featured_or_boosted'] = this.isFeaturedOrBoosted;
    if (productMedias != null) {
      data['product_medias'] =
          productMedias?.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.subCategory != null) {
      data['sub_category'] = this.subCategory!.toJson();
    }
    if (this.subSubCategory != null) {
      data['sub_sub_category'] = this.subSubCategory!.toJson();
    }
    if (this.brand != null) {
      data['brand'] = this.brand!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class ProductMedias {
  String? media;

  ProductMedias({this.media});

  ProductMedias.fromJson(Map<String, dynamic> json) {
    media = json['media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['media'] = this.media;
    return data;
  }
}

class Category {
  String? name;

  Category({this.name});

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class User {
  String? name;
  String? profilePic;
  String? phoneNo;
  String? countryCode;
  String? email;

  User(
      {this.name, this.profilePic, this.phoneNo, this.countryCode, this.email});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePic = json['profile_pic'];
    phoneNo = json['phone_no'];
    countryCode = json['country_code'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_pic'] = this.profilePic;
    data['phone_no'] = this.phoneNo;
    data['country_code'] = this.countryCode;
    data['email'] = this.email;
    return data;
  }
}
