import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:sneaker_shop/model/shoemodel.dart';

import 'package:sneaker_shop/screens/user/details.dart';
import 'package:sneaker_shop/support/favicon.dart';
// import 'package:sneaker_shop/support/destructiveop.dart';
import 'package:sneaker_shop/support/textstyles.dart';
import 'dart:math' as math;

class WishListTile extends StatelessWidget {
  final ShoeModel sneaker;
  const WishListTile({super.key, required this.sneaker});

  @override
  Widget build(BuildContext context) {
    Size contextSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenDetails(sneaker: sneaker),
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
          child: Row(
            //mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
                  child: sneaker.imagePath.isNotEmpty
                      ? Transform.rotate(
                          angle: -math.pi / 6.6,
                          child: Image.file(
                            File(sneaker.imagePath.first),
                            height: contextSize.height / 9.2,
                            // width: screenSize.width / 1,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                          ))
                      : Image.asset(
                          'assets/images/na.png',
                          color: Colors.redAccent[100],
                          height: contextSize.height / 9.2,
                          // width: screenSize.width / 1,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sneaker.brand,
                      style: largeTileNonWhiteTextStyle,
                    ),
                    Text(
                      sneaker.name,
                      style: largeTileWhiteTextStyle,
                    ),
                    Text(
                      '\u20B9 ${sneaker.price}',
                      style: largeTileNonWhiteTextStyle,
                    ),
                  ],
                ),
              ),
              FavIcon(
                  shoeId: sneaker.shoeId!, iconSize: contextSize.width / 11.5)
            ],
          ),
        ),
      ),
    );
  }
}
