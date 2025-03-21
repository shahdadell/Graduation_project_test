// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:graduation_project/auth/data/model/request/Login/LoginRequest.dart';
import 'package:graduation_project/auth/data/model/request/ResetPasssword/OtpForgetPasswordRequest.dart';
import 'package:graduation_project/auth/data/model/request/Register/OtpRequest.dart';
import 'package:graduation_project/auth/data/model/response/OTP/CheckEmailResponse.dart';
import 'package:graduation_project/auth/data/model/response/Login/LoginResponse.dart';
import 'package:graduation_project/auth/data/model/response/Register/registerresponse_new.dart';
import 'package:graduation_project/auth/data/model/response/Register/VerfiyCodeResponse.dart';
import 'package:graduation_project/auth/data/model/response/ResetPassword/ResetPasswordResponse.dart';
import 'package:graduation_project/auth/data/model/response/ResetPassword/VerfiyCodeForgetPasswordResponse.dart';
import 'package:graduation_project/local_data/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../model/request/ResetPasssword/CheckEmailRequest.dart';
import '../model/request/Register/RegisterRequest.dart';
import 'api_constance.dart';

class ApiManager {
  ApiManager._();
  static ApiManager? _instance;

  static ApiManager getInstance() {
    _instance ??= ApiManager._();
    return _instance!;
  }

  Future<RegisterresponseNew> register(
      String username, String password, String email, String phone) async {
    Uri url = Uri.https(ApiConstants.baseUrl, ApiConstants.registerApi);
    var requestBody = RegisterRequest(
      username: username,
      email: email,
      password: password,
      phone: phone,
    );
    var response = await http.post(url, body: requestBody.toJson());
    var registerResponse =
        RegisterresponseNew.fromJson(jsonDecode(response.body));
    if (registerResponse.token != null) {
      await AppLocalStorage.cacheData('token', registerResponse.token);
    }
    return registerResponse;
  }

  Future<LoginResponse> login(String email, String password) async {
    Uri url = Uri.https(ApiConstants.baseUrl, ApiConstants.LoginApi);
    var requestBody = LoginRequest(email: email, password: password);
    var response = await http.post(url, body: requestBody.toJson());
    var loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
    if (loginResponse.token != null) {
      await AppLocalStorage.cacheData('token', loginResponse.token);
    }
    return loginResponse;
  }

  //email forgetPassword
  Future<CheckEmailResponse> checkemail(String email) async {
    //https://abdulrahmanantar.com/outbye/forgetpassword/checkemail.php
    Uri url = Uri.https(ApiConstants.baseUrl, ApiConstants.checkemail);
    var requestBody = CheckEmailRequest(
      email: email,
    );
    var response = await http.post(url, body: requestBody.toJson());
    return CheckEmailResponse.fromJson(jsonDecode(response.body));
  }

// Verify Code API
  Future<VerfiyCodeResponse> verifyCode(String email, String verifyCode) async {
    Uri url = Uri.https(ApiConstants.baseUrl, ApiConstants.verifyCodeApi);
    var requestBody = OtpRequest(
      email: email,
      verifycode: verifyCode,
    );
    var response = await http.post(url, body: requestBody.toJson());

    return VerfiyCodeResponse.fromJson(jsonDecode(response.body));
  }

  Future<VerfiyCodeForgetPasswordResponse> verifyCodeForgetPassword(
      String email, String verifycode) async {
    Uri url =
        Uri.https(ApiConstants.baseUrl, ApiConstants.verifyCodeForgetPassword);
    var requestBody = OtpScreenForgetPassword(
      email: email,
      verifycode: verifycode,
    );
    print(" Server Response: $requestBody");
    var response = await http.post(url, body: requestBody.toJson());
    return VerfiyCodeForgetPasswordResponse.fromJson(jsonDecode(response.body));
  }

  Future<ResetPasswordResponse> resetPassword(
      String email, String password) async {
    Uri url = Uri.https(ApiConstants.baseUrl, ApiConstants.resetpassword);

    if (email == null || email.isEmpty) {
      print("Error: Email is null or empty");
      // return ResetPasswordResponse(status: "error", message: "البريد الإلكتروني مطلوب");
    }
    if (password == null || password.isEmpty) {
      print("Error: Password is null or empty");
      // return ResetPasswordResponse(status: "error", message: "كلمة المرور مطلوبة");
    }

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'email': email,
          'password': password,
        },
      );

      print("Request Body: ${{'email': email, 'password': password}}");
      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode != 200) {
        return ResetPasswordResponse(
          status: "error",
          // message: "فشل الاتصال بالخادم: ${response.statusCode}",
        );
      }

      String contentType = response.headers['content-type'] ?? '';
      if (!contentType.contains('application/json')) {
        return ResetPasswordResponse(
          status: "error",
          // message: "استجابة غير متوقعة من الخادم: ${response.body}",
        );
      }

      var jsonResponse = jsonDecode(response.body);
      return ResetPasswordResponse.fromJson(jsonResponse);
    } catch (e) {
      print("Exception occurred: $e");
      return ResetPasswordResponse(
        status: "error",
        // message: "حدث خطأ أثناء الاتصال: $e",
      );
    }
  }
}
