import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/textstyles.dart';

class FavIcon extends StatefulWidget {
  final String shoeId;
  final double iconSize;

  const FavIcon({
    super.key,
    required this.shoeId,
    required this.iconSize,
  });

  @override
  State<FavIcon> createState() => _FavIconState();
}

class _FavIconState extends State<FavIcon> {
  late bool isFavorite;
  late SneakerShopProvider provider;
  @override
  void initState() {
    provider = Provider.of<SneakerShopProvider>(context, listen: false);
    isFavorite = provider.isThisSneakerAFavorite(idToCheck: widget.shoeId);
    super.initState();
  }

  Future<void> toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });
    if (isFavorite) {
      await provider.addToFavList(idToAdd: widget.shoeId);
    } else {
      await provider.removeFromFavList(idToRemove: widget.shoeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          isFavorite
              ? await destructiveOp(
                  text: 'Remove from WishList ?',
                  affirmText: 'Yes',
                  cancelText: 'No',
                  context: context)
              : await toggleFavorite();
        },
        icon: isFavorite
            ? Icon(
                Icons.favorite,
                color: Colors.red,
                size: widget.iconSize,
              )
            : Icon(
                Icons.favorite_border_outlined,
                color: Colors.white38,
                size: widget.iconSize,
              ));
  }

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

                        toggleFavorite();
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
}
