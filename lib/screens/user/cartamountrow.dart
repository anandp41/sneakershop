import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/support/textstyles.dart';

class CartAmountRow extends StatefulWidget {
  const CartAmountRow({super.key});

  @override
  State<CartAmountRow> createState() => _CartAmountRowState();
}

class _CartAmountRowState extends State<CartAmountRow> {
  late double price;

  Future<void> loadCartAmount() async {
    SneakerShopProvider provider = Provider.of(context, listen: false);
    price = await provider.totalAmountDue();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SneakerShopProvider>(
        builder: (context, value, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: cartItemsBillTextStyle,
                ),
                FutureBuilder(
                    future: loadCartAmount(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(
                          '\u20B9 ${price.toString()}',
                          style: cartItemsBillCostTextStyle,
                        );
                      } else {
                        return Shimmer.fromColors(
                          period: const Duration(milliseconds: 1500),
                          baseColor: Colors.grey[500]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.black,
                            height: 25,
                            padding: const EdgeInsets.all(16.0),
                          ),
                        );
                      }
                    })
              ],
            ));
  }
}
