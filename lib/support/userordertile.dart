import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sneaker_shop/db/dbhelper.dart';
import 'package:sneaker_shop/model/revenuemodel.dart';
import 'package:sneaker_shop/model/status_adapter.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/textstyles.dart';

// ignore: must_be_immutable
class UserOrderListTile extends StatelessWidget {
  final RevenueData revenueData;
  UserOrderListTile({super.key, required this.revenueData});
  String path = '';

  late String name;
  @override
  Widget build(BuildContext context) {
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

                          await updateStatus(
                              newStatus: Status.cancelled,
                              id: revenueData.transactionId);
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

    Future<void> loadImage() async {
      SneakerShopProvider provider = Provider.of(context, listen: false);

      path =
          await provider.getImagePathofThisId(sneakerId: revenueData.sneakerId);
    }

    Future<void> loadName() async {
      SneakerShopProvider provider = Provider.of(context, listen: false);
      name = await provider.getNameofThisId(sneakerId: revenueData.sneakerId);
    }

    Size contextSize = MediaQuery.of(context).size;
    return Consumer<SneakerShopProvider>(builder: (context, provider, child) {
      return GlassmorphicContainer(
        linearGradient: const LinearGradient(
          colors: [
            Color.fromRGBO(53, 63, 84, 1),
            Color.fromRGBO(53, 63, 84, 0)
          ],
          begin: AlignmentDirectional.topStart,
          end: Alignment.bottomRight,
        ),
        width: contextSize.width,
        height: contextSize.height,
        borderRadius: 20,
        border: 2,
        blur: 16,
        borderGradient: const LinearGradient(colors: [
          Color.fromRGBO(255, 255, 255, 0.25),
          Color.fromRGBO(0, 0, 0, 0.25)
        ]),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16.0, right: 16, top: 16, bottom: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                FutureBuilder(
                  future: loadName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(
                        name,
                        style: cartItemsNameTextStyle,
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      );
                    } else {
                      return Shimmer.fromColors(
                        period: const Duration(milliseconds: 1500),
                        baseColor: Colors.grey[500]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.black,
                          height: 25,
                          width: contextSize.width / 3,
                          padding: const EdgeInsets.all(16.0),
                        ),
                      );
                    }
                  },
                )
              ]),
              Row(
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 8, right: 8),
                            child: FutureBuilder(
                              future: loadImage(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (path != '') {
                                    return Image.network(
                                      path,
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
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Order Status: ${revenueData.orderStatus.toString().split('.').last.toUpperCase()}',
                            maxLines: 2,
                            style: revenueData.orderStatus == Status.cancelled
                                ? revenueTileOrderRedTextStyle
                                : revenueData.orderStatus == Status.delivered
                                    ? revenueTileOrderBlueTextStyle
                                    : revenueTileOrderGreenTextStyle),
                        Text(
                          'Size: ${revenueData.size}',
                          style: largeTileWhiteTextStyle,
                        ),
                        Text('Number: ${revenueData.number}',
                            style: largeTileWhiteTextStyle),
                        Text(
                          'Total: \u20B9 ${revenueData.amount}',
                          style: largeTileNonWhiteTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (revenueData.orderStatus != Status.cancelled &&
                            revenueData.orderStatus != Status.delivered)
                          ElevatedButton(
                            onPressed: () async {
                              destructiveOp(
                                  text: 'Confirm to cancel this order',
                                  affirmText: 'Yes',
                                  cancelText: 'No',
                                  context: context);
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.red)),
                            child: const Text(
                              'Cancel',
                              maxLines: 1,
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
