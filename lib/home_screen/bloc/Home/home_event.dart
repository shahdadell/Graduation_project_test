import 'package:graduation_project/home_screen/data/model/home_model_response/home_model_response.dart';

abstract class HomeEvent {}

class FetchHomeDataEvent extends HomeEvent {
  final HomeModelResponse? params;
  FetchHomeDataEvent(this.params);
}

class FetchOffersEvent extends HomeEvent {}

class FetchTopSellingEvent extends HomeEvent {}

class FetchCategoriesEvent extends HomeEvent {
  final HomeModelResponse?
      params; // جعلته اختياري لأنه مش مستخدم حاليًا في الـ Repo
  FetchCategoriesEvent(this.params);
}

class FetchDiscountEvent extends HomeEvent {
  final HomeModelResponse?
      params; // جعلته اختياري لأنه مش مستخدم حاليًا في الـ Repo
  FetchDiscountEvent(this.params);
}

class FetchServicesEvent extends HomeEvent {
  final int categoryId;
  FetchServicesEvent(this.categoryId);
}

class FetchServiceItemsEvent extends HomeEvent {
  final int serviceId;
  final int userId;
  FetchServiceItemsEvent({required this.serviceId, required this.userId});
}
