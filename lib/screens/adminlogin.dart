import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/db/dbhelper.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';

import 'package:sneaker_shop/support/colors.dart';

import '../main.dart';
import '../support/customtextfield.dart';
import '../support/my_button.dart';

class ScreenAdminLogin extends StatefulWidget {
  const ScreenAdminLogin({super.key});

  @override
  State<ScreenAdminLogin> createState() => _ScreenAdminLoginState();
}

class _ScreenAdminLoginState extends State<ScreenAdminLogin> {
  final _adminPasswordController = TextEditingController();
  //final _adminNameController = TextEditingController();
  final _adminLoginKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;

  void gotoAdminHome() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/admindashboard', (route) => false);
  }

  void showCustomSnackBarFail(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
        margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('second');
    // double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<SneakerShopProvider>(builder: (context, value, child) {
      void loginAdmin() async {
        final admin = await adminLogin();
        if (admin.password == _adminPasswordController.text.trim()) {
          _adminPasswordController.clear();
          final sharedPref = await SharedPreferences.getInstance();
          sharedPref.setBool(adminLogStatus, true);
          gotoAdminHome();
        } else {
          showCustomSnackBarFail('Incorrect Password');
        }
      }

      return Scaffold(
        //resizeToAvoidBottomInset: true,
        backgroundColor: detailsDescriptionBackgroundColor,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "ADMIN LOGIN",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: screenWidth * .95,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: userLoginBoxColor,
                      borderRadius: BorderRadius.circular(19)),
                  child: Column(
                    children: [
                      Form(
                          key: _adminLoginKey,
                          child: Column(
                            children: [
                              const MyCustomTextField(
                                label: 'Admin name',
                                initialValue: 'admin',
                                readOnly: true,
                              ),
                              MyCustomTextField(
                                obscure: _isPasswordVisible,
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: adminGridTileColor,
                                    )),
                                label: 'Password (Default : "Password@123")',
                                controller: _adminPasswordController,
                                validator: (value) {
                                  RegExp regx = RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                  if (!regx.hasMatch(value as String)) {
                                    return 'Enter valid password \n(one uppercase, one lowercase, one special symbol,\n 8 characters in total)';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          )),
                      MyButton(
                          onPressed: () {
                            if (_adminLoginKey.currentState!.validate()) {
                              loginAdmin();
                            } else {
                              showCustomSnackBarFail('Invalid Password');
                            }
                          },
                          data: 'Login'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
