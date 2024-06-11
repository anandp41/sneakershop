import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:sneaker_shop/model/shoemodel.dart';
import 'package:sneaker_shop/model/usermodel.dart';
import 'package:sneaker_shop/repositories/common_firebase_repository.dart';

import '../core/strings.dart';
import '../functions/functions.dart';
import '../model/adminmodel.dart';
import '../model/revenuemodel.dart';
import '../model/status_adapter.dart';

//import 'package:sneaker_shop/support/enum_status.dart';
var firestore = FirebaseFirestore.instance;

/// **********************ADMIN FUNCTIONS***********************/
Future<void> addBrandToDb({required String brand}) async {
  await firestore
      .collection(firebaseBrandsCollection)
      .doc(brand)
      .set({brand: brand});
}

Future<void> addSneakerToDb({required ShoeModel shoe}) async {
  await firestore
      .collection(firebaseShoesCollection)
      .doc(shoe.shoeId.toString())
      .set(shoe.toMap());
}

// Future<void> updateSneakerWithImages(
//     {required List<String> sneakerImagePaths, required int shoeId}) async {}

Future<void> updateSneakerInDb({required ShoeModel shoe}) async {
  await firestore
      .collection(firebaseShoesCollection)
      .doc(shoe.shoeId)
      .set(shoe.toMap());
}

Future<void> deleteSneakerFromDb({required String sneakerId}) async {
  var shoeMap =
      await firestore.collection(firebaseShoesCollection).doc(sneakerId).get();
  var shoe = ShoeModel.fromMap(shoeMap.data()!);
  if (shoe.imagePath.isNotEmpty) {
    for (var path in shoe.imagePath) {
      await deleteFile(serverFilePath: path);
    }
  }

  await firestore.collection(firebaseShoesCollection).doc(sneakerId).delete();
}

Future<void> deleteBrandFromDb({required String name}) async {
  await firestore.collection(firebaseBrandsCollection).doc(name).delete();
}

// Future getSneakerById(int id) async {
//   var productsBox = await Hive.openBox<ShoeModel>('productsbox');
//   return productsBox.get(id);
// }

// Future<void> signUpUser(UserData newUser) async {
//   var usersBox = await Hive.openBox<UserData>('usersbox');
//   await usersBox.add(newUser);
// }

Future<bool> checkIfEmailExist(String email) async {
  bool result = false;
  var usersList = await firestore.collection(firebaseUsersCollection).get();
  for (var doc in usersList.docs) {
    if (doc.data()['email'] == email) {
      result = true;
    }
  }
  return result;
}

Future<bool> doesEmailPasswordMatch(
    {required String email, required String password}) async {
  bool result = false;
  var doc =
      await firestore.collection(firebaseUsersCollection).doc(email).get();

  if (doc.data()!['email'] == email && doc.data()!['password'] == password) {
    result = true;
  }

  return result;
}

Future<AdminData> adminLogin() async {
  var adminDoc =
      await firestore.collection(firebaseUsersCollection).doc('admin').get();
  var adminMap = adminDoc.data();
  AdminData admin = AdminData.fromMap(adminMap!);
  return admin;
}

Future<void> saveUserDataToFirebase({
  required UserData userData,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection(firebaseUsersCollection)
        .doc(userData.email)
        .set(userData.toMap());
  } catch (e) {
    showCustomSnackBar(message: e.toString());
  }
}

// ///***********************END OF ADMIN FUNCTIONS**************************
// ///
// ///***********************START OF USER FUNCTIONS*************************/
// ///
// ///
// ///
Future<void> addToRevenue({
  required int size,
  required double amount,
  required String sneakerId,
  required int number,
  required String email,
}) async {
  DateTime dateTime = DateTime.now();
  RevenueData revenueData = RevenueData(
      size: size,
      amount: amount,
      sneakerId: sneakerId,
      number: number,
      dateTime: dateTime,
      email: email,
      transactionId: "$email/$dateTime",
      orderStatus: Status.ordered);

  await firestore
      .collection(firebaseRevenueCollection)
      .doc("${revenueData.email}-${dateTime.toString().replaceAll(' ', '_')}")
      .set(revenueData.toMap());
}

Future<void> updateUserToDB({required UserData updatedUser}) async {
  await FirebaseFirestore.instance
      .collection(firebaseUsersCollection)
      .doc(updatedUser.email)
      .set(updatedUser.toMap());
}

Future<void> updateStatus(
    {required Status newStatus, required String id}) async {
  await firestore
      .collection(firebaseRevenueCollection)
      .doc(id)
      .set({'orderStatus': newStatus.toString()});
}


///***********************END OF USER FUNCTIONS***************************/