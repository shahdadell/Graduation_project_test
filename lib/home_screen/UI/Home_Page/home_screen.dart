import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_bloc.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_event.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_state.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/home_screen/ui/home_page/homewidgets.dart';
import 'package:graduation_project/home_screen/ui/category_page/service_for_category.dart';
import 'package:graduation_project/home_screen/data/model/home_model_response/home_model_response.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  static const String routName = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
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
      create: (context) =>
      HomeBloc()..add(FetchHomeDataEvent(HomeModelResponse())),
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
                  _buildTopBar(context),
                  //SizedBox(height: 10.h),
                  _buildSearchField(context),
                  //SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: Text(
                      "Special Offer",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildSpecialOfferCarousel(context),
                  SizedBox(height: 20.h),
                  _buildCategoriesGrid(context),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: Text(
                      "Discount Guaranteed!",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildDiscountList(context),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [MyTheme.orangeColor, Colors.orange[400]!],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.2),
      //       blurRadius: 6.r,
      //       spreadRadius: 1.r,
      //     ),
      //   ],
      // ),
      child: homeTopBar(context),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: searchField(ScreenUtil().screenWidth),
    );
  }

  Widget _buildSpecialOfferCarousel(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is FetchLoadingHomeDataState) {
                return Container(
                  height: 150.h,
                  child: Center(child: CircularProgressIndicator(color: MyTheme.orangeColor)),
                );
              } else if (state is FetchSuccessHomeDataState) {
                return CarouselSlider.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index, realIndex) {
                    final item = state.items[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6.r,
                            spreadRadius: 1.r,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              item.itemsImage ?? '',
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          color: MyTheme.orangeColor)),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(Icons.broken_image,
                                      size: 40.w, color: Colors.grey[400]),
                                );
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.3),
                                    Colors.transparent
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            if (item.itemsDiscount != null && item.itemsDiscount != 0)
                              Positioned(
                                top: 8.h,
                                right: 8.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.redAccent, Colors.red[700]!],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    "${item.itemsDiscount}% OFF",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.sp,
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
                    height: 150.h,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
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
                height: 150.h,
                child: Center(child: Text("Error loading offers", style: TextStyle(fontSize: 14.sp))),
              );
            },
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is FetchSuccessHomeDataState) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: AnimatedSmoothIndicator(
                    activeIndex: currentIndex,
                    count: 5,
                    effect: WormEffect(
                      activeDotColor: MyTheme.orangeColor,
                      dotColor: Colors.grey[300]!,
                      dotWidth: 8.w,
                      dotHeight: 8.h,
                      spacing: 6.w,
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is FetchLoadingHomeDataState) {
          return Container(
            height: 150.h,
            child: Center(child: CircularProgressIndicator(color: MyTheme.orangeColor)),
          );
        } else if (state is FetchSuccessHomeDataState) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: 0.9, // تعديل الـ aspect ratio لحل الـ overflow
              ),
              itemCount: state.categories.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServicesScreen(
                          categoryId: state.categories[index].categoriesId.toString(),
                          categoryName: state.categories[index].categoriesName ?? 'Unknown',
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 60.w, // تصغير الصورة
                        height: 50.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey[50]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6.r,
                              spreadRadius: 1.r,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            state.categories[index].categoriesImage ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Icon(Icons.broken_image,
                                    size: 25.w, color: Colors.grey[400]),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h), // تصغير المسافة
                      Text(
                        state.categories[index].categoriesName ?? 'Unknown',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp, // تصغير النص
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else if (state is HomeErrorState) {
          return Container(
            height: 150.h,
            child: Center(child: Text("Error: ${state.message}", style: TextStyle(fontSize: 14.sp))),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildDiscountList(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is FetchLoadingHomeDataState) {
          return Container(
            height: 150.h,
            child: Center(child: CircularProgressIndicator(color: MyTheme.orangeColor)),
          );
        } else if (state is FetchSuccessHomeDataState) {
          return SizedBox(
            height: 150.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return Container(
                  width: 140.w, // تصغير العرض
                  margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey[50]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6.r,
                        spreadRadius: 1.r,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                            child: Image.network(
                              item.itemsImage ?? '',
                              height: 80.h, // تصغير الارتفاع
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 80.h,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.broken_image,
                                      size: 30.w, color: Colors.grey[400]),
                                );
                              },
                            ),
                          ),
                          if (item.itemsDiscount != null && item.itemsDiscount != 0)
                            Positioned(
                              top: 6.h,
                              left: 6.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.redAccent, Colors.red[700]!],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  "${item.itemsDiscount}% OFF",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp, // تصغير النص
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(6.w), // تصغير الـ padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.itemsName ?? 'Unknown',
                              style: TextStyle(
                                fontSize: 12.sp, // تصغير النص
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 3.h), // تصغير المسافة
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${item.itemsPrice ?? 'N/A'} EGP",
                                  style: TextStyle(
                                    fontSize: 11.sp, // تصغير النص
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        size: 12.w, color: Colors.orangeAccent),
                                    SizedBox(width: 3.w),
                                    Text(
                                      item.serviceRating?.toString() ?? 'N/A',
                                      style: TextStyle(
                                        fontSize: 10.sp, // تصغير النص
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

class RibbonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width - 8.w, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 8.w, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}