import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/user/userappbar.dart';

import 'package:sneaker_shop/support/allitemstile.dart';
import 'package:sneaker_shop/support/user_custom_search.dart';

class ScreenAllItems extends StatelessWidget {
  const ScreenAllItems({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: UserAppBar(text: 'All items', otherActions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            );
          },
          icon: const Icon(
            Icons.search,
            size: 35,
            color: Colors.white,
          ),
        ),
      ]),
      body: Stack(children: [
        SvgPicture.asset(
          'assets/images/bg.svg',
          // width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 120),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<SneakerShopProvider>(
                builder: (context, provider, child) {
                  if (provider.products.isEmpty) {
                    provider.getAllStock();
                    return Center(
                      child: LoadingAnimationWidget.halfTriangleDot(
                          color: Colors.white, size: 40),
                    );
                  } else if (provider.brands.isEmpty) {
                    provider.getBrandData();
                    return Center(
                      child: LoadingAnimationWidget.halfTriangleDot(
                          color: Colors.white, size: 40),
                    );
                  } else {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: GridView.builder(
                            padding: const EdgeInsets.all(0),
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    maxCrossAxisExtent: screenSize.width / 2,
                                    mainAxisExtent: screenSize.height / 3.4),
                            itemCount: provider.products.length,
                            itemBuilder: (context, index) => AllItemsTile(
                                  sneaker: provider.products[index],
                                )),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        )
      ]),
    );
  }
}
