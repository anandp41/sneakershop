import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/admin/adminappbar.dart';

import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/widgets/shoeslistwidget.dart';

class ScreenInventory extends StatelessWidget {
  const ScreenInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SneakerShopProvider>(builder: (context, value, child) {
      return const Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: detailsDescriptionBackgroundColor,
        appBar: AdminAppBar(title: 'Admin Inventory'),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 16),
          child: Column(
            children: [
              // ElevatedButton.icon(
              //     label: const Text('Clear Inventory DB'),
              //     onPressed: () async {
              //       await value.clearProductsDB();
              //     },
              //     style: const ButtonStyle(
              //         backgroundColor: MaterialStatePropertyAll(Colors.red)),
              //     icon: const Icon(Icons.delete_forever_rounded)),
              Expanded(child: ShoesListWidget()),
            ],
          ),
        ),
      );
    });
  }
}

int i = 1;
