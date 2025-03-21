// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:graduation_project/API_Services/dio_provider.dart';
import 'package:graduation_project/API_Services/endpoints.dart';
import 'package:graduation_project/home_screen/data/model/Cart_model_response/cart_add_response.dart';
import 'package:graduation_project/home_screen/data/model/home_model_response/Categorydatum.dart';
import 'package:graduation_project/home_screen/data/model/home_model_response/items_model.dart';
import 'package:graduation_project/home_screen/data/model/item_model_response/Itemdatum.dart';
import 'package:graduation_project/home_screen/data/model/offers_model_response/offers_model_response.dart';
import 'package:graduation_project/home_screen/data/model/services_model_response/service_model.dart';

class HomeRepo {
  static Future<List<Categorydatum>> fetchCategories() async {
    try {
      var response = await DioProvider.get(endpoint: AppEndpoints.fetchHome);
      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        // List categoriesData = response.data['categories'];
        List categoriesData = response.data['categories']['data'];
        return categoriesData.map((e) => Categorydatum.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (e) {
      log('Exception: $e');
      throw Exception('Error fetching categories');
    }
  }

  static Future<OffersModelResponse> fetchOffers() async {
    try {
      var response = await DioProvider.get(
        endpoint: "https://abdulrahmanantar.com/outbye/offers.php",
      );
      log('Fetch Offers Response Status Code: ${response.statusCode}');
      log('Fetch Offers Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return OffersModelResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to fetch offers: ${response.data['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      log('Exception in fetchOffers: $e');
      throw Exception('Error fetching offers: $e');
    }
  }

  static Future<List<ItemModel>> fetchDiscountedItems() async {
    try {
      var response = await DioProvider.get(endpoint: AppEndpoints.fetchHome);
      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        List itemsData = response.data['items']['data'];
        return itemsData.map((e) => ItemModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch discounted items');
      }
    } catch (e) {
      log('Exception: $e');
      throw Exception('Error fetching discounted items');
    }
  }

  static Future<List<ServiceModel>> fetchServicesByCategory(
      int serviceId) async {
    try {
      var response = await DioProvider.get(
        endpoint: "${AppEndpoints.fetchService}?id=$serviceId",
        headers: {
          'Authorization': 'Bearer your_token_here', // استبدل التوكن الفعلي
          'Content-Type': 'application/json',
        },
      );

      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        List servicesData = response.data['data'];

        /// ✅ تأكد من أنك تستخدم `ServiceModel.fromJson`
        return servicesData.map((e) => ServiceModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch services');
      }
    } catch (e) {
      log('Exception: $e');
      throw Exception('Error fetching services');
    }
  }

  static Future<List<ItemDatum>> fetchServiceItems({
    required int serviceId,
    required int userId,
  }) async {
    try {
      var response = await DioProvider.get(
        endpoint: "${AppEndpoints.fetchItems}?id=$serviceId&userid=$userId",
        headers: {
          'Authorization': 'Bearer your_token_here', // استبدلي التوكن الفعلي
          'Content-Type': 'application/json',
        },
      );
      log('Response Status Code: ${response.statusCode}');
      log('Full Response: ${response.toString()}');
      log('Response Data: ${response.data.toString()}');

      if (response.statusCode == 200) {
        if (response.data != null && response.data['status'] == 'success') {
          if (response.data['data'] != null) {
            List itemsData = response.data['data'];
            log('Items Data: $itemsData');
            return itemsData.map((e) => ItemDatum.fromJson(e)).toList();
          } else {
            throw Exception('No data found in response');
          }
        } else {
          throw Exception(
              'API returned status: ${response.data['status']} - Message: ${response.data['message'] ?? 'No message'}');
        }
      } else {
        throw Exception(
            'Failed to fetch service items - Status Code: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception Details: $e');
      throw Exception('Error fetching service items: $e');
    }
  }

  //Cart
  static Future<CartAddResponse> addItemToCart({
    required int userId,
    required int itemId,
  }) async {
    try {
      var requestBody = {
        'usersid': userId.toString(),
        'itemsid': itemId.toString(),
      };

      log('Add to Cart Request URL: ${AppEndpoints.baseUrl}cart/add.php');
      log('Add to Cart Request Body: ${jsonEncode(requestBody)}');

      var response = await DioProvider.post(
        endpoint: "${AppEndpoints.addToCart}?id=$itemId&userid=$userId",
        data: requestBody,
        headers: {'Content-Type': 'application/json'},
      );

      log('Add to Cart Response Status: ${response.statusCode}');
      log('Add to Cart Response Data: ${response.data}');

      if (response.statusCode == 200) {
        return CartAddResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to add item to cart: ${response.statusCode} - ${response.data['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      log('Exception in Add to Cart: $e');
      throw Exception('Error adding item to cart: $e');
    }
  }
}
