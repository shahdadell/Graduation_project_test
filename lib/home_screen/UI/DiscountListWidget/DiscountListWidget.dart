import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_bloc.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_state.dart';
import 'DiscountPage/AllDiscountsPage.dart';
import 'DiscountCard.dart';

class DiscountListWidget extends StatelessWidget {
  const DiscountListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        SizedBox(height: 4.h),
        _buildContent(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, top: 4.h),
      child: Text(
        "Discount Guaranteed 🤑",
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          shadows: [
            Shadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 3.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is FetchLoadingHomeDataState) {
          return Container(
            height: 130.h,
            child: Center(child: CircularProgressIndicator(color: MyTheme.orangeColor)),
          );
        } else if (state is FetchSuccessHomeDataState) {
          final itemCount = state.items.length > 4 ? 5 : state.items.length;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Container(
              height: 130.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if (index == 4 && state.items.length > 3) {
                    return _buildShowMoreCard(context);
                  }
                  final item = state.items[index];
                  return DiscountCard(item: item); // هنعدل الـ DiscountCard بس
                },
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildShowMoreCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllDiscountsPage()),
        );
      },
      child: Container(
        width: 120.w,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Show More",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: MyTheme.orangeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.arrow_forward_ios,
                size: 14.w,
                color: MyTheme.orangeColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}