import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/db/dbhelper.dart';

import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/admin/adminappbar.dart';

import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/customtextfield.dart';
import 'package:sneaker_shop/widgets/brandlistwidget.dart';

class ScreenAdminAddBrand extends StatefulWidget {
  const ScreenAdminAddBrand({super.key});

  @override
  State<ScreenAdminAddBrand> createState() => _ScreenAdminAddBrandState();
}

class _ScreenAdminAddBrandState extends State<ScreenAdminAddBrand> {
  final TextEditingController brandNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<SneakerShopProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: detailsDescriptionBackgroundColor,
        appBar: const AdminAppBar(title: 'Manage Brands'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                MyCustomTextField(
                  label: 'Brand name',
                  controller: brandNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a valid brand name';
                    } else {
                      for (var element in provider.brands) {
                        if (element.toUpperCase() == value.toUpperCase()) {
                          return 'Brand already exists';
                        }
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: adminGridTileColor),
                  onPressed: () async {
                    final brandName =
                        brandNameController.text.trim().toUpperCase();

                    await addBrand(brand: brandName);

                    provider.getBrandData();
                  },
                  child: const Text('Add Brand'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Expanded(child: BrandListWidget()),
              ],
            ),
          ),
        ),
      );
    });
  }

  void showSuccessCustomSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Success'),
        backgroundColor: Colors.green,
        margin: EdgeInsets.all(10),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showFailedCustomSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Enter valid data'),
        backgroundColor: Colors.red,
        margin: EdgeInsets.all(10),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> addBrand({required String brand}) async {
    if (formKey.currentState!.validate()) {
      await addBrandToDb(brand: brand);
      brandNameController.clear();

      showSuccessCustomSnackBar();
    } else {
      showFailedCustomSnackBar();
    }
  }
}
