class CartEvent {}

class AddToCartEvent extends CartEvent {
  final int itemId;

  AddToCartEvent({required this.itemId});
}

class GetCartItemCountEvent extends CartEvent {
  final int itemId;

  GetCartItemCountEvent({required this.itemId});
}

class FetchCartEvent extends CartEvent {
  FetchCartEvent(int userId);
}

// class CartEvent {}

// class AddToCartEvent extends CartEvent {
//   final int userId;
//   final int itemId;

//   AddToCartEvent({required this.userId, required this.itemId});
// }

// class GetCartItemCountEvent extends CartEvent {
//   final int userId;
//   final int itemId;

//   GetCartItemCountEvent({required this.userId, required this.itemId});
// }

// class FetchCartEvent extends CartEvent {
//   final int userId;

//   FetchCartEvent({required this.userId});
// }
