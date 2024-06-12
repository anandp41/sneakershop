import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/model/revenuemodel.dart';
import 'package:sneaker_shop/model/status_adapter.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/support/colors.dart';

import 'package:sneaker_shop/support/ordertile.dart';

import 'package:sneaker_shop/support/textstyles.dart';

class OrderListWidget extends StatefulWidget {
  const OrderListWidget({super.key});

  @override
  State<OrderListWidget> createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  @override
  Widget build(BuildContext context) {
    void showCustomSnackBar(String message, Color? color) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    }

    return Consumer<SneakerShopProvider>(builder: (context, provider, child) {
      //provider.products.clear();
      if (provider.revenue.isEmpty) {
        provider.getRevenue();

        return const Center(child: CircularProgressIndicator());
      } else {
        return ListView.builder(
            itemCount: provider.revenue.length,
            itemBuilder: (context, index) {
              RevenueData eachRevenue = provider.revenue[index];

              return InkWell(
                  onTap: () {
                    if (eachRevenue.orderStatus != Status.cancelled &&
                        eachRevenue.orderStatus != Status.delivered) {
                      _showModal(context, revenueData: eachRevenue);
                    } else if (eachRevenue.orderStatus == Status.cancelled) {
                      showCustomSnackBar(
                          'Cancelled orders cannot be updated', Colors.red);
                    } else if (eachRevenue.orderStatus == Status.delivered) {
                      showCustomSnackBar(
                          'Order already delivered', Colors.blue);
                    }
                  },
                  child: OrderTile(revenueData: eachRevenue));
            });
      }
    });
  }

  void _showModal(BuildContext context, {required RevenueData revenueData}) {
    Status selectedStatus = revenueData.orderStatus;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.redAccent[100],
          contentPadding: const EdgeInsets.all(5),
          content: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 7, 45, 110),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Transaction ID: ${revenueData.transactionId}',
                    style: manageOrderBottomSheetHeadingTextStyle,
                  ),
                  const Divider(
                    color: Colors.white70,
                  ),
                  DropdownButtonFormField<Status>(
                      dropdownColor: Colors.blueGrey,
                      hint: Text(selectedStatus.toString()),
                      value: selectedStatus,
                      onChanged: (Status? newValue) async {
                        setState(() {
                          selectedStatus = newValue!;
                        });
                        Navigator.pop(context);

                        // await updateStatus(
                        //     newStatus: newValue!,
                        //     id: revenueData.transactionId!);
                      },
                      items: Status.values
                          .map<DropdownMenuItem<Status>>((Status value) {
                        return DropdownMenuItem<Status>(
                          value: value,
                          child: Text(
                            value.toString().split('.').last.toUpperCase(),
                            style: modalText,
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: focusedBorderColor, width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
