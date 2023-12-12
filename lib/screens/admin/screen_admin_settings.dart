import 'package:flutter/material.dart';
import 'package:sneaker_shop/screens/admin/adminappbar.dart';
import 'package:sneaker_shop/screens/admin/screen_admin_changepw.dart';
import 'package:sneaker_shop/support/admin_settings_gridtile.dart';
import 'package:sneaker_shop/support/colors.dart';

class ScreenAdminSettings extends StatelessWidget {
  const ScreenAdminSettings({super.key});

  @override
  Widget build(BuildContext context) {
    void gotoChangePw() {
      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => const ScreenAdminChangePw()));
    }

    List gridItems = [
      AdminSettingsGridTile(
        iconData: Icons.security,
        data: '''Change Password''',
        onTap: gotoChangePw,
      ),
    ];
    return Scaffold(
      backgroundColor: detailsDescriptionBackgroundColor,
      appBar: const AdminAppBar(title: 'Admin Settings'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1 / 1.5,
                crossAxisCount: 2),
            itemCount: gridItems.length,
            itemBuilder: ((context, index) {
              return gridItems[index];
            }),
          ),
        ),
      ),
    );
  }
}
