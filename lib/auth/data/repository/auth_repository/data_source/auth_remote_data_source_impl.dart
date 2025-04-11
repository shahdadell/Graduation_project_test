import 'package:graduation_project/auth/data/api/api_manager.dart';
import 'package:graduation_project/auth/data/model/response/Login/LoginResponse.dart';
import 'package:graduation_project/auth/data/model/response/OTP/CheckEmailResponse.dart';
import 'package:graduation_project/auth/data/model/response/Register/registerresponse_new.dart';
import 'package:graduation_project/auth/data/model/response/Register/VerfiyCodeResponse.dart';
import 'package:graduation_project/auth/data/model/response/ResetPassword/ResetPasswordResponse.dart';
import 'package:graduation_project/auth/data/model/response/ResetPassword/VerfiyCodeForgetPasswordResponse.dart';
import 'package:graduation_project/auth/domain/repository/data_source/auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  ApiManager apiManager;

  AuthRemoteDataSourceImpl({required this.apiManager});

  @override
  Future<RegisterresponseNew> register(
      String username, String password, String email, String phone) async {
    var response = await apiManager.register(username, password, email, phone);
    return response;
  }

  @override
  Future<LoginResponse> login(String email, String password) async {
    var response = await apiManager.login(email, password);
    print("Response :=> $response");
    return response;
  }

  @override
  Future<CheckEmailResponse> checkemail(String email) async {
    var response = await apiManager.checkemail(email);
    return response;
//    throw UnimplementedError();
  }

  @override
  Future<VerfiyCodeResponse> verifyCode(String email, String verifyCode) async {
    var response = await apiManager.verifyCode(email, verifyCode);
    return response;
  }

  @override
  Future<VerfiyCodeForgetPasswordResponse> verifyCodeForgetPassword(
      String email, String verifyCode) async {
    var response = await apiManager.verifyCodeForgetPassword(email, verifyCode);
    return response;
  }

  Future<ResetPasswordResponse> resetPassword(
      String email, String hashedPassword) async {
    var response = await apiManager.resetPassword(email, hashedPassword);
    return response;
  }
}
