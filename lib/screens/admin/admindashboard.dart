import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sneaker_shop/screens/admin/adminappbar.dart';
import 'package:sneaker_shop/support/admingridtile.dart';
import 'package:sneaker_shop/support/colors.dart';

class ScreenAdminDashboard extends StatelessWidget {
  const ScreenAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    List<dynamic> gridItems = [
      AdminGridTile(
        iconData: Icons.inventory,
        data: 'Inventory',
        onTap: () {
          Navigator.pushNamed(context, '/admininventory');
        },
      ),
      AdminGridTile(
        iconData: Icons.add_card,
        data: 'Add Sneakers',
        onTap: () {
          Navigator.pushNamed(context, '/adminaddshoes');
        },
      ),
      AdminGridTile(
        iconData: Icons.branding_watermark,
        data: 'Manage Brands',
        onTap: () {
          Navigator.pushNamed(context, '/adminaddbrand');
        },
      ),
      AdminGridTile(
        iconData: Icons.monetization_on,
        data: 'Revenue',
        onTap: () {
          Navigator.pushNamed(context, '/revenue');
        },
      ),
      AdminGridTile(
        iconData: // Icons.monetization_on
            LineIcons.clipboardList,
        data: 'Manage Orders',
        onTap: () {
          Navigator.pushNamed(context, '/manageorders');
        },
      ),
      AdminGridTile(
        iconData: Icons.settings,
        data: 'Settings',
        onTap: () {
          Navigator.pushNamed(context, '/adminsettings');
        },
      ),
    ];

    return Scaffold(
      appBar: const AdminAppBar(title: 'Admin Dashboard'),
      backgroundColor: detailsDescriptionBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 20,
              crossAxisSpacing: 15,
              childAspectRatio: 1 / 1.2,
              crossAxisCount: 2),
          itemCount: gridItems.length,
          itemBuilder: ((context, index) {
            return gridItems[index];
          }),
        ),
      ),
    );
  }
}
