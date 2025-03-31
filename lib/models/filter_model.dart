// class FilterModel {
//   String? limit;
//   String? page;
//   String? categoryId;
//   String? subcategoryId;
//   String? subSubCategoryId;
//   String? brandId;
//   String? userId;
//   String? favourite;
//   String? latitude;
//   String? longitude;
//   String? minPrice;
//   String? maxPrice;
//   String? minKmDriven;
//   String? maxKmDriven;
//   String? fuel;
//   String? numberOfOwner;
//   String? year;
//   String? sellStatus;
//   String? search;
//   String? datePublished;
//   String? sortByPrice;
//   String? distance;
//   String? itemCondition;
//   String? startDate;
//   String? endDate;
//   String? transmission;
//   String? modelId;
//   String? selectedAmnities;
//
//   //new keys
//   String? propertyFor;
//   String? bedrooms;
//   String? bathrooms;
//   String? furnishedType;
//   String? ownership;
//   String? paymentType;
//   String? completionStatus;
//   String? deliveryTerm;
//   String? type;
//   String? level;
//   String? buildingAge;
//   String? listedBy;
//   String? rentalTerm;
//   String? accessToUtilities;
//   String? minDownPrice;
//   String? maxDownPrice;
//   String? maxAreaSize;
//   String? minAreaSize;
//
//   FilterModel({
//     this.limit,
//     this.page,
//     this.categoryId,
//     this.subcategoryId,
//     this.subSubCategoryId,
//     this.brandId,
//     this.userId,
//     this.favourite,
//     this.latitude,
//     this.longitude,
//     this.minPrice,
//     this.maxPrice,
//     this.minKmDriven,
//     this.maxKmDriven,
//     this.fuel,
//     this.numberOfOwner,
//     this.year,
//     this.sellStatus,
//     this.search,
//     this.datePublished,
//     this.sortByPrice,
//     this.distance,
//     this.itemCondition,
//     this.startDate,
//     this.endDate,
//     this.transmission,
//     this.modelId,
//     this.selectedAmnities,
//     this.propertyFor,
//     this.bedrooms,
//     this.bathrooms,
//     this.furnishedType,
//     this.ownership,
//     this.paymentType,
//     this.completionStatus,
//     this.deliveryTerm,
//     this.type,
//     this.level,
//     this.buildingAge,
//     this.listedBy,
//     this.rentalTerm,
//     this.accessToUtilities,
//     this.minDownPrice,
//     this.maxDownPrice,
//     this.maxAreaSize,
//     this.minAreaSize,
//   });
//
//   Map<String, String?> toMap() {
//     return {
//       'limit': limit,
//       'page': page,
//       'category_id': categoryId,
//       'sub_category_id': subcategoryId,
//       'sub_sub_category_id': subSubCategoryId,
//       'brand_id': brandId,
//       'user_id': userId,
//       'favourite': favourite,
//       'latitude': latitude,
//       'longitude': longitude,
//       'min_price': minPrice,
//       'max_price': maxPrice,
//       'min_km_driven': minKmDriven,
//       'max_km_driven': maxKmDriven,
//       'fuel': fuel,
//       'number_of_owner': numberOfOwner,
//       'year': year,
//       'sell_status': sellStatus,
//       'search': search,
//       'date_published': datePublished,
//       'sort_by_price': sortByPrice,
//       'distance': distance,
//       'item_condition': itemCondition,
//       'start_date': startDate,
//       'end_date': endDate,
//       'transmission': transmission,
//       'model_id': modelId,
//       'selected_amnities': selectedAmnities,
//       'property_for': propertyFor,
//       'bedrooms': bedrooms,
//       'bathrooms': bathrooms,
//       'furnished_type': furnishedType,
//       'ownership': ownership,
//       'payment_type': paymentType,
//       'completion_status': completionStatus,
//       'delivery_term': deliveryTerm,
//       'type': type,
//       'level': level,
//       'building_age': buildingAge,
//       'listed_by': listedBy,
//       'rental_term': rentalTerm,
//       'access_to_utilities': accessToUtilities,
//       'min_down_price': minDownPrice,
//       'max_down_price': maxDownPrice,
//       'max_area_size': maxAreaSize,
//       'min_area_size': minAreaSize
//     };
//   }
//
//   FilterModel copyWith({
//     String? limit,
//     String? page,
//     String? categoryId,
//     String? subcategoryId,
//     String? subSubCategoryId,
//     String? brandId,
//     String? userId,
//     String? favourite,
//     String? latitude,
//     String? longitude,
//     String? minPrice,
//     String? maxPrice,
//     String? minKmDriven,
//     String? maxKmDriven,
//     String? fuel,
//     String? numberOfOwner,
//     String? year,
//     String? sellStatus,
//     String? search,
//     String? datePublished,
//     String? sortByPrice,
//     String? distance,
//     String? itemCondition,
//     String? startDate,
//     String? endDate,
//     String? transmission,
//     String? modelId,
//     String? selectedAmnities,
//     String? propertyFor,
//     String? bedrooms,
//     String? bathrooms,
//     String? furnishedType,
//     String? ownership,
//     String? paymentType,
//     String? completionStatus,
//     String? deliveryTerm,
//     String? type,
//     String? level,
//     String? buildingAge,
//     String? listedBy,
//     String? rentalTerm,
//     String? accessToUtilities,
//     String? minDownPrice,
//     String? maxDownPrice,
//     String? maxAreaSize,
//     String? minAreaSize,
//   }) {
//     return FilterModel(
//       limit: limit ?? this.limit,
//       page: page ?? this.page,
//       categoryId: categoryId ?? this.categoryId,
//       subcategoryId: subcategoryId ?? this.subcategoryId,
//       subSubCategoryId: subSubCategoryId ?? this.subSubCategoryId,
//       brandId: brandId ?? this.brandId,
//       userId: userId ?? this.userId,
//       favourite: favourite ?? this.favourite,
//       latitude: latitude ?? this.latitude,
//       longitude: longitude ?? this.longitude,
//       minPrice: minPrice ?? this.minPrice,
//       maxPrice: maxPrice ?? this.maxPrice,
//       minKmDriven: minKmDriven ?? this.minKmDriven,
//       maxKmDriven: maxKmDriven ?? this.maxKmDriven,
//       fuel: fuel ?? this.fuel,
//       numberOfOwner: numberOfOwner ?? this.numberOfOwner,
//       year: year ?? this.year,
//       sellStatus: sellStatus ?? this.sellStatus,
//       search: search ?? this.search,
//       datePublished: datePublished ?? this.datePublished,
//       sortByPrice: sortByPrice ?? this.sortByPrice,
//       distance: distance ?? this.distance,
//       itemCondition: itemCondition ?? this.itemCondition,
//       startDate: startDate ?? this.startDate,
//       endDate: endDate ?? this.endDate,
//       transmission: transmission ?? this.transmission,
//       modelId: modelId ?? this.modelId,
//       selectedAmnities: selectedAmnities ?? this.selectedAmnities,
//       propertyFor: propertyFor ?? this.propertyFor,
//       bedrooms: bedrooms ?? this.bedrooms,
//       bathrooms: bathrooms ?? this.bathrooms,
//       furnishedType: furnishedType ?? this.furnishedType,
//       ownership: ownership ?? this.ownership,
//       paymentType: paymentType ?? this.paymentType,
//       completionStatus: completionStatus ?? this.completionStatus,
//       deliveryTerm: deliveryTerm ?? this.deliveryTerm,
//       level: level ?? this.level,
//       type: type ?? this.type,
//       buildingAge: buildingAge ?? this.buildingAge,
//       listedBy: listedBy ?? this.listedBy,
//       rentalTerm: rentalTerm ?? this.rentalTerm,
//       accessToUtilities: accessToUtilities ?? this.accessToUtilities,
//       minDownPrice: minDownPrice ?? this.minDownPrice,
//       maxDownPrice: maxDownPrice ?? this.maxDownPrice,
//       maxAreaSize: maxAreaSize ?? this.maxAreaSize,
//       minAreaSize: minAreaSize ?? this.minAreaSize,
//
//     );
//   }
// }

class FilterModel {
  String? screenFrom;

  /// for check route
  String? limit;
  String? page;
  String? categoryId;
  String? subcategoryId;
  String? subSubCategoryId;
  String? brandId;
  String? sizeId;
  String? userId;
  String? ram;
  String? storage;
  String? favourite;
  String? latitude;
  String? longitude;
  String? minPrice;
  String? maxPrice;
  String? minKmDriven;
  String? maxKmDriven;
  String? fuel;
  String? numberOfOwner;
  String? year;
  String? horsePower;
  String? bodyType;
  String? carColor;
  String? sellStatus;
  String? screenSize;
  String? search;
  String? datePublished;
  String? sortByPrice;
  String? distance;
  String? itemCondition;
  String? startDate;
  String? endDate;
  String? transmission;
  String? modelId;
  String? selectedAmnities;
  String? carRentalTerm;

  // New keys
  String? propertyFor;
  String? bedrooms;
  String? bathrooms;
  String? furnishedType;
  String? ownership;
  String? paymentType;
  String? completionStatus;
  String? deliveryTerm;
  String? type;
  String? level;
  String? buildingAge;
  String? listedBy;
  String? rentalTerm;
  String? accessToUtilities;
  String? minDownPrice;
  String? maxDownPrice;
  String? maxAreaSize;
  String? minAreaSize;
  String? salleryFrom;
  String? salleryTo;
  String? workSetting;
  String? workExperience;
  String? workEducation;
  String? milleage;
  String? engineCapacity;
  String? interiorColor;
  String? numbCylinders;
  String? numbDoors;

  FilterModel({
    this.screenFrom,
    this.limit,
    this.page,
    this.categoryId,
    this.subcategoryId,
    this.subSubCategoryId,
    this.brandId,
    this.userId,
    this.sizeId,
    this.favourite,
    this.latitude,
    this.longitude,
    this.minPrice,
    this.maxPrice,
    this.minKmDriven,
    this.maxKmDriven,
    this.fuel,
    this.numberOfOwner,
    this.year,
    this.horsePower,
    this.carColor,
    this.bodyType,
    this.sellStatus,
    this.search,
    this.datePublished,
    this.sortByPrice,
    this.distance,
    this.itemCondition,
    this.startDate,
    this.endDate,
    this.transmission,
    this.modelId,
    this.screenSize,
    this.selectedAmnities,
    this.propertyFor,
    this.bedrooms,
    this.bathrooms,
    this.furnishedType,
    this.ownership,
    this.paymentType,
    this.completionStatus,
    this.deliveryTerm,
    this.type,
    this.level,
    this.buildingAge,
    this.listedBy,
    this.rentalTerm,
    this.accessToUtilities,
    this.minDownPrice,
    this.maxDownPrice,
    this.maxAreaSize,
    this.minAreaSize,
    this.salleryFrom,
    this.salleryTo,
    this.workSetting,
    this.workExperience,
    this.workEducation,
    this.milleage,
    this.engineCapacity,
    this.interiorColor,
    this.numbCylinders,
    this.numbDoors,
    this.carRentalTerm,
  });

  // fromJson method
  FilterModel.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    page = json['page'];
    categoryId = json['category_id'];
    subcategoryId = json['sub_category_id'];
    subSubCategoryId = json['sub_sub_category_id'];
    brandId = json['brand_id'];
    sizeId = json['size_id'];
    userId = json['user_id'];
    favourite = json['favourite'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    carColor = json['car_color'];
    horsePower = json['horse_power'];
    screenSize = json['screen_size'];
    bodyType = json['body_type'];
    minKmDriven = json['min_km_driven'];
    maxKmDriven = json['max_km_driven'];
    fuel = json['fuel'];
    numberOfOwner = json['number_of_owner'];
    year = json['year'];
    ram = json['ram'];
    storage = json['storage'];
    sellStatus = json['sell_status'];
    search = json['search'];
    datePublished = json['date_published'];
    sortByPrice = json['sort_by_price'];
    distance = json['distance'];
    itemCondition = json['item_condition'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    transmission = json['transmission'];
    modelId = json['model_id'];
    selectedAmnities = json['selected_amnities'];
    propertyFor = json['property_for'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    furnishedType = json['furnished_type'];
    ownership = json['ownership'];
    paymentType = json['payment_type'];
    completionStatus = json['completion_status'];
    deliveryTerm = json['delivery_term'];
    type = json['type'];
    level = json['level'];
    buildingAge = json['building_age'];
    listedBy = json['listed_by'];
    rentalTerm = json['rental_term'];
    accessToUtilities = json['access_to_utilities'];
    minDownPrice = json['min_down_price'];
    maxDownPrice = json['max_down_price'];
    maxAreaSize = json['max_area_size'];
    minAreaSize = json['min_area_size'];
    salleryFrom = json['sallery_from'];
    salleryTo = json['sallery_to'];
    workSetting = json['work_setting'];
    workExperience = json['work_experience'];
    workEducation = json['work_education'];
    milleage = json['milleage'];
    engineCapacity = json['engine_capacity'];
    interiorColor = json['interior_color'];
    numbCylinders = json['numb_cylinders'];
    numbDoors = json['numb_doors'];
    carRentalTerm = json['car_rental_term'];
  }

  // toJson method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['limit'] = limit;
    data['page'] = page;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subcategoryId;
    data['sub_sub_category_id'] = subSubCategoryId;
    data['brand_id'] = brandId;
    data['user_id'] = userId;
    data['favourite'] = favourite;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['min_price'] = minPrice;
    data['size_id'] = sizeId;
    data['max_price'] = maxPrice;
    data['min_km_driven'] = minKmDriven;
    data['max_km_driven'] = maxKmDriven;
    data['car_color'] = carColor;
    data['body_type'] = bodyType;
    data['horse_power'] = horsePower;
    data['screen_size'] = screenSize;
    data['fuel'] = fuel;
    data['number_of_owner'] = numberOfOwner;
    data['year'] = year;
    data['sell_status'] = sellStatus;
    data['search'] = search;
    data['date_published'] = datePublished;
    data['sort_by_price'] = sortByPrice;
    data['distance'] = distance;
    data['item_condition'] = itemCondition;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['transmission'] = transmission;
    data['model_id'] = modelId;
    data['selected_amnities'] = selectedAmnities;
    data['property_for'] = propertyFor;
    data['bedrooms'] = bedrooms;
    data['bathrooms'] = bathrooms;
    data['furnished_type'] = furnishedType;
    data['ownership'] = ownership;
    data['payment_type'] = paymentType;
    data['completion_status'] = completionStatus;
    data['delivery_term'] = deliveryTerm;
    data['type'] = type;
    data['level'] = level;
    data['building_age'] = buildingAge;
    data['listed_by'] = listedBy;
    data['rental_term'] = rentalTerm;
    data['access_to_utilities'] = accessToUtilities;
    data['min_down_price'] = minDownPrice;
    data['max_down_price'] = maxDownPrice;
    data['max_area_size'] = maxAreaSize;
    data['min_area_size'] = minAreaSize;
    data['sallery_from'] = salleryFrom;
    data['sallery_to'] = salleryTo;
    data['work_setting'] = workSetting;
    data['work_experience'] = workExperience;
    data['work_education'] = workEducation;
    data['milleage'] = milleage;
    data['engine_capacity'] = engineCapacity;
    data['interior_color'] = interiorColor;
    data['numb_cylinders'] = numbCylinders;
    data['numb_doors'] = numbDoors;
    data['car_rental_term'] = carRentalTerm;
    data['ram'] = ram;
    data['storage'] = storage;
    data.removeWhere((key, value) => value == "" || value == null);
    return data;
  }
}
