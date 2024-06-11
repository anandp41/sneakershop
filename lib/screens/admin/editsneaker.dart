import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:simple_markdown_editor/widgets/markdown_form_field.dart';
import 'package:sneaker_shop/model/shoemodel.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/admin/adminappbar.dart';
import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/customtextfield.dart';
import 'package:sneaker_shop/support/dynamictextfield.dart';
import 'package:sneaker_shop/support/editscreenimagespreview.dart';
import 'package:sneaker_shop/support/textstyles.dart';

import '../../db/dbhelper.dart';

class ScreenEditSneaker extends StatefulWidget {
  final ShoeModel sneaker;

  const ScreenEditSneaker({super.key, required this.sneaker});

  @override
  State<ScreenEditSneaker> createState() => _ScreenEditSneakerState();
}

late bool isNewProduct;
late TextEditingController shoePriceController;
late TextEditingController shoeNameController;
late TextEditingController descriptionController;

class _ScreenEditSneakerState extends State<ScreenEditSneaker> {
  @override
  void initState() {
    isNewProduct = widget.sneaker.isNew;
    shoePriceController =
        TextEditingController(text: widget.sneaker.price.toString());

    shoeNameController = TextEditingController(text: widget.sneaker.name);
    descriptionController =
        TextEditingController(text: widget.sneaker.description);
    final provider = Provider.of<SneakerShopProvider>(context, listen: false);
    provider.clearTempPreviewPaths();
    provider.loadSavedImagesPaths(widget.sneaker.imagePath);
    super.initState();
  }

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context1) {
    return Consumer<SneakerShopProvider>(builder: (context, provider, child) {
      if (provider.brands.isEmpty) {
        provider.getBrandData();
        //return const Center(child: Text('was empty'));
      }

      provider.selectedBrand = widget.sneaker.brand;
      void showSuccessCustomSnackBar() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sneaker data updated'),
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

      Future<void> updateSneaker() async {
        if (formKey.currentState!.validate()) {
          Navigator.pop(context1);
          await provider.saveSelectedImagesinApplicationDirectory(
              shoeId: widget.sneaker.shoeId);
          final shoeName = shoeNameController.text.trim().toUpperCase();

          final shoePrice = double.parse(shoePriceController.text.trim());
          final description = descriptionController.text.trim();
          final shoeBrand = provider.selectedBrand;
          provider.selectedBrand = null;
          final List<Map<String, int>> availableSizesandStock =
              provider.mappedListOfSizesAndStock;
          ShoeModel sneaker = ShoeModel(
              shoeId: widget.sneaker.shoeId,
              name: shoeName,
              price: shoePrice,
              description: description,
              brand: shoeBrand!,
              imagePath: provider.copiedPaths,
              availableSizesandStock: availableSizesandStock,
              isNew: isNewProduct);

          await updateSneakerInDb(shoe: sneaker);
          provider.clearAllDataInDynamicTextfield();

          provider.getAllStock();
          showSuccessCustomSnackBar();
          provider.clearTempPreviewPaths();
        } else {
          showFailedCustomSnackBar();
        }
      }

      return Scaffold(
        appBar: const AdminAppBar(title: 'Edit Sneaker', showLogOut: false),
        backgroundColor: detailsDescriptionBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyCustomTextField(
                    label: 'Sneaker Name',
                    controller: shoeNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  MyCustomTextField(
                    label: 'Price',
                    controller: shoePriceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a valid Price';
                      }
                      RegExp exp = RegExp(r"(\d+\.\d{1,2})");

                      if (!exp.hasMatch(value)) {
                        return 'Enter a valid Price';
                      }
                      {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 15),
                    child: DropdownButtonFormField<String>(
                      dropdownColor: Colors.blueGrey,
                      style: const TextStyle(color: Colors.white),
                      value: provider.selectedBrand,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          provider.selectedBrand = provider.brands
                              .firstWhere((brand) => brand == newValue);
                        }
                      },
                      items: provider.brands
                          .map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: focusedBorderColor, width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        focusColor: adminGridTileColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Description:',
                    style: largeTileNonWhiteTextStyle,
                  ),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MarkdownFormField(
                      cursorColor: Colors.white,
                      controller: descriptionController,
                      enableToolBar: true,
                      emojiConvert: true,
                      autoCloseAfterSelectEmoji: false,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Images:',
                    style: largeTileNonWhiteTextStyle,
                  ),
                  AdminInventoryEditImagePanel(
                      imagesPaths: provider.tempPreviewPaths),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.green)),
                        onPressed: () async {
                          await provider.pickImages();

                          setState(() {});
                        },
                        child: const Text('Pick Images'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          provider.clearTempPreviewPaths();
                          setState(() {});
                        },
                        child: const Text('Clear images selection'),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sizes and Stocks:',
                        style: largeTileNonWhiteTextStyle,
                      ),
                      FlutterSwitch(
                          duration: const Duration(milliseconds: 100),
                          toggleSize: 20,
                          padding: 3,
                          showOnOff: true,
                          width: 70,
                          activeColor: Colors.white54,
                          inactiveColor: const Color.fromARGB(225, 48, 61, 119),
                          activeText: 'New',
                          inactiveText: 'Old',
                          activeTextColor: Colors.black87,
                          inactiveTextColor: Colors.black87,
                          value: isNewProduct,
                          activeToggleColor: Colors.green,
                          inactiveToggleColor: Colors.red,
                          onToggle: (value) {
                            setState(() {
                              isNewProduct = value;
                            });
                          })
                    ],
                  ),
                  DynamicTextFields(
                      sentSizesAndStock: widget.sneaker.availableSizesandStock),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: adminGridTileColor),
                      onPressed: () async {
                        await updateSneaker();
                      },
                      child: const Text('Update sneaker data'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // @override
  // void dispose() {
  // final provider = Provider.of<SneakerShopProvider>(context);
  // provider.clearImageModule();
  //   super.dispose();
  // }
}
