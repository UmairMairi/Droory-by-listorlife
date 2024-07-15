import 'package:list_and_life/models/user_model.dart';

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
  num? favouritesCount;
  num? distance;
  num? isFavourite;
  dynamic isFeaturedOrBoosted;
  List<ProductMedias>? productMedias;
  Category? category;
  Category? subCategory;
  Category? subSubCategory;
  Category? brand;
  UserModel? user;

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
      this.favouritesCount,
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
    favouritesCount = json['favourites_count'];
    distance = json['distance'];
    isFavourite = json['is_favourite'];
    isFeaturedOrBoosted = json['is_featured_or_boosted'];
    if (json['product_medias'] != null) {
      productMedias = <ProductMedias>[];
      if (json['product_medias'].isNotEmpty) {
        json['product_medias'].forEach((v) {
          productMedias!.add(ProductMedias.fromJson(v));
        });
      }
    }
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? Category.fromJson(json['sub_category'])
        : null;
    subSubCategory = json['sub_sub_category'] != null
        ? Category.fromJson(json['sub_sub_category'])
        : null;
    brand = json['brand'] != null ? Category.fromJson(json['brand']) : null;
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['sub_sub_category_id'] = subSubCategoryId;
    data['brand_id'] = brandId;
    data['favourites_count'] = favouritesCount;
    data['name'] = name;
    data['item_condition'] = itemCondition;
    data['position_type'] = positionType;
    data['sallery_period'] = salleryPeriod;
    data['education_type'] = educationType;
    data['sallery_from'] = salleryFrom;
    data['sallery_to'] = salleryTo;
    data['price'] = price;
    data['description'] = description;
    data['year'] = year;
    data['fuel'] = fuel;
    data['transmission'] = transmission;
    data['km_driven'] = kmDriven;
    data['number_of_owner'] = numberOfOwner;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['nearby'] = nearby;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['status'] = status;
    data['sell_status'] = sellStatus;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['count_views'] = countViews;
    data['distance'] = distance;
    data['is_favourite'] = isFavourite;
    data['is_featured_or_boosted'] = isFeaturedOrBoosted;
    if (productMedias != null) {
      data['product_medias'] = productMedias?.map((v) => v.toJson()).toList();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (subCategory != null) {
      data['sub_category'] = subCategory!.toJson();
    }
    if (subSubCategory != null) {
      data['sub_sub_category'] = subSubCategory!.toJson();
    }
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['media'] = media;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
