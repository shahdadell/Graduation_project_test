import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:graduation_project/API_Services/dio_provider.dart';
import 'package:graduation_project/API_Services/endpoints.dart';
import 'package:graduation_project/Profile_screen/data/model/response/profile_screen_response/profile_screen_response.dart';

class Profilerepo {
  Future<ProfileScreenResponse> fetchProfile(String userId) async {
    try {
      var response = await DioProvider.get(
        endpoint: AppEndpoints.profileView,
        // data: null,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        queryParameters: {"users_id": userId},
        // contentType: 'application/x-www-form-urlencoded', // التأكد من الـ contentType
      );

      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data['status'] == 'success') {
          return ProfileScreenResponse.fromJson(response.data);
        } else {
          throw Exception('API returned status: ${response.data['status']}, message: ${response.data['message']}');
        }
      } else {
        throw Exception('Failed to fetch profile, status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('DioException: ${e.message}, Response: ${e.response?.data}, Error: ${e.error}');
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout while fetching profile');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout while fetching profile');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception('Bad response: ${e.response?.statusCode} - ${e.response?.data}');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error: Please check your internet connection');
      } else {
        throw Exception('DioException [${e.type}]: ${e.message}, Error: ${e.error}');
      }
    } catch (e) {
      log('Exception: $e');
      throw Exception('Error fetching profile: $e');
    }
  }
}