class Datacart {
  String? cartId;
  String? cartUsersid;
  String? cartItemsid;
  String? cartOrders;
  int? cartQuantity; // غيرتها لـ int
  String? itemsName;
  double? itemsPrice; // غيرتها لـ double
  String? itemsImage;
  String? itemsCat;
  String? itemsDiscount;
  double? totalPrice; // غيرتها لـ double

  Datacart({
    this.cartId,
    this.cartUsersid,
    this.cartItemsid,
    this.cartOrders,
    this.cartQuantity,
    this.itemsName,
    this.itemsPrice,
    this.itemsImage,
    this.itemsCat,
    this.itemsDiscount,
    this.totalPrice,
  });

  factory Datacart.fromJson(Map<String, dynamic> json) => Datacart(
        cartId: json['cart_id'] as String? ?? '',
        cartUsersid: json['cart_usersid'] as String? ?? '',
        cartItemsid: json['cart_itemsid'] as String? ?? '',
        cartOrders: json['cart_orders'] as String? ?? '',
        cartQuantity: json['cart_quantity'] != null
            ? int.tryParse(json['cart_quantity'].toString()) ?? 0
            : 0,
        itemsName: json['items_name'] as String? ?? 'No Name',
        itemsPrice: json['items_price'] != null
            ? double.tryParse(json['items_price'].toString()) ?? 0.0
            : 0.0,
        itemsImage: json['items_image'] as String? ?? '',
        itemsCat: json['items_cat'] as String? ?? '',
        itemsDiscount: json['items_discount'] != null
            ? json['items_discount'].toString()
            : '0',
        totalPrice: json['total_price'] != null
            ? double.tryParse(json['total_price'].toString()) ?? 0.0
            : 0.0,
      );

  Map<String, dynamic> toJson() => {
        'cart_id': cartId,
        'cart_usersid': cartUsersid,
        'cart_itemsid': cartItemsid,
        'cart_orders': cartOrders,
        'cart_quantity': cartQuantity?.toString(),
        'items_name': itemsName,
        'items_price': itemsPrice?.toString(),
        'items_image': itemsImage,
        'items_cat': itemsCat,
        'items_discount': itemsDiscount,
        'total_price': totalPrice?.toString(),
      };
}