import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';

void showItemDetailsDialog(BuildContext context, dynamic item) {
  double originalPrice = (item.itemsPrice ?? 0.0).toDouble();
  double discount = (item.itemsDiscount ?? 0) / 100;
  double discountedPrice = originalPrice * (1 - discount);

  // بيانات من الـ ItemModel
  String restaurantName = item.serviceName ?? 'Unknown Restaurant';
  double rating = item.serviceRating ?? 0.0;
  String phoneNumber = item.servicePhone ?? 'Not Available';

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
                // الصورة (ارتفاع أقل)
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.r)),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 160.h, // ارتفاع أقل من 200.h
                        width: double.infinity,
                        child: item.itemsImage != null &&
                                item.itemsImage!.isNotEmpty
                            ? Image.network(
                                item.itemsImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
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
                      if (item.itemsDiscount != null && item.itemsDiscount != 0)
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.redAccent, Colors.red[700]!],
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
                              '-${item.itemsDiscount.toStringAsFixed(0)}%',
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
                // المحتوى النصي
                Padding(
                  padding: EdgeInsets.all(12.w), // padding أقل
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemsName ?? 'No Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp, // حجم أصغر شوية
                          color: Colors.black87,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h), // مسافة أقل
                      Text(
                        item.itemsDes ?? 'No Description',
                        style: TextStyle(
                          fontSize: 13.sp, // حجم أصغر
                          color: Colors.grey[700],
                          height: 1.3,
                        ),
                        maxLines: 2, // قللنا السطور عشان الارتفاع
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10.h), // مسافة أقل
                      // الأسعار
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
                                  decoration: TextDecoration.lineThrough,
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
                      SizedBox(height: 10.h), // مسافة أقل
                      // قسم المطعم والتقييم ورقم الموبايل
                      Container(
                        padding: EdgeInsets.all(8.w), // padding أقل
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
                                  Icons.restaurant,
                                  size: 16.w, // أيقونة أصغر
                                  color: MyTheme.orangeColor,
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    restaurantName,
                                    style: TextStyle(
                                      fontSize: 14.sp, // حجم أصغر
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h), // مسافة أقل
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16.w, // أيقونة أصغر
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  '$rating / 5',
                                  style: TextStyle(
                                    fontSize: 13.sp, // حجم أصغر
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h), // مسافة أقل
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 16.w, // أيقونة أصغر
                                  color: Colors.green[700],
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  phoneNumber,
                                  style: TextStyle(
                                    fontSize: 13.sp, // حجم أصغر
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h), // مسافة أقل
                      // الأزرار (أيقونات أصغر)
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
                // زر الإغلاق
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
                      print("Dialog closed");
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
      padding: EdgeInsets.all(8.w), // padding أصغر
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 5.r,
            spreadRadius: 1.r,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 18.w, // أيقونة أصغر
      ),
    ),
  );
}
