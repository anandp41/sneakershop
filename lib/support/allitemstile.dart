import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/model/shoemodel.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';

import 'package:sneaker_shop/screens/user/details.dart';
import 'package:sneaker_shop/support/textstyles.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class AllItemsTile extends StatefulWidget {
  final ShoeModel sneaker;
  const AllItemsTile({super.key, required this.sneaker});

  @override
  State<AllItemsTile> createState() => _AllItemsTileState();
}

class _AllItemsTileState extends State<AllItemsTile> {
  late bool isFavorite;
  late SneakerShopProvider provider;
  @override
  void initState() {
    provider = Provider.of<SneakerShopProvider>(context, listen: false);
    isFavorite =
        provider.isThisSneakerAFavorite(idToCheck: widget.sneaker.shoeId!);
    super.initState();
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    if (isFavorite) {
      provider.addToFavList(idToAdd: widget.sneaker.shoeId!);
    } else {
      provider.removeFromFavList(idToRemove: widget.sneaker.shoeId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size contextSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenDetails(sneaker: widget.sneaker),
          )),
      child: GlassmorphicContainer(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: isFavorite
                      ? (bounds) {
                          return ui.Gradient.linear(
                              const Offset(10.0, 21.0),
                              const Offset(23.0, 25.0),
                              [Colors.transparent, Colors.transparent]);
                        }
                      : (bounds) {
                          return ui.Gradient.linear(const Offset(12.0, 17.0),
                              const Offset(35.0, 25.0), [
                            const Color.fromRGBO(52, 202, 232, 1),
                            const Color.fromRGBO(78, 73, 242, 1)
                          ]);
                        },
                  child: IconButton(
                      onPressed: () {
                        toggleFavorite();
                      },
                      icon: isFavorite
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: contextSize.width / 11.5,
                            )
                          : Icon(
                              Icons.favorite_border_outlined,
                              size: contextSize.width / 11.5,
                            )),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
                  child: widget.sneaker.imagePath.isNotEmpty
                      ? Transform.rotate(
                          angle: -math.pi / 6.6,
                          child: Image.file(
                            File(widget.sneaker.imagePath.first),
                            //  height: contextSize.height / 9.2,
                            //width: screenSize.width / 1,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                          ))
                      : Image.asset(
                          'assets/images/na.png',
                          color: Colors.redAccent[100],
                          //height: contextSize.height / 9.2,
                          // width: screenSize.width / 1,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sneaker.brand,
                    style: largeTileNonWhiteTextStyle,
                  ),
                  Text(
                    widget.sneaker.name,
                    style: largeTileWhiteTextStyle,
                  ),
                  Text(
                    '\u20B9 ${widget.sneaker.price}',
                    style: largeTileNonWhiteTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
