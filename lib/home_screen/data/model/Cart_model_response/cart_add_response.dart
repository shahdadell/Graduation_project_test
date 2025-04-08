class CartAddResponse {
  bool? success;
  String? message;
  int? quantity;

  CartAddResponse({this.success, this.message, this.quantity});

  factory CartAddResponse.fromJson(Map<String, dynamic> json) {
    return CartAddResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      quantity: json['quantity'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'quantity': quantity,
      };
}
