import 'package:flutter/material.dart';

class MyCustomTextField extends StatelessWidget {
  final String label;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType? type;
  final void Function()? ontap;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? initialValue;
  final bool readOnly;
  final TextStyle? errorStyle;
  const MyCustomTextField(
      {super.key,
      required this.label,
      this.controller,
      this.validator,
      this.obscure = false,
      this.type,
      this.ontap,
      this.suffixIcon,
      this.initialValue,
      this.readOnly = false,
      this.errorStyle,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onTap: ontap,
        readOnly: readOnly,
        initialValue: initialValue,
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscure,
        obscuringCharacter: '*',
        keyboardType: type,
        decoration: InputDecoration(
          errorStyle: errorStyle,
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromRGBO(255, 255, 255, 0.702), width: 2),
              borderRadius: BorderRadius.circular(10)),
          suffixIcon: suffixIcon,
          focusColor: const Color.fromARGB(255, 84, 70, 162),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          label: Text(
            label,
            style: const TextStyle(color: Color.fromRGBO(170, 179, 183, 1)),
          ),
        ),
      ),
    );
  }
}
