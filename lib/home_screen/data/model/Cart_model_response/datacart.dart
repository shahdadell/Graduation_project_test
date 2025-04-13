class Datacart {
  String? cartId;
  String? cartUsersid;
  String? cartItemsid; // تأكدي إن الحقل ده موجود
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

  Datacart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id']?.toString();
    cartUsersid = json['cart_usersid']?.toString();
    cartItemsid = json['cart_itemsid']?.toString(); // التأكد من الحقل ده
    cartOrders = json['cart_orders']?.toString();
    cartQuantity = json['cart_quantity']?.toString();
    itemsName = json['items_name']?.toString();
    itemsPrice = json['items_price']?.toString();
    itemsImage = json['items_image']?.toString();
    itemsCat = json['items_cat']?.toString();
    itemsDiscount = json['items_discount']?.toString();
    totalPrice = json['total_price']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['cart_usersid'] = cartUsersid;
    data['cart_itemsid'] = cartItemsid;
    data['cart_orders'] = cartOrders;
    data['cart_quantity'] = cartQuantity;
    data['items_name'] = itemsName;
    data['items_price'] = itemsPrice;
    data['items_image'] = itemsImage;
    data['items_cat'] = itemsCat;
    data['items_discount'] = itemsDiscount;
    data['total_price'] = totalPrice;
    return data;
  }
}
