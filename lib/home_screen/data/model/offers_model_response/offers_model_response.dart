class OffersModel {
  final String status;
  final List<OfferData> data;

  OffersModel({required this.status, required this.data});

  factory OffersModel.fromJson(Map<String, dynamic> json) {
    return OffersModel(
      status: json['status'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => OfferData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class OfferData {
  final String serviceId;
  final String serviceName;
  final String serviceNameAr;
  final String serviceDescription;
  final String serviceDescriptionAr;
  final String serviceImage;
  final String serviceLocation;
  final String serviceRating;
  final String servicePhone;
  final String serviceEmail;
  final String serviceWebsite;
  final String serviceType;
  final String serviceCat;
  final String serviceActive;
  final String serviceCreated;
  final String itemsId;
  final String itemsName;
  final String itemsNameAr;
  final String itemsDes;
  final String itemsDesAr;
  final String itemsImage;
  final String itemsCount;
  final String itemsActive;
  final String itemsPrice;
  final String itemsDiscount;
  final String itemsDate;
  final String itemsCat;
  final String favorite;
  final String itemsPriceDiscount;

  OfferData({
    required this.serviceId,
    required this.serviceName,
    required this.serviceNameAr,
    required this.serviceDescription,
    required this.serviceDescriptionAr,
    required this.serviceImage,
    required this.serviceLocation,
    required this.serviceRating,
    required this.servicePhone,
    required this.serviceEmail,
    required this.serviceWebsite,
    required this.serviceType,
    required this.serviceCat,
    required this.serviceActive,
    required this.serviceCreated,
    required this.itemsId,
    required this.itemsName,
    required this.itemsNameAr,
    required this.itemsDes,
    required this.itemsDesAr,
    required this.itemsImage,
    required this.itemsCount,
    required this.itemsActive,
    required this.itemsPrice,
    required this.itemsDiscount,
    required this.itemsDate,
    required this.itemsCat,
    required this.favorite,
    required this.itemsPriceDiscount,
  });

  factory OfferData.fromJson(Map<String, dynamic> json) {
    return OfferData(
      serviceId: json['service_id'] ?? '',
      serviceName: json['service_name'] ?? '',
      serviceNameAr: json['service_name_ar'] ?? '',
      serviceDescription: json['service_description'] ?? '',
      serviceDescriptionAr: json['service_description_ar'] ?? '',
      serviceImage: json['service_image'] ?? '',
      serviceLocation: json['service_location'] ?? '',
      serviceRating: json['service_rating'] ?? '',
      servicePhone: json['service_phone'] ?? '',
      serviceEmail: json['service_email'] ?? '',
      serviceWebsite: json['service_website'] ?? '',
      serviceType: json['service_type'] ?? '',
      serviceCat: json['service_cat'] ?? '',
      serviceActive: json['service_active'] ?? '',
      serviceCreated: json['service_created'] ?? '',
      itemsId: json['items_id'] ?? '',
      itemsName: json['items_name'] ?? '',
      itemsNameAr: json['items_name_ar'] ?? '',
      itemsDes: json['items_des'] ?? '',
      itemsDesAr: json['items_des_ar'] ?? '',
      itemsImage: json['items_image'] ?? '',
      itemsCount: json['items_count'] ?? '',
      itemsActive: json['items_active'] ?? '',
      itemsPrice: json['items_price'] ?? '',
      itemsDiscount: json['items_discount'] ?? '',
      itemsDate: json['items_date'] ?? '',
      itemsCat: json['items_cat'] ?? '',
      favorite: json['favorite'] ?? '',
      itemsPriceDiscount: json['itemspricediscount'] ?? '',
    );
  }
}
