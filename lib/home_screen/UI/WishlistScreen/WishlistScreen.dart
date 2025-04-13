import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MyTheme.lightTheme.textTheme; // استخدام TextTheme من MyTheme

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.orangeColor,
        shadowColor: MyTheme.blackColor.withOpacity(0.3),
        title: Text(
          'My Wishlist',
          style: textTheme.displayLarge, // من الثيم: أبيض، 24sp، bold
        ),
        centerTitle: true,
      ),
    );
  }
}