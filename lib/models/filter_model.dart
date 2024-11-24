class FilterModel {
  String? limit;
  String? page;
  String? categoryId;
  String? subcategoryId;
  String? brandId;
  String? userId;
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
  String? sellStatus;
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

  //new keys
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

  FilterModel({
    this.limit,
    this.page,
    this.categoryId,
    this.subcategoryId,
    this.brandId,
    this.userId,
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
  });

  Map<String, String?> toMap() {
    return {
      'limit': limit,
      'page': page,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'brand_id': brandId,
      'user_id': userId,
      'favourite': favourite,
      'latitude': latitude,
      'longitude': longitude,
      'min_price': minPrice,
      'max_price': maxPrice,
      'min_km_driven': minKmDriven,
      'max_km_driven': maxKmDriven,
      'fuel': fuel,
      'number_of_owner': numberOfOwner,
      'year': year,
      'sell_status': sellStatus,
      'search': search,
      'date_published': datePublished,
      'sort_by_price': sortByPrice,
      'distance': distance,
      'item_condition': itemCondition,
      'start_date': startDate,
      'end_date': endDate,
      'transmission': transmission,
      'model_id': modelId,
      'selected_amnities': selectedAmnities,
      'property_for': propertyFor,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'furnished_type': furnishedType,
      'ownership': ownership,
      'payment_type': paymentType,
      'completion_status': completionStatus,
      'delivery_term': deliveryTerm,
      'type': type,
      'level': level,
      'building_age': buildingAge,
      'listed_by': listedBy,
      'rental_term': rentalTerm,
      'access_to_utilities': accessToUtilities,
      'min_down_price': minDownPrice,
      'max_down_price': maxDownPrice,
      'max_area_size': maxAreaSize,
      'min_area_size': minAreaSize
    };
  }

  FilterModel copyWith({
    String? limit,
    String? page,
    String? categoryId,
    String? subcategoryId,
    String? brandId,
    String? userId,
    String? favourite,
    String? latitude,
    String? longitude,
    String? minPrice,
    String? maxPrice,
    String? minKmDriven,
    String? maxKmDriven,
    String? fuel,
    String? numberOfOwner,
    String? year,
    String? sellStatus,
    String? search,
    String? datePublished,
    String? sortByPrice,
    String? distance,
    String? itemCondition,
    String? startDate,
    String? endDate,
    String? transmission,
    String? modelId,
    String? selectedAmnities,
    String? propertyFor,
    String? bedrooms,
    String? bathrooms,
    String? furnishedType,
    String? ownership,
    String? paymentType,
    String? completionStatus,
    String? deliveryTerm,
    String? type,
    String? level,
    String? buildingAge,
    String? listedBy,
    String? rentalTerm,
    String? accessToUtilities,
    String? minDownPrice,
    String? maxDownPrice,
    String? maxAreaSize,
    String? minAreaSize,
  }) {
    return FilterModel(
      limit: limit ?? this.limit,
      page: page ?? this.page,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      brandId: brandId ?? this.brandId,
      userId: userId ?? this.userId,
      favourite: favourite ?? this.favourite,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minKmDriven: minKmDriven ?? this.minKmDriven,
      maxKmDriven: maxKmDriven ?? this.maxKmDriven,
      fuel: fuel ?? this.fuel,
      numberOfOwner: numberOfOwner ?? this.numberOfOwner,
      year: year ?? this.year,
      sellStatus: sellStatus ?? this.sellStatus,
      search: search ?? this.search,
      datePublished: datePublished ?? this.datePublished,
      sortByPrice: sortByPrice ?? this.sortByPrice,
      distance: distance ?? this.distance,
      itemCondition: itemCondition ?? this.itemCondition,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      transmission: transmission ?? this.transmission,
      modelId: modelId ?? this.modelId,
      selectedAmnities: selectedAmnities ?? this.selectedAmnities,
      propertyFor: propertyFor ?? this.propertyFor,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      furnishedType: furnishedType ?? this.furnishedType,
      ownership: ownership ?? this.ownership,
      paymentType: paymentType ?? this.paymentType,
      completionStatus: completionStatus ?? this.completionStatus,
      deliveryTerm: deliveryTerm ?? this.deliveryTerm,
      level: level ?? this.level,
      type: type ?? this.type,
      buildingAge: buildingAge ?? this.buildingAge,
      listedBy: listedBy ?? this.listedBy,
      rentalTerm: rentalTerm ?? this.rentalTerm,
      accessToUtilities: accessToUtilities ?? this.accessToUtilities,
      minDownPrice: minDownPrice ?? this.minDownPrice,
      maxDownPrice: maxDownPrice ?? this.maxDownPrice,
      maxAreaSize: maxAreaSize ?? this.maxAreaSize,
      minAreaSize: minAreaSize ?? this.minAreaSize,

    );
  }
}
