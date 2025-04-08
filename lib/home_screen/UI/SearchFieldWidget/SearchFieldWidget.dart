import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/home_screen/UI/SearchFieldWidget/SearchScreen.dart';

class SearchFieldWidget extends StatelessWidget {
  final bool isClickable;
  final void Function(String query)? onSearch;

  const SearchFieldWidget({
    super.key,
    this.isClickable = false,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h,
      margin: EdgeInsets.symmetric(horizontal: 12.w,),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[600], size: 22.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              readOnly: isClickable, // نخليه read-only لما نكون عايزين نروح للصفحة
              onTap: () {
                if (isClickable) {
                  Navigator.pushNamed(context, SearchScreen.routeName);
                }
              },
              onChanged: onSearch,
              style: TextStyle(fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: "What are you looking for?",
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13.sp),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
