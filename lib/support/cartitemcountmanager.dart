import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:gradient_elevated_button/button_style.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/textstyles.dart';

class CartItemCountManager extends StatelessWidget {
  final int sneakerId;
  final int size;
  final int quantity;
  const CartItemCountManager(
      {super.key,
      required this.quantity,
      required this.sneakerId,
      required this.size});

  @override
  Widget build(BuildContext context) {
    void showCustomSnackBarFail(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.orange[500],
          margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Colors.black38,
                blurRadius: 0.5,
                offset: Offset(0, 3),
                inset: true),
            BoxShadow(
                color: Colors.white24,
                blurRadius: 1,
                offset: Offset(0, -3),
                inset: true)
          ]),
      padding: const EdgeInsets.all(2),
      child: Row(children: [
        InkWell(
          onTap: () {
            Provider.of<SneakerShopProvider>(context, listen: false)
                .decrementASneakerCountInCart(sneakerId: sneakerId, size: size);
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: cartItemCountManagerMinusDeleteBackground,
                borderRadius: BorderRadius.circular(10)),
            height: 30,
            width: 30,
            child: const LineIcon.minus(
              size: 15,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 30,
          height: 30,
          child: Center(
            child: Text(
              quantity.toString(),
              style: cartItemsCountManagerNumberTextStyle,
            ),
          ),
        ),
        SizedBox(
          width: 30,
          height: 30,
          child: GradientElevatedButton(
            style: const GradientButtonStyle(
                alignment: Alignment.center,
                padding: MaterialStatePropertyAll(EdgeInsets.zero),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(52, 200, 232, 1),
                  Color.fromRGBO(78, 74, 242, 1)
                ])),
            onPressed: () async {
              await Provider.of<SneakerShopProvider>(context, listen: false)
                  .stockLimitReached(
                      sneakerId: sneakerId,
                      size: size,
                      currentCartQuantity: quantity)
                  .then((result) {
                if (result == true) {
                  showCustomSnackBarFail('Stock limit reached !');
                } else {
                  Provider.of<SneakerShopProvider>(context, listen: false)
                      .incrementASneakerCountInCart(
                          sneakerId: sneakerId, size: size);
                }
              });
            },
            child: const LineIcon.plus(
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}
