import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/main.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/user/appinfo.dart';
import 'package:sneaker_shop/screens/user/orders.dart';
import 'package:sneaker_shop/screens/user/privpolicy.dart';
import 'package:sneaker_shop/screens/user/userchangepw.dart';
import 'package:sneaker_shop/screens/user/usereditprofile.dart';
import 'package:sneaker_shop/screens/user/wishlist.dart';

import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/constants.dart';
import 'package:sneaker_shop/support/my_button.dart';
import 'package:sneaker_shop/support/textstyles.dart';

class ScreenUserProfile extends StatelessWidget {
  const ScreenUserProfile({super.key});
  @override
  Widget build(BuildContext context) {
    Future<void> logOut() async {
      Navigator.pushNamedAndRemoveUntil(
          context, '/userlogin', (route) => false);

      await SharedPreferences.getInstance().then((sharedPref) {
        sharedPref.setBool(userLogStatus, false);
        sharedPref.remove(loggedInUserString);
      });
    }

    Future<void> destructiveOp({
      required String text,
      required String affirmText,
      required String cancelText,
      required BuildContext context,
    }) async {
      showDialog(
          context: context,
          builder: (context1) {
            return AlertDialog(
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                title: Center(
                    child: Text(
                  text,
                  style: largeTileWhiteTextStyle,
                )),
                contentPadding: const EdgeInsets.all(10),
                backgroundColor: const Color.fromARGB(249, 48, 35, 235),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          Navigator.pop(context1);

                          await logOut();
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.red.shade500,
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              affirmText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: adminGridTileColor,
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              cancelText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ]);
          });
    }

    return Consumer<SneakerShopProvider>(
      builder: (context, provider, child) => Scaffold(
        backgroundColor: detailsDescriptionBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // leading: const CircleAvatar(
          //   backgroundImage: AssetImage('assets/images/circle_avatar.png'),
          // ),
          title: Text(
            'Hi ${provider.currentUser!.name}',
            style: bannerTileWhiteTextStyle,
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 4, color: Colors.blueAccent)),
                          child: CircleAvatar(
                            backgroundImage:
                                provider.currentUser!.imagePath != null
                                    ? FileImage(
                                        File(provider.currentUser!.imagePath!),
                                        // filterQuality: FilterQuality.high,
                                        // fit: BoxFit.scaleDown,
                                      ) as ImageProvider
                                    : const AssetImage('assets/images/def.png'),
                            radius: 80,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserEditProfile(
                                    user: provider.currentUser!),
                              ));
                        },
                        child: GlassmorphicContainer(
                          width: double.infinity,
                          height: 60,
                          borderRadius: 12,
                          blur: 10,
                          alignment: Alignment.center,
                          border: 2,
                          linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white12.withOpacity(0.1),
                            ],
                          ),
                          borderGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white24.withOpacity(0.2),
                              Colors.white38.withOpacity(0.1),
                            ],
                          ),
                          child: Text(
                            'Edit Profile',
                            style: bannerTileWhiteTextStyle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ScreenUserChangePw(),
                              ));
                        },
                        child: GlassmorphicContainer(
                          width: double.infinity,
                          height: 60,
                          borderRadius: 12,
                          blur: 10,
                          alignment: Alignment.center,
                          border: 2,
                          linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white12.withOpacity(0.1),
                            ],
                          ),
                          borderGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white24.withOpacity(0.2),
                              Colors.white38.withOpacity(0.1),
                            ],
                          ),
                          child: Text(
                            'Change Password',
                            style: bannerTileWhiteTextStyle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScreenOrders(),
                              ));
                        },
                        child: GlassmorphicContainer(
                          width: double.infinity,
                          height: 60,
                          borderRadius: 12,
                          blur: 10,
                          alignment: Alignment.center,
                          border: 2,
                          linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white12.withOpacity(0.1),
                            ],
                          ),
                          borderGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white24.withOpacity(0.2),
                              Colors.white38.withOpacity(0.1),
                            ],
                          ),
                          child: Text(
                            'Orders',
                            style: bannerTileWhiteTextStyle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScreenWishList(),
                              ));
                        },
                        child: GlassmorphicContainer(
                          width: double.infinity,
                          height: 60,
                          borderRadius: 12,
                          blur: 10,
                          alignment: Alignment.center,
                          border: 2,
                          linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white12.withOpacity(0.1),
                            ],
                          ),
                          borderGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white24.withOpacity(0.2),
                              Colors.white38.withOpacity(0.1),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.favorite_sharp,
                                color: Colors.red,
                              ),
                              Text(
                                'WishList',
                                style: bannerTileWhiteTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ScreenPrivacyPolicy(),
                              ));
                        },
                        child: GlassmorphicContainer(
                          width: double.infinity,
                          height: 60,
                          borderRadius: 12,
                          blur: 10,
                          alignment: Alignment.center,
                          border: 2,
                          linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white12.withOpacity(0.1),
                            ],
                          ),
                          borderGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white24.withOpacity(0.2),
                              Colors.white38.withOpacity(0.1),
                            ],
                          ),
                          child: Text(
                            'Privacy Policy',
                            style: bannerTileWhiteTextStyle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScreenAppInfo(),
                              ));
                        },
                        child: GlassmorphicContainer(
                          width: double.infinity,
                          height: 60,
                          borderRadius: 12,
                          blur: 10,
                          alignment: Alignment.center,
                          border: 2,
                          linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white12.withOpacity(0.1),
                            ],
                          ),
                          borderGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white24.withOpacity(0.2),
                              Colors.white38.withOpacity(0.1),
                            ],
                          ),
                          child: Text(
                            'App Info',
                            style: bannerTileWhiteTextStyle,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              MyButton(
                  width: double.infinity,
                  color: const Color.fromARGB(255, 93, 90, 90),
                  onPressed: () async {
                    await destructiveOp(
                        text: 'Are you sure you want to logout?',
                        affirmText: 'Yes',
                        cancelText: 'No',
                        context: context);
                  },
                  data: 'Log Out')
            ],
          ),
        )),
      ),
    );
  }
}
