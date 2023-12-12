import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/support/largetile.dart';

class UserNewArrivalTilePanel extends StatelessWidget {
  const UserNewArrivalTilePanel({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<SneakerShopProvider>(builder: (context, provider, child) {
      if (provider.newProductsList.isEmpty) {
        provider.loadSortedProductsList();

        return const Center(child: CircularProgressIndicator());
      } else {
        return Container(
          height: size.height / 2.5,
          padding: const EdgeInsets.only(left: 16),
          child: GridView.builder(
              padding: const EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisExtent: size.width / 1.6,
                  maxCrossAxisExtent: size.height / 2.5,
                  mainAxisSpacing: 20),
              itemCount: provider.newProductsList.length,
              itemBuilder: (context, index) => ItemLargeTile(
                    screenSize: size,
                    sneaker: provider.newProductsList[index],
                  )),
        );
      }
    });
  }
}
