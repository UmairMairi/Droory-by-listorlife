import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/user_model.dart';

class ProductDetailModel {
  num? id;
  num? userId;
  num? categoryId;
  num? subCategoryId;
  num? subSubCategoryId;
  num? brandId;
  num? modelId;
  String? name;
  String? image;
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
  String? material;
  num? ram;
  num? storage;
  num? sizeId;
  String? milleage;
  String? screenSize;
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
  num? isFavourite;
  num? favouritesCount;
  List<ProductMedias>? productMedias;
  CategoryModel? category;
  CategoryModel? subCategory;
  CategoryModel? subSubCategory;
  CategoryModel? model;
  CategoryModel? fashionSize;
  CategoryModel? brand;
  UserModel? user;

  ProductDetailModel(
      {this.id,
      this.userId,
      this.categoryId,
      this.subCategoryId,
      this.subSubCategoryId,
      this.brandId,
      this.modelId,
      this.name,
      this.image,
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
      this.material,
      this.ram,
      this.storage,
      this.sizeId,
      this.milleage,
      this.screenSize,
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
      this.isFavourite,
      this.favouritesCount,
      this.countViews,
      this.productMedias,
      this.category,
      this.subCategory,
      this.subSubCategory,
      this.model,
      this.fashionSize,
      this.brand,
      this.user});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    subSubCategoryId = json['sub_sub_category_id'];
    brandId = json['brand_id'];
    modelId = json['model_id'];
    name = json['name'];
    image = json['image'];
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
    material = json['material'];
    ram = json['ram'];
    storage = json['storage'];
    sizeId = json['size_id'];
    milleage = json['milleage'];
    screenSize = json['screen_size'];
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
    isFavourite = json['is_favourite'];
    favouritesCount = json['favourites_count'];
    countViews = json['count_views'];
    if (json['product_medias'] != null) {
      productMedias = <ProductMedias>[];
      json['product_medias'].forEach((v) {
        productMedias!.add(new ProductMedias.fromJson(v));
      });
    }
    category = json['category'] != null
        ? new CategoryModel.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? new CategoryModel.fromJson(json['sub_category'])
        : null;
    subSubCategory = json['sub_sub_category'] != null
        ? new CategoryModel.fromJson(json['sub_sub_category'])
        : null;
    model = json['model'] != null
        ? new CategoryModel.fromJson(json['model'])
        : null;
    fashionSize = json['fashion_size'];
    brand = json['brand'] != null
        ? new CategoryModel.fromJson(json['brand'])
        : null;
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['sub_sub_category_id'] = this.subSubCategoryId;
    data['brand_id'] = this.brandId;
    data['model_id'] = this.modelId;
    data['name'] = this.name;
    data['image'] = this.image;
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
    data['material'] = this.material;
    data['ram'] = this.ram;
    data['storage'] = this.storage;
    data['size_id'] = this.sizeId;
    data['milleage'] = this.milleage;
    data['screen_size'] = this.screenSize;
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
    data['is_favourite'] = this.isFavourite;
    data['favourites_count'] = this.favouritesCount;
    data['count_views'] = countViews;
    if (this.productMedias != null) {
      data['product_medias'] =
          this.productMedias!.map((v) => v.toJson()).toList();
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
    if (this.model != null) {
      data['model'] = this.model!.toJson();
    }
    data['fashion_size'] = this.fashionSize;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['media'] = media;
    return data;
  }
}
