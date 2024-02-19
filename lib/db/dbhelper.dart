import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sneaker_shop/model/revenuemodel.dart';
import 'package:sneaker_shop/model/shoemodel.dart';
import 'package:sneaker_shop/model/status_adapter.dart';
import 'package:sneaker_shop/model/usermodel.dart';
//import 'package:sneaker_shop/support/enum_status.dart';

/// **********************ADMIN FUNCTIONS***********************/
Future<void> addBrandToDb({required String brand}) async {
  var brandsBox = await Hive.openBox<String>('brandsbox');
  await brandsBox.add(brand);
}

Future<int> addSneakerToDb({required ShoeModel shoe}) async {
  var productsBox = await Hive.openBox<ShoeModel>('productsbox');
  int id = await productsBox.add(shoe);
  shoe.shoeId = id;

  await shoe.save();
  return id;
}

Future<void> updateSneakerWithImages(
    {required List<String> sneakerImagePaths, required int shoeId}) async {
  debugPrint('UpdateSneakerWithImages');
  var productsBox = await Hive.openBox<ShoeModel>('productsbox');
  ShoeModel sneaker = productsBox.get(shoeId)!;
  sneaker.imagePath = sneakerImagePaths;
  await sneaker.save();
}

Future<void> updateSneakerInDb({required ShoeModel shoe}) async {
  var productsBox = await Hive.openBox<ShoeModel>('productsbox');
  await productsBox.put(shoe.shoeId, shoe);
}

Future<void> deleteSneakerFromDb({required int sneakerId}) async {
  var productsBox = await Hive.openBox<ShoeModel>('productsbox');
  Directory documentsDir = await getApplicationDocumentsDirectory();

  documentsDir = Directory('${documentsDir.path}/images/$sneakerId');
  if (await documentsDir.exists()) {
    await documentsDir.delete(recursive: true);
  }

  await productsBox.delete(sneakerId);
}

Future<void> deleteBrandFromDb({required String name}) async {
  var boxBrands = await Hive.openBox<String>('brandsbox');

  int index = boxBrands.values.toList().indexOf(name);
  await boxBrands.deleteAt(index);
}

Future getSneakerById(int id) async {
  var productsBox = await Hive.openBox<ShoeModel>('productsbox');
  return productsBox.get(id);
}

Future<void> signUpUser(UserData newUser) async {
  var usersBox = await Hive.openBox<UserData>('usersbox');
  await usersBox.add(newUser);
}

Future<bool> checkIfEmailExist(String email) async {
  var usersBox = await Hive.openBox<UserData>('usersbox');
  List<String> emailList = usersBox.values.map((e) => e.email).toList();
  return emailList.contains(email);
}

Future<bool> doesEmailPasswordMatch(
    {required String email, required String password}) async {
  var usersBox = await Hive.openBox<UserData>('usersbox');
  for (UserData element in usersBox.values) {
    if (element.email == email && element.password == password) {
      return true;
    }
  }
  return false;
}

Future<void> saveNewUserToDb(UserData newUser) async {
  var usersBox = await Hive.openBox<UserData>('usersbox');
  await usersBox.add(newUser);
}

void debugPrintBoxValues(Box box) {
  for (var key in box.keys) {
    UserData value = box.get(key);
    debugPrint('$key: ${value.email}|:${value.password}|');
  }
}

///***********************END OF ADMIN FUNCTIONS**************************
///
///***********************START OF USER FUNCTIONS*************************/
///
///
///
Future<void> addToRevenue({
  required int size,
  required double amount,
  required int sneakerId,
  required int number,
  required String email,
}) async {
  var revenueBox = await Hive.openBox<RevenueData>('revenuebox');
  DateTime dateTime = DateTime.now();
  RevenueData revenueData = RevenueData(
      size: size,
      amount: amount,
      sneakerId: sneakerId,
      number: number,
      dateTime: dateTime,
      email: email,
      orderStatus: Status.ordered);
  await revenueBox.add(revenueData).then((id) async {
    debugPrint('id is $id');
    revenueData.transactionId = id;
    await revenueData.save();
  });
}

Future<void> updateUserToDB({required UserData updatedUser}) async {
  var usersBox = await Hive.openBox<UserData>('usersbox');
  usersBox.values.singleWhere((element) => element.email == updatedUser.email);
  int index = usersBox.values.toList().indexOf(usersBox.values
      .singleWhere((element) => element.email == updatedUser.email));

  usersBox.putAt(index, updatedUser);
}

Future<void> updateStatus({required Status newStatus, required int id}) async {
  var revenueBox = await Hive.openBox<RevenueData>('revenuebox');

  var revenueData = revenueBox.get(id);
  revenueData!.orderStatus = newStatus;
  await revenueData.save();
}






///***********************END OF USER FUNCTIONS***************************/