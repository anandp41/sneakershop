import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/admin/adminappbar.dart';

import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/widgets/orderlistwidget.dart';

class ScreenManageOrders extends StatelessWidget {
  const ScreenManageOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SneakerShopProvider>(
      builder: (context, provider, child) => const Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: detailsDescriptionBackgroundColor,
        appBar: AdminAppBar(title: 'Manage Orders', showLogOut: true),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 16),
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8.0),
              //   child: ElevatedButton.icon(
              //       label: const Text('Clear Revenue DB'),
              //       onPressed: () async {
              //         await provider.clearRevenueDB();
              //       },
              //       style: const ButtonStyle(
              //           backgroundColor: MaterialStatePropertyAll(Colors.red)),
              //       icon: const Icon(Icons.delete_forever_rounded)),
              // ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Tap to change status of an order',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Expanded(child: OrderListWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
