class Datacart {
  final int? cartId;
  final String? cartUsersid;
  final String? cartItemsid;
  final String? cartOrders;
  final String? cartQuantity;
  final String? itemsName;
  final String? itemsPrice;
  final String? itemsImage;
  final String? itemsCat;
  final String? itemsDiscount;
  final String? totalPrice;

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

  factory Datacart.fromJson(Map<String, dynamic> json) {
    return Datacart(
      cartId: json['cart_id'] != null ? int.tryParse(json['cart_id'].toString()) : null,
      cartUsersid: json['cart_usersid'] as String?,
      cartItemsid: json['cart_itemsid'] as String?,
      cartOrders: json['cart_orders'] as String?,
      cartQuantity: json['cart_quantity'] as String?,
      itemsName: json['items_name'] as String?,
      itemsPrice: json['items_price'] as String?,
      itemsImage: json['items_image'] as String?,
      itemsCat: json['items_cat'] as String?,
      itemsDiscount: json['items_discount'] as String?,
      totalPrice: json['total_price'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'cart_usersid': cartUsersid,
      'cart_itemsid': cartItemsid,
      'cart_orders': cartOrders,
      'cart_quantity': cartQuantity,
      'items_name': itemsName,
      'items_price': itemsPrice,
      'items_image': itemsImage,
      'items_cat': itemsCat,
      'items_discount': itemsDiscount,
      'total_price': totalPrice,
    };
  }
}