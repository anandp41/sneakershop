import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController showCustomSnackBar({
  required String message,
  bool isDismissible = true,
  Color backgroundColor = const Color(0xFF303030),
  EdgeInsets margin = const EdgeInsets.only(bottom: 20, left: 4, right: 4),
  EdgeInsets padding = const EdgeInsets.all(16),
  Color? borderColor,
  double? borderWidth = 1.0,
  String? title,
  Widget? titleText,
  Widget? messageText,
}) {
  return Get.showSnackbar(GetSnackBar(
      title: title,
      titleText: titleText,
      messageText: messageText,
      backgroundColor: backgroundColor,
      padding: padding,
      margin: margin,
      borderColor: borderColor,
      borderWidth: borderWidth,
      message: message,
      isDismissible: isDismissible));
}
