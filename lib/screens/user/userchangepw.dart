import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/db/dbhelper.dart';
import 'package:sneaker_shop/model/usermodel.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/customtextfield.dart';

class ScreenUserChangePw extends StatefulWidget {
  const ScreenUserChangePw({super.key});

  @override
  State<ScreenUserChangePw> createState() => _ScreenUserChangePwState();
}

class _ScreenUserChangePwState extends State<ScreenUserChangePw> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController rePassController = TextEditingController();
  final adminSettingsformKey = GlobalKey<FormState>();
  bool obscureValuePass = true;
  bool obscureValueNewPass = true;
  bool isPasswordEightCharacter = false;
  bool isPasswordHasNumber = false;
  bool isPasswordHasUpperCaseLetter = false;
  bool isPasswordHasLowercaseLetter = false;
  bool isPasswordHasSpecialCharacters = false;
  checkPassword(String password) {
    final numberRegex = RegExp(r'[0-9]');
    final upperCaseRegex = RegExp(r'[A-Z]');
    final lowerCaseRegex = RegExp(r'[a-z]');
    final specialCharcters = RegExp(r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+='
        "'"
        ']');
    setState(() {
      isPasswordEightCharacter = false;
      if (password.length >= 8) {
        isPasswordEightCharacter = true;
      }
      isPasswordHasNumber = false;
      if (numberRegex.hasMatch(password)) {
        isPasswordHasNumber = true;
      }
      isPasswordHasUpperCaseLetter = false;
      if (upperCaseRegex.hasMatch(password)) {
        isPasswordHasUpperCaseLetter = true;
      }
      isPasswordHasLowercaseLetter = false;
      if (lowerCaseRegex.hasMatch(password)) {
        isPasswordHasLowercaseLetter = true;
      }
      isPasswordHasSpecialCharacters = false;
      if (specialCharcters.hasMatch(password)) {
        isPasswordHasSpecialCharacters = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SneakerShopProvider provider = Provider.of(context, listen: true);
    void showCustomSnackBarSave() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password changed',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
          margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
    }

    void showCustomSnackBarFail() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter valid password',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
    }

    void handlePasswordChange() async {
      final updatedUser = UserData(
        password: newPasswordController.text,
        name: provider.currentUser!.name,
        address: provider.currentUser!.address,
        email: provider.currentUser!.email,
        phoneno: provider.currentUser!.phoneno,
        cart: provider.currentUser!.cart,
        favList: provider.currentUser!.favList,
      );
      Navigator.of(context).pop();
      await updateUserToDB(updatedUser: updatedUser);
      showCustomSnackBarSave();
    }

    newPasswordShow() {
      setState(() {
        if (obscureValueNewPass == false) {
          obscureValueNewPass = true;
        } else {
          obscureValueNewPass = false;
        }
      });
    }

    passwordShow() {
      setState(() {
        if (obscureValuePass == false) {
          obscureValuePass = true;
        } else {
          obscureValuePass = false;
        }
      });
    }

    return Scaffold(
      backgroundColor: detailsDescriptionBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: adminSettingsformKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MyCustomTextField(
                  controller: oldPasswordController,
                  label: 'Old Password',
                  obscure: obscureValuePass,
                  suffixIcon: IconButton(
                      onPressed: () {
                        passwordShow();
                      },
                      icon: Icon(
                        obscureValuePass
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: adminGridTileColor,
                      )),
                  validator: (value) {
                    if (value != provider.currentUser!.password) {
                      return 'Incorrect old password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                MyCustomTextField(
                  controller: newPasswordController,
                  onChanged: (password) => checkPassword(password),
                  label: 'New Password',
                  obscure: obscureValueNewPass,
                  suffixIcon: IconButton(
                      onPressed: () {
                        newPasswordShow();
                      },
                      icon: Icon(
                        obscureValueNewPass
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: adminGridTileColor,
                      )),
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
                  controller: rePassController,
                  label: 'Re-enter password',
                  validator: (value) {
                    if (newPasswordController.text != value) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                //first row
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isPasswordEightCharacter
                            ? Colors.green
                            : Colors.transparent,
                        border: isPasswordEightCharacter
                            ? Border.all(color: Colors.grey.shade400)
                            : Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          color: detailsDescriptionBackgroundColor,
                          size: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('Contains at least 8 characters')
                  ],
                ),

                //second row
                const SizedBox(height: 10),
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isPasswordHasNumber
                            ? Colors.green
                            : Colors.transparent,
                        border: isPasswordEightCharacter
                            ? Border.all(color: Colors.grey.shade400)
                            : Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          color: detailsDescriptionBackgroundColor,
                          size: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('Contains at least 1 number')
                  ],
                ),
                const SizedBox(height: 10),
                //third row
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isPasswordHasUpperCaseLetter
                            ? Colors.green
                            : Colors.transparent,
                        border: isPasswordHasUpperCaseLetter
                            ? Border.all(color: Colors.grey.shade400)
                            : Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          color: detailsDescriptionBackgroundColor,
                          size: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('Contains at least 1 uppercase character')
                  ],
                ),
                const SizedBox(height: 10),
                //fourth row
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isPasswordHasLowercaseLetter
                            ? Colors.green
                            : Colors.transparent,
                        border: isPasswordHasLowercaseLetter
                            ? Border.all(color: Colors.grey.shade400)
                            : Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          color: detailsDescriptionBackgroundColor,
                          size: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('Contains at least 1 lowercase character')
                  ],
                ),
                const SizedBox(height: 10),
                //fifth row
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isPasswordHasSpecialCharacters
                            ? Colors.green
                            : Colors.transparent,
                        border: isPasswordHasSpecialCharacters
                            ? Border.all(color: Colors.grey.shade400)
                            : Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          color: detailsDescriptionBackgroundColor,
                          size: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('Contains at least 1 special character')
                  ],
                ),
                const SizedBox(height: 50),
                MaterialButton(
                  height: 55,
                  minWidth: double.infinity,
                  color: adminGridTileColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () async {
                    if (adminSettingsformKey.currentState!.validate()) {
                      handlePasswordChange();
                    } else {
                      showCustomSnackBarFail();
                    }
                  },
                  child: const Text(
                    'CHANGE PASSWORD',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
