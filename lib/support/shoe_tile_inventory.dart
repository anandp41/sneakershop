import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/db/dbhelper.dart';

import 'package:sneaker_shop/model/shoemodel.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/admin/editsneaker.dart';

import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/shoetileimagespanel.dart';
import 'package:sneaker_shop/support/shoetilesizespanel.dart';
import 'package:sneaker_shop/support/textstyles.dart';

class InventoryShoeTile extends StatelessWidget {
  final ShoeModel shoe;
  const InventoryShoeTile({super.key, required this.shoe});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: brandTileBackground,
      ),
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: shoe.isNew ? Colors.green : Colors.red),
                child: shoe.isNew
                    ? Text(
                        'New Product',
                        style: largeTileWhiteTextStyle,
                      )
                    : Text(
                        'Old Product',
                        style: largeTileWhiteTextStyle,
                      ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ScreenEditSneaker(sneaker: shoe),
                        )),
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white60),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width / 30,
                  ),
                  InkWell(
                    onTap: () async {
                      await deleteSneaker(
                          productId: shoe.shoeId, context: context);
                    },
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
                  )
                ],
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Sneaker ID:',
                style: largeTileWhiteTextStyle,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                shoe.shoeId.toString(),
                style: largeTileWhiteTextStyle,
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Sneaker Name:',
                style: largeTileWhiteTextStyle,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                shoe.name,
                style: largeTileWhiteTextStyle,
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Sneaker Price:',
                style: largeTileWhiteTextStyle,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                shoe.price.toString(),
                style: largeTileWhiteTextStyle,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Sneaker Brand:',
                style: largeTileWhiteTextStyle,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                shoe.brand,
                style: largeTileWhiteTextStyle,
              ),
            ],
          ),
          Text(
            'Images: ${shoe.imagePath.length}',
            style: largeTileWhiteTextStyle,
          ),
          AdminShoeTileImagesPanel(imagePaths: shoe.imagePath),
          Text(
            'Sizes: ${shoe.availableSizesandStock.length}',
            style: largeTileWhiteTextStyle,
          ),
          SizedBox(
              height: 52,
              child: AdminShoeTileSizesPanel(
                  availableSizesandStock: shoe.availableSizesandStock))
        ],
      ),
    );
  }
}

Future<void> deleteSneaker(
    {required String productId, required BuildContext context}) async {
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
              'Delete sneaker from stock?',
              style: largeTileWhiteTextStyle,
            ),
          ],
        )),
        contentPadding: const EdgeInsets.all(10),
        backgroundColor: const Color.fromARGB(249, 48, 35, 235),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  await deleteSneakerFromDb(sneakerId: productId);
                  value.getAllStock();
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
    ),
  );
}
