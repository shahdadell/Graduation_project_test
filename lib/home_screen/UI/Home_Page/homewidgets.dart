import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/Profile_screen/UI/profile_screen.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/app_images/app_images.dart';
import 'package:graduation_project/home_screen/UI/Cart_Page/CartScreen.dart';
import 'package:graduation_project/Theme/style.dart';
import 'package:graduation_project/home_screen/UI/Home_Page/homevariables.dart';
import 'package:graduation_project/local_data/shared_preference.dart';
import '../../bloc/Cart/cart_bloc.dart';
import '../../bloc/Cart/cart_event.dart';
import '../../bloc/Cart/cart_state.dart';
import '../../data/repo/cart_repo.dart';

Widget homeTopBar(BuildContext context) {
  String greeting = getGreetingMessage();
  final int? userId = AppLocalStorage.getData('user_id');

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      InkWell(
        onTap: () {},
        overlayColor: WidgetStatePropertyAll(MyTheme.transparent),
        child: Icon(
          IconlyLight.notification,
          size: 24,
          color: MyTheme.mauveColor,
        ),
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
                    String displayName =
                        userId == null ? "" : (snapshot.data ?? "Guest");
                    return SizedBox(
                      width: 142,
                      child: Text(
                        displayName,
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
      BlocProvider(
        create: (context) => CartBloc(cartRepo: CartRepo())
          ..add(FetchCartEvent(userId: userId ?? 0)),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            int itemsCount = 0;
            if (state is FetchCartSuccessState && userId != null) {
              final cart = state.cartViewResponse;
              final restCafeItems = cart.restCafe?.datacart ?? [];
              final hotelTouristItems = cart.hotelTourist?.datacart ?? [];
              itemsCount = [...restCafeItems, ...hotelTouristItems].length;
            }
            return InkWell(
              onTap: () {
                if (userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please log in to view your cart')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                }
              },
              overlayColor: WidgetStatePropertyAll(MyTheme.transparent),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Icon(
                    IconlyLight.bag,
                    size: 24,
                    color: MyTheme.mauveColor,
                  ),
                  if (itemsCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 14.w,
                        height: 14.w,
                        decoration: BoxDecoration(
                          color: MyTheme.orangeColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: MyTheme.orangeColor.withOpacity(0.4),
                              blurRadius: 4.r,
                              spreadRadius: 1.r,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '$itemsCount',
                            style: TextStyle(
                              color: MyTheme.whiteColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
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

Widget horizontalList(List list) {
  final int? userId = AppLocalStorage.getData('user_id'); // جيب الـ userId
  return Container(
    height: 220,
    margin: const EdgeInsets.only(top: 10, left: 10),
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
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
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
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please log in to add to favorites')),
                              );
                            } else {
                              // منطق إضافة للمفضلة هنا
                              print("Added to favorites");
                            }
                          },
                          child: Image.asset(
                            AppImages.heart,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            if (userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please log in to add to cart')),
                              );
                            } else {
                              // منطق إضافة للعربة هنا
                              print("Added to cart");
                            }
                          },
                          child: Icon(
                            Icons.add_shopping_cart,
                            size: 20,
                            color: MyTheme.orangeColor,
                          ),
                        ),
                      ],
                    ),
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

Widget horizontalDishesList(List list) {
  return Container(
    height: 220,
    margin: const EdgeInsets.only(top: 10, left: 10),
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

Widget horizontalRestaurantList(List list) {
  return Container(
    height: 220,
    margin: const EdgeInsets.only(top: 10, left: 10),
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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
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
  final int? userId = AppLocalStorage.getData('user_id'); // جيب الـ userId
  return Padding(
    padding: const EdgeInsets.only(top: 10),
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
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
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
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please log in to add to favorites')),
                              );
                            } else {
                              // منطق إضافة للمفضلة هنا
                              print("Added to favorites");
                            }
                          },
                          child: Image.asset(
                            AppImages.heart,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            if (userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please log in to add to cart')),
                              );
                            } else {
                              // منطق إضافة للعربة هنا
                              print("Added to cart");
                            }
                          },
                          child: Icon(
                            Icons.add_shopping_cart,
                            size: 20,
                            color: MyTheme.orangeColor,
                          ),
                        ),
                      ],
                    ),
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
