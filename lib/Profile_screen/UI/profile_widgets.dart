import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';

Widget buildProfileImage(String? imageUrl, bool isEditing) {
  return Stack(
    children: [
      Container(
        width: 130.w,
        height: 130.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: MyTheme.orangeColor2, width: 3.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.r,
              spreadRadius: 2.r,
            ),
          ],
        ),
        child: ClipOval(
          child: imageUrl != null && imageUrl.isNotEmpty
              ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.person,
              size: 60.w,
              color: MyTheme.grayColor,
            ),
          )
              : Icon(
            Icons.person,
            size: 60.w,
            color: MyTheme.grayColor,
          ),
        ),
      ),
      if (isEditing)
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            radius: 20.r,
            backgroundColor: MyTheme.orangeColor,
            child: Icon(Icons.camera_alt, color: MyTheme.whiteColor, size: 20.w),
          ),
        ),
    ],
  );
}

Widget buildEditableField(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon, {
      bool isEditing = false,
      bool obscureText = false,
    }) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: MyTheme.grayColor2),
        ),
        SizedBox(height: 5.h),
        isEditing
            ? TextField(
          controller: controller,
          style: Theme.of(context).textTheme.titleMedium,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: MyTheme.grayColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: MyTheme.grayColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: MyTheme.orangeColor,
                width: 2.w,
              ),
            ),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            suffixIcon: Icon( // أضفنا الـ Icon كـ suffixIcon داخل الـ TextField
              icon,
              color: MyTheme.orangeColor2,
              size: 20.w,
            ),
          ),
        )
            : Row( // لما مش في وضع التعديل، هنحط الـ Text والـ Icon في Row
          children: [
            Expanded(
              child: Text(
                controller.text,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              icon,
              color: MyTheme.orangeColor2,
              size: 20.w,
            ),
          ],
        ),
      ],
    ),
  );
}