import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/db/dbhelper.dart';
import 'package:sneaker_shop/main.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/user/privpolicy.dart';
import 'package:sneaker_shop/screens/user/screen_signup.dart';
import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/constants.dart';
import 'package:sneaker_shop/support/customtextfield.dart';
import 'package:sneaker_shop/support/textstyles.dart';

class ScreenUserLogin extends StatefulWidget {
  const ScreenUserLogin({super.key});

  @override
  State<ScreenUserLogin> createState() => _ScreenUserLoginState();
}

class _ScreenUserLoginState extends State<ScreenUserLogin> {
  final formKey = GlobalKey<FormState>();

  final userEmailController = TextEditingController();

  final passwordController = TextEditingController();
  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    void goToUserDashBoard() {
      Navigator.pushReplacementNamed(context, '/userdashboard');
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

    // double screenHeight = MediaQuery.of(context).size.height;
    return Consumer<SneakerShopProvider>(builder: (context, provider, child) {
      Future<void> loginUser() async {
        String email = userEmailController.text.trim();
        String password = passwordController.text.trim();
        if (await checkIfEmailExist(email)) {
          if (await doesEmailPasswordMatch(email: email, password: password)) {
            await SharedPreferences.getInstance().then((prefs) {
              prefs.setBool(userLogStatus, true);
              prefs.setString(loggedInUserString, email);
            });

            await provider.loadUser(email: email);
            goToUserDashBoard();
          } else {
            showCustomSnackBarFail("Email and and Password do not match");
          }
        } else {
          showCustomSnackBarFail("User does not exist");
        }
      }

      return Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: detailsDescriptionBackgroundColor,
        body: Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                detailsDescriptionBackgroundColor,
                Color.fromARGB(255, 50, 28, 66),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Hello\nSign in!',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                border: GradientBoxBorder(
                    gradient:
                        LinearGradient(colors: [Colors.white, Colors.black])),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: detailsDescriptionBackgroundColor,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18, top: 50),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MyCustomTextField(
                            label: 'Email (ad@gmail.com)',
                            controller: userEmailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter valid email';
                              }
                              return null;
                            }),
                        MyCustomTextField(
                            obscure: _isPasswordVisible,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: adminGridTileColor,
                                )),
                            label: 'Password (Anand@123)',
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter valid password';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              await loginUser();
                            } else {
                              showCustomSnackBarFail('Invalid data');
                            }
                          },
                          child: Container(
                            height: 55,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(colors: [
                                Colors.blue,
                                Color(0xff281537),
                              ]),
                            ),
                            child: const Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text('Or', style: largeTileNonWhiteTextStyle),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => const ScreenSignup()));
                          },
                          child: Container(
                            height: 55,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(colors: [
                                Colors.grey[600]!,
                                const Color(0xff281537),
                              ]),
                            ),
                            child: const Center(
                              child: Text(
                                'Create Account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/adminlogin',
                              );
                            },
                            child: Text(
                              'Admin Login',
                              style: TextStyle(
                                  color: Colors.grey[100], fontSize: 18),
                            )),
                        const SizedBox(
                          height: 40,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ScreenPrivacyPolicy(),
                                  ));
                            },
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationColor: Colors.white,
                                  decorationThickness: 2,
                                  color: Colors.grey[100],
                                  fontSize: 18),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      );
    });
  }
}
