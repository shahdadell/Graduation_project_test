class OffersModelResponse {
  final String status;
  final List<OfferData> data;

  OffersModelResponse({required this.status, required this.data});

  factory OffersModelResponse.fromJson(Map<String, dynamic> json) {
    return OffersModelResponse(
      status: json['status'],
      data:
          List<OfferData>.from(json['data'].map((x) => OfferData.fromJson(x))),
    );
  }
}

class OfferData {
  final String serviceId;
  final String serviceName;
  final String itemsId;
  final String itemsName;
  final String? itemsImage;
  final String? itemsDiscount;
  final String? itemsPrice;

  OfferData({
    required this.serviceId,
    required this.serviceName,
    required this.itemsId,
    required this.itemsName,
    this.itemsImage,
    this.itemsDiscount,
    this.itemsPrice,
  });

  factory OfferData.fromJson(Map<String, dynamic> json) {
    return OfferData(
      serviceId: json['service_id'],
      serviceName: json['service_name'],
      itemsId: json['items_id'],
      itemsName: json['items_name'],
      itemsImage: json['items_image'],
      itemsDiscount: json['items_discount'],
      itemsPrice: json['items_price'],
    );
  }
}
