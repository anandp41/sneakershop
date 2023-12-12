import 'package:flutter/material.dart';

import 'package:sneaker_shop/support/textstyles.dart';

class AppBarCart extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCart({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(0, 70),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
        child: AppBar(
          toolbarHeight: 50,
          leadingWidth: 50,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'My Cart',
            style: topHeadingStyle,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

// class BackButtonCartAppBar extends StatelessWidget {
//   const BackButtonCartAppBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MyNavigationBarProvider>(
//       builder: (context, value, child) => InkWell(
//         onTap: () {
//           value.myPageStack.pop();
//         },
//         child: Container(
//           height: 20,
//           width: 20,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(11),
//               gradient: const LinearGradient(
//                   begin: Alignment.topRight,
//                   end: Alignment.bottomLeft,
//                   colors: [
//                     Color.fromRGBO(52, 202, 232, 1),
//                     Color.fromRGBO(78, 74, 242, 1),
//                   ])),
//           child: const Icon(
//             Icons.chevron_left_sharp,
//             size: 38,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }
