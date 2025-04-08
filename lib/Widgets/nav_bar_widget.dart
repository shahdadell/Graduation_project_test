import 'package:flutter/material.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/home_screen/UI/Home_Page/home_screen.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key, this.preIndex});
  final int? preIndex;

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    currentPage = widget.preIndex ?? 0;
  }

  List<Widget> pages = [
    const HomeScreen(),
    // const WishlistScreen(),
    // const CartScreen(),
    // const ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: MyTheme.whiteColor,
          selectedItemColor: MyTheme.orangeColor,
          unselectedItemColor: MyTheme.blackColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentPage,
          onTap: (index) {
            setState(() {
              currentPage = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favorite'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Order'),
            BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard), label: 'Reward'),
          ]),
    );
  }
}
