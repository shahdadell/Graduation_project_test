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
      status: json['status'] as String? ?? 'error',
      quantity: json['quantity'] != null
          ? int.tryParse(json['quantity'].toString()) ?? 0
          : 0,
      message: json['message'] as String?,
    );
  }
}