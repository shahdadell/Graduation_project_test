import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/home_screen/UI/SearchFieldWidget/SearchFieldWidget.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_bloc.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_event.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_state.dart';
import 'package:graduation_project/home_screen/data/model/search_model_response/SearchModelResponse.dart' as search;

import 'SearchResultCard.dart';

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
      if (query.trim().isEmpty) { // تأكدنا إن النص فاضي حتى لو فيه مسافات
        context.read<HomeBloc>().add(ClearSearchEvent());
      } else {
        context.read<HomeBloc>().add(FetchSearchEvent(query));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: MyTheme.whiteColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Icon(Icons.arrow_back_ios, color: MyTheme.whiteColor, size: 24.w),
          ),
        ),
        title: Text(
          "Search",
          style: textTheme.displayLarge,
        ),
        centerTitle: true,
        backgroundColor: MyTheme.orangeColor,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [MyTheme.orangeColor, Colors.orange[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
            child: SearchFieldWidget(
              isClickable: false,
              onSearch: search,
            ),
          ),
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is FetchSearchLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(color: MyTheme.orangeColor),
                  );
                } else if (state is FetchSearchSuccessState) {
                  if (state.services.isEmpty) {
                    return Center(
                      child: Text(
                        "لا توجد نتائج. جرب كلمة أخرى!",
                        style: textTheme.titleMedium?.copyWith(
                          color: MyTheme.grayColor2,
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      if (_lastQuery.isNotEmpty) {
                        context.read<HomeBloc>().add(FetchSearchEvent(_lastQuery));
                      }
                    },
                    color: MyTheme.orangeColor,
                    child: Container(
                      color: MyTheme.whiteColor,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.services.length,
                        itemBuilder: (context, index) {
                          return SearchResultCard(service: state.services[index]);
                        },
                      ),
                    ),
                  );
                } else if (state is FetchSearchErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Results",
                          style: textTheme.titleMedium?.copyWith(
                            color: MyTheme.grayColor2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  );
                }
                return Center(
                  child: Text(
                    "Find Something To Start 👀",
                    style: textTheme.titleMedium?.copyWith(
                      color: MyTheme.grayColor2,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}