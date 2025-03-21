// class Offersdatum {
//   String? serviceId;
//   String? serviceName;
//   String? serviceNameAr;
//   String? serviceDescription;
//   String? serviceDescriptionAr;
//   String? serviceImage;
//   String? serviceLocation;
//   String? serviceRating;
//   String? servicePhone;
//   String? serviceEmail;
//   String? serviceWebsite;
//   String? serviceType;
//   String? serviceCat;
//   String? serviceActive;
//   String? serviceCreated;
//   String? itemsId;
//   String? itemsName;
//   String? itemsNameAr;
//   String? itemsDes;
//   String? itemsDesAr;
//   String? itemsImage;
//   String? itemsCount;
//   String? itemsActive;
//   String? itemsPrice;
//   String? itemsDiscount;
//   String? itemsDate;
//   String? itemsCat;
//   String? favorite;
//   String? itemspricediscount;

//   Offersdatum({
//     this.serviceId,
//     this.serviceName,
//     this.serviceNameAr,
//     this.serviceDescription,
//     this.serviceDescriptionAr,
//     this.serviceImage,
//     this.serviceLocation,
//     this.serviceRating,
//     this.servicePhone,
//     this.serviceEmail,
//     this.serviceWebsite,
//     this.serviceType,
//     this.serviceCat,
//     this.serviceActive,
//     this.serviceCreated,
//     this.itemsId,
//     this.itemsName,
//     this.itemsNameAr,
//     this.itemsDes,
//     this.itemsDesAr,
//     this.itemsImage,
//     this.itemsCount,
//     this.itemsActive,
//     this.itemsPrice,
//     this.itemsDiscount,
//     this.itemsDate,
//     this.itemsCat,
//     this.favorite,
//     this.itemspricediscount,
//   });

//   factory Offersdatum.fromJson(Map<String, dynamic> json) => Offersdatum(
//         serviceId: json['service_id'] as String?,
//         serviceName: json['service_name'] as String?,
//         serviceNameAr: json['service_name_ar'] as String?,
//         serviceDescription: json['service_description'] as String?,
//         serviceDescriptionAr: json['service_description_ar'] as String?,
//         serviceImage: json['service_image'] as String?,
//         serviceLocation: json['service_location'] as String?,
//         serviceRating: json['service_rating'] as String?,
//         servicePhone: json['service_phone'] as String?,
//         serviceEmail: json['service_email'] as String?,
//         serviceWebsite: json['service_website'] as String?,
//         serviceType: json['service_type'] as String?,
//         serviceCat: json['service_cat'] as String?,
//         serviceActive: json['service_active'] as String?,
//         serviceCreated: json['service_created'] as String?,
//         itemsId: json['items_id'] as String?,
//         itemsName: json['items_name'] as String?,
//         itemsNameAr: json['items_name_ar'] as String?,
//         itemsDes: json['items_des'] as String?,
//         itemsDesAr: json['items_des_ar'] as String?,
//         itemsImage: json['items_image'] as String?,
//         itemsCount: json['items_count'] as String?,
//         itemsActive: json['items_active'] as String?,
//         itemsPrice: json['items_price'] as String?,
//         itemsDiscount: json['items_discount'] as String?,
//         itemsDate: json['items_date'] as String?,
//         itemsCat: json['items_cat'] as String?,
//         favorite: json['favorite'] as String?,
//         itemspricediscount: json['itemspricediscount'] as String?,
//       );

//   Map<String, dynamic> toJson() => {
//         'service_id': serviceId,
//         'service_name': serviceName,
//         'service_name_ar': serviceNameAr,
//         'service_description': serviceDescription,
//         'service_description_ar': serviceDescriptionAr,
//         'service_image': serviceImage,
//         'service_location': serviceLocation,
//         'service_rating': serviceRating,
//         'service_phone': servicePhone,
//         'service_email': serviceEmail,
//         'service_website': serviceWebsite,
//         'service_type': serviceType,
//         'service_cat': serviceCat,
//         'service_active': serviceActive,
//         'service_created': serviceCreated,
//         'items_id': itemsId,
//         'items_name': itemsName,
//         'items_name_ar': itemsNameAr,
//         'items_des': itemsDes,
//         'items_des_ar': itemsDesAr,
//         'items_image': itemsImage,
//         'items_count': itemsCount,
//         'items_active': itemsActive,
//         'items_price': itemsPrice,
//         'items_discount': itemsDiscount,
//         'items_date': itemsDate,
//         'items_cat': itemsCat,
//         'favorite': favorite,
//         'itemspricediscount': itemspricediscount,
//       };
// }
