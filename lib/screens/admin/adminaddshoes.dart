import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_markdown_editor/widgets/markdown_form_field.dart';
import 'package:sneaker_shop/db/dbhelper.dart';
import 'package:sneaker_shop/model/shoemodel.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/repositories/common_firebase_repository.dart';
import 'package:sneaker_shop/screens/admin/adminappbar.dart';
import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/customtextfield.dart';
import 'package:sneaker_shop/support/dynamictextfield.dart';
import 'package:sneaker_shop/support/editscreenimagespreview.dart';
import 'package:sneaker_shop/support/textstyles.dart';

class ScreenAdminAddShoes extends StatefulWidget {
  const ScreenAdminAddShoes({super.key});

  @override
  State<ScreenAdminAddShoes> createState() => _ScreenAdminAddShoesState();
}

class _ScreenAdminAddShoesState extends State<ScreenAdminAddShoes> {
  final TextEditingController shoeNameController = TextEditingController();
  final TextEditingController shoeIdController = TextEditingController();
  final TextEditingController shoePriceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isNewProduct = false;
  var formKey = GlobalKey<FormState>();

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void initState() {
    _requestPermission(Permission.storage);
    final provider = Provider.of<SneakerShopProvider>(context, listen: false);
    provider.clearTempPreviewPaths();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SneakerShopProvider>(builder: (context, provider, child) {
      if (provider.brands.isEmpty) {
        provider.getBrandData();
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

      void clearFormFields() {
        setState(() {
          shoeNameController.clear();
          shoePriceController.clear();
          shoeIdController.clear();
          descriptionController.clear();
          formKey = GlobalKey<FormState>();
        });
      }

      Future addSneaker() async {
        if (formKey.currentState!.validate()) {
          final shoeName = shoeNameController.text.trim().toUpperCase();
          final shoeId = shoeIdController.text.trim();
          final shoePrice = double.parse(shoePriceController.text.trim());
          final description = descriptionController.text.trim();
          final shoeBrand = provider.selectedBrand;
          provider.selectedBrand = null;

          final List<Map<String, int>> availableSizesandStock =
              provider.mappedListOfSizesAndStock;

          if (provider.tempPreviewPaths.isEmpty) {
            ShoeModel sneaker = ShoeModel(
              shoeId: shoeId,
              name: shoeName,
              price: shoePrice,
              description: description,
              brand: shoeBrand!,
              availableSizesandStock: availableSizesandStock,
              isNew: isNewProduct,
            );
            await addSneakerToDb(shoe: sneaker);
          } else {
            var imagePaths = await storeMultipleFilesToFirebase(
                serverFilePath: shoeId, paths: provider.tempPreviewPaths);
            ShoeModel sneaker = ShoeModel(
                shoeId: shoeId,
                name: shoeName,
                price: shoePrice,
                description: description,
                brand: shoeBrand!,
                availableSizesandStock: availableSizesandStock,
                isNew: isNewProduct,
                imagePath: imagePaths);
            await addSneakerToDb(shoe: sneaker);
          }

          provider.clearAllDataInDynamicTextfield();
          await provider.getAllStock();
          clearFormFields();
          showSuccessCustomSnackBar();
          provider.clearTempPreviewPaths();
          setState(() {});
        } else {
          showFailedCustomSnackBar();
        }
      }

      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: detailsDescriptionBackgroundColor,
        appBar: const AdminAppBar(title: 'Add New Sneakers'),
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
                    label: 'Sneaker ID',
                    controller: shoeIdController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a shoe ID";
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
                        return 'Enter decimal values';
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
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.blueGrey,
                    style: const TextStyle(color: Colors.white),
                    value: provider.selectedBrand,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        provider.selectedBrand = newValue;
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a brand to add';
                      }
                      return null;
                    },
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text("-Select Brand-"),
                      ),
                      ...provider.brands.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }),
                    ],
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: focusedBorderColor, width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      focusColor: adminGridTileColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: const Text(
                        'Select Brand',
                        style: TextStyle(color: textfieldLabelColor),
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
                    imagesPaths: provider.tempPreviewPaths,
                  ),
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
                  const DynamicTextFields(),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: adminGridTileColor),
                      onPressed: () async {
                        await addSneaker();
                      },
                      child: const Text('Add Sneaker'),
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
}
