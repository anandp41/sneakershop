import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/textstyles.dart';

import '../../main.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLogOut;
  final String title;
  const AdminAppBar({super.key, required this.title, this.showLogOut = true});

  @override
  Widget build(BuildContext context) {
    //Size screenSize = MediaQuery.of(context).size;

    Future<void> adminLogout() async {
      Navigator.pushNamedAndRemoveUntil(
          context, '/userlogin', (route) => false);

      final sharedPref = await SharedPreferences.getInstance();
      sharedPref.setBool(adminLogStatus, false);
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

                          await adminLogout();
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

    return AppBar(
      forceMaterialTransparency: true,
      actions: showLogOut
          ? [
              ElevatedButton.icon(
                  style: const ButtonStyle(
                      shadowColor: MaterialStatePropertyAll(Colors.black),
                      // fixedSize: MaterialStatePropertyAll(
                      //     Size(screenSize.width / 3.9, screenSize.height / 10)),
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(210, 4, 52, 92))),
                  label: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    LineIcons.alternateSignOut,
                    color: Colors.redAccent,
                  ),
                  onPressed: () async {
                    await destructiveOp(
                        text: 'Are you sure you want to logout?',
                        affirmText: 'Yes',
                        cancelText: 'No',
                        context: context);
                  }),
            ]
          : null,
      //backgroundColor: Color.fromARGB(233, 5, 63, 114),
      elevation: 10,
      title: Text(
        title,
        style: adminTopHeadingStyle,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size(0, 56);
}
