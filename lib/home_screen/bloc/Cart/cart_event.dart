class CartEvent {}

class AddToCartEvent extends CartEvent {
  final int userId;
  final int itemId;
  final int quantity;

  AddToCartEvent({
    required this.userId,
    required this.itemId,
    this.quantity = 1,
  });
}

class GetCartItemCountEvent extends CartEvent {
  final int userId;
  final int itemId;

  GetCartItemCountEvent({
    required this.userId,
    required this.itemId,
  });
}

class FetchCartEvent extends CartEvent {
  final int userId;

  FetchCartEvent({required this.userId});
}

class DeleteCartItemEvent extends CartEvent {
  final int userId;
  final int itemId;

  DeleteCartItemEvent({
    required this.userId,
    required this.itemId,
  });
}
