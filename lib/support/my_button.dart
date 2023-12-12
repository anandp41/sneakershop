import 'package:flutter/material.dart';
import 'package:sneaker_shop/support/colors.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String data;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  const MyButton({
    super.key,
    required this.onPressed,
    required this.data,
    this.color = adminGridTileColor,
    this.textColor = Colors.white,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: color,
        ),
        width: width ?? screenWidth * 0.5,
        height: height ?? screenHeight * 0.07,
        margin: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        child: Text(
          data,
          style: TextStyle(
            color: textColor,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
