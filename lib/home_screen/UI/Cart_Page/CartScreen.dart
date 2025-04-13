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
import 'package:graduation_project/home_screen/data/model/Cart_model_response/CartViewResponse.dart';
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
            child: Text(
              'Please log in to view your cart',
              style: TextStyle(fontSize: 16.sp, color: Colors.black87),
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => CartBloc(cartRepo: CartRepo())..add(FetchCartEvent(userId: userId)),
      child: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is DeleteCartItemSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Item quantity decreased'),
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
                content: Text('Failed to decrease quantity: ${state.message}'),
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
                      return _buildCartList(context, allItems, userId);
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
                          child: Text('Retry'),
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

  Widget _buildCartList(BuildContext context, List<Datacart> dataCart, int userId) {
    // حساب الـ total price بناءً على الـ items في الـ Cart
    double totalPrice = 0.0;
    for (var item in dataCart) {
      double price = double.tryParse(item.itemsPrice ?? '0.0') ?? 0.0;
      int quantity = int.tryParse(item.cartQuantity ?? '0') ?? 0;
      totalPrice += price * quantity;
    }

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
                'Items: ${dataCart.length}',
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
            itemCount: dataCart.length,
            itemBuilder: (context, index) {
              final item = dataCart[index];
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
                    Icon(Icons.fastfood, size: 30.w, color: MyTheme.orangeColor),
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
                    IconButton(
                      icon: Icon(Icons.delete, size: 24.w, color: Colors.redAccent),
                      onPressed: () {
                        if (item.cartId != null) {
                          context.read<CartBloc>().add(DeleteCartItemEvent(
                            userId: userId,
                            itemId: item.cartId!,
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cannot decrease quantity: Missing item ID'),
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
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
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
        ],
      ),
    );
  }
}