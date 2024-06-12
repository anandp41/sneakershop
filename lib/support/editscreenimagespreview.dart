import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/admin/imageviewingtile.dart';

class AdminInventoryEditImagePanel extends StatelessWidget {
  const AdminInventoryEditImagePanel({super.key, required this.imagesPaths});
  final List<String> imagesPaths;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 0.5, color: Colors.black)),
        child: SizedBox(
            height: screenSize.height / 9,
            child: Consumer<SneakerShopProvider>(
                builder: (context, provider, child) {
              if (imagesPaths.isNotEmpty) {
                return ListView.separated(
                    separatorBuilder: (context, index) => const VerticalDivider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.tempPreviewPaths.length,
                    itemBuilder: (context, index) =>
                        AdminImageTile(path: provider.tempPreviewPaths[index]));
              } else {
                return const Center(child: Text('No images added'));
              }
            })));
  }
}
