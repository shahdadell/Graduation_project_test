import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/local_data/shared_preference.dart';
import 'package:lottie/lottie.dart';

class WishlistScreen extends StatelessWidget {
  static const String routeName = '/wishlist';
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int? userId = AppLocalStorage.getData('user_id');
    if (userId == null) {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[100]!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                'assets/images/favouriteEmpty.json',
                  width: 200.w,
                  height: 200.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Please log in to view your favorites',
                  style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
                    backgroundColor: MyTheme.orangeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    "Go to Login",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _buildEmptyFavorites(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Favorites",
        style: TextStyle(
          fontSize: 22.sp,
          color: MyTheme.whiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: MyTheme.orangeColor,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [MyTheme.orangeColor, Colors.orange[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyFavorites(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/images/favouriteEmpty.json',
            width: 200.w,
            height: 200.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20.h),
          Text(
            'Your favorites list is empty',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Start adding items now!',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}