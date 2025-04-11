import 'package:graduation_project/home_screen/data/model/Cart_model_response/cart_add_response.dart';
import 'package:graduation_project/home_screen/data/model/Cart_model_response/cart_count_response.dart';
import 'package:graduation_project/home_screen/data/model/Cart_model_response/cart_view_response/cart_view_response.dart';

class CartState {}

class CartInitialState extends CartState {}

class AddToCartLoadingState extends CartState {}

class AddToCartSuccessState extends CartState {
  final CartAddResponse cartResponse;

  AddToCartSuccessState({required this.cartResponse});
}

class AddToCartErrorState extends CartState {
  final String message;

  AddToCartErrorState({required this.message});
}

class GetCartItemCountLoadingState extends CartState {}

class GetCartItemCountSuccessState extends CartState {
  final CartCountResponse countResponse;
  final int? itemId;

  GetCartItemCountSuccessState({required this.countResponse, this.itemId});
}

class GetCartItemCountErrorState extends CartState {
  final String message;

  GetCartItemCountErrorState({required this.message});
}

class FetchCartLoadingState extends CartState {}

class FetchCartSuccessState extends CartState {
  final CartViewResponse cartViewResponse;

  FetchCartSuccessState({required this.cartViewResponse});
}

class FetchCartErrorState extends CartState {
  final String message;

  FetchCartErrorState({required this.message});
}
