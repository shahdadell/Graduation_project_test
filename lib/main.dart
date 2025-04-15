// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Main_Screen/main_screen.dart';
import 'package:graduation_project/Splash_Screen/splash_screen.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/API_Services/dio_provider.dart';
import 'package:graduation_project/auth/forget_password/check_email/check_email.dart';
import 'package:graduation_project/auth/forget_password/reset_password/ResetPassword.dart';
import 'package:graduation_project/home_screen/UI/Home_Page/home_screen.dart';
import 'package:graduation_project/home_screen/UI/Items_Page/Items_screen.dart';
import 'package:graduation_project/home_screen/UI/Category_Page/Services_Screen.dart';
import 'package:graduation_project/home_screen/bloc/Cart/cart_bloc.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_bloc.dart';
import 'package:graduation_project/home_screen/data/repo/cart_repo.dart';
import 'package:graduation_project/local_data/shared_preference.dart';
import 'package:graduation_project/auth/OTP/otp_screen.dart';
import 'package:graduation_project/auth/forget_password/OTP_Forget_Password/otp_screen.dart';
import 'package:graduation_project/auth/sign_up_screen/sign_up_screen.dart';
import 'package:graduation_project/auth/sing_in_screen/sign_in_screen.dart';
import 'package:graduation_project/home_screen/UI/SearchFieldWidget/SearchFieldWidget.dart';
import 'package:graduation_project/home_screen/UI/SearchFieldWidget/SearchScreen.dart';
import 'package:graduation_project/Profile_screen/UI/profile_screen.dart';
import 'package:graduation_project/Profile_screen/UI/edit_profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DioProvider.init();
  AppLocalStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => HomeBloc()),
          BlocProvider(
              create: (context) =>
                  CartBloc(cartRepo: CartRepo())), // CartBloc global
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: MyTheme.lightTheme,
          initialRoute: SplashScreen.routName,
          routes: {
            SplashScreen.routName: (context) => const SplashScreen(),
            HomeScreen.routName: (context) => const HomeScreen(),
            MainScreen.routName: (context) => const MainScreen(),
            SignInScreen.routName: (context) => const SignInScreen(),
            SignUpScreen.routeName: (context) => const SignUpScreen(),
            OtpScreen.routeName: (context) => const OtpScreen(),
            SearchScreen.routeName: (context) => const SearchScreen(),
            OtpScreenForgetPassword.routName: (context) =>
                const OtpScreenForgetPassword(),
            ForgetPassword.routName: (context) => const ForgetPassword(),
            ResetPassword.routName: (context) {
              final String email =
                  ModalRoute.of(context)!.settings.arguments as String;
              return ResetPassword(email: email);
            },
            ServiceItemsScreen.routeName: (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
              return ServiceItemsScreen(serviceId: args['serviceId']);
            },
            ProfileScreen.routeName: (context) => const ProfileScreen(),
            EditProfileScreen.routeName: (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
              return EditProfileScreen(
                userId: args['userId'],
                profile: args['profile'],
              );
            },
          },
          onGenerateRoute: (settings) {
            if (settings.name == ServicesScreen.routeName) {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => ServicesScreen(
                  categoryId: args['categoryId'] as String,
                  categoryName: args['categoryName'] as String,
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
