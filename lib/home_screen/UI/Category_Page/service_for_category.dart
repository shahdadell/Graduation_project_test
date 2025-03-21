import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/home_screen/UI/Items_Page/Items_screen.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_bloc.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_event.dart';
import 'package:graduation_project/home_screen/bloc/Home/home_state.dart';

class ServicesScreen extends StatelessWidget {
  static const String routeName = 'ServicesScreen';
  final String categoryId;
  final String categoryName;

  const ServicesScreen(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final int parsedCategoryId = int.tryParse(categoryId) ?? 0;

    return BlocProvider(
      create: (context) =>
          HomeBloc()..add(FetchServicesEvent(parsedCategoryId)),
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Icon(
                Icons.arrow_back_ios,
                color: MyTheme.whiteColor,
                size: 24.w,
              ),
            ),
          ),
          title: Text(
            categoryName,
            style: TextStyle(
              fontSize: 22.sp,
              color: MyTheme.whiteColor,
              fontWeight: FontWeight.bold,
            ),
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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[100]!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is FetchServicesLoadingState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: MyTheme.orangeColor,
                  ),
                );
              } else if (state is FetchServicesSuccessState) {
                return Column(
                  children: [
                    // Carousel للخدمات المميزة
                    if (state.services.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 150.h,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 16 / 9,
                            autoPlayInterval: Duration(seconds: 3),
                            viewportFraction: 0.8,
                          ),
                          items: state.services.take(3).map((service) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        blurRadius: 8.r,
                                        spreadRadius: 2.r,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.r),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        service.serviceImage != null &&
                                                service.serviceImage!.isNotEmpty
                                            ? Image.network(
                                                service.serviceImage!,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                color: Colors.grey[200],
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  size: 50.w,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black.withOpacity(0.4),
                                                Colors.transparent
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10.h,
                                          left: 10.w,
                                          child: Text(
                                            service.serviceName ?? 'No Name',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    // الـ ListView
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: ListView.builder(
                          itemCount: state.services.length,
                          itemBuilder: (context, index) {
                            final service = state.services[index];
                            return TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration:
                                  Duration(milliseconds: 500 + (index * 100)),
                              builder: (context, opacity, child) {
                                return Opacity(
                                  opacity: opacity,
                                  child: child,
                                );
                              },
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ServiceItemsScreen.routeName,
                                    arguments: {
                                      'serviceId': int.tryParse(
                                              service.categoryId ?? '0') ??
                                          0,
                                      'userId':
                                          10, // استبدلي بالـ userId الفعلي
                                    },
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10.h),
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    gradient: LinearGradient(
                                      colors: [Colors.white, Colors.grey[50]!],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 8.r,
                                        spreadRadius: 2.r,
                                        offset: Offset(0, 4.h),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            child: service.serviceImage !=
                                                        null &&
                                                    service.serviceImage!
                                                        .isNotEmpty
                                                ? Image.network(
                                                    service.serviceImage!,
                                                    width: 90.w,
                                                    height: 80.h,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Container(
                                                      width: 90.w,
                                                      height: 80.h,
                                                      color: Colors.grey[200],
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        size: 40.w,
                                                        color: Colors.grey[400],
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    width: 90.w,
                                                    height: 80.h,
                                                    color: Colors.grey[200],
                                                    child: Icon(
                                                      Icons.image_not_supported,
                                                      size: 40.w,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                          ),
                                          SizedBox(width: 15.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  service.serviceName ??
                                                      'No Name',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.sp,
                                                    color: Colors.black87,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 6.h),
                                                Row(
                                                  children: [
                                                    Icon(Icons.star,
                                                        color: Colors.amber,
                                                        size: 18.w),
                                                    SizedBox(width: 4.w),
                                                    Text(
                                                      service.serviceRating ??
                                                          'N/A',
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 6.h),
                                                Row(
                                                  children: [
                                                    Icon(Icons.location_on,
                                                        color: Colors.red,
                                                        size: 18.w),
                                                    SizedBox(width: 4.w),
                                                    Expanded(
                                                      child: Text(
                                                        service.serviceLocation ??
                                                            'Unknown location',
                                                        style: TextStyle(
                                                          fontSize: 13.sp,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      Container(
                                        height: 1.h,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              MyTheme.orangeColor,
                                              Colors.transparent
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Wrap(
                                        spacing: 8.w,
                                        runSpacing: 6.h,
                                        children: [
                                          if (service.servicePhone != null)
                                            _buildChip(
                                              label: "Call",
                                              icon: Icons.phone,
                                              color: Colors.green[800]!,
                                              onTap: () => showServiceDialog(
                                                  context,
                                                  "Phone Number",
                                                  service.servicePhone ??
                                                      "No Phone Number"),
                                            ),
                                          if (service.serviceWebsite != null)
                                            _buildChip(
                                              label: "Website",
                                              icon: Icons.web,
                                              color: Colors.blue[800]!,
                                              onTap: () => showServiceDialog(
                                                  context,
                                                  "Website",
                                                  service.serviceWebsite ??
                                                      "No Website Available"),
                                            ),
                                          _buildChip(
                                            label: "Details",
                                            icon: Icons.info,
                                            color: MyTheme.orangeColor,
                                            onTap: () => showServiceDialog(
                                              context,
                                              "More Details",
                                              '''
📌 Name: ${service.serviceName}
📝 Description: ${service.serviceDescription}
📍 Location: ${service.serviceLocation}
⭐ Rating: ${service.serviceRating}
''',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is FetchServicesErrorState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 60.w, color: Colors.redAccent),
                      SizedBox(height: 20.h),
                      Text(
                        "Oops! Something Went Wrong",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Error: ${state.message}",
                        style:
                            TextStyle(fontSize: 16.sp, color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BlocProvider.of<HomeBloc>(context)
                .add(FetchServicesEvent(parsedCategoryId));
          },
          backgroundColor: MyTheme.orangeColor,
          child: Icon(Icons.refresh, size: 24.w, color: Colors.white),
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 4.r,
              spreadRadius: 1.r,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.w, color: Colors.white),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

void showServiceDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ScreenUtil().screenWidth * 0.7,
          maxHeight: ScreenUtil().screenHeight * 0.4,
        ),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Close",
            style: TextStyle(fontSize: 14.sp, color: MyTheme.orangeColor),
          ),
        ),
      ],
    ),
  );
}
