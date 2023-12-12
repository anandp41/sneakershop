import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/support/brand_tile.dart';

class BrandListWidget extends StatelessWidget {
  const BrandListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SneakerShopProvider>(builder: (context, value, child) {
      if (value.brands.isEmpty) {
        value.getBrandData();

        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return ListView.builder(
            itemCount: value.brands.length,
            itemBuilder: (context, index) {
              String eachBrand = value.brands[index];
              return BrandTile(brand: eachBrand);
            });
      }
    });
  }
}
