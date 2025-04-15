import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Home_Screen/UI/home_page/home_screen.dart';
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

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final int? userId = AppLocalStorage.getData('user_id');
    if (userId == null) {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          color: MyTheme.whiteColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_rounded,
                  size: 80.w,
                  color: MyTheme.mauveColor.withOpacity(0.7),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Please log in to view your cart',
                  style: MyTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: MyTheme.mauveColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyTheme.orangeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
                    elevation: 5,
                    shadowColor: MyTheme.orangeColor.withOpacity(0.4),
                  ),
                  child: Text(
                    'Login',
                    style: MyTheme.lightTheme.textTheme.displayMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
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
        }
        bloc.add(FetchCartEvent(userId: userId));
        return bloc;
      },
      child: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is FetchCartSuccessState) {
            AppLocalStorage.cacheCart(state.cartViewResponse.toJson());
          } else if (state is DeleteCartItemSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: MyTheme.whiteColor, size: 16.w),
                    SizedBox(width: 8.w),
                    Text('Item removed from cart'),
                  ],
                ),
                backgroundColor: MyTheme.greenColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
            context.read<CartBloc>().add(FetchCartEvent(userId: userId));
          } else if (state is DeleteCartItemErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error_rounded,
                        color: MyTheme.whiteColor, size: 16.w),
                    SizedBox(width: 8.w),
                    Text('Failed to remove item: ${state.message}'),
                  ],
                ),
                backgroundColor: MyTheme.redColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is AddToCartSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: MyTheme.whiteColor, size: 16.w),
                    SizedBox(width: 8.w),
                    Text('Quantity updated!'),
                  ],
                ),
                backgroundColor: MyTheme.greenColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
            context.read<CartBloc>().add(FetchCartEvent(userId: userId));
          } else if (state is AddToCartErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error_rounded,
                        color: MyTheme.whiteColor, size: 16.w),
                    SizedBox(width: 8.w),
                    Text('Failed to update quantity: ${state.message}'),
                  ],
                ),
                backgroundColor: MyTheme.redColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: Container(
            color: MyTheme.whiteColor,
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is FetchCartLoadingState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: MyTheme.orangeColor,
                          strokeWidth: 3.w,
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          'Loading your cart...',
                          style:
                              MyTheme.lightTheme.textTheme.titleSmall?.copyWith(
                            fontSize: 18.sp,
                            color: MyTheme.mauveColor,
                          ),
                        ),
                      ],
                    ),
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
                        Icon(
                          Icons.error_rounded,
                          size: 80.w,
                          color: MyTheme.redColor.withOpacity(0.7),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Error: ${state.message}',
                          style: MyTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontSize: 18.sp,
                            color: MyTheme.redColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<CartBloc>()
                                .add(FetchCartEvent(userId: userId));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.orangeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.w, vertical: 12.h),
                            elevation: 5,
                            shadowColor: MyTheme.orangeColor.withOpacity(0.4),
                          ),
                          child: Text(
                            'Retry',
                            style: MyTheme.lightTheme.textTheme.displayMedium
                                ?.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: MyTheme.orangeColor,
                        strokeWidth: 3.w,
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        'Loading your cart...',
                        style:
                            MyTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontSize: 18.sp,
                          color: MyTheme.mauveColor,
                        ),
                      ),
                    ],
                  ),
                );
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
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: MyTheme.whiteColor,
            size: 24.w,
          ),
        ),
      ),
      title: Text(
        "Your Cart",
        style: MyTheme.lightTheme.textTheme.displayLarge?.copyWith(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: MyTheme.grayColor3,
              blurRadius: 3.r,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
      centerTitle: true,
      backgroundColor: MyTheme.orangeColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.r),
        ),
      ),
    );
  }

  Widget _buildCartList(BuildContext context, List<Datacart> dataCart,
      int userId, CartViewResponse cart) {
    List<Datacart> localCartItems = List.from(dataCart);
    double totalPrice = calculateTotalPrice(cart);

    return Column(
      children: [
        // قائمة العناصر
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
            itemCount: localCartItems.length,
            itemBuilder: (context, index) {
              final item = localCartItems[index];
              return BlocConsumer<CartBloc, CartState>(
                listener: (context, state) {
                  if (state is DeleteCartItemSuccessState) {
                    setState(() {
                      localCartItems.removeAt(index);
                      totalPrice = calculateTotalPrice(cart);
                    });
                    context
                        .read<CartBloc>()
                        .add(FetchCartEvent(userId: userId));
                  }
                },
                builder: (context, state) {
                  bool isLoading = state is DeleteCartItemLoadingState ||
                      state is AddToCartLoadingState;
                  double itemPrice =
                      double.tryParse(item.itemsPrice ?? '0.0') ?? 0.0;
                  int itemQuantity =
                      int.tryParse(item.cartQuantity ?? '0') ?? 0;
                  double totalItemPrice = itemPrice * itemQuantity;

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 6.h),
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: MyTheme.whiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: MyTheme.grayColor.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: MyTheme.grayColor3.withOpacity(0.3),
                          blurRadius: 6.r,
                          spreadRadius: 1.r,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: item.itemsImage != null
                              ? CachedNetworkImage(
                                  imageUrl: item.itemsImage!,
                                  width: 70.w,
                                  height: 60.h,
                                  fit: BoxFit.cover,
                                  memCacheHeight: (60.h).toInt(),
                                  memCacheWidth: (60.w).toInt(),
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      color: MyTheme.orangeColor,
                                      strokeWidth: 2.w,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.fastfood_rounded,
                                    size: 24.w,
                                    color: MyTheme.orangeColor,
                                  ),
                                )
                              : Icon(
                                  Icons.fastfood_rounded,
                                  size: 24.w,
                                  color: MyTheme.orangeColor,
                                ),
                        ),
                        SizedBox(width: 12.w),
                        // التفاصيل
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.itemsName ?? 'No Name',
                                style: MyTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: MyTheme.mauveColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                '${itemPrice.toStringAsFixed(2)} EGP',
                                style: MyTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontSize: 12.sp,
                                  color: MyTheme.greenColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Qty: $itemQuantity',
                                style: MyTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  fontSize: 12.sp,
                                  color: MyTheme.grayColor2,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Total: ${totalItemPrice.toStringAsFixed(2)} EGP',
                                style: MyTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontSize: 12.sp,
                                  color: MyTheme.greenColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (item.cartItemsid != null &&
                                    (int.tryParse(item.cartQuantity ?? '0') ??
                                            0) >
                                        1) {
                                  context
                                      .read<CartBloc>()
                                      .add(DeleteCartItemEvent(
                                        userId: userId,
                                        itemId: int.parse(item.cartItemsid!),
                                      ));
                                } else if (item.cartItemsid != null) {
                                  context
                                      .read<CartBloc>()
                                      .add(DeleteCartItemEvent(
                                        userId: userId,
                                        itemId: int.parse(item.cartItemsid!),
                                      ));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Cannot decrease quantity: Missing item ID'),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.w),
                                decoration: BoxDecoration(
                                  color: MyTheme.orangeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Icon(
                                  Icons.remove_rounded,
                                  size: 18.w,
                                  color: MyTheme.orangeColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              item.cartQuantity ?? '0',
                              style: MyTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: MyTheme.mauveColor,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: () {
                                if (item.cartItemsid != null) {
                                  context.read<CartBloc>().add(AddToCartEvent(
                                        userId: userId,
                                        itemId: int.parse(item.cartItemsid!),
                                        quantity: 1,
                                      ));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Cannot increase quantity: Missing item ID'),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.w),
                                decoration: BoxDecoration(
                                  color: MyTheme.orangeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Icon(
                                  Icons.add_rounded,
                                  size: 18.w,
                                  color: MyTheme.orangeColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () {
                                      if (item.cartItemsid != null) {
                                        context
                                            .read<CartBloc>()
                                            .add(DeleteCartItemEvent(
                                              userId: userId,
                                              itemId:
                                                  int.parse(item.cartItemsid!),
                                            ));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Cannot remove item: Missing item ID'),
                                            backgroundColor: Colors.redAccent,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                              child: Container(
                                padding: EdgeInsets.all(5.w),
                                decoration: BoxDecoration(
                                  color: MyTheme.redColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        width: 18.w,
                                        height: 18.w,
                                        child: CircularProgressIndicator(
                                          color: MyTheme.redColor,
                                          strokeWidth: 2.w,
                                        ),
                                      )
                                    : Icon(
                                        Icons.delete_rounded,
                                        size: 18.w,
                                        color: MyTheme.redColor,
                                      ),
                              ),
                            ),
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
        // الـ Total Price وعدد الـ Items في الأسفل
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: MyTheme.mauveColor.withOpacity(0.1),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '${totalPrice.toStringAsFixed(2)} EGP',
                    style: MyTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.greenColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: MyTheme.orangeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_cart_rounded,
                      size: 18.w,
                      color: MyTheme.orangeColor,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '${localCartItems.length} Item${localCartItems.length != 1 ? 's' : ''}',
                      style: MyTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: MyTheme.orangeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // زر الـ Checkout
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.payment_rounded,
                          color: MyTheme.whiteColor, size: 16.w),
                      SizedBox(width: 8.w),
                      Text('Proceed to checkout!'),
                    ],
                  ),
                  backgroundColor: MyTheme.greenColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.orangeColor,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              elevation: 5,
              shadowColor: MyTheme.orangeColor.withOpacity(0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.payment_rounded,
                  size: 18.w,
                  color: MyTheme.whiteColor,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Checkout (${totalPrice.toStringAsFixed(2)} EGP)',
                  style: MyTheme.lightTheme.textTheme.displayMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
            style: MyTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: MyTheme.mauveColor,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Start adding items now!',
            style: MyTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontSize: 16.sp,
              color: MyTheme.grayColor2,
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                HomeScreen.routName,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.orangeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.h),
              elevation: 5,
              shadowColor: MyTheme.orangeColor.withOpacity(0.4),
            ),
            child: Text(
              'Start Shopping',
              style: MyTheme.lightTheme.textTheme.displayMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
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
