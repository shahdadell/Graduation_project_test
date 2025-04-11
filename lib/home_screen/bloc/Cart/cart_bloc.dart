import 'package:bloc/bloc.dart';
import 'package:graduation_project/home_screen/data/repo/cart_repo.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepo cartRepo;

  CartBloc({required this.cartRepo}) : super(CartInitialState()) {
    on<AddToCartEvent>(_onAddToCart);
    on<GetCartItemCountEvent>(_onGetCartItemCount);
    on<FetchCartEvent>(_onFetchCart);
  }

  Future<void> _onAddToCart(
      AddToCartEvent event, Emitter<CartState> emit) async {
    emit(AddToCartLoadingState());
    try {
      final response = await CartRepo.addToCart(itemId: event.itemId);
      emit(AddToCartSuccessState(cartResponse: response));
    } catch (e) {
      emit(AddToCartErrorState(message: e.toString()));
    }
  }

  Future<void> _onGetCartItemCount(
      GetCartItemCountEvent event, Emitter<CartState> emit) async {
    emit(GetCartItemCountLoadingState());
    try {
      final response = await CartRepo.getCartItemCount(itemId: event.itemId);
      emit(GetCartItemCountSuccessState(
          countResponse: response, itemId: event.itemId));
    } catch (e) {
      emit(GetCartItemCountErrorState(message: e.toString()));
    }
  }

  Future<void> _onFetchCart(
      FetchCartEvent event, Emitter<CartState> emit) async {
    emit(FetchCartLoadingState());
    try {
      final response = await CartRepo.fetchCart();
      emit(FetchCartSuccessState(cartViewResponse: response));
    } catch (e) {
      emit(FetchCartErrorState(message: e.toString()));
    }
  }
}
// class CartBloc extends Bloc<CartEvent, CartState> {
//   final CartRepo cartRepo;

//   CartBloc({required this.cartRepo}) : super(CartInitialState()) {
//     on<AddToCartEvent>(_onAddToCart);
//     on<GetCartItemCountEvent>(_onGetCartItemCount);
//     on<FetchCartEvent>(_onFetchCart); // التأكد إن الـ event ده مسجل
//   }

//   Future<void> _onAddToCart(
//       AddToCartEvent event, Emitter<CartState> emit) async {
//     emit(AddToCartLoadingState());
//     try {
//       final response = await CartRepo.addToCart(
//         userId: event.userId,
//         itemId: event.itemId,
//       );
//       emit(AddToCartSuccessState(cartResponse: response));
//     } catch (e) {
//       emit(AddToCartErrorState(message: e.toString()));
//     }
//   }

//   Future<void> _onGetCartItemCount(
//       GetCartItemCountEvent event, Emitter<CartState> emit) async {
//     emit(GetCartItemCountLoadingState());
//     try {
//       final response = await CartRepo.getCartItemCount(
//         userId: event.userId,
//         itemId: event.itemId,
//       );
//       emit(GetCartItemCountSuccessState(
//         countResponse: response,
//         itemId: event.itemId,
//       ));
//     } catch (e) {
//       emit(GetCartItemCountErrorState(message: e.toString()));
//     }
//   }

//   Future<void> _onFetchCart(
//       FetchCartEvent event, Emitter<CartState> emit) async {
//     emit(FetchCartLoadingState());
//     try {
//       final response = await CartRepo.fetchCart(userId: event.userId);
//       emit(FetchCartSuccessState(cartViewResponse: response));
//     } catch (e) {
//       emit(FetchCartErrorState(message: e.toString()));
//     }
//   }
// }
