import 'package:graduation_project/auth/data/model/response/OTP/CheckEmailResponse.dart';
import 'package:graduation_project/auth/data/model/response/Login/LoginResponse.dart';
import 'package:graduation_project/auth/data/model/response/Register/registerresponse_new.dart';
import 'package:graduation_project/auth/data/model/response/ResetPassword/ResetPasswordResponse.dart';
import 'package:graduation_project/auth/data/model/response/ResetPassword/VerfiyCodeForgetPasswordResponse.dart';
import 'package:graduation_project/auth/data/model/response/Register/VerfiyCodeResponse.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterresponseNew> register(
      String username, String password, String email, String phone);

  Future<LoginResponse> login(String username, String password);

  Future<VerfiyCodeResponse> verifyCode(String email, String verifyCode);

  Future<VerfiyCodeForgetPasswordResponse> verifyCodeForgetPassword(
      String email, String verifyCode);

  Future<CheckEmailResponse> checkemail(String email);

  Future<ResetPasswordResponse> resetPassword(
      String email, String hashedPassword);
}
