import 'package:flutter/material.dart';
import 'package:sneaker_shop/support/colors.dart';

class AdminGridTile extends StatelessWidget {
  final IconData iconData;
  final String data;
  final VoidCallback onTap;
  const AdminGridTile(
      {super.key,
      required this.iconData,
      required this.data,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 150,
        height: 260,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white38, width: 1.5),
            color: adminGridTileColor,
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              data,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
