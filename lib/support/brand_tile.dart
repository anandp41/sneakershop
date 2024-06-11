import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/db/dbhelper.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/textstyles.dart';

class BrandTile extends StatelessWidget {
  final String brand;

  const BrandTile({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: brandTileBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Brand name: $brand',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          Row(
            children: [
              // InkWell(
              //   child: Container(
              //     decoration: const BoxDecoration(
              //         shape: BoxShape.circle, color: Colors.white60),
              //     child: const Padding(
              //       padding: EdgeInsets.all(8.0),
              //       child: Icon(
              //         Icons.edit,
              //         color: Colors.black,
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   width: screenSize.width / 30,
              // ),
              InkWell(
                onTap: () => deleteBrand(brand: brand, context: context),
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white60),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

void deleteBrand({required String brand, required BuildContext context}) {
  void showDeletedCustomSnackBar({required String name}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted brand: $name'),
        backgroundColor: Colors.green,
        margin: const EdgeInsets.all(10),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  showDialog(
      context: context,
      builder: (ctx) => Consumer<SneakerShopProvider>(
            builder: (context, value, child) => AlertDialog(
              alignment: Alignment.center,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              title: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LineIcon.trash(
                    size: 40,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  Text(
                    'Delete brand from stock?',
                    style: largeTileWhiteTextStyle,
                  ),
                ],
              )),
              backgroundColor: const Color.fromARGB(249, 48, 35, 235),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        await deleteBrandFromDb(name: brand);
                        value.getBrandData();
                        showDeletedCustomSnackBar(name: brand);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.red.shade500,
                        margin: const EdgeInsets.all(10),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Delete',
                            style: TextStyle(
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
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
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
              ],
            ),
          ));
}
