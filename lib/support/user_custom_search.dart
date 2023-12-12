import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/model/shoemodel.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/user/details.dart';

import 'package:sneaker_shop/support/colors.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: detailsDescriptionBackgroundColor,
      hintColor: Colors.white,
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(
          Icons.clear,
          //color: mainTitles,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back_rounded,
        // color: mainTitles,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    void goToDetailsPage(ShoeModel sneaker) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenDetails(sneaker: sneaker),
          ));
    }

    final provider = Provider.of<SneakerShopProvider>(context);
    final result = provider.products
        .where(
          (sneaker) => sneaker.name.toUpperCase().contains(query.toUpperCase()),
        )
        .toList();
    return ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(result[index].name),
              onTap: () => goToDetailsPage(result[index]));
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    void goToDetailsPage(ShoeModel sneaker) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenDetails(sneaker: sneaker),
        ),
      );
    }

    final provider = Provider.of<SneakerShopProvider>(context);
    final result = provider.products
        .where(
          (coffee) => coffee.name.toUpperCase().contains(query.toUpperCase()),
        )
        .toList();
    return ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(result[index].name),
              onTap: () => goToDetailsPage(result[index]));
        });
  }
}
