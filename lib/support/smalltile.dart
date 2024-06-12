import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:sneaker_shop/model/shoemodel.dart';
import 'package:sneaker_shop/screens/user/details.dart';
import 'package:sneaker_shop/support/favicon.dart';

import 'package:sneaker_shop/support/textstyles.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class ItemSmallTile extends StatelessWidget {
  final Size screenSize;
  final ShoeModel sneaker;
  const ItemSmallTile(
      {super.key, required this.screenSize, required this.sneaker});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenDetails(sneaker: sneaker),
          )),
      child: CustomPaint(
        foregroundPainter: BorderPainter(),
        child: ClipPath(
          clipper: SmallTileCustomClipper(),
          child: GlassmorphicContainer(
            linearGradient: const LinearGradient(
              colors: [
                Color.fromRGBO(53, 63, 84, 1),
                Color.fromRGBO(53, 63, 84, 0)
              ],
              begin: AlignmentDirectional.topStart,
              end: Alignment.bottomRight,
            ),
            width: screenSize.width / 1.9,
            height: screenSize.height / 5,
            borderRadius: 0,
            border: 0,
            blur: 16,
            borderGradient: const LinearGradient(
                colors: [Colors.transparent, Colors.transparent]),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: FavIcon(
                        shoeId: sneaker.shoeId,
                        iconSize: screenSize.width / 11.5),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: 10, left: 8, right: 8),
                      child: sneaker.imagePath.isNotEmpty
                          ? Transform.rotate(
                              angle: -math.pi / 6.6,
                              child: Image.network(
                                sneaker.imagePath.first,
                                //height: widget.screenSize.height / 5,
                                width: screenSize.width,
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                              ))
                          : Image.asset(
                              'assets/images/na.png',
                              color: Colors.redAccent[100],
                              //height: widget.screenSize.height / 9.2,
                              width: screenSize.width / 1,
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.center,
                            ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sneaker.brand,
                        style: largeTileNonWhiteTextStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        sneaker.name,
                        style: largeTileWhiteTextStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        '\u20B9 ${sneaker.price}',
                        style: largeTileNonWhiteTextStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SmallTileCustomClipper extends CustomClipper<Path> {
  double cornerDepth = 20;
  @override
  getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.25);
    path.lineTo(0, size.height * 0.92);
    path.quadraticBezierTo(0, size.height, size.width * 0.08, size.height);
    path.lineTo(size.width * 0.92, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height * 0.92);
    path.lineTo(size.width, size.height * 0.08);
    path.quadraticBezierTo(size.width, 0, size.width * 0.92, 0);
    path.lineTo(size.width * 0.17, size.height * 0.13);
    path.quadraticBezierTo(0, size.height * 0.143, 0, size.height * 0.25);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      //..color = Colors.red // Border color
      ..style = PaintingStyle.stroke // Border style
      ..strokeWidth = 2 // Border width
      ..shader = ui.Gradient.linear(
          const Offset(15, 40), const Offset(180, 150), [
        const Color.fromRGBO(255, 255, 255, 0.25),
        const Color.fromRGBO(0, 0, 0, 0.25)
      ]);

    canvas.drawPath(
      SmallTileCustomClipper().getClip(size),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
