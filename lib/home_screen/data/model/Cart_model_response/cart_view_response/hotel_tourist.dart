import 'package:graduation_project/home_screen/data/model/Cart_model_response/cart_view_response/countprice.dart';
import 'package:graduation_project/home_screen/data/model/Cart_model_response/cart_view_response/datacart.dart';

class HotelTourist {
  Countprice? countprice;
  List<Datacart>? datacart;

  HotelTourist({this.countprice, this.datacart});

  factory HotelTourist.fromJson(Map<String, dynamic> json) => HotelTourist(
        countprice: json['countprice'] == null
            ? null
            : Countprice.fromJson(json['countprice'] as Map<String, dynamic>),
        datacart: (json['datacart'] as List<dynamic>?)
            ?.map((e) => Datacart.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'countprice': countprice?.toJson(),
        'datacart': datacart?.map((e) => e.toJson()).toList(),
      };
}