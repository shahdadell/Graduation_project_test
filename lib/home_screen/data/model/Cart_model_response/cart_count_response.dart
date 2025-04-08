class CartCountResponse {
  final String status;
  final int quantity;
  final String? message;

  CartCountResponse({
    required this.status,
    required this.quantity,
    this.message,
  });

  factory CartCountResponse.fromJson(Map<String, dynamic> json) {
    return CartCountResponse(
      status: json['status'] as String,
      quantity: json['quantity'] as int? ?? 0,
      message: json['message'] as String?,
    );
  }
}
