import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';
class FullDiscountCard extends StatelessWidget {
  final dynamic item;

  const FullDiscountCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            _buildImage(),
            SizedBox(width: 15.w),
            _buildDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Image.network(
        item.itemsImage ?? '',
        height: 80.h,
        width: 80.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 80.h,
            width: 80.w,
            color: Colors.grey[200],
            child: Icon(Icons.broken_image, size: 30.w, color: Colors.grey[400]),
          );
        },
      ),
    );
  }

  Widget _buildDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.itemsName ?? 'Unknown',
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
            "${item.itemsPrice ?? 'N/A'} EGP",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.h),
          if (item.itemsDiscount != null && item.itemsDiscount != "0")
            Text(
              "${item.itemsDiscount}% OFF",
              style: TextStyle(
                fontSize: 12.sp,
                color: MyTheme.orangeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Icon(Icons.star, size: 14.w, color: Colors.orangeAccent),
              SizedBox(width: 4.w),
              Text(
                item.serviceRating?.toString() ?? 'N/A',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}