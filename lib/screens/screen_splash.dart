import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/WelcomeScreen.dart';

import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/constants.dart';

import '../main.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    super.initState();
    checkAdminLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/splash.svg',
            height: double.infinity,
            fit: BoxFit.fill,
          ),
          Positioned(
              bottom: screenSize.height / 4,
              right: 0.0,
              left: 0.0,
              child: LoadingAnimationWidget.halfTriangleDot(
                  color: Colors.white, size: 40))
        ],
      ),
      backgroundColor: adminGridTileColor,
    );
  }

  void gotoUserLogin() async {
    //Navigator.pushReplacementNamed(context, '/userlogin');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => const WelcomeScreen()));
  }

  void gotoUserHome() {
    Navigator.pushReplacementNamed(context, '/userdashboard');
  }

  void gotoAdminHome() {
    Navigator.pushReplacementNamed(context, '/admindashboard');
  }

  Future<void> checkAdminLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    await SharedPreferences.getInstance().then((sharedPref) async {
      final adminLoginStatus = sharedPref.getBool(adminLogStatus);
      final userLoginStatus = sharedPref.getBool(userLogStatus);
      final loggedInUserEmail = sharedPref.getString(loggedInUserString);
      if (adminLoginStatus == null || adminLoginStatus == false) {
        if (userLoginStatus == null || userLoginStatus == false) {
          gotoUserLogin();
        } else {
          await Provider.of<SneakerShopProvider>(context, listen: false)
              .loadUser(email: loggedInUserEmail!);
          gotoUserHome();
        }
      } else {
        gotoAdminHome();
      }
    });
  }
}
