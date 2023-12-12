import 'package:flutter/material.dart';
import 'package:sneaker_shop/screens/user/appbarcart.dart';

import 'package:sneaker_shop/support/appbarbackbutton.dart';
import 'package:sneaker_shop/support/textstyles.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  final List<Widget> otherActions;
  const UserAppBar(
      {super.key, required this.text, this.otherActions = const []});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size(0, 80),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 20,
            right: 20,
          ),
          child: AppBar(
              clipBehavior: Clip.none,
              toolbarHeight: 50,
              leadingWidth: 50,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const AppBarBackButton(),
              centerTitle: true,
              title: Text(
                text,
                style: topHeadingStyle,
              ),
              actions: [
                ...otherActions,
                const AppBarCartIcon(),
              ]),
        ));
  }

  @override
  Size get preferredSize => const Size(0, 80);
}
