import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/user/userappbar.dart';

import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/wishtile.dart';

class ScreenWishList extends StatelessWidget {
  const ScreenWishList({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const UserAppBar(
        text: 'WishList',
      ),
      backgroundColor: detailsDescriptionBackgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
            left: 8, right: 8, bottom: 10, top: screenSize.height / 9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<SneakerShopProvider>(
              builder: (context, provider, child) {
                if (provider.products.isEmpty) {
                  provider.getAllStock();
                  return Center(
                    child: LoadingAnimationWidget.halfTriangleDot(
                        color: Colors.white, size: 40),
                  );
                } else if (provider.brands.isEmpty) {
                  provider.getBrandData();
                  return Center(
                    child: LoadingAnimationWidget.halfTriangleDot(
                        color: Colors.white, size: 40),
                  );
                } else {
                  return Expanded(
                    child: GridView.builder(
                        padding: const EdgeInsets.all(0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            crossAxisCount: 1,
                            mainAxisExtent: screenSize.height / 6),
                        itemCount: provider.favshoes.length,
                        itemBuilder: (context, index) => WishListTile(
                              sneaker: provider.favshoes[index],
                            )),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
