import 'countprice.dart';

class HotelTourist {
  Countprice? countprice;
  List<dynamic>? datacart;

  HotelTourist({this.countprice, this.datacart});

  factory HotelTourist.fromJson(Map<String, dynamic> json) => HotelTourist(
        countprice: json['countprice'] == null
            ? null
            : Countprice.fromJson(json['countprice'] as Map<String, dynamic>),
        datacart: json['datacart'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'countprice': countprice?.toJson(),
        'datacart': datacart,
      };
}
