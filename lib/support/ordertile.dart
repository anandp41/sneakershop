import 'package:flutter/material.dart';
import 'package:sneaker_shop/model/revenuemodel.dart';
import 'package:sneaker_shop/model/status_adapter.dart';

import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/textstyles.dart';

class OrderTile extends StatelessWidget {
  final RevenueData revenueData;
  const OrderTile({super.key, required this.revenueData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: brandTileBackground,
      ),
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TransactionID:${revenueData.transactionId}',
              style: revenueTileTextStyle),
          const Divider(
            color: Colors.white70,
          ),
          Text(
              'Order Status: ${revenueData.orderStatus.toString().split('.').last.toUpperCase()}',
              style: revenueData.orderStatus == Status.cancelled
                  ? revenueTileOrderRedTextStyle
                  : revenueData.orderStatus == Status.delivered
                      ? revenueTileOrderBlueTextStyle
                      : revenueTileOrderGreenTextStyle),
          Text('Email: ${revenueData.email}', style: revenueTileTextStyle),
          Text('SneakerId: ${revenueData.sneakerId}',
              style: revenueTileTextStyle),
          Text('Number:${revenueData.number}', style: revenueTileTextStyle),
          Text('Amount: ${revenueData.amount}', style: revenueTileTextStyle),
          Text('Date and Time ordered: ${revenueData.dateTime}',
              style: revenueTileTextStyle),
        ],
      ),
    );
  }
}

// Future<void> deleteSneaker(
//     {required int productId, required BuildContext context}) async {
//   showDialog(
//     context: context,
//     builder: (ctx) => Consumer<SneakerShopProvider>(
//       builder: (context, value, child) => AlertDialog(
//         alignment: Alignment.center,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(25),
//         ),
//         title: Center(
//             child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             LineIcon.trash(
//               size: 40,
//               color: Colors.white.withOpacity(0.8),
//             ),
//             Text(
//               'Delete sneaker from stock?',
//               style: largeTileWhiteTextStyle,
//             ),
//           ],
//         )),
//         contentPadding: const EdgeInsets.all(10),
//         backgroundColor: const Color.fromARGB(249, 48, 35, 235),
//         actions: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               InkWell(
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await deleteSneakerFromDb(sneakerId: productId);
//                   value.getAllStock();
//                 },
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   color: Colors.red.shade500,
//                   margin: const EdgeInsets.all(10),
//                   child: const Padding(
//                     padding: EdgeInsets.all(10),
//                     child: Text(
//                       'Delete',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   color: adminGridTileColor,
//                   margin: const EdgeInsets.all(10),
//                   child: const Padding(
//                     padding: EdgeInsets.all(10),
//                     child: Text(
//                       'Cancel',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
