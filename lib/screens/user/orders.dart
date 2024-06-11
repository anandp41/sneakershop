import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/user/userappbar.dart';

import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/userordertile.dart';

import '../../support/textstyles.dart';

class ScreenOrders extends StatelessWidget {
  const ScreenOrders({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const UserAppBar(
        text: 'Orders',
      ),
      backgroundColor: detailsDescriptionBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<SneakerShopProvider>(
              builder: (context, provider, child) {
                return Expanded(
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: provider.getUsersOrders(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Center(
                              child: LoadingAnimationWidget.halfTriangleDot(
                                  color: Colors.white, size: 40),
                            );
                          } else if (provider.orders.isEmpty) {
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
                                              screenSize.height / 4.6),
                                  itemCount: provider.orders.length,
                                  itemBuilder: (context, index) =>
                                      UserOrderListTile(
                                        revenueData: provider.orders[index],
                                      )),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
