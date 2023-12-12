import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/support/textstyles.dart';

// ignore: must_be_immutable
class SizeTile extends StatelessWidget {
  final Map<String, dynamic> size;
  SizeTile({super.key, required this.size});
  bool isThisSelected = false;
  @override
  Widget build(BuildContext context) {
    bool available = size['Stock'] as int > 0;
    return Consumer<SneakerShopProvider>(builder: (context, provider, child) {
      if (provider.selectedSize == size['Size']) {
        isThisSelected = true;
      } else {
        isThisSelected = false;
      }

      return InkWell(
        onTap: () {
          if (available) {
            provider.setSelectedSize(size: size['Size']);
          }
        },
        child: Container(
          foregroundDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: available
                  ? Colors.transparent
                  : Colors.grey.withOpacity(0.7)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isThisSelected
                ? Border.all(
                    width: 5, color: const Color.fromARGB(208, 3, 61, 109))
                : null,
            color: const Color.fromARGB(255, 233, 230, 233),
          ),
          child: Align(
              alignment: Alignment.center,
              child: Text(
                'UK${size['Size']}',
                style: sizeTileTextStyle,
              )),
        ),
      );
    });
  }
}
