import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/home_screen/UI/Items_Page/Items_screen.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_bloc.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_state.dart';
import 'package:graduation_project/home_screen/data/model/offers_model_response/offers_model_response.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SpecialOfferCarouselWidget extends StatefulWidget {
  const SpecialOfferCarouselWidget({super.key});

  @override
  State<SpecialOfferCarouselWidget> createState() => _SpecialOfferCarouselWidgetState();
}

class _SpecialOfferCarouselWidgetState extends State<SpecialOfferCarouselWidget> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: Text(
            "Special Offer",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: MyTheme.blackColor,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(1, 1),
                  blurRadius: 3.r,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is FetchOffersLoadingState) {
                    return Container(
                      height: 120.h,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: MyTheme.orangeColor,
                          strokeWidth: 4.w,
                        ),
                      ),
                    );
                  } else if (state is FetchOffersSuccessState) {
                    // لو مفيش Offers، نعرض رسالة
                    if (state.offers.isEmpty) {
                      return Container(
                        height: 120.h,
                        child: Center(
                          child: Text(
                            'No offers available',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: MyTheme.grayColor2,
                            ),
                          ),
                        ),
                      );
                    }
                    return CarouselSlider.builder(
                      itemCount: state.offers.length > 5 ? 5 : state.offers.length, // بحد أقصى 5
                      itemBuilder: (context, index, realIndex) {
                        final offer = state.offers[index];
                        return GestureDetector(
                          onTap: () {
                            // لما يضغط على الـ Offer، يروح لـ ServiceItemsScreen
                            Navigator.pushNamed(
                              context,
                              ServiceItemsScreen.routeName,
                              arguments: int.parse(offer.serviceId),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  blurRadius: 4.r,
                                  spreadRadius: 1.r,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    offer.itemsImage ?? '',
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: MyTheme.orangeColor,
                                            strokeWidth: 3.w,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 30.w,
                                          color: Colors.grey[400],
                                        ),
                                      );
                                    },
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.4),
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                  if (offer.itemsDiscount != null && offer.itemsDiscount != "0")
                                    Positioned(
                                      top: 6.h,
                                      right: 6.w,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6.w,
                                          vertical: 3.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(6.r),
                                        ),
                                        child: Text(
                                          "${offer.itemsDiscount}% OFF",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 120.h,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.85,
                        autoPlayInterval: Duration(seconds: 4),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    );
                  } else if (state is FetchOffersErrorState) {
                    return Container(
                      height: 120.h,
                      child: Center(
                        child: Text(
                          'Failed to load offers: ${state.message}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: MyTheme.grayColor2,
                          ),
                        ),
                      ),
                    );
                  }
                  return Container(
                    height: 120.h,
                    child: Center(
                      child: Text(
                        'No offers available',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: MyTheme.grayColor2,
                        ),
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is FetchOffersSuccessState && state.offers.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: AnimatedSmoothIndicator(
                        activeIndex: currentIndex,
                        count: state.offers.length > 5 ? 5 : state.offers.length,
                        effect: WormEffect(
                          activeDotColor: MyTheme.orangeColor,
                          dotColor: Colors.grey[300]!,
                          dotWidth: 6.w,
                          dotHeight: 6.h,
                          spacing: 5.w,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}