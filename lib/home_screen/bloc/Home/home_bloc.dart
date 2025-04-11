// lib/home_screen/bloc/Home/home_bloc.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_event.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_state.dart';
import 'package:graduation_project/home_screen/data/repo/home_repo.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    on<FetchHomeDataEvent>(fetchHomeData);
    on<FetchOffersEvent>(fetchOffers);
    on<FetchTopSellingEvent>(fetchTopSelling);
    on<FetchCategoriesEvent>(fetchCategories);
    on<FetchDiscountEvent>(fetchDiscountedItems);
    on<FetchServicesEvent>(fetchServicesByCategory);
    on<FetchServiceItemsEvent>(fetchServiceItems);
    on<FetchSearchEvent>(fetchSearch);
    on<ClearSearchEvent>((event, emit) {
      print('ClearSearchEvent Triggered'); // للتصحيح
      emit(HomeInitialState());
    });
  }

  Future<void> fetchHomeData(
      FetchHomeDataEvent event, Emitter<HomeState> emit) async {
    emit(FetchLoadingHomeDataState());
    try {
      final categories = await HomeRepo.fetchCategories();
      final items = await HomeRepo.fetchDiscountedItems();
      emit(FetchSuccessHomeDataState(categories: categories, items: items));
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  Future<void> fetchOffers(
      FetchOffersEvent event, Emitter<HomeState> emit) async {
    emit(FetchOffersLoadingState());
    try {
      final offersResponse = await HomeRepo.fetchOffers();
      emit(FetchOffersSuccessState(offers: offersResponse.data ?? []));
    } catch (e) {
      emit(FetchOffersErrorState(message: e.toString()));
    }
  }

  Future<void> fetchTopSelling(
      FetchTopSellingEvent event, Emitter<HomeState> emit) async {
    if (kDebugMode) {
      print("FetchTopSellingEvent Started");
    }
    emit(FetchTopSellingLoadingState());
    try {
      final topSellingResponse = await HomeRepo.fetchTopSelling();
      final topSellingItems = topSellingResponse.items?.data ?? [];
      print(
          "FetchTopSellingEvent Succeeded with ${topSellingItems.length} items");
      emit(FetchTopSellingSuccessState(topSelling: topSellingItems));
    } catch (e) {
      if (kDebugMode) {
        print("FetchTopSellingEvent Failed: $e");
      }
      emit(FetchTopSellingErrorState(message: e.toString()));
    }
  }

  Future<void> fetchCategories(
      FetchCategoriesEvent event, Emitter<HomeState> emit) async {
    emit(FetchCategoriesLoadingState());
    try {
      final categories = await HomeRepo.fetchCategories();
      emit(FetchCategoriesSuccessState(categories: categories));
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  Future<void> fetchDiscountedItems(
      FetchDiscountEvent event, Emitter<HomeState> emit) async {
    emit(FetchDiscountItemsLoadingState());
    try {
      final items = await HomeRepo.fetchDiscountedItems();
      emit(FetchDiscountItemsSuccessState(items: items));
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  Future<void> fetchServicesByCategory(
      FetchServicesEvent event, Emitter<HomeState> emit) async {
    emit(FetchServicesLoadingState());
    try {
      final services = await HomeRepo.fetchServicesByCategory(event.categoryId);
      emit(FetchServicesSuccessState(services: services));
    } catch (e) {
      emit(FetchServicesErrorState(message: e.toString()));
    }
  }

  Future<void> fetchServiceItems(
      FetchServiceItemsEvent event, Emitter<HomeState> emit) async {
    emit(FetchServiceItemsLoadingState());
    try {
      final items = await HomeRepo.fetchServiceItems(
        serviceId: event.serviceId,
        userId: event.userId,
      );
      emit(FetchServiceItemsSuccessState(items: items));
    } catch (e) {
      emit(FetchServiceItemsErrorState(message: e.toString()));
    }
  }

  Future<void> fetchSearch(
      FetchSearchEvent event, Emitter<HomeState> emit) async {
    emit(FetchSearchLoadingState());
    try {
      final searchResults = await HomeRepo.fetchSearch(event.query);
      final services = searchResults.services?.data ?? [];
      final items = searchResults.items?.data ?? [];
      emit(FetchSearchSuccessState(services: services, items: items));
    } catch (e) {
      emit(FetchSearchErrorState(message: e.toString()));
    }
  }
}
