import 'package:graduation_project/home_screen/data/model/home_model_response/home_model_response.dart';
import 'package:graduation_project/home_screen/data/model/services_model_response/services_model_response.dart';

class HomeEvent {}

class FetchCategoriesEvent extends HomeEvent {
  final HomeModelResponse params;
  FetchCategoriesEvent(this.params);
}

class FetchOffersEvent extends HomeEvent {}

class FetchDiscountEvent extends HomeEvent {
  final HomeModelResponse params;
  FetchDiscountEvent(this.params);
}

class FetchHomeDataEvent extends HomeEvent {
  final HomeModelResponse? params;
  FetchHomeDataEvent(this.params);
}

class FetchServicesEvent extends HomeEvent {
  final int categoryId; // نمرر الـ ID فقط بدل الـ Model بالكامل
  FetchServicesEvent(this.categoryId);
}

class FetchServiceItemsEvent extends HomeEvent {
  final int serviceId;
  final int userId;
  FetchServiceItemsEvent({required this.serviceId, required this.userId});
}
