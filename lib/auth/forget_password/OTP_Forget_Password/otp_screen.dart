import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/auth/data/api/api_manager.dart';
import 'package:graduation_project/auth/forget_password/reset_password/ResetPassword.dart';
import 'text_filed_otp_screem.dart';

class OtpScreenForgetPassword extends StatefulWidget {
  static const String routName = 'otpScreenf';

  const OtpScreenForgetPassword({super.key});

  @override
  State<OtpScreenForgetPassword> createState() => _OtpScreenForgetPasswordState();
}

class _OtpScreenForgetPasswordState extends State<OtpScreenForgetPassword> {
  ApiManager apiManager = ApiManager.getInstance();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController otpController1 = TextEditingController();
  final TextEditingController otpController2 = TextEditingController();
  final TextEditingController otpController3 = TextEditingController();
  final TextEditingController otpController4 = TextEditingController();
  final TextEditingController otpController5 = TextEditingController();

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    otpController1.addListener(_checkOtpFields);
    otpController2.addListener(_checkOtpFields);
    otpController3.addListener(_checkOtpFields);
    otpController4.addListener(_checkOtpFields);
    otpController5.addListener(_checkOtpFields);
  }

  void _checkOtpFields() {
    setState(() {
      _isButtonEnabled = otpController1.text.isNotEmpty &&
          otpController2.text.isNotEmpty &&
          otpController3.text.isNotEmpty &&
          otpController4.text.isNotEmpty &&
          otpController5.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    otpController1.dispose();
    otpController2.dispose();
    otpController3.dispose();
    otpController4.dispose();
    otpController5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
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
          "Enter OTP",
          style: TextStyle(
            fontSize: 22.sp,
            color: MyTheme.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: MyTheme.orangeColor,
        centerTitle: true,
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
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "Enter The Confirmation Code",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Text(
                  "We've sent a code to $email",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),
                Form(
                  key: formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildOtpField(otpController1),
                      _buildOtpField(otpController2),
                      _buildOtpField(otpController3),
                      _buildOtpField(otpController4),
                      _buildOtpField(otpController5),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                ElevatedButton(
                  onPressed: _isButtonEnabled
                      ? () async {
                    print("OTP Continue Button Pressed");

                    if (formKey.currentState!.validate()) {
                      String otpCode =
                          "${otpController1.text}${otpController2.text}${otpController3.text}${otpController4.text}${otpController5.text}";

                      print("Entered OTP: $otpCode");

                      var response = await apiManager.verifyCodeForgetPassword(email, otpCode);

                      print("API Response: ${response.status}, Message: ${response.message}");

                      if (response.status == "success") {
                        print("Verification Successful! Navigating to Reset Password...");
                        Navigator.of(context).pushReplacementNamed(
                          ResetPassword.routName,
                          arguments: email,
                        );
                      } else {
                        print("Verification Failed: ${response.message}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(response.message ?? "Verification Failed"),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
                    backgroundColor: MyTheme.orangeColor,
                    disabledBackgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black38,
                  ),
                  child: Text(
                    "Continue",
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
      ),
    );
  }

  Widget _buildOtpField(TextEditingController controller) {
    return SizedBox(
      height: 60.h,
      width: 50.w,
      child: TextFiledOtpScreen(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return " ";
          }
          return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: MyTheme.orangeColor, width: 2.w),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.redAccent, width: 1.w),
          ),
        ),
      ),
    );
  }
}