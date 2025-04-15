import 'datacart.dart';

/// status : "success"
/// rest_cafe : {"countprice":{"totalprice":"0","totalcount":"0"},"datacart":[]}
/// hotel_tourist : {"countprice":{"totalprice":"0","totalcount":"0"},"datacart":[]}

class CartViewResponse {
  CartViewResponse({
    this.status,
    this.restCafe,
    this.hotelTourist,
  });

  CartViewResponse.fromJson(dynamic json) {
    status = json['status'];
    restCafe =
        json['rest_cafe'] != null ? RestCafe.fromJson(json['rest_cafe']) : null;
    hotelTourist = json['hotel_tourist'] != null
        ? HotelTourist.fromJson(json['hotel_tourist'])
        : null;
  }
  String? status;
  RestCafe? restCafe;
  HotelTourist? hotelTourist;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (restCafe != null) {
      map['rest_cafe'] = restCafe?.toJson();
    }
    if (hotelTourist != null) {
      map['hotel_tourist'] = hotelTourist?.toJson();
    }
    return map;
  }
}

/// countprice : {"totalprice":"0","totalcount":"0"}
/// datacart : []

class HotelTourist {
  HotelTourist({
    this.countprice,
    this.datacart,
  });

  HotelTourist.fromJson(dynamic json) {
    countprice = json['countprice'] != null
        ? Countprice.fromJson(json['countprice'])
        : null;
    if (json['datacart'] != null) {
      datacart = [];
      json['datacart'].forEach((v) {
        datacart?.add(Datacart.fromJson(v));
      });
    }
  }
  Countprice? countprice;
  List<Datacart>? datacart;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (countprice != null) {
      map['countprice'] = countprice?.toJson();
    }
    if (datacart != null) {
      map['datacart'] = datacart?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// totalprice : "0"
/// totalcount : "0"

class Countprice {
  Countprice({
    this.totalprice,
    this.totalcount,
  });

  Countprice.fromJson(dynamic json) {
    totalprice = json['totalprice'];
    totalcount = json['totalcount'];
  }
  String? totalprice;
  String? totalcount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalprice'] = totalprice;
    map['totalcount'] = totalcount;
    return map;
  }
}

/// countprice : {"totalprice":"0","totalcount":"0"}
/// datacart : []

class RestCafe {
  RestCafe({
    this.countprice,
    this.datacart,
  });

  RestCafe.fromJson(dynamic json) {
    countprice = json['countprice'] != null
        ? Countprice.fromJson(json['countprice'])
        : null;
    if (json['datacart'] != null) {
      datacart = [];
      json['datacart'].forEach((v) {
        datacart?.add(Datacart.fromJson(v));
      });
    }
  }
  Countprice? countprice;
  List<Datacart>? datacart;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (countprice != null) {
      map['countprice'] = countprice?.toJson();
    }
    if (datacart != null) {
      map['datacart'] = datacart?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
