import 'countprice.dart';
import 'datacart.dart';

class RestCafe {
  Countprice? countprice;
  List<Datacart>? datacart;

  RestCafe({this.countprice, this.datacart});

  factory RestCafe.fromJson(Map<String, dynamic> json) => RestCafe(
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
