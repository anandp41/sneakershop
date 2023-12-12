import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/support/cartitemcountmanager.dart';
import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/textstyles.dart';

// ignore: must_be_immutable
class CartItemTile extends StatelessWidget {
  final Map<String, dynamic> cartItem;
  CartItemTile({super.key, required this.cartItem});

  late String? path;

  late String name;

  late double price;

  late bool stockNotSufficient;

  @override
  Widget build(BuildContext context) {
    Future<void> checkStockNotSufficient() async {
      SneakerShopProvider provider = Provider.of(context, listen: true);

      stockNotSufficient = await provider.stockNotSufficient(
          quantity: cartItem['Quantity'],
          sneakerId: cartItem['SneakerId'],
          size: cartItem['Size']);
    }

    Future<void> loadImage() async {
      SneakerShopProvider provider = Provider.of(context, listen: false);

      path =
          await provider.getImagePathofThisId(sneakerId: cartItem['SneakerId']);
    }

    Future<void> loadName() async {
      SneakerShopProvider provider = Provider.of(context, listen: false);
      name = await provider.getNameofThisId(sneakerId: cartItem['SneakerId']);
    }

    Future<void> loadPrice() async {
      SneakerShopProvider provider = Provider.of(context, listen: false);
      price =
          (await provider.getPriceofThisId(sneakerId: cartItem['SneakerId'])) *
              cartItem['Quantity'];
    }

    void delete() {
      SneakerShopProvider provider = Provider.of(context, listen: false);
      provider.removeFromCart(
          sneakerId: cartItem['SneakerId'], size: cartItem['Size']);
    }

    Size screenSize = MediaQuery.of(context).size;

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

                          delete();
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

    return Container(
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 3),
      height: screenSize.height / 8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Container(
              alignment: Alignment.center,
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  border: const GradientBoxBorder(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                        Color.fromRGBO(255, 255, 255, 0.2),
                        Color.fromRGBO(0, 0, 0, 0.2)
                      ])),
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(54, 62, 81, 1),
                        Color.fromRGBO(76, 87, 112, 1)
                      ])),
              child: FutureBuilder(
                future: loadImage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (path != null) {
                      return Image.file(
                        File(path!),
                        width: 75,
                        fit: BoxFit.scaleDown,
                        filterQuality: FilterQuality.high,
                      );
                    } else {
                      return Image.asset(
                        'assets/images/na.png',
                        width: 75,
                        fit: BoxFit.scaleDown,
                        filterQuality: FilterQuality.high,
                      );
                    }
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white12,
                    ));
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                bottom: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FutureBuilder(
                        future: loadName(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Expanded(
                              child: Text(
                                name,
                                style: cartItemsNameTextStyle,
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          } else {
                            return Shimmer.fromColors(
                              period: const Duration(milliseconds: 1500),
                              baseColor: Colors.grey[500]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.black,
                                height: 25,
                                width: screenSize.width / 3,
                                padding: const EdgeInsets.all(16.0),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Text(
                    'Size: ${cartItem['Size']}',
                    style: cartItemsNameTextStyle,
                  ),
                  FutureBuilder(
                    future: loadPrice(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(
                          '\u20B9 $price',
                          style: cartItemsPriceTextStyle,
                        );
                      } else {
                        return Shimmer.fromColors(
                          period: const Duration(milliseconds: 1500),
                          baseColor: Colors.grey[500]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.black,
                            height: 25,
                            width: screenSize.width / 3,
                            padding: const EdgeInsets.all(16.0),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    await destructiveOp(
                        text: 'Remove from cart?',
                        affirmText: 'Yes',
                        cancelText: 'No',
                        context: context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: cartItemCountManagerMinusDeleteBackground,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    ),
                  ),
                ),
                FutureBuilder(
                  future: checkStockNotSufficient(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (stockNotSufficient) {
                        return Text('Stock too few', style: noStockTextStyle);
                      } else {
                        return const Spacer();
                      }
                    } else {
                      return const Spacer();
                    }
                  },
                ),
                CartItemCountManager(
                  size: cartItem['Size'],
                  sneakerId: cartItem['SneakerId'],
                  quantity: cartItem['Quantity'],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
