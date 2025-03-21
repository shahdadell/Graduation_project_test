class Datacart {
  String? cartId;
  String? cartUsersid;
  String? cartItemsid;
  String? cartOrders;
  String? cartQuantity;
  String? itemsName;
  String? itemsPrice;
  String? itemsImage;
  String? itemsCat;
  String? itemsDiscount;
  String? totalPrice;

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
        cartId: json['cart_id'] as String?,
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

  Map<String, dynamic> toJson() => {
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
