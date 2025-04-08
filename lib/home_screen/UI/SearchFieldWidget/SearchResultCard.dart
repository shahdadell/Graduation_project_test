import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/home_screen/data/model/search_model_response/SearchModelResponse.dart' as search;

class SearchResultCard extends StatelessWidget {
  final search.Data service;

  const SearchResultCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (service.serviceName == null && service.serviceDescription == null) {
      return Card(
        margin: EdgeInsets.only(bottom: 12.h),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
          side: BorderSide(color: MyTheme.grayColor, width: 1.w),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              Icon(Icons.error, size: 60.w, color: MyTheme.grayColor2),
              SizedBox(width: 15.w),
              Expanded(
                child: Text(
                  "بيانات غير متاحة",
                  style: textTheme.titleMedium?.copyWith(
                    color: MyTheme.grayColor2,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        // تحويل serviceId من String? لـ int مع التحقق من القيمة
        final serviceId = int.tryParse(service.serviceId ?? '');
        if (serviceId != null) {
          Navigator.pushNamed(
            context,
            'ServiceItemsScreen', // اسم الصفحة بتاعتك
            arguments: serviceId, // بنبعت الـ serviceId كـ int
          );
        } else {
          // لو serviceId null أو مش رقم، بنظهر رسالة خطأ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('غير قادر على فتح تفاصيل الخدمة')),
          );
        }
      },
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 12.h),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
          side: BorderSide(color: MyTheme.grayColor, width: 1.w),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              ClipOval(
                child: Image.network(
                  service.serviceImage ?? '',
                  width: 70.w,
                  height: 60.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error, size: 60.w, color: MyTheme.grayColor2),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.serviceName ?? 'غير متاح',
                      style: textTheme.titleMedium?.copyWith(
                        color: MyTheme.blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      service.serviceDescription ?? 'لا يوجد وصف',
                      style: textTheme.bodySmall?.copyWith(
                        color: MyTheme.grayColor2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Icon(Icons.star, color: MyTheme.yellowColor, size: 16.sp),
                        SizedBox(width: 5.w),
                        Text(
                          service.serviceRating ?? '0.0',
                          style: textTheme.titleSmall?.copyWith(
                            color: MyTheme.grayColor2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Icon(Icons.phone, color: MyTheme.greenColor, size: 16.sp),
                        SizedBox(width: 5.w),
                        Text(
                          service.servicePhone ?? 'غير متاح',
                          style: textTheme.titleSmall?.copyWith(
                            color: MyTheme.grayColor2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}