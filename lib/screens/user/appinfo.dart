import 'package:flutter/material.dart';
import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/textstyles.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenAppInfo extends StatelessWidget {
  const ScreenAppInfo({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: detailsDescriptionBackgroundColor,
        elevation: 0,
        title: Text(
          'SneakerShop',
          style: topHeadingStyle,
        ),
        centerTitle: true,
      ),
      backgroundColor: detailsDescriptionBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 20),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'App Info',
                    style: topHeadingStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.all(30),
                    margin: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 250,
                    ),
                  ),
                  const Text(
                    'Version: 1.0.0+1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.copyright,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '2023-2024  Anand P',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.blueAccent,
                            context: context,
                            builder: ((ctx) {
                              return Container(
                                padding: const EdgeInsets.all(10),
                                //height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.blueAccent,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'apanandp41@gmail.com',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextButton.icon(
                                            onPressed: () {
                                              launchEmailSubmission();
                                            },
                                            icon: const Icon(
                                              Icons.email,
                                              color: Colors.white,
                                            ),
                                            label: const Text(
                                              'Send Mail',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              );
                            }));
                      },
                      icon: const Icon(
                        Icons.contact_page_rounded,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Contact Developer',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> launchEmailSubmission() async {
    final Uri params = Uri(
        scheme: 'mailto',
        path: 'apanandp41@gmail.com',
        query: 'subject=From Coffee Break');
    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      debugPrint('Could not launch $params');
    }
  }
}
