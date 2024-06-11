import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sneaker_shop/model/shoemodel.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';

import 'package:sneaker_shop/support/shoe_tile_inventory.dart';

class ShoesListWidget extends StatelessWidget {
  const ShoesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SneakerShopProvider>(builder: (context, provider, child) {
      //provider.products.clear();
      if (provider.products.isEmpty) {
        provider.getAllStock();

        return const Center(
            child: Text("Add inventory in the Add Sneakers page"));
      } else {
        return ListView.builder(
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              ShoeModel eachShoe = provider.products[index];
              debugPrint(
                  'shoelistwidget name and sizes${eachShoe.name} ${eachShoe.availableSizesandStock.length}');
              debugPrint(
                  'shoelistwidget name and images ${eachShoe.name} ${eachShoe.imagePath.length}');
              return InventoryShoeTile(shoe: eachShoe);
            });
      }
    });
  }
}
