import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/model/usermodel.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/repositories/common_firebase_repository.dart';
import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/customtextfield.dart';
import 'package:sneaker_shop/support/my_button.dart';
import 'package:sneaker_shop/support/textstyles.dart';

import '../../db/dbhelper.dart';

// ignore: must_be_immutable
class UserEditProfile extends StatefulWidget {
  final UserData user;
  const UserEditProfile({super.key, required this.user});

  @override
  State<UserEditProfile> createState() => _UserEditProfileState();
}

class _UserEditProfileState extends State<UserEditProfile> {
  late SneakerShopProvider provider;
  @override
  void initState() {
    super.initState();
    provider = Provider.of<SneakerShopProvider>(context, listen: false);
  }

  final editUserProfileKey = GlobalKey<FormState>();

  var _nameController = TextEditingController();

  var _phoneController = TextEditingController();

  var _addressController = TextEditingController();

  File? _imageFile;

  String? imageFilePath;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // You can store the path or use the file for other purposes.
      imageFilePath = pickedFile.path;
      // Perform actions with the imagePath, like storing it.
    }
  }

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

    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phoneno);
    _addressController = TextEditingController(text: widget.user.address);
    void popPage() {
      Navigator.pop(context);
    }

    Future<void> updateUser() async {
      final imagePath = imageFilePath == null
          ? ''
          : await storeFileToFirebase(
              serverFilePath: widget.user.email, file: File(imageFilePath!));
      final name = _nameController.text.trim();
      final phoneNumber = _phoneController.text.trim();
      final email = widget.user.email;
      final password = widget.user.password;
      final address = _addressController.text.trim();
      final cartItem = widget.user.cart;
      final favList = widget.user.favList;
      var updatedUser = UserData(
          name: name,
          email: email,
          phoneno: phoneNumber,
          address: address,
          password: password,
          imagePath: imagePath,
          cart: cartItem,
          favList: favList);
      await updateUserToDB(updatedUser: updatedUser);
      imageFilePath = null;
      _imageFile = null;
      provider.loadUser(email: email);
      Provider.of<SneakerShopProvider>(context, listen: false)
          .notifyListeners();
      popPage();
    }

    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: detailsDescriptionBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const Text(
                    'Edit  Profile',
                    style: TextStyle(fontSize: 44, color: Colors.white70),
                  ),
                  SizedBox(
                    height: screenSize.height / 20,
                  ),
                  // Container(
                  //   width: screenWidth,
                  //   height: screenHeight / 3.2,
                  //   decoration: const BoxDecoration(color: subTitles),
                  //   margin: const EdgeInsets.symmetric(horizontal: 50),
                  //   child: ProfilePhotoUpdater(
                  //     ontap: () async {
                  //       avatar = (await pickImage()) ?? avatar;
                  //       setState(() {});
                  //     },
                  //     avatar: avatar,
                  //   ),
                  // ),
                  // const SizedBox(height: 15),

                  Stack(
                    children: [
                      Container(
                        height: screenSize.width / 2,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              strokeAlign: BorderSide.strokeAlignOutside,
                              width: 4,
                              color: Colors.blue,
                            )),
                        child: _imageFile == null
                            ? CircleAvatar(
                                backgroundImage: provider
                                            .currentUser!.imagePath !=
                                        null
                                    ? NetworkImage(
                                        provider.currentUser!.imagePath!,
                                      ) as ImageProvider
                                    : const AssetImage('assets/images/def.png'),
                                radius: 100,
                              )
                            : CircleAvatar(
                                radius: 100,
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton.filled(
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.blueAccent)),
                            color: Colors.white,
                            onPressed: () {
                              _showImagePickerOptions(context);
                            },
                            icon: const Icon(Icons.edit)),
                      ),
                    ],
                  ),

                  Form(
                    key: editUserProfileKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: Column(
                        children: [
                          MyCustomTextField(
                            label: 'Name',
                            controller: _nameController,
                            validator: (value) {
                              RegExp regx = RegExp(r'^[a-z A-Z]+$');
                              if (!regx.hasMatch(value as String)) {
                                return 'Enter valid name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: screenSize.height / 60,
                          ),
                          MyCustomTextField(
                            label: 'Phone Number',
                            controller: _phoneController,
                            type: TextInputType.phone,
                            validator: (value) {
                              RegExp regx = RegExp(r'^([9876]{1})(\d{9})$');
                              if (!regx.hasMatch(value as String)) {
                                return 'Enter valid phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: screenSize.height / 60,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            maxLines: 3,
                            controller: _addressController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              focusColor: detailsDescriptionBackgroundColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              label: const Text(
                                'Address',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter valid address';
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: screenSize.height / 60,
                          ),
                          MyButton(
                              onPressed: () async {
                                if (editUserProfileKey.currentState!
                                    .validate()) {
                                  await updateUser();
                                  provider.loadUser(
                                      email: provider.currentUser!.email);
                                  Provider.of<SneakerShopProvider>(context,
                                          listen: false)
                                      .notifyListeners();
                                  showCustomSnackBar('Success', Colors.green);
                                } else {
                                  showCustomSnackBar(
                                      'Enter valid data', Colors.red);
                                }
                              },
                              color: Colors.green[600],
                              data: 'Update Profile'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.blueAccent,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Colors.white,
                ),
                title: const Text(
                  'Pick from Gallery',
                  style: modalText,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                title: const Text(
                  'Take a Photo',
                  style: modalText,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
