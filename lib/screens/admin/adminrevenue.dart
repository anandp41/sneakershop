import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/admin/adminappbar.dart';

import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/widgets/revenuelistwidget.dart';

class ScreenRevenue extends StatelessWidget {
  const ScreenRevenue({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SneakerShopProvider>(
      builder: (context, provider, child) => const Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: detailsDescriptionBackgroundColor,
        appBar: AdminAppBar(title: 'Edit Sneaker', showLogOut: true),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 16),
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8.0),
              //   child: ElevatedButton.icon(
              //       label: const Text(
              //         'Clear Revenue DB',
              //         style: TextStyle(color: Colors.white),
              //       ),
              //       onPressed: () async {
              //         await provider.clearRevenueDB();
              //       },
              //       style: const ButtonStyle(
              //           backgroundColor: MaterialStatePropertyAll(Colors.red)),
              //       icon: const Icon(Icons.delete_forever_rounded)),
              // ),
              Expanded(child: RevenueListWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
