class Datacart {
  final int? cartId;
  final String? itemsName;
  final String? itemsPrice;
  final String? cartQuantity;

  Datacart({
    this.cartId,
    this.itemsName,
    this.itemsPrice,
    this.cartQuantity,
  });

  factory Datacart.fromJson(Map<String, dynamic> json) {
    return Datacart(
      cartId: json['cart_id'] != null ? int.tryParse(json['cart_id'].toString()) : null,
      itemsName: json['items_name'] as String?,
      itemsPrice: json['items_price'] as String?,
      cartQuantity: json['cart_quantity'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'items_name': itemsName,
      'items_price': itemsPrice,
      'cart_quantity': cartQuantity,
    };
  }
}