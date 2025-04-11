class ServiceModel {
  String? categoryId;
  String? serviceName;
  String? serviceNameAr;
  String? serviceDescription;
  String? serviceDescriptionAr;
  String? serviceImage;
  String? serviceLocation;
  String? serviceRating;
  String? servicePhone;
  String? serviceEmail;
  String? serviceWebsite;
  String? serviceType;
  String? serviceCat;
  String? serviceActive;
  String? serviceCreated;

  ServiceModel({
    this.categoryId,
    this.serviceName,
    this.serviceNameAr,
    this.serviceDescription,
    this.serviceDescriptionAr,
    this.serviceImage,
    this.serviceLocation,
    this.serviceRating,
    this.servicePhone,
    this.serviceEmail,
    this.serviceWebsite,
    this.serviceType,
    this.serviceCat,
    this.serviceActive,
    this.serviceCreated,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        categoryId: json['service_id'] as String?,
        serviceName: json['service_name'] as String?,
        serviceNameAr: json['service_name_ar'] as String?,
        serviceDescription: json['service_description'] as String?,
        serviceDescriptionAr: json['service_description_ar'] as String?,
        serviceImage: json['service_image'] as String?,
        serviceLocation: json['service_location'] as String?,
        serviceRating: json['service_rating'] as String?,
        servicePhone: json['service_phone'] as String?,
        serviceEmail: json['service_email'] as String?,
        serviceWebsite: json['service_website'] as String?,
        serviceType: json['service_type'] as String?,
        serviceCat: json['service_cat'] as String?,
        serviceActive: json['service_active'] as String?,
        serviceCreated: json['service_created'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'service_id': categoryId,
        'service_name': serviceName,
        'service_name_ar': serviceNameAr,
        'service_description': serviceDescription,
        'service_description_ar': serviceDescriptionAr,
        'service_image': serviceImage,
        'service_location': serviceLocation,
        'service_rating': serviceRating,
        'service_phone': servicePhone,
        'service_email': serviceEmail,
        'service_website': serviceWebsite,
        'service_type': serviceType,
        'service_cat': serviceCat,
        'service_active': serviceActive,
        'service_created': serviceCreated,
      };
}
