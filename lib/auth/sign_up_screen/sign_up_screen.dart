import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/App_Images/app_images.dart';
import 'package:graduation_project/Main_Screen/main_screen.dart';
import 'package:graduation_project/Theme/dialog_utils.dart';
import 'package:graduation_project/Theme/dialogs.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/auth/OTP/otp_screen.dart';
import 'package:graduation_project/auth/data/api/api_manager.dart';
import 'package:graduation_project/auth/data/repository/auth_repository/data_source/auth_remote_data_source_impl.dart';
import 'package:graduation_project/auth/data/repository/auth_repository/repository/auth_repository_impl.dart';
import 'package:graduation_project/auth/domain/repository/repository/auth_repository_contract.dart';
import 'package:graduation_project/auth/sign_up_screen/text_filed_siginup.dart';
import 'package:graduation_project/local_data/shared_preference.dart';
import 'cubit/register_screen_viewmodel.dart';
import 'cubit/register_state.dart';

class SignUpScreen extends StatefulWidget {
  static const String routName = 'SignUpScreen';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  RegisterScreenViewmodel viewmodel = RegisterScreenViewmodel(
    repositoryContract: injectAuthRepositoryContract(),
  );

  @override
  void initState() {
    super.initState();
    // checkToken(); // نعلق التحقق التلقائي مؤقتًا
  }

  void checkToken() async {
    final token = AppLocalStorage.getData('token');
    if (token != null && token.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed(OtpScreen.routName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterScreenViewmodel, RegisterState>(
      bloc: viewmodel,
      listener: (context, state) {
        if (state is RegisterLoadingState) {
          showLoadingDialog(context);
        } else if (state is RegisterErrorState) {
          Navigator.pop(context);
          showAppDialog(context, state.errorMessage!);
        } else if (state is RegisterSuccessState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(context, state.response.message ?? '',
              posActionName: 'Ok', posAction: () {
                if (viewmodel.emailController.text.isNotEmpty) {
                  Navigator.of(context).pushReplacementNamed(
                    OtpScreen.routName,
                    arguments: viewmodel.emailController.text,
                  );
                } else {
                  DialogUtils.showMessage(context, "Email is missing!");
                }
              });
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
            "Sign up",
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
                  TextFiledSignup(
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
                  SizedBox(height: 10.h), // تقليل المسافة
                  Text(
                    "User Name",
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp), // تقليل حجم النص
                  ),
                  SizedBox(height: 4.h), // تقليل المسافة
                  TextFiledSignup(
                    controller: viewmodel.userNameController,
                    text: 'User Name',
                    icon: Icons.person,
                    type: TextInputType.name,
                    action: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "User Name is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h), // تقليل المسافة
                  Text(
                    "Phone Number",
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp), // تقليل حجم النص
                  ),
                  SizedBox(height: 4.h), // تقليل المسافة
                  TextFiledSignup(
                    controller: viewmodel.phoneController,
                    text: 'Phone Number',
                    icon: Icons.phone,
                    type: TextInputType.phone,
                    action: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone Number is required";
                      }
                      if (value.length < 11) {
                        return "Phone Number Should Be At Least 11 Chars";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h), // تقليل المسافة
                  Text(
                    "Password",
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp), // تقليل حجم النص
                  ),
                  SizedBox(height: 4.h), // تقليل المسافة
                  TextFiledSignup(
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
                      if (value.length < 6) {
                        return "Password Should Be At Least 6 Chars";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h), // تقليل المسافة
                  ElevatedButton(
                    onPressed: () {
                      viewmodel.SignUp(context);
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
                      "Register",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 13.sp), // تقليل حجم النص
                    ),
                  ),
                  SizedBox(height: 15.h), // تقليل المسافة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300.w, // تقليل العرض ليكون متكيف وأنيق
                        child: Image.asset(
                          "assets/images/Separator2.png",
                          fit: BoxFit.contain, // للتكيف مع الحجم
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h), // تقليل المسافة
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
}

AuthRepositoryContract injectAuthRepositoryContract() {
  return AuthRepositoryImpl(
      remoteDataSource:
      AuthRemoteDataSourceImpl(apiManager: ApiManager.getInstance()));
}