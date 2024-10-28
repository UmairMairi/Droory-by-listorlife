import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/user_model.dart';

class ProductDetailModel {
  int? id;
  num? userId;
  num? categoryId;
  num? subCategoryId;
  num? subSubCategoryId;
  int? brandId;
  int? modelId;
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
  int? sizeId;
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
  String? communicationChoice;
  num? chatCount;
  num? callCount;

  // New fields
  String? propertyFor; // ENUM "sell", "rent"
  int? bedrooms;
  int? bathrooms;
  String? furnishedType; // ENUM "furnished", "unfurnished", "semi_furnished"
  String? ownership; // ENUM "primary", "resale"
  String? paymentType; // ENUM "installment", "cash_or_installment", "cash"
  String? completionStatus; // ENUM "ready", "off_plan"
  String?
      deliveryTerm; // ENUM "finished", "not_finished", "core_and_sell", "semi_finished"

  ProductDetailModel({
    this.id,
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
    this.chatCount,
    this.callCount,
    this.communicationChoice,
    this.user,

    // Initialize new fields
    this.propertyFor,
    this.bedrooms,
    this.bathrooms,
    this.furnishedType,
    this.ownership,
    this.paymentType,
    this.completionStatus,
    this.deliveryTerm,
  });

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
    chatCount = json['chat_count'];
    callCount = json['call_count'];
    isFavourite = json['is_favourite'];
    communicationChoice = json['communication_choice'];
    favouritesCount = json['favourites_count'];
    countViews = json['count_views'];

    // Deserialize new fields
    propertyFor = json['property_for'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    furnishedType = json['furnished_type'];
    ownership = json['ownership'];
    paymentType = json['payment_type'];
    completionStatus = json['completion_status'];
    deliveryTerm = json['delivery_term'];

    if (json['product_medias'] != null) {
      productMedias = <ProductMedias>[];
      json['product_medias'].forEach((v) {
        productMedias!.add(ProductMedias.fromJson(v));
      });
    }
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? CategoryModel.fromJson(json['sub_category'])
        : null;
    subSubCategory = json['sub_sub_category'] != null
        ? CategoryModel.fromJson(json['sub_sub_category'])
        : null;
    model =
        json['model'] != null ? CategoryModel.fromJson(json['model']) : null;
    fashionSize = json['fashion_size'];
    brand =
        json['brand'] != null ? CategoryModel.fromJson(json['brand']) : null;
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
    data['model_id'] = modelId;
    data['name'] = name;
    data['image'] = image;
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
    data['material'] = material;
    data['ram'] = ram;
    data['storage'] = storage;
    data['size_id'] = sizeId;
    data['milleage'] = milleage;
    data['screen_size'] = screenSize;
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
    data['is_favourite'] = isFavourite;
    data['favourites_count'] = favouritesCount;
    data['count_views'] = countViews;
    data['communication_choice'] = communicationChoice;

    // Serialize new fields
    data['property_for'] = propertyFor;
    data['bedrooms'] = bedrooms;
    data['bathrooms'] = bathrooms;
    data['furnished_type'] = furnishedType;
    data['ownership'] = ownership;
    data['payment_type'] = paymentType;
    data['completion_status'] = completionStatus;
    data['delivery_term'] = deliveryTerm;

    if (productMedias != null) {
      data['product_medias'] = productMedias!.map((v) => v.toJson()).toList();
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
    if (model != null) {
      data['model'] = model!.toJson();
    }
    data['fashion_size'] = fashionSize;
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
  int? id;
  String? media;

  ProductMedias({this.media, this.id});

  ProductMedias.fromJson(Map<String, dynamic> json) {
    media = json['media'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['media'] = media;
    data['id'] = id;
    return data;
  }
}
