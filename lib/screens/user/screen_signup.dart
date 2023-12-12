// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:sneaker_shop/db/dbhelper.dart';
import 'package:sneaker_shop/model/usermodel.dart';
import 'package:sneaker_shop/screens/user/login.dart';

import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/customtextfield.dart';
import 'package:sneaker_shop/support/my_button.dart';

class ScreenSignup extends StatefulWidget {
  const ScreenSignup({super.key});

  @override
  State<ScreenSignup> createState() => _ScreenSignupState();
}

class _ScreenSignupState extends State<ScreenSignup> {
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final userSignupformkey = GlobalKey<FormState>();
  bool _isPassVisible = false;
  bool _isRePassVisible = false;
  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: detailsDescriptionBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: screenWidth * .95,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 33, 76, 99),
                        borderRadius: BorderRadius.circular(19)),
                    child: Column(
                      children: [
                        Form(
                            key: userSignupformkey,
                            child: Column(
                              children: [
                                MyCustomTextField(
                                  label: 'Name',
                                  controller: _nameController,
                                  validator: (value) {
                                    RegExp regx = RegExp(r'^[a-z A-Z]+$');
                                    if (!regx.hasMatch(value as String)) {
                                      return 'Enter valid name without characters';
                                    }
                                    return null;
                                  },
                                ),
                                MyCustomTextField(
                                  label: 'Phone Number',
                                  controller: _phoneController,
                                  type: TextInputType.phone,
                                  validator: (value) {
                                    RegExp regx =
                                        RegExp(r'^([9876]{1})(\d{9})$');
                                    if (!regx.hasMatch(value as String)) {
                                      return 'Enter valid phone number';
                                    }
                                    return null;
                                  },
                                ),
                                MyCustomTextField(
                                  label: 'Email',
                                  controller: _emailController,
                                  type: TextInputType.emailAddress,
                                  validator: (value) {
                                    RegExp regx = RegExp(
                                        r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
                                    if (!regx.hasMatch(value as String)) {
                                      return 'Enter valid Email';
                                    }
                                    return null;
                                  },
                                ),
                                MyCustomTextField(
                                  label: 'Address',
                                  controller: _addressController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your address";
                                    }
                                    return null;
                                  },
                                ),
                                MyCustomTextField(
                                  obscure: !_isPassVisible,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isPassVisible = !_isPassVisible;
                                        });
                                      },
                                      icon: Icon(
                                        _isPassVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: adminGridTileColor,
                                      )),
                                  label: 'Password',
                                  controller: _passwordController,
                                  validator: (value) {
                                    RegExp regx = RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                    if (!regx.hasMatch(value as String)) {
                                      return 'Enter valid password';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                MyCustomTextField(
                                  obscure: !_isRePassVisible,
                                  label: 'Re-Enter Password',
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isRePassVisible = !_isRePassVisible;
                                        });
                                      },
                                      icon: Icon(
                                        _isRePassVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: adminGridTileColor,
                                      )),
                                  controller: _rePasswordController,
                                  validator: (value) {
                                    if (_passwordController.text != value) {
                                      return 'Password not matching';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            )),
                        MyButton(
                            onPressed: () {
                              _signUpUser();
                            },
                            data: 'Sign Up'),
                        Padding(
                          padding: const EdgeInsets.only(top: 45),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            const ScreenUserLogin())),
                                child: const Text(
                                  'Already have an account? Login here',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void gotoLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (ctx) => const ScreenUserLogin()),
      (route) => false,
    );
  }

  void showCustomSnackBarSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Signed up successfully',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _signUpUser() {
    final name = _nameController.text.trim();

    final phoneNumber = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final address = _addressController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _rePasswordController.text.trim();
    if (userSignupformkey.currentState!.validate()) {
      var user = UserData(
          name: name,
          email: email,
          phoneno: phoneNumber,
          address: address,
          password: password);
      saveNewUserToDb(user);
      showCustomSnackBarSave();
      _nameController.clear();

      _phoneController.clear();
      _emailController.clear();
      _passwordController.clear();
      _rePasswordController.clear();
      gotoLogin();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter valid data',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
