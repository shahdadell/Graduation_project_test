import 'package:graduation_project/home_screen/data/model/home_model_response/Categorydatum.dart';
import 'package:graduation_project/home_screen/data/model/home_model_response/items_model.dart';
import 'package:graduation_project/home_screen/data/model/item_model_response/Itemdatum.dart';
import 'package:graduation_project/home_screen/data/model/offers_model_response/offers_model_response.dart';
import 'package:graduation_project/home_screen/data/model/services_model_response/service_model.dart';

class HomeState {}

class HomeInitialState extends HomeState {}

// fetchCategories
class FetchCategoriesLoadingState extends HomeState {}

class FetchCategoriesSuccessState extends HomeState {
  final List<Categorydatum> categories;

  FetchCategoriesSuccessState({required this.categories});
}

// Fetch Offers
class FetchOffersLoadingState extends HomeState {}

class FetchOffersSuccessState extends HomeState {
  final List<OfferData> offers;
  FetchOffersSuccessState({required this.offers});
}

class FetchOffersErrorState extends HomeState {
  final String message;
  FetchOffersErrorState({required this.message});
}

// fetchDiscountedItems
class FetchDiscountItemsLoadingState extends HomeState {}

class FetchDiscountItemsSuccessState extends HomeState {
  final List<ItemModel> items;

  FetchDiscountItemsSuccessState({required this.items});
}

// fetchHomeData
class FetchLoadingHomeDataState extends HomeState {}

class FetchSuccessHomeDataState extends HomeState {
  final List<Categorydatum> categories;
  final List<ItemModel> items;

  FetchSuccessHomeDataState({required this.categories, required this.items});
}

class HomeErrorState extends HomeState {
  String message;
  HomeErrorState({required this.message});
}

// fetchServicesByCategory
class FetchServicesLoadingState extends HomeState {}

class FetchServicesSuccessState extends HomeState {
  final List<ServiceModel> services;
  FetchServicesSuccessState({required this.services});
}

class FetchServicesErrorState extends HomeState {
  final String message;
  FetchServicesErrorState({required this.message});
}

//Fetch Items in each Categoty
class FetchServiceItemsLoadingState extends HomeState {}

class FetchServiceItemsSuccessState extends HomeState {
  final List<ItemDatum> items;
  FetchServiceItemsSuccessState({required this.items});
}

class FetchServiceItemsErrorState extends HomeState {
  final String message;
  FetchServiceItemsErrorState({required this.message});
}
