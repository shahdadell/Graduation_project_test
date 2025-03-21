import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/App_Images/app_images.dart';
import 'package:graduation_project/Theme/dialog_utils.dart';
import 'package:graduation_project/Theme/dialogs.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/auth/data/api/api_manager.dart';
import 'package:graduation_project/auth/data/repository/auth_repository/data_source/auth_remote_data_source_impl.dart';
import 'package:graduation_project/auth/data/repository/auth_repository/repository/auth_repository_impl.dart';
import 'package:graduation_project/auth/domain/repository/repository/auth_repository_contract.dart';
import 'package:graduation_project/auth/forget_password/check_email/forget_password_bottom_sheet.dart';
import 'package:graduation_project/auth/sing_in_screen/cubit/login_screen_viewmodel.dart';
import 'package:graduation_project/auth/sing_in_screen/cubit/login_state.dart';
import 'package:graduation_project/auth/sing_in_screen/text_filed_login.dart';
import 'package:graduation_project/home_screen/UI/Home_Page/home_screen.dart';
import 'package:graduation_project/local_data/shared_preference.dart';
import '../../main_screen/main_screen.dart';

class SignInScreen extends StatefulWidget {
  static const String routName = 'SignInScreen';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  LoginScreenViewmodel viewmodel = LoginScreenViewmodel(
    repositoryContract: injectAuthRepositoryContract(),
  );
  late TextEditingController emailController;
  late TextEditingController passwordController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    // checkToken(); // نعلق التحقق التلقائي مؤقتًا
  }

  void checkToken() async {
    final token = AppLocalStorage.getData('token');
    if (token != null && token.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginScreenViewmodel, LoginState>(
      bloc: viewmodel,
      listener: (context, state) {
        if (state is LoginLoadingState) {
          showLoadingDialog(context);
        } else if (state is LoginErrorState) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          showAppDialog(context, state.errorMessage!);
        } else if (state is LoginSuccessState) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          Navigator.of(context).pushReplacementNamed(
            HomeScreen.routName,
            arguments: viewmodel.emailController.text,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(MainScreen.routName);
            },
            child: Padding(
              padding: EdgeInsets.all(10.w), // تقليل الـ padding
              child: Icon(
                Icons.arrow_back_ios,
                color: MyTheme.blackColor,
                size: 24.w, // تقليل حجم الأيقونة
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            "Sign in",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 18.sp), // تقليل حجم العنوان
          ),
        ),
        body: Form(
          key: viewmodel.formKey,
          child: Padding(
            padding: EdgeInsets.all(20.w), // تقليل الـ padding الكلي
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    AppImages.sign,
                    width: 140.w, // تقليل حجم الصورة
                    height: 140.h,
                  ),
                  SizedBox(height: 15.h), // تقليل المسافة
                  Text(
                    "Email Address",
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp), // تقليل حجم النص
                  ),
                  SizedBox(height: 4.h), // تقليل المسافة
                  TextFiledLogin(
                    text: 'User name / Email',
                    type: TextInputType.emailAddress,
                    action: TextInputAction.done,
                    icon: Icons.email,
                    controller: viewmodel.emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "E-mail is required";
                      }
                      bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (!emailValid) {
                        return 'Please Enter Valid Email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h), // تقليل المسافة
                  Text(
                    "Password",
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp), // تقليل حجم النص
                  ),
                  SizedBox(height: 4.h), // تقليل المسافة
                  TextFiledLogin(
                    controller: viewmodel.passwordController,
                    text: 'Password',
                    icon: Icons.lock,
                    type: TextInputType.visiblePassword,
                    action: TextInputAction.done,
                    password: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 4.h), // تقليل المسافة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showForgetPasswordBottomSheet();
                        },
                        child: Text(
                          "Forget Password?",
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 12.sp), // تقليل حجم النص
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h), // تقليل المسافة
                  ElevatedButton(
                    onPressed: () {
                      viewmodel.SignIn(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 6.h), // تقليل الـ padding
                      backgroundColor: MyTheme.orangeColor,
                      minimumSize: Size(double.infinity, 35.h), // تقليل ارتفاع الزر
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r), // زوايا أنيقة
                      ),
                    ),
                    child: Text(
                      "Sign in",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 13.sp), // تقليل حجم النص
                    ),
                  ),
                  SizedBox(height: 30.h), // تقليل المسافة الكبيرة
                  Divider(indent: 5.w, endIndent: 5.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.w), // تقليل الـ padding
                        child: Text(
                          "or sign in with",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 12.sp), // تقليل حجم النص
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Material(
                          elevation: 3, // تقليل الظل لمظهر أنيق
                          borderRadius: BorderRadius.circular(10.r),
                          shadowColor: Colors.black.withOpacity(0.2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.asset(
                              AppImages.google,
                              width: 40.w, // تقليل حجم الأيقونة
                              height: 40.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showForgetPasswordBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ForgetPasswordBottomSheet(),
    );
  }
}

AuthRepositoryContract injectAuthRepositoryContract() {
  return AuthRepositoryImpl(
      remoteDataSource:
      AuthRemoteDataSourceImpl(apiManager: ApiManager.getInstance()));
}