import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/home_screen/bloc/Cart/cart_bloc.dart';
import 'package:graduation_project/home_screen/bloc/Cart/cart_event.dart';
import 'package:graduation_project/home_screen/bloc/Cart/cart_state.dart';
import 'package:graduation_project/home_screen/data/repo/cart_repo.dart';
import 'package:graduation_project/local_data/shared_preference.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/model/Cart_model_response/CartViewResponse.dart';
import '../../data/model/Cart_model_response/datacart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int? userId = AppLocalStorage.getData('user_id');
    if (userId == null) {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[100]!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Please log in to view your cart',
                  style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyTheme.orangeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) {
        final bloc = CartBloc(cartRepo: CartRepo());
        final cachedCart = AppLocalStorage.getCachedCart();
        if (cachedCart != null) {
          bloc.emit(FetchCartSuccessState(
            cartViewResponse: CartViewResponse.fromJson(cachedCart),
          ));
        } else {
          bloc.add(FetchCartEvent(userId: userId));
        }
        return bloc;
      },
      child: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is FetchCartSuccessState) {
            AppLocalStorage.cacheCart(state.cartViewResponse.toJson());
          } else if (state is DeleteCartItemSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Item removed from cart'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is DeleteCartItemErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to remove item: ${state.message}'),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is AddToCartSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Quantity updated!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is AddToCartErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update quantity: ${state.message}'),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[100]!, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is FetchCartLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(color: MyTheme.orangeColor),
                  );
                } else if (state is FetchCartSuccessState) {
                  final cart = state.cartViewResponse;
                  if (cart.status == 'success') {
                    final restCafeItems = cart.restCafe?.datacart ?? [];
                    final hotelTouristItems = cart.hotelTourist?.datacart ?? [];
                    final allItems = [...restCafeItems, ...hotelTouristItems];
                    if (allItems.isNotEmpty) {
                      return _buildCartList(context, allItems, userId, cart);
                    }
                    return _buildEmptyCart(context);
                  }
                  return _buildEmptyCart(context);
                } else if (state is FetchCartErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${state.message}',
                          style: TextStyle(fontSize: 16.sp, color: Colors.red),
                        ),
                        SizedBox(height: 10.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CartBloc>().add(FetchCartEvent(userId: userId));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.orangeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                          ),
                          child: Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return _buildEmptyCart(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Icon(Icons.arrow_back_ios, color: MyTheme.whiteColor, size: 24.w),
        ),
      ),
      title: Text(
        "Cart",
        style: TextStyle(
          fontSize: 22.sp,
          color: MyTheme.whiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: MyTheme.orangeColor,
    );
  }

  Widget _buildCartList(BuildContext context, List<Datacart> dataCart, int userId, CartViewResponse cart) {
    List<Datacart> localCartItems = List.from(dataCart);
    double totalPrice = calculateTotalPrice(cart);

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6.r,
                    spreadRadius: 1.r,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ${totalPrice.toStringAsFixed(2)} EGP',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Items: ${localCartItems.length}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                itemCount: localCartItems.length,
                itemBuilder: (context, index) {
                  final item = localCartItems[index];
                  return BlocConsumer<CartBloc, CartState>(
                    listener: (context, state) {
                      if (state is DeleteCartItemSuccessState) {
                        setState(() {
                          localCartItems.removeAt(index); // حذف العنصر من الـ UI يدويًا
                          totalPrice = calculateTotalPrice(cart); // تحديث السعر
                        });
                        context.read<CartBloc>().add(FetchCartEvent(userId: userId));
                      }
                    },
                    builder: (context, state) {
                      bool isLoading = state is DeleteCartItemLoadingState;
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey[50]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6.r,
                              spreadRadius: 1.r,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            item.itemsImage != null
                                ? CachedNetworkImage(
                              imageUrl: item.itemsImage!,
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  color: MyTheme.orangeColor,
                                  strokeWidth: 2.w,
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.fastfood,
                                size: 30.w,
                                color: MyTheme.orangeColor,
                              ),
                            )
                                : Icon(
                              Icons.fastfood,
                              size: 30.w,
                              color: MyTheme.orangeColor,
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.itemsName ?? 'No Name',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    'Price: ${item.itemsPrice ?? '0.00'} EGP | Qty: ${item.cartQuantity ?? '0'}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    size: 24.w,
                                    color: MyTheme.orangeColor,
                                  ),
                                  onPressed: () {
                                    if (item.cartItemsid != null &&
                                        (int.tryParse(item.cartQuantity ?? '0') ?? 0) > 1) {
                                      context.read<CartBloc>().add(DeleteCartItemEvent(
                                        userId: userId,
                                        itemId: int.parse(item.cartItemsid!),
                                      ));
                                    } else if (item.cartItemsid != null) {
                                      context.read<CartBloc>().add(DeleteCartItemEvent(
                                        userId: userId,
                                        itemId: int.parse(item.cartItemsid!),
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Cannot decrease quantity: Missing item ID'),
                                          backgroundColor: Colors.redAccent,
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  item.cartQuantity ?? '0',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: MyTheme.orangeColor,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    size: 24.w,
                                    color: MyTheme.orangeColor,
                                  ),
                                  onPressed: () {
                                    if (item.cartItemsid != null) {
                                      context.read<CartBloc>().add(AddToCartEvent(
                                        userId: userId,
                                        itemId: int.parse(item.cartItemsid!),
                                        quantity: 1,
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Cannot increase quantity: Missing item ID'),
                                          backgroundColor: Colors.redAccent,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                // IconButton(
                                //   icon: isLoading
                                //       ? SizedBox(
                                //     width: 24.w,
                                //     height: 24.w,
                                //     child: CircularProgressIndicator(
                                //       color: Colors.redAccent,
                                //       strokeWidth: 2.w,
                                //     ),
                                //   )
                                //       : Icon(
                                //     Icons.delete,
                                //     size: 24.w,
                                //     color: Colors.redAccent,
                                //   ),
                                //   onPressed: isLoading
                                //       ? null
                                //       : () {
                                //     if (item.cartItemsid != null) {
                                //       context.read<CartBloc>().add(DeleteCartItemEvent(
                                //         userId: userId,
                                //         itemId: int.parse(item.cartItemsid!),
                                //       ));
                                //     } else {
                                //       ScaffoldMessenger.of(context).showSnackBar(
                                //         const SnackBar(
                                //           content: Text('Cannot remove item: Missing item ID'),
                                //           backgroundColor: Colors.redAccent,
                                //           duration: Duration(seconds: 2),
                                //         ),
                                //       );
                                //     }
                                //   },
                                // ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Proceed to checkout!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyTheme.orangeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  minimumSize: Size(double.infinity, 0),
                ),
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/images/cartEmpty2.json',
            width: 200.w,
            height: 200.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20.h),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Start adding items now!',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/items');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.orangeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),

              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            ),
            child: Text(
              'Start Shopping',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateTotalPrice(CartViewResponse cart) {
    double totalPrice = 0.0;
    final restCafeItems = cart.restCafe?.datacart ?? [];
    final hotelTouristItems = cart.hotelTourist?.datacart ?? [];
    final allItems = [...restCafeItems, ...hotelTouristItems];

    for (var item in allItems) {
      double price = double.tryParse(item.itemsPrice ?? '0.0') ?? 0.0;
      int quantity = int.tryParse(item.cartQuantity ?? '0') ?? 0;
      totalPrice += price * quantity;
    }
    return totalPrice;
  }
}
