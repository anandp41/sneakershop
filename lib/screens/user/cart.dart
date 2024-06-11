import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';

import 'package:sneaker_shop/screens/user/cartamountrow.dart';

import 'package:sneaker_shop/support/appbars/cartappbar.dart';
import 'package:sneaker_shop/screens/user/cartitemtile.dart';
import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/textstyles.dart';

class ScreenCart extends StatelessWidget {
  ScreenCart({
    super.key,
  });
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Consumer<SneakerShopProvider>(
      builder: (context, provider, child) {
        bool isAddOn = false;
        Future<void> loadButtonStatus() async {
          isAddOn = await provider.isAddButtonOn();
        }

        return Scaffold(
            backgroundColor: detailsDescriptionBackgroundColor,
            // extendBody: true,
            //  extendBodyBehindAppBar: true,
            appBar: const AppBarCart(),
            body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                child: Scrollbar(
                  controller: scrollController,
                  interactive: true,
                  child: provider.currentUser!.cart.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              SvgPicture.asset('assets/images/emptycart.svg'),
                              Text(
                                'Hey,your cart is empty',
                                style: topHeadingStyle,
                              )
                            ],
                          ),
                        )
                      : ListView.separated(
                          controller: scrollController,

                          ///shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          separatorBuilder: (context, index) =>
                              const Divider(color: Colors.white24),
                          itemCount: provider.currentUser!.cart.length,
                          itemBuilder: (context, index) {
                            return CartItemTile(
                                cartItem: provider.currentUser!.cart[index]);
                          },
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
                child: Column(
                  children: [
                    const CartAmountRow(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       'Delivery fee:',
                    //       style: cartItemsBillTextStyle,
                    //     ),
                    //     Text(
                    //       '₹ 0',
                    //       style: cartItemsBillCostTextStyle,
                    //     )
                    //   ],
                    // ),
                    SizedBox(
                      height: screenSize.height / 30,
                    ),
                    FutureBuilder(
                        future: loadButtonStatus(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return InkWell(
                              onTap: () async {
                                if (isAddOn) {
                                  QuickAlert.show(
                                    backgroundColor: Colors.white70,
                                    context: context,
                                    type: QuickAlertType.success,
                                    text: 'Your order is on its way!',
                                  );

                                  await provider.checkOut();
                                }

                                debugPrint('isAddOn $isAddOn');
                              },
                              child: GlassmorphicContainer(
                                alignment: Alignment.center,
                                width: screenSize.width / 2,
                                height: screenSize.height / 17,
                                borderRadius: 10,
                                linearGradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment(screenSize.width / 2000,
                                        screenSize.height / 350),
                                    colors: isAddOn
                                        ? addToCartActiveColors
                                        : addToCartInactiveColors),
                                border: 2,
                                borderGradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withOpacity(0.6),
                                      Colors.black.withOpacity(0.6),
                                    ]),
                                blur: 200,
                                child: Text(
                                  'Checkout',
                                  style: checkoutTextStyle,
                                ),
                              ),
                            );
                          } else {
                            return GlassmorphicContainer(
                              alignment: Alignment.center,
                              width: screenSize.width / 2,
                              height: screenSize.height / 17,
                              borderRadius: 10,
                              linearGradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment(screenSize.width / 2000,
                                      screenSize.height / 350),
                                  colors: addToCartInactiveColors),
                              border: 2,
                              borderGradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white.withOpacity(0.6),
                                    Colors.black.withOpacity(0.6),
                                  ]),
                              blur: 200,
                              child: Text(
                                'Checkout',
                                style: checkoutTextStyle,
                              ),
                            );
                          }
                        }),
                    SizedBox(
                      height: screenSize.height / 7,
                    )
                  ],
                ),
              ),
            ]));
      },
    );
  }
}
