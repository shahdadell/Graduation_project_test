import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';

class ItemsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ItemsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Icon(
            Icons.arrow_back_ios,
            color: MyTheme.whiteColor,
            size: 24.w,
          ),
        ),
      ),
      title: Text(
        "Items",
        style: TextStyle(fontSize: 20.sp, color: MyTheme.whiteColor),
      ),
      backgroundColor: MyTheme.orangeColor,
      centerTitle: true,
      // elevation: 4,
      // shadowColor: Colors.black.withOpacity(0.3),
      // flexibleSpace: Container(
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       colors: [MyTheme.orangeColor, Colors.orange[400]!],
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //     ),
      //   ),
      // ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
