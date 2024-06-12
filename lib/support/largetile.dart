import 'package:flutter/material.dart';
import 'package:sneaker_shop/model/shoemodel.dart';
import 'package:sneaker_shop/screens/user/details.dart';
import 'package:sneaker_shop/support/favicon.dart';

import 'package:sneaker_shop/support/textstyles.dart';
import 'dart:math' as math;
import 'package:glassmorphism/glassmorphism.dart';
import 'dart:ui' as ui;

class ItemLargeTile extends StatelessWidget {
  final Size screenSize;
  final ShoeModel sneaker;
  const ItemLargeTile(
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
          clipper: LargeTileCustomClipper(),
          child: GlassmorphicContainer(
            linearGradient: const LinearGradient(
              colors: [
                Color.fromRGBO(53, 63, 84, 1),
                Color.fromRGBO(53, 63, 84, 0)
              ],
              begin: AlignmentDirectional.topStart,
              end: Alignment.bottomRight,
            ),
            width: screenSize.width / 1.75,
            height: screenSize.height / 2.5,
            borderRadius: 0,
            border: 0,
            blur: 16,
            borderGradient: const LinearGradient(
                colors: [Colors.transparent, Colors.transparent]),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, right: 16),
                      child: SizedBox(
                        width: screenSize.width / 2.8,
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
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '\u20B9 ${sneaker.price}',
                              style: largeTileNonWhiteTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: FavIcon(
                          shoeId: sneaker.shoeId,
                          iconSize: screenSize.width / 10),
                    )
                  ],
                ),
                Expanded(
                  child: sneaker.imagePath.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(
                              bottom: 80, left: 10, right: 10),
                          child: Transform.rotate(
                            angle: -math.pi / 6.6,
                            child: Image.network(
                              sneaker.imagePath.first,
                              width: screenSize.width,
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.center,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 80),
                          child: Image.asset(
                            'assets/images/na.png',
                            color: Colors.redAccent[100],
                            width: screenSize.width,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LargeTileCustomClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.08);
    path.lineTo(0, size.height * 0.9);
    path.quadraticBezierTo(
        0, size.height, size.width * 0.18, size.height * 0.95);

    path.lineTo(size.width * 0.9, size.height * 0.8);
    path.quadraticBezierTo(
        size.width, size.height * 0.78, size.width, size.height * 0.65);

    path.lineTo(size.width, size.height * 0.08);
    path.quadraticBezierTo(size.width, 0, size.width * 0.87, 0);
    path.lineTo(size.width * 0.13, 0);
    path.quadraticBezierTo(0, 0, 0, size.height * 0.08);
    path.lineTo(0, size.height * 0.08);
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
      // ..color = Colors.red // Border color
      ..style = PaintingStyle.stroke // Border style
      ..strokeWidth = 2 // Border width
      ..shader = ui.Gradient.linear(
          const Offset(35, 60), const Offset(160, 160), [
        const Color.fromRGBO(255, 255, 255, 0.25),
        const Color.fromRGBO(0, 0, 0, 0.25)
      ]);

    canvas.drawPath(
      LargeTileCustomClipper().getClip(size),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
