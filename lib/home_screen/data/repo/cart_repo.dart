import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:graduation_project/API_Services/dio_provider.dart';
import 'package:graduation_project/API_Services/endpoints.dart';
import 'package:graduation_project/home_screen/data/model/Cart_model_response/cart_add_response.dart';
import 'package:graduation_project/home_screen/data/model/Cart_model_response/cart_count_response.dart';
import 'package:graduation_project/home_screen/data/model/Cart_model_response/cart_view_response/cart_view_response.dart';
import 'package:graduation_project/local_data/shared_preference.dart';

class CartRepo {
  static Future<CartCountResponse> getCartItemCount({
    required int itemId,
  }) async {
    try {
      final int? userId = AppLocalStorage.getData('user_id');
      if (userId == null) {
        throw Exception('User not logged in');
      }
      // شيلت الـ query parameters، افترضت إن الـ API بيستخدم الـ body بس
      final String endpoint = AppEndpoints.cartCount;
      final Map<String, dynamic> requestData = {
        'usersid': userId,
        'itemsid': itemId,
      };
      log('Get Cart Item Count Request: $endpoint, Data: $requestData');
      final response = await DioProvider.post(
        endpoint: endpoint,
        data: requestData,
        headers: {'Content-Type': 'application/json'},
      );
      log('Get Cart Item Count Response: ${response.data}');
      if (response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('Response data is null');
        }
        return CartCountResponse.fromJson(response.data);
      }
      throw Exception(
          'Failed to get cart item count - Status: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout while getting cart item count');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout while getting cart item count');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception(
            'Bad response: ${e.response?.statusCode} - ${e.response?.data}');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
            'Connection error: Please check your internet connection');
      } else {
        throw Exception('Error getting cart item count: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error getting cart item count: $e');
    }
  }

  static Future<CartAddResponse> addToCart({
    required int itemId,
  }) async {
    try {
      const String endpoint = AppEndpoints.addToCart;
      final int? userId = AppLocalStorage.getData('user_id');
      if (userId == null) {
        throw Exception('User not logged in');
      }
      final Map<String, dynamic> requestData = {
        'usersid': userId,
        'itemsid': itemId,
      };
      log('Add to Cart Request: $requestData');
      final response = await DioProvider.post(
        endpoint: endpoint,
        data: requestData,
        headers: {'Content-Type': 'application/json'},
      );
      log('Add to Cart Response: ${response.data}');
      if (response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('Response data is null');
        }
        return CartAddResponse.fromJson(response.data);
      }
      throw Exception(
          'Failed to add item to cart - Status: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout while adding to cart');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout while adding to cart');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception(
            'Bad response: ${e.response?.statusCode} - ${e.response?.data}');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
            'Connection error: Please check your internet connection');
      } else {
        throw Exception('Error adding to cart: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error adding to cart: $e');
    }
  }

  static Future<CartViewResponse> fetchCart() async {
    try {
      final int? userId = AppLocalStorage.getData('user_id');
      if (userId == null) {
        throw Exception('User not logged in');
      }
      final String endpoint = AppEndpoints.viewCart;
      final Map<String, dynamic> requestData = {
        'usersid': userId,
      };
      final response = await DioProvider.post(
        endpoint: endpoint,
        data: requestData,
        headers: {'Content-Type': 'application/json'},
      );
      log('Fetch Cart Response: ${response.data}');
      if (response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('Response data is null');
        }
        return CartViewResponse.fromJson(response.data);
      }
      throw Exception('Failed to fetch cart - Status: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout while fetching cart');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout while fetching cart');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception(
            'Bad response: ${e.response?.statusCode} - ${e.response?.data}');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
            'Connection error: Please check your internet connection');
      } else {
        throw Exception('Error fetching cart: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error fetching cart: $e');
    }
  }
}
// class CartRepo {
//   /// Adds an item to the cart for a specific user.
//   static Future<CartAddResponse> addToCart({
//     required int userId,
//     required int itemId,
//   }) async {
//     try {
//       const String endpoint = AppEndpoints.addToCart; // حذف الـ query string
//       final Map<String, dynamic> requestData = {
//         'usersid': userId,
//         'itemsid': itemId,
//       };
//       log('Add to Cart Request: $requestData');
//       final response = await DioProvider.post(
//         endpoint: endpoint,
//         data: requestData,
//         headers: {'Content-Type': 'application/json'},
//       );
//       log('Add to Cart Response: ${response.data}');
//       if (response.statusCode == 200) {
//         return CartAddResponse.fromJson(response.data);
//       }
//       throw Exception(
//           'Failed to add item to cart - Status: ${response.statusCode}');
//     } catch (e) {
//       throw Exception('Error adding item to cart: $e');
//     }
//   }

//   /// Retrieves the count of a specific item in the user's cart.
//   static Future<CartCountResponse> getCartItemCount({
//     required int userId,
//     required int itemId,
//   }) async {
//     try {
//       final String endpoint =
//           '${AppEndpoints.cartCount}?id=$itemId&userid=$userId';
//       final Map<String, dynamic> requestData = {
//         'usersid': userId,
//         'itemsid': itemId,
//       };
//       final response = await DioProvider.post(
//         endpoint: endpoint,
//         data: requestData,
//         headers: {'Content-Type': 'application/json'},
//       );
//       log('Get Cart Item Count Response: ${response.data}');
//       if (response.statusCode == 200) {
//         return CartCountResponse.fromJson(response.data);
//       }
//       throw Exception(
//           'Failed to get cart item count - Status: ${response.statusCode}');
//     } catch (e) {
//       throw Exception('Error getting cart item count: $e');
//     }
//   }

//   /// Fetches the cart summary and items for a specific user.
//   static Future<CartViewResponse> fetchCart({
//     required int userId,
//   }) async {
//     try {
//       final String endpoint = '${AppEndpoints.viewCart}?usersid=$userId';
//       final Map<String, dynamic> requestData = {
//         'usersid': userId,
//       };
//       final response = await DioProvider.post(
//         endpoint: endpoint,
//         data: requestData,
//         headers: {'Content-Type': 'application/json'},
//       );
//       log('Fetch Cart Response: ${response.data}');
//       if (response.statusCode == 200) {
//         return CartViewResponse.fromJson(response.data);
//       }
//       throw Exception('Failed to fetch cart - Status: ${response.statusCode}');
//     } catch (e) {
//       throw Exception('Error fetching cart: $e');
//     }
//   }
// }
