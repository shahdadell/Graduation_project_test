import 'hotel_tourist.dart';
import 'rest_cafe.dart';

class CartViewResponse {
  String? status;
  RestCafe? restCafe;
  HotelTourist? hotelTourist;

  CartViewResponse({this.status, this.restCafe, this.hotelTourist});

  factory CartViewResponse.fromJson(Map<String, dynamic> json) {
    return CartViewResponse(
      status: json['status'] as String? ?? 'error',
      restCafe: json['rest_cafe'] == null
          ? null
          : RestCafe.fromJson(json['rest_cafe'] as Map<String, dynamic>),
      hotelTourist: json['hotel_tourist'] == null
          ? null
          : HotelTourist.fromJson(
              json['hotel_tourist'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'rest_cafe': restCafe?.toJson(),
        'hotel_tourist': hotelTourist?.toJson(),
      };
}