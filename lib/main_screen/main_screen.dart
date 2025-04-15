import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/App_Images/app_images.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/auth/sign_up_screen/sign_up_screen.dart';
import 'package:graduation_project/auth/sing_in_screen/sign_in_screen.dart';
import 'package:graduation_project/home_screen/UI/Home_Page/home_screen.dart';
import 'package:graduation_project/local_data/shared_preference.dart';

class MainScreen extends StatelessWidget {
  static const String routName = 'LoginScreen';
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppImages.rectangle,
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  SizedBox(
                    width: 100.w,
                    height: 100.h,
                    child: Image.asset(
                      AppImages.logo,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Image.asset(
                    AppImages.text,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignInScreen.routName);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.h), // تقليل الـ padding
                      backgroundColor: MyTheme.orangeColor,
                      minimumSize:
                          Size(double.infinity, 15.h), // عرض كامل وارتفاع مناسب
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Sign in",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: 14.sp), // تقليل حجم النص
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 130.w,
                        child: Image.asset(
                          AppImages.divider,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Text(
                          "or",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontSize: 14.sp),
                        ),
                      ),
                      SizedBox(
                        width: 130.w,
                        child: Image.asset(
                          AppImages.divider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.of(context)
                      //     .pushReplacementNamed(HomeScreen.routName);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.h), // تقليل الـ padding
                      backgroundColor: MyTheme.blueColor,
                      minimumSize:
                          Size(double.infinity, 15.h), // عرض كامل وارتفاع مناسب
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.google,
                          width: 20.w, // تقليل حجم الأيقونة
                          height: 20.h,
                        ),
                        SizedBox(width: 8.w), // تقليل المسافة
                        Text(
                          textAlign: TextAlign.center,
                          "Continue with Google",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontSize: 14.sp), // تقليل حجم النص
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 14.sp),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(SignUpScreen.routeName);
                        },
                        child: Text(
                          " Sign Up",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      await AppLocalStorage.clearData();
                      final int? userId = AppLocalStorage.getData('user_id');
                      final String? username =
                          AppLocalStorage.getData(AppLocalStorage.userNameKey)
                              as String?;
                      print(
                          "After clearData - User ID: $userId, Username: $username");
                      Navigator.of(context)
                          .pushReplacementNamed(HomeScreen.routName);
                    },
                    child: Text(
                      textAlign: TextAlign.center,
                      "visiting as a guest",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
