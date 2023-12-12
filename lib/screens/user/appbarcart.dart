import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/user/userdashboard.dart';

import 'package:sneaker_shop/support/colors.dart';

class AppBarCartIcon extends StatelessWidget {
  const AppBarCartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SneakerShopProvider>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScreenUserDashboard(sentIndex: 1),
                ));
          },
          child: Stack(
            children: [
              const Icon(
                Icons.shopping_cart_rounded,
                size: 35,
                color: Colors.white,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 22,
                  width: 22,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: appBarCartColor,
                  ),
                  child: Center(
                      child: Text(
                    provider.showCartcount().toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
