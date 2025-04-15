import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/home_screen/bloc/Cart/cart_bloc.dart';
import 'package:graduation_project/home_screen/bloc/Cart/cart_event.dart';
import 'package:graduation_project/home_screen/bloc/Cart/cart_state.dart';
import 'package:graduation_project/home_screen/data/model/topSelling_model_response/TopSellinModelResponse.dart';
import 'package:graduation_project/local_data/shared_preference.dart';

void showItemDetailsDialogTopSelling(BuildContext context, dynamic item) {
  if (item is! TopSellingData) {
    if (kDebugMode) {
      print(
          "Error: Item is not of type TopSellingData - Type: ${item.runtimeType}");
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error: Invalid item type'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  double originalPrice = double.tryParse(item.itemsPrice ?? '0') ?? 0.0;
  double discount = double.tryParse(item.itemsDiscount ?? '0') ?? 0.0;
  double discountedPrice = originalPrice * (1 - (discount / 100));
  String itemName = item.itemsName ?? 'No Name';
  String itemDescription = item.itemsDes ?? 'No Description';
  String itemImage = item.itemsImage ?? '';
  String serviceId = item.serviceId ?? 'Unknown Service';
  String itemsCount = item.itemsCount ?? 'N/A';
  double rating = 0.0; // لو فيه Rating حقيقي، استبدليه
  String phoneNumber = 'Not Available'; // لو فيه رقم حقيقي، استبدليه
  int quantity = 1;

  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: StatefulBuilder(
          builder: (dialogContext, setState) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: MediaQuery.of(dialogContext).size.width * 0.9,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12.r,
                    spreadRadius: 3.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.r)),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 160.h,
                            width: double.infinity,
                            child: itemImage.isNotEmpty
                                ? Image.network(
                                    itemImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      if (kDebugMode) {
                                        print("Image load error: $error");
                                      }
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 50.w,
                                          color: Colors.grey[500],
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50.w,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                          ),
                          Container(
                            height: 160.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          if (discount != 0)
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.redAccent,
                                      Colors.red[700]!
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.redAccent.withOpacity(0.3),
                                      blurRadius: 4.r,
                                      offset: Offset(0, 2.h),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '-${discount.toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                              color: Colors.black87,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            itemDescription,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[700],
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Original',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    '${originalPrice.toStringAsFixed(2)} EGP',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.grey[600],
                                      decoration: discount > 0
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Discounted',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                  Text(
                                    '${discountedPrice.toStringAsFixed(2)} EGP',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.green[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 4.r,
                                  spreadRadius: 1.r,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.store,
                                      size: 16.w,
                                      color: MyTheme.orangeColor,
                                    ),
                                    SizedBox(width: 6.w),
                                    Expanded(
                                      child: Text(
                                        'Service ID: $serviceId',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16.w,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      '$rating / 5',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 16.w,
                                      color: Colors.green[700],
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      phoneNumber,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.inventory,
                                      size: 16.w,
                                      color: Colors.blue[700],
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      'Available: $itemsCount',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                icon: Icons.favorite_border,
                                color: Colors.redAccent,
                                onTap: () {
                                  ScaffoldMessenger.of(dialogContext)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Added to Favorites!',
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                      backgroundColor: Colors.black87,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
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
                                      setState(() {
                                        if (quantity > 1) quantity--;
                                      });
                                    },
                                  ),
                                  Text(
                                    '$quantity',
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
                                      setState(() {
                                        quantity++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              BlocListener<CartBloc, CartState>(
                                listener: (context, state) {
                                  if (state is AddToCartSuccessState) {
                                    ScaffoldMessenger.of(dialogContext)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Added to Cart!',
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                        backgroundColor: Colors.green,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  } else if (state is AddToCartErrorState) {
                                    ScaffoldMessenger.of(dialogContext)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to add to cart: ${state.message}',
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                        backgroundColor: Colors.redAccent,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                child: _buildActionButton(
                                  icon: Icons.add_shopping_cart,
                                  color: MyTheme.orangeColor,
                                  onTap: () {
                                    final userId =
                                        AppLocalStorage.getData('user_id');
                                    if (userId != null) {
                                      final itemId = item.itemsId;
                                      if (itemId != null) {
                                        context
                                            .read<CartBloc>()
                                            .add(AddToCartEvent(
                                              userId: userId,
                                              itemId:
                                                  int.parse(itemId.toString()),
                                              quantity: quantity,
                                            ));
                                      } else {
                                        ScaffoldMessenger.of(dialogContext)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Cannot add to cart: Missing item ID',
                                              style: TextStyle(fontSize: 14.sp),
                                            ),
                                            backgroundColor: Colors.redAccent,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            duration:
                                                const Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(dialogContext)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Please log in to add to cart',
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                          backgroundColor: Colors.redAccent,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey[300]!, width: 1),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print("Dialog closed");
                          }
                          Navigator.pop(dialogContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyTheme.orangeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          elevation: 4,
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

Widget _buildActionButton({
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4.r,
            //spreadRadius: 1.r,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 18.w,
      ),
    ),
  );
}
