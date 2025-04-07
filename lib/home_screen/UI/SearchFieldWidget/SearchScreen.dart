import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/home_screen/UI/SearchFieldWidget/SearchFieldWidget.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_bloc.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_event.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_state.dart';
import 'package:graduation_project/home_screen/data/model/search_model_response/SearchModelResponse.dart' as search;

class SearchScreen extends StatefulWidget {
  static const String routeName = 'SearchScreen';
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _debounce;
  String _lastQuery = '';

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void search(String query) {
    _lastQuery = query;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<HomeBloc>().add(FetchSearchEvent(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: SearchFieldWidget(
                      isClickable: false,
                      onSearch: search,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is FetchSearchLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchSearchSuccessState) {
            if (state.services.isEmpty) {
              return Center(
                child: Text(
                  "لا توجد نتائج. جرب كلمة أخرى!",
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              physics: const BouncingScrollPhysics(),
              itemCount: state.services.length,
              itemBuilder: (context, index) {
                return SearchResultCard(service: state.services[index]);
              },
            );
          } else if (state is FetchSearchErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "حدث خطأ: ${state.message}",
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      if (_lastQuery.isNotEmpty) {
                        context.read<HomeBloc>().add(FetchSearchEvent(_lastQuery));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    ),
                    child: Text(
                      "إعادة المحاولة",
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Text(
              "ابحث عن شيء لتبدأ",
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
            ),
          );
        },
      ),
    );
  }
}

class SearchResultCard extends StatelessWidget {
  final search.Data service;

  const SearchResultCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    if (service.serviceName == null && service.serviceDescription == null) {
      return Card(
        margin: EdgeInsets.only(bottom: 10.h),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Row(
            children: [
              Icon(Icons.error, size: 80.w, color: Colors.grey),
              SizedBox(width: 15.w),
              Expanded(
                child: Text(
                  "بيانات غير متاحة",
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                service.serviceImage ?? '',
                width: 80.w,
                height: 80.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.error, size: 80.w),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.serviceName ?? 'غير متاح',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    service.serviceDescription ?? 'لا يوجد وصف',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 16.sp),
                      SizedBox(width: 5.w),
                      Text(
                        service.serviceRating ?? '0.0',
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
