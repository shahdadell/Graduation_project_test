import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/home_screen/UI/TopBarWidget/TopBarWidget.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_bloc.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_event.dart';
import '../CategoriesGridWidget/CategoriesGridWidget.dart';
import '../DiscountListWidget/DiscountListWidget.dart';
import '../SearchFieldWidget/SearchFieldWidget.dart';
import '../SpecialOfferCarouselWidget/SpecialOfferCarouselWidget.dart';
import '../TopSellingListWidget/TopSellingListWidget.dart';

class HomeScreen extends StatefulWidget {
  static const String routName = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = HomeBloc();
        if (kDebugMode) {
          print("Adding FetchHomeDataEvent");
        }
        bloc.add(FetchHomeDataEvent(null));
        if (kDebugMode) {
          print("Adding FetchTopSellingEvent");
        }
        bloc.add(FetchTopSellingEvent());
        if (kDebugMode) {
          print("Adding FetchOffersEvent");
        }
        bloc.add(FetchOffersEvent());
        return bloc;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[100]!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopBarWidget(),
                  const SearchFieldWidget(
                    isClickable: true, // هنا بنخليه ينقل لـ SearchScreen
                  ),
                  SizedBox(height: 10.h),
                  const SpecialOfferCarouselWidget(),
                  SizedBox(height: 15.h),
                  const CategoriesGridWidget(),
                  SizedBox(height: 15.h),
                  const DiscountListWidget(),
                  const TopSellingListWidget(),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
