import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sneaker_shop/support/colors.dart';

class ScreenPrivacyPolicy extends StatelessWidget {
  const ScreenPrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: detailsDescriptionBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 20),
          child: FutureBuilder(
            future: rootBundle.loadString("assets/privacypolicy.md"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(child: Markdown(data: snapshot.data!));
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
