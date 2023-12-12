import 'package:flutter/material.dart';
import 'package:sneaker_shop/screens/user/cart.dart';
import 'package:sneaker_shop/screens/user/home.dart';
import 'package:sneaker_shop/screens/user/userprofile.dart';

import 'package:sneaker_shop/support/bottomnavbar.dart';

// ignore: must_be_immutable
class ScreenUserDashboard extends StatefulWidget {
  int sentIndex;
  ScreenUserDashboard({super.key, this.sentIndex = 0});

  @override
  State<ScreenUserDashboard> createState() => _ScreenUserDashboardState();
}

class _ScreenUserDashboardState extends State<ScreenUserDashboard> {
  List pages = [const ScreenHome(), ScreenCart(), const ScreenUserProfile()];
  late int selectedIndex;
  @override
  void initState() {
    selectedIndex = widget.sentIndex;
    super.initState();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: pages[selectedIndex],
      bottomNavigationBar: BottomShopNavBar(
          currentIndex: selectedIndex,
          onTap: (currentIndex) {
            onItemTapped(currentIndex);
          }),
    );
  }
}
