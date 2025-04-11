import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_bloc.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SpecialOfferCarouselWidget extends StatefulWidget {
  const SpecialOfferCarouselWidget({super.key});

  @override
  State<SpecialOfferCarouselWidget> createState() =>
      _SpecialOfferCarouselWidgetState();
}

class _SpecialOfferCarouselWidgetState
    extends State<SpecialOfferCarouselWidget> {
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
              fontSize:
                  18.sp, // صغرته من 18.sp لـ 20.sp مع وزن أثقل لتباين أفضل
              fontWeight: FontWeight.bold,
              color: MyTheme.blackColor,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(1, 1),
                  blurRadius: 3.r,
                ),
              ], // غيرته للون الثيم عشان التناسق
            ),
          ),
        ),
        SizedBox(height: 10.h), // صغرته من 8.h لـ 10.h لمسافة أنيقة
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is FetchLoadingHomeDataState) {
                    return Container(
                      height: 120.h, // صغرته من 150.h لـ 120.h
                      child: Center(
                        child: CircularProgressIndicator(
                          color: MyTheme.orangeColor,
                          strokeWidth: 4.w, // صغرنا الـ Stroke لتناسق
                        ),
                      ),
                    );
                  } else if (state is FetchSuccessHomeDataState) {
                    return CarouselSlider.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index, realIndex) {
                        final item = state.items[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                10.r), // صغرته من 12.r لـ 10.r
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.15), // خففنا الـ Shadow
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
                                  item.itemsImage ?? '',
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
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
                                        size: 30.w, // صغرنا الأيقونة من 40.w
                                        color: Colors.grey[400],
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(
                                            0.4), // زاد الـ Opacity شوية للوضوح
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                                if (item.itemsDiscount != null &&
                                    item.itemsDiscount != 0)
                                  Positioned(
                                    top: 6.h, // صغرنا من 8.h
                                    right: 6.w, // صغرنا من 8.w
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w, // صغرنا من 8.w
                                        vertical: 3.h, // صغرنا من 4.h
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(
                                            6.r), // صغرنا من 8.r
                                      ),
                                      child: Text(
                                        "${item.itemsDiscount}% OFF",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp, // صغرنا من 11.sp
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 120.h, // صغرنا من 150.h
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.85, // صغرناه من 0.9 لتباين أفضل
                        autoPlayInterval: Duration(seconds: 4),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    );
                  }
                  return Container(
                    height: 120.h,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: MyTheme.orangeColor,
                        strokeWidth: 3.w,
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is FetchSuccessHomeDataState) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 6.h), // صغرنا من 8.h
                      child: AnimatedSmoothIndicator(
                        activeIndex: currentIndex,
                        count: state.items.length > 5 ? 5 : state.items.length,
                        effect: WormEffect(
                          activeDotColor: MyTheme.orangeColor,
                          dotColor: Colors.grey[300]!,
                          dotWidth: 6.w, // صغرنا من 8.w
                          dotHeight: 6.h, // صغرنا من 8.h
                          spacing: 5.w, // صغرنا من 6.w
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
