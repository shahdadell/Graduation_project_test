import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/Profile_screen/UI/profile_screen.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/app_images/app_images.dart';
import 'package:graduation_project/home_screen/UI/Cart_Page/CartScreen.dart';
import 'package:graduation_project/Theme/style.dart';
import 'package:graduation_project/home_screen/UI/Home_Page/homevariables.dart';
import 'package:graduation_project/local_data/shared_preference.dart';


Widget homeTopBar(BuildContext context) {
  String greeting  = getGreetingMessage();
  final int? userId = AppLocalStorage.getData('user_id'); // جيب الـ userId من الـ storage

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      InkWell(
        onTap: () {
          if (userId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please log in to view your profile')),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
        overlayColor:  WidgetStatePropertyAll(MyTheme.transparent),
        child:  Icon(
          Icons.person,
          size: 24,
          color: MyTheme.blackColor,
        ),
        // لو عندك صورة للـ profile في AppImages، استخدمي Image.asset:
        // child: Image.asset(
        //   AppImages.profileIcon, // استبدلي باسم الصورة الفعلي
        //   width: 24,
        //   height: 24,
        // ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: MyTheme.orangeColor2,
          borderRadius: BorderRadius.circular(21),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      AppImages.sun,
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      greeting.toUpperCase(),
                      style: GoogleFonts.rubik(
                        fontSize: 12,
                        color: MyTheme.lowOpacity,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                FutureBuilder<String?>(
                  future: getUsername(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading...');
                    }
                    return SizedBox(
                      width: 142,
                      child: Text(
                        snapshot.data ?? "Guest",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: MyTheme.whiteColor,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(width: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                AppImages.avatar,
                width: 50,
                height: 50,
              ),
            )
          ],
        ),
      ),
      InkWell(
        onTap: () {},
        overlayColor: WidgetStatePropertyAll(MyTheme.transparent),
        child: Image.asset(
          AppImages.notification,
          width: 24,
          height: 24,
        ),
      ),
      InkWell(
        onTap: () {
          if (userId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please log in to view your cart')),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CartScreen()), // شيل الـ userId
            );
          }
        },
        overlayColor: WidgetStatePropertyAll(MyTheme.transparent),
        child: Image.asset(
          AppImages.cart,
          width: 24,
          height: 24,
        ),
      ),
    ],
  );
}


Widget carouselSliderImage(String image) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.asset(
      image,
    ),
  );
}

Widget horizontalListTitle(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: textStyle(20, FontWeight.w700, MyTheme.blackColor),
        ),
        Icon(
          Icons.arrow_forward_ios,
          color: MyTheme.iconGrayColor,
          size: 16,
        )
      ],
    ),
  );
}

Widget horizontalList(List list,) {
  return Container(
    height: 220,
    margin: const EdgeInsets.only(
      top: 10,
      left: 10,
    ),
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        CardClass item = list[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(
                      item.image!,
                      height: 140,
                      width: 192,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 5),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: MyTheme.mauveColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      item.discount!,
                      style: textStyle(10, FontWeight.w700, MyTheme.whiteColor),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  item.name!,
                  style: textStyle(18, FontWeight.w600, MyTheme.blackColor),
                ),
              ),
              SizedBox(
                width: 192,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.destination!,
                          style: textStyle(
                              14, FontWeight.w500, MyTheme.iconGrayColor),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 1,
                          height: 14,
                          color: MyTheme.iconGrayColor,
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.star,
                          color: MyTheme.yellowColor,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          item.rate!,
                          style: textStyle(
                              14, FontWeight.w500, MyTheme.iconGrayColor),
                        ),
                      ],
                    ),
                    Image.asset(
                      AppImages.heart,
                      width: 20,
                      height: 20,
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    ),
  );
}

Widget horizontalDishesList(List list,) {
  return Container(
    height: 220,
    margin: const EdgeInsets.only(
      top: 10,
      left: 10,
    ),
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        TextAndImageClass item = list[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  item.icon!,
                  height: 124,
                  width: 260,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                item.name!,
                style: textStyle(16, FontWeight.w500, MyTheme.blackColor),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget horizontalRestaurantList(
  List list,
) {
  return Container(
    height: 220,
    margin: const EdgeInsets.only(
      top: 10,
      left: 10,
    ),
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        RestaurantClass item = list[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
                child: Image.asset(
                  item.icon!,
                  height: 140,
                  width: 192,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                item.name!,
                style: textStyle(16, FontWeight.w600, MyTheme.blackColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: MyTheme.iconGrayColor,
                    size: 20,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    item.location!,
                    style:
                        textStyle(14, FontWeight.w500, MyTheme.iconGrayColor),
                  )
                ],
              )
            ],
          ),
        );
      },
    ),
  );
}

Widget recommendedListView(List list) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 10,
    ),
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        CardClass item = list[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(
                      item.image!,
                      height: 142,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 5),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: MyTheme.mauveColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      item.discount!,
                      style: textStyle(10, FontWeight.w700, MyTheme.whiteColor),
                    ),
                  )
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                child: Text(
                  item.name!,
                  style: textStyle(18, FontWeight.w600, MyTheme.blackColor),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.destination!,
                          style: textStyle(
                              14, FontWeight.w500, MyTheme.iconGrayColor),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 1,
                          height: 14,
                          color: MyTheme.iconGrayColor,
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.star,
                          color: MyTheme.yellowColor,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          item.rate!,
                          style: textStyle(
                              14, FontWeight.w500, MyTheme.iconGrayColor),
                        ),
                      ],
                    ),
                    Image.asset(
                      AppImages.heart,
                      width: 20,
                      height: 20,
                    )
                  ],
                ),
              ),
              if (index != list.length - 1)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 1,
                  width: double.infinity,
                  color: MyTheme.iconGrayColor,
                )
            ],
          ),
        );
      },
    ),
  );
}
