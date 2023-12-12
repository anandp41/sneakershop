import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';

class AdminImageTile extends StatelessWidget {
  final String path;
  const AdminImageTile({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<SneakerShopProvider>(
      builder: (context, provider, child) => Stack(children: [
        Container(
          height: screenHeight / 4,
          width: screenWidth / 4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 2, color: Colors.white38)),
          child: Image.file(
            File(path),
            filterQuality: FilterQuality.high,
            fit: BoxFit.scaleDown,
          ),
        ),
        Positioned(
          top: 5,
          left: 5,
          child: InkWell(
            onTap: () async {
              provider.deleteImageFromPanel(path);
            },
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white60),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
