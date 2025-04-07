import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

import 'package:graduation_project/API_Services/dio_provider.dart';
import 'package:graduation_project/API_Services/endpoints.dart';
import 'package:graduation_project/Profile_screen/data/model/response/profile_screen_response/ProfileScreenResponse.dart';
import 'package:graduation_project/local_data/shared_preference.dart';
import '../model/response/profile_screen_response/EditeProfileResponse.dart';

class ProfileRepo {
  Future<ProfileScreenResponse> fetchProfile(String userId) async {
    try {
      // جيب الـ Token من AppLocalStorage
      String? token = await AppLocalStorage.getData('token');
      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      var response = await DioProvider.get(
        endpoint: AppEndpoints.profileView,
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
        },
        queryParameters: {"users_id": userId},
      );

      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        // تنظيف الـ Response من الـ HTML
        String responseBody = response.data.toString();
        final jsonStartIndex = responseBody.indexOf('{');
        final jsonEndIndex = responseBody.lastIndexOf('}') + 1;
        if (jsonStartIndex != -1 && jsonEndIndex != -1) {
          responseBody = responseBody.substring(jsonStartIndex, jsonEndIndex);
          log('Cleaned Response: $responseBody');

          // تحويل الـ Response النظيف لـ Map
          final cleanedResponse = jsonDecode(responseBody);
          if (cleanedResponse['status'] == 'success') {
            return ProfileScreenResponse.fromJson(cleanedResponse);
          } else {
            throw Exception('API returned status: ${cleanedResponse['status']}, message: ${cleanedResponse['message'] ?? 'Unknown error'}');
          }
        } else {
          throw Exception('Invalid response format: $responseBody');
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

  Future<EditeProfileResponse> updateProfile(
      String userId,
      String username,
      String email,
      String phone,
      ) async {
    try {
      String? token = await AppLocalStorage.getData('token');
      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      var response = await DioProvider.post(
        endpoint: AppEndpoints.profileEdite,
        data: {
          "users_id": userId,
          "new_name": username,
          "new_email": email,
          "new_phone": phone,
        },
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
        },
      );
      log('Update Response Status Code: ${response.statusCode}');
      log('Update Response Data: ${response.data}');

      if (response.statusCode == 200) {
        return EditeProfileResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to update profile, status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('DioException: ${e.message}, Response: ${e.response?.data}, Error: ${e.error}');
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout while updating profile');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout while updating profile');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception('Bad response: ${e.response?.statusCode} - ${e.response?.data}');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error: Please check your internet connection');
      } else {
        throw Exception('DioException [${e.type}]: ${e.message}, Error: ${e.error}');
      }
    } catch (e) {
      log('Exception: $e');
      throw Exception('Error updating profile: $e');
    }
  }
}