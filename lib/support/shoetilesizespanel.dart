import 'package:flutter/material.dart';
import 'package:sneaker_shop/support/textstyles.dart';

class AdminShoeTileSizesPanel extends StatelessWidget {
  final List<Map<String, int>> availableSizesandStock;
  const AdminShoeTileSizesPanel(
      {super.key, required this.availableSizesandStock});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const VerticalDivider(
        color: Colors.white70,
        thickness: 2,
      ),
      scrollDirection: Axis.horizontal,
      itemCount: availableSizesandStock.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white30,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Size:',
                    style: inventoryStockTextStyle,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    availableSizesandStock[index]['Size'].toString(),
                    style: inventoryStockTextStyle,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Stock:',
                    style: inventoryStockTextStyle,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    availableSizesandStock[index]['Stock'].toString(),
                    style: inventoryStockTextStyle,
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
