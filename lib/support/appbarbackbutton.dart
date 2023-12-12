import 'package:flutter/material.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(144, 16, 20, 28),
                  blurRadius: 10.0,
                  offset: Offset(0, 7))
            ],
            borderRadius: BorderRadius.circular(11),
            gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromRGBO(52, 202, 232, 1),
                  Color.fromRGBO(78, 74, 242, 1),
                ])),
        child: const Icon(
          Icons.chevron_left_sharp,
          size: 38,
          color: Colors.white,
        ),
      ),
    );
  }
}
