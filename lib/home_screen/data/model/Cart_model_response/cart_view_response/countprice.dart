class Countprice {
  String? totalprice;
  String? totalcount;

  Countprice({this.totalprice, this.totalcount});

  factory Countprice.fromJson(Map<String, dynamic> json) => Countprice(
        totalprice: json['totalprice'] as String? ?? '0.00',
        totalcount: json['totalcount'] as String? ?? '0',
      );

  Map<String, dynamic> toJson() => {
        'totalprice': totalprice,
        'totalcount': totalcount,
      };
}