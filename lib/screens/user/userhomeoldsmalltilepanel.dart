import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/support/smalltile.dart';
import 'package:sneaker_shop/support/textstyles.dart';

class UserOldSmallTilePanel extends StatelessWidget {
  const UserOldSmallTilePanel({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<SneakerShopProvider>(builder: (context, provider, child) {
      List<dynamic> tilesInBottomPanel = [];

      for (int i = 0;
          i <
              (provider.oldProductsList.length <= 4
                  ? provider.oldProductsList.length
                  : 4);
          i++) {
        tilesInBottomPanel.add(ItemSmallTile(
          screenSize: size,
          sneaker: provider.oldProductsList[i],
        ));
      }

      tilesInBottomPanel.add(
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: size.width / 15, vertical: size.height / 15),
          child: Container(
            decoration: const BoxDecoration(shape: BoxShape.circle),
            clipBehavior: Clip.hardEdge,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent.withOpacity(0.3),
                  shape: const CircleBorder(
                      side: BorderSide(
                    width: 2,
                    color: Colors.white10,
                  )),
                  minimumSize: Size(
                    size.width / 10,
                    size.height / 10,
                  ),
                  fixedSize: const Size(double.infinity, double.infinity)),
              onPressed: () {
                Navigator.pushNamed(context, '/allitems');
              },
              child: Text('See More', style: bannerTileWhiteTextStyle),
            ),
          ),
        ),
      );

      if (provider.oldProductsList.isEmpty) {
        provider.loadSortedProductsList();

        return const Center(child: CircularProgressIndicator());
      } else {
        return Container(
            height: size.height / 3.3,
            padding: const EdgeInsets.only(left: 16),
            child: GridView.builder(
              padding: const EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisExtent: size.width / 2,
                  maxCrossAxisExtent: size.height / 3,
                  mainAxisSpacing: 20),
              itemCount: tilesInBottomPanel.length,
              itemBuilder: (context, index) => tilesInBottomPanel[index],
            ));
      }
    });
  }
}
