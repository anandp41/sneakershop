import 'package:flutter/material.dart';
import 'package:sneaker_shop/support/colors.dart';

class AdminSettingsGridTile extends StatelessWidget {
  final IconData iconData;
  final String data;
  final VoidCallback onTap;
  const AdminSettingsGridTile(
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
        width: 70,
        height: 70,
        decoration: BoxDecoration(
            color: adminGridTileColor, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
