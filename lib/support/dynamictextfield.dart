import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/support/textstyles.dart';

class DynamicTextFields extends StatefulWidget {
  final List<Map<String, int>> sentSizesAndStock;
  const DynamicTextFields({super.key, this.sentSizesAndStock = const []});

  @override
  DynamicTextFieldsState createState() => DynamicTextFieldsState();
}

class DynamicTextFieldsState extends State<DynamicTextFields> {
  //TextEditingController allFieldValuesController = TextEditingController();
  List<TextEditingController> sizeControllers = [];
  List<TextEditingController> stockControllers = [];
  List<Widget> fieldRows = [];
  List<Map<String, int>> mappedListOfSizesAndStock = [];
  int i = 0;

  bool loadedFlag = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SneakerShopProvider>(builder: (context, provider, child) {
      provider.receiveListOfMap(mappedListOfSizesAndStock);
      void updateAllFieldValues() {
        mappedListOfSizesAndStock =
            List.generate(sizeControllers.length, (index) {
          int size = int.tryParse(sizeControllers[index].text) ?? 0;
          int stock = int.tryParse(stockControllers[index].text) ?? 0;
          return {'Size': size, 'Stock': stock};
        });

        // allFieldValuesController.text = mappedListOfSizesAndStock
        //     .map((fieldValue) =>
        //         "{'Size': ${fieldValue['Size']}, 'Stock': ${fieldValue['Stock']}}")
        //     .join(", ");
        provider.receiveListOfMap(mappedListOfSizesAndStock);
      }

      if (loadedFlag == false) {
        if (widget.sentSizesAndStock != []) {
          mappedListOfSizesAndStock = widget.sentSizesAndStock;
          for (var element in mappedListOfSizesAndStock) {
            debugPrint(element.toString());
            debugPrint('Count ${i++}');
            var sizeController =
                TextEditingController(text: element['Size'].toString());
            sizeControllers.add(sizeController);
            var stockController =
                TextEditingController(text: element['Stock'].toString());
            stockControllers.add(stockController);
            fieldRows.add(
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: sizeController,
                      onChanged: (value) {
                        updateAllFieldValues();
                        debugPrint('sizeController\'s debugprint');
                      },
                      decoration: InputDecoration(
                          labelText: 'Size',
                          labelStyle: cartItemsBillTextStyle),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: stockController,
                      onChanged: (value) {
                        updateAllFieldValues();
                        debugPrint('stockController\'s debugprint');
                      },
                      decoration: InputDecoration(
                          labelText: 'Stock',
                          labelStyle: cartItemsBillTextStyle),
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Accept only digits
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        }
        loadedFlag = true;
      }

      if (provider.doClearAllDataInDynamicTextfield == true) {
        sizeControllers.clear();
        stockControllers.clear();
        fieldRows.clear();
        mappedListOfSizesAndStock = [];
        updateAllFieldValues();

        provider.doClearAllDataInDynamicTextfield = false;
      }

      return Column(
        children: [
          Column(
            children: fieldRows,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Add Button
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                onPressed: () {
                  if (sizeControllers.isNotEmpty &&
                      (sizeControllers.last.text.isEmpty ||
                          stockControllers.last.text.isEmpty)) {
                    // Prevent adding a new field if the last size field is empty
                    return;
                  }
                  setState(() {
                    TextEditingController sizeController =
                        TextEditingController();
                    TextEditingController stockController =
                        TextEditingController();
                    sizeControllers.add(sizeController);
                    stockControllers.add(stockController);

                    // Create a new row with size and stock text fields
                    debugPrint('onChanged');
                    fieldRows.add(
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              controller: sizeController,
                              onChanged: (value) {
                                updateAllFieldValues();
                                debugPrint('fieldRow added');
                              },
                              decoration: InputDecoration(
                                  labelText: 'Size',
                                  labelStyle: cartItemsBillTextStyle),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              controller: stockController,
                              onChanged: (value) {
                                updateAllFieldValues();
                              },
                              decoration: InputDecoration(
                                  labelText: 'Stock',
                                  labelStyle: cartItemsBillTextStyle),
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly, // Accept only digits
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                    updateAllFieldValues();
                  });
                },
                child: const Text('+ Add'),
              ),
              // Remove Button
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (mappedListOfSizesAndStock.isNotEmpty) {
                    setState(() {
                      sizeControllers.removeLast();
                      stockControllers.removeLast();
                      fieldRows.removeLast();
                      mappedListOfSizesAndStock.removeLast();
                      updateAllFieldValues();
                    });
                  }
                },
                child: const Text('- Remove'),
              ),
            ],
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    // Dispose all the controllers when the widget is removed
    for (var controller in sizeControllers) {
      controller.dispose();
    }
    for (var controller in stockControllers) {
      controller.dispose();
    }
    //allFieldValuesController.dispose();
    super.dispose();
  }
}
