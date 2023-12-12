import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glassmorphism/glassmorphism.dart';

import 'package:sneaker_shop/screens/user/appbarcart.dart';
import 'package:sneaker_shop/screens/user/userhomenewlargetilepanel.dart';
import 'package:sneaker_shop/screens/user/userhomeoldsmalltilepanel.dart';

import 'package:sneaker_shop/support/textstyles.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(children: [
        SvgPicture.asset(
          'assets/images/bg.svg',
          // width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Arrivals',
                      style: topHeadingStyle,
                    ),
                    const AppBarCartIcon()
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                  height: screenSize.height / 2.5,
                  child: const UserNewArrivalTilePanel()),
              const SizedBox(
                height: 20,
              ),
              GlassmorphicContainer(
                  width: screenSize.width,
                  height: screenSize.height / 38,
                  borderRadius: 0,
                  linearGradient: const LinearGradient(
                      colors: [Colors.transparent, Colors.white12]),
                  border: 0,
                  blur: 40,
                  borderGradient: const LinearGradient(
                      colors: [Colors.transparent, Colors.transparent])),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                  height: screenSize.height / 3.3,
                  child: const UserOldSmallTilePanel())
            ],
          ),
        ),
      ]),
    );
  }
}
