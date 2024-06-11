import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/user/userappbar.dart';

import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/wishtile.dart';

import '../../support/textstyles.dart';

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
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<SneakerShopProvider>(
              builder: (context, provider, child) {
                return FutureBuilder(
                  future: provider.getAllStockForWishList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (provider.products.isEmpty) {
                        return Center(
                          child: Text(
                            "No data found",
                            style: topHeadingStyle,
                          ),
                        );
                      } else {
                        return FutureBuilder(
                          future: provider.getBrandDataForWishList(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (provider.brands.isEmpty) {
                                return Center(
                                  child: Text(
                                    "No data found",
                                    style: topHeadingStyle,
                                  ),
                                );
                              } else {
                                return Expanded(
                                  child: GridView.builder(
                                      padding: const EdgeInsets.all(0),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                              crossAxisCount: 1,
                                              mainAxisExtent:
                                                  screenSize.height / 6),
                                      itemCount:
                                          provider.currentUser!.favList.length,
                                      itemBuilder: (context, index) {
                                        var shoe =
                                            provider.returnShoeFromProductsList(
                                                shoeId: provider.currentUser!
                                                    .favList[index]);
                                        return WishListTile(
                                          sneaker: shoe,
                                        );
                                      }),
                                );
                              }
                            } else {
                              return Center(
                                child: LoadingAnimationWidget.halfTriangleDot(
                                    color: Colors.white, size: 40),
                              );
                            }
                          },
                        );
                      }
                    } else {
                      return Center(
                        child: LoadingAnimationWidget.halfTriangleDot(
                            color: Colors.white, size: 40),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
