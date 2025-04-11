class Countprice {
  String? totalprice;
  String? totalcount;

  Countprice({this.totalprice, this.totalcount});

  factory Countprice.fromJson(Map<String, dynamic> json) => Countprice(
        totalprice: json['totalprice'] as String?,
        totalcount: json['totalcount'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'totalprice': totalprice,
        'totalcount': totalcount,
      };
}
