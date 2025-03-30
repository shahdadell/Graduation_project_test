import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Container(
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: "What are you looking for ?",
            hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          ),
        ),
      ),
    );
  }
}
