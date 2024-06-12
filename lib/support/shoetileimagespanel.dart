import 'package:flutter/material.dart';

class AdminShoeTileImagesPanel extends StatelessWidget {
  final List<String> imagePaths;
  const AdminShoeTileImagesPanel({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height / 18,
      child: ListView.separated(
        separatorBuilder: (context, index) => const VerticalDivider(
          color: Colors.white70,
          thickness: 2,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Container(
            width: screenSize.width / 5,
            color: Colors.white30,
            child: Image.network(
              imagePaths[index],
              filterQuality: FilterQuality.high,
              fit: BoxFit.fitHeight,
            ),
          );
        },
      ),
    );
  }
}
