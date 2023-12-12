import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/model/revenuemodel.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/support/revenuetile.dart';

import 'package:sneaker_shop/support/textstyles.dart';

class RevenueListWidget extends StatelessWidget {
  const RevenueListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SneakerShopProvider>(builder: (context, provider, child) {
      //provider.products.clear();
      if (provider.revenue.isEmpty) {
        provider.getRevenue();

        return const Center(child: CircularProgressIndicator());
      } else {
        return ListView.builder(
            itemCount: provider.revenue.length,
            itemBuilder: (context, index) {
              RevenueData eachRevenue = provider.revenue[index];

              return InkWell(
                  onTap: () {
                    _showBottomSheet(context, revenueData: eachRevenue);
                  },
                  child: RevenueTile(revenueData: eachRevenue));
            });
      }
    });
  }
}

void _showBottomSheet(BuildContext context,
    {required RevenueData revenueData}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Transaction ID: ${revenueData.transactionId}',
                style: checkoutTextStyle,
              ),
              Row(
                children: [
                  Text(
                    'Email:',
                    style: cartItemsBillTextStyle,
                  ),
                  Text(
                    revenueData.email,
                    style: cartItemsBillTextStyle,
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'SneakerId:',
                    style: cartItemsBillTextStyle,
                  ),
                  Text(
                    revenueData.sneakerId.toString(),
                    style: cartItemsBillTextStyle,
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'Size:',
                    style: cartItemsBillTextStyle,
                  ),
                  Text(
                    revenueData.size.toString(),
                    style: cartItemsBillTextStyle,
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'Units bought:',
                    style: cartItemsBillTextStyle,
                  ),
                  Text(
                    revenueData.number.toString(),
                    style: cartItemsBillTextStyle,
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'Amount:',
                    style: cartItemsBillTextStyle,
                  ),
                  Text(
                    revenueData.amount.toString(),
                    style: cartItemsBillTextStyle,
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'Date and Time:',
                    style: cartItemsBillTextStyle,
                  ),
                  Text(
                    revenueData.dateTime.toString(),
                    style: cartItemsBillTextStyle,
                  )
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
