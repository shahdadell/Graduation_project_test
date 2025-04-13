import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/home_screen/data/model/topSelling_model_response/TopSellinModelResponse.dart';

void showItemDetailsDialogTopSelling(BuildContext context, dynamic item) {
  // طباعة الـ item كامل عشان نتأكد منه
  print("Item received: $item");

  if (item is! TopSellingData) {
    print("Error: Item is not of type TopSellingData - Type: ${item.runtimeType}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: Invalid item type'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  // تحويل البيانات
  double originalPrice = double.tryParse(item.itemsPrice ?? '0') ?? 0.0;
  double discount = (double.tryParse(item.itemsDiscount ?? '0') ?? 0.0) / 100;
  double discountedPrice = originalPrice * (1 - discount);
  String itemName = item.itemsName ?? 'No Name';
  String itemDescription = item.itemsDes ?? 'No Description';
  String itemImage = item.itemsImage ?? '';
  String serviceId = item.serviceId ?? 'Unknown Service';
  String itemsCount = item.itemsCount ?? 'N/A';
  double rating = 0.0; // لو عندك قيمة حقيقية للـ rating، استبدليها
  String phoneNumber = 'Not Available'; // لو عندك رقم حقيقي، استبدليه

  // طباعة البيانات عشان نتأكد إنها وصلت
  print("Item Name: $itemName");
  print("Item Description: $itemDescription");
  print("Item Image: $itemImage");
  print("Original Price: $originalPrice");
  print("Discounted Price: $discountedPrice");

  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: AnimatedContainer(
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
                blurRadius: 10.r,
                spreadRadius: 2.r,
                offset: Offset(0, 3.h),
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
                        height: 140.h,
                        width: double.infinity,
                        child: itemImage.isNotEmpty
                            ? Image.network(
                          itemImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print("Image load error: $error");
                            return Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.broken_image,
                                size: 40.w,
                                color: Colors.grey[500],
                              ),
                            );
                          },
                        )
                            : Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.broken_image,
                            size: 40.w,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      Container(
                        height: 140.h,
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
                      if (discount > 0)
                        Positioned(
                          top: 6.h,
                          right: 6.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.redAccent, Colors.red[700]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.3),
                                  blurRadius: 3.r,
                                  offset: Offset(0, 1.h),
                                ),
                              ],
                            ),
                            child: Text(
                              '-${(discount * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.black87,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        itemDescription,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[700],
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Original',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${originalPrice.toStringAsFixed(2)} EGP',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                  decoration: discount > 0
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          if (discount > 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Discounted',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.green[800],
                                  ),
                                ),
                                Text(
                                  '${discountedPrice.toStringAsFixed(2)} EGP',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(6.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 3.r,
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
                                  size: 14.w,
                                  color: MyTheme.orangeColor,
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    'Service ID: $serviceId',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 14.w,
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '$rating / 5',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 14.w,
                                  color: Colors.green[700],
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  phoneNumber,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.inventory,
                                  size: 14.w,
                                  color: Colors.blue[700],
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Available: $itemsCount',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: Icons.favorite_border,
                            color: Colors.redAccent,
                            onTap: () {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Added to Favorites!',
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                  backgroundColor: Colors.black87,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          _buildActionButton(
                            icon: Icons.add_shopping_cart,
                            color: MyTheme.orangeColor,
                            onTap: () {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Add to Cart Coming Soon!',
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                  backgroundColor: Colors.black87,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      print("Dialog closed");
                      Navigator.pop(dialogContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.orangeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      elevation: 3,
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4.r,
            spreadRadius: 1.r,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 16.w,
      ),
    ),
  );
}