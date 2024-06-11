import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/bottomnavbarprovider.dart';

class BottomShopNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  const BottomShopNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    Provider.of<BottomNavBarProvider>(context, listen: false).currentIndex =
        currentIndex;
    return CustomPaint(
      painter: BorderPainter(),
      child: ClipPath(
        clipBehavior: Clip.hardEdge,
        clipper: BottomNavBarClipper(),
        child: GlassmorphicContainer(
          borderGradient: const LinearGradient(
              colors: [Colors.transparent, Colors.transparent]),
          border: 0,
          linearGradient: const LinearGradient(
              colors: [Colors.transparent, Colors.transparent]),
          borderRadius: 0,
          height: screenSize.height / 9,
          width: screenSize.width,
          blur: 100,
          child: GNav(
              tabShadow: const [
                //BoxShadow(blurRadius: 10)
              ],
              selectedIndex:
                  Provider.of<BottomNavBarProvider>(context, listen: false)
                      .currentIndex,
              onTabChange: (index) => onTap(index),
              backgroundColor: const ui.Color.fromARGB(10, 53, 51, 181),
              mainAxisAlignment: MainAxisAlignment.center,
              tabMargin:
                  const EdgeInsets.only(top: 20, bottom: 5, right: 4, left: 4),
              tabBackgroundGradient: const LinearGradient(colors: [
                Color.fromRGBO(52, 200, 232, 1),
                Color.fromRGBO(78, 74, 242, 1)
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              tabBorderRadius: 15,
              color: Colors.white.withOpacity(0.7), // unselected icon color
              activeColor: Colors.white, // selected icon and text color
              iconSize: 35, // tab button icon size
              curve: Curves.linear,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 18), // navigation bar padding

              tabs: const [
                GButton(
                  icon: Icons.home_filled,
                  iconSize: 35,
                ),
                GButton(
                  icon: Icons.shopping_cart_outlined,
                  iconSize: 35,
                ),
                GButton(
                  icon: Icons.person,
                  iconSize: 35,
                )
              ]),
        ),
      ),
    );
  }
}

class BottomNavBarClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.22);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      // ..color = Colors.red // Border color
      ..style = PaintingStyle.stroke // Border style
      ..strokeWidth = 2 // Border width
      ..shader = ui.Gradient.linear(
          const Offset(50, 0), const Offset(50, 400), [
        const Color.fromRGBO(255, 255, 255, 0.1),
        const Color.fromRGBO(0, 0, 0, 0)
      ]);

    canvas.drawPath(
      BottomNavBarClipper().getClip(size),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
