import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sneaker_shop/db/dbhelper.dart';
import 'package:sneaker_shop/model/revenuemodel.dart';
import 'package:sneaker_shop/model/shoemodel.dart';
import 'package:sneaker_shop/model/usermodel.dart';
import 'package:sneaker_shop/repositories/common_firebase_repository.dart';

import '../core/strings.dart';

class SneakerShopProvider extends ChangeNotifier {
  String? selectedBrand;
  ShoeModel? selectedShoe;
  FilePickerResult? pickedFiles;
  List<String> copiedPaths = [];
  List<String> tempPreviewPaths = [];
  // List<String> pathsToDeleteFromStoragePermanently = [];
  List brands = [];
  List<ShoeModel> products = [];
  String? tempProfPath;

  /// *******************START OF ADMIN FUNCTIONS*******************/
  void loadSavedImagesPaths(List<String> imagesPath) {
    tempPreviewPaths = List.from(imagesPath);

    debugPrint('loadSavedImagesPaths $tempPreviewPaths ');
  }

  Future<void> pickImages() async {
    pickedFiles = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: true,
    );
    if (pickedFiles != null) {
      for (var element in pickedFiles!.paths) {
        if (!tempPreviewPaths.contains(element)) {
          tempPreviewPaths.add(element!);
        }
      }
      for (var x in tempPreviewPaths) {
        debugPrint('in tempPreviewPathList $x');
      }
    }
  }

  FilePickerResult? pickedFile;

  Future<void> pickProfileImage() async {
    pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );
    if (pickedFile != null) {
      tempProfPath = pickedFile!.paths[0];
    }
  }

  // Future<void> deleteTheseImageFiles(List<String> paths) async {
  //   for (String path in paths) {
  //     if (!tempPreviewPaths.contains(path)) {
  //       if (await File(path).exists()) {
  //         await File(path).delete(recursive: true);
  //       }
  //     }
  //   }
  //   // pathsToDeleteFromStoragePermanently.clear();
  // }

  // void queuePathForPermanentDeletion(String path) {
  //   pathsToDeleteFromStoragePermanently.add(path);
  // }

  void deleteImageFromPanel(String path) {
    tempPreviewPaths.remove(path);
    notifyListeners();
    // queuePathForPermanentDeletion(path);
  }

  void clearTempPreviewPaths() {
    tempPreviewPaths = [];

    pickedFiles = null;
  }

  Future<void> saveSelectedImagesinApplicationDirectory(
      {required String shoeId}) async {
    copiedPaths = await storeMultipleFilesToFirebase(
        serverFilePath: shoeId, paths: tempPreviewPaths);
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  List<Map<String, int>> mappedListOfSizesAndStock = [];
  // putSneakerById(int id) async {
  //   // var boxOfProducts = await Hive.openBox<ShoeModel>('productsbox');
  //   selectedShoe = boxOfProducts.get(id);
  // }

  Future<bool> checkIfBrandAlreadyExist(String nameToSearch) async {
    var brandsMap = await firestore.collection(firebaseBrandsCollection).get();
    var brands = brandsMap.docs;
    for (var eachBrand in brands) {
      var name = eachBrand.id;
      return name == nameToSearch;
    }
    return false;
  }

  void receiveListOfMap(List<Map<String, int>> map) {
    mappedListOfSizesAndStock = map;
  }

  bool doClearAllDataInDynamicTextfield = false;
  void clearAllDataInDynamicTextfield() {
    doClearAllDataInDynamicTextfield = true;
    notifyListeners();
  }

  Future<void> getBrandData() async {
    brands.clear();
    var brandsList = await firestore.collection(firebaseBrandsCollection).get();
    var data = brandsList.docs;
    for (var item in data) {
      brands.add(item.id);
    }

    notifyListeners();
  }

  Future<void> getBrandDataForWishList() async {
    brands.clear();
    var brandsList = await firestore.collection(firebaseBrandsCollection).get();
    var data = brandsList.docs;
    for (var item in data) {
      brands.add(item.id);
    }
  }

  Future<void> getAllStock() async {
    var map = await firestore.collection(firebaseShoesCollection).get();
    var data = map.docs;
    products.clear();
    for (var item in data) {
      var shoeFromMap = ShoeModel.fromMap(item.data());
      products.add(shoeFromMap);
    }
    notifyListeners();
  }

  Future<void> getAllStockForWishList() async {
    var map = await firestore.collection(firebaseShoesCollection).get();
    var data = map.docs;
    products.clear();
    for (var item in data) {
      var shoeFromMap = ShoeModel.fromMap(item.data());
      products.add(shoeFromMap);
    }
  }

  ShoeModel returnShoeFromProductsList({required String shoeId}) {
    for (var shoe in products) {
      if (shoe.shoeId == shoeId) {
        return shoe;
      }
    }
    return products[0];
  }

  List revenue = [];
  Future<void> getRevenue() async {
    var map = await firestore.collection(firebaseRevenueCollection).get();
    var data = map.docs;
    revenue.clear();
    for (var item in data) {
      var revenueFromMap = RevenueData.fromMap(item.data());
      revenue.add(revenueFromMap);
    }
    revenue = revenue.reversed.toList();
    notifyListeners();
  }

  List orders = [];
  Future<void> getUsersOrders() async {
    var map = await firestore.collection(firebaseRevenueCollection).get();
    var data = map.docs;
    orders.clear();
    for (var item in data) {
      var revenueFromMap = RevenueData.fromMap(item.data());
      if (revenueFromMap.email == currentUser!.email) {
        orders.add(revenueFromMap);
      }
    }
    orders = orders.reversed.toList();
    // notifyListeners();
  }

  // Future<void> clearRevenueDB() async {
  //   var revenueBox = await Hive.openBox<RevenueData>('revenuebox');

  //   revenueBox.clear();

  //   getRevenue();
  //   notifyListeners();
  // }

  // Future<void> clearProductsDB() async {
  //   var shoesBox = await Hive.openBox<ShoeModel>('productsbox');

  //   shoesBox.clear();

  //   getAllStock();
  //   notifyListeners();
  // }

  // Future<bool> isProductsEmpty() async {
  //   // var boxOfProducts = await Hive.openBox('productsbox');
  //   return boxOfProducts.isEmpty;
  // }

  // void adminLogout() async {
  //   await Hive.close();
  //   navigatorKey.currentState!.pushNamedAndRemoveUntil(
  //     '/userlogin',
  //     (route) => false,
  //   );
  // }

  ///***********************END OF ADMIN FUNCTIONS******************/
  ///***********************START OF USER FUNCTIONS*****************/
  List<ShoeModel> newProductsList = [];
  List<ShoeModel> oldProductsList = [];
  UserData? currentUser;
  int? selectedSize;
  void setSelectedSizeNull() {
    selectedSize = null;
  }

  bool isSelectedSizeNull() {
    if (selectedSize == null) {
      return true;
    } else {
      return false;
    }
  }

  void setSelectedSize({required int size}) {
    if (selectedSize != size) {
      selectedSize = size;
    } else {
      selectedSize = null;
    }
    notifyListeners();
  }

  bool shoesBoxEmpty = true;
  Future<void> loadSortedProductsList() async {
    var map = await firestore.collection(firebaseShoesCollection).get();
    var data = map.docs;
    newProductsList.clear();
    oldProductsList.clear();
    for (var item in data) {
      var shoeFromMap = ShoeModel.fromMap(item.data());
      if (shoeFromMap.isNew) {
        newProductsList.add(shoeFromMap);
      } else {
        oldProductsList.add(shoeFromMap);
      }
    }
  }

  List<ShoeModel> favshoes = [];

  // Future<void> loadFavoriteShoes() async {
  //   favshoes.clear();
  //   await getAllStock();
  //   if (currentUser!.favList.isNotEmpty) {
  //     for (var id in currentUser!.favList) {
  //       // debugPrint('favList id $id');
  //       // debugPrint(products.length.toString());
  //       favshoes.add(products.singleWhere((shoe) => shoe.shoeId == id));
  //     }
  //   }
  //   notifyListeners();
  // }

  // void unLoadFavoriteShoes() {
  //   favshoes.clear();
  // }

  Future<void> loadUser({required String email}) async {
    var userDoc =
        await firestore.collection(firebaseUsersCollection).doc(email).get();
    currentUser = UserData.fromMap(userDoc.data()!);
    // notifyListeners();
  }

  // var usersBox = await Hive.openBox<UserData>('usersbox');
  // currentUser =
  //     usersBox.values.singleWhere((element) => element.email == email);
  // // currentUser!.cart.clear();
  // // currentUser!.save();
  // await loadSortedProductsList();
  // // currentUser!.favList = [];
  // // currentUser!.save();
  // await getAllStock();
  // await loadFavoriteShoes();
  //}

  void unLoadUser() {
    currentUser = null;
  }

  Future<void> addToFavList({required String idToAdd}) async {
    if (!currentUser!.favList.contains(idToAdd)) {
      List<String> newList = [...currentUser!.favList, idToAdd];
      await firestore
          .collection(firebaseUsersCollection)
          .doc(currentUser!.email)
          .update({'favList': newList});
      await loadUser(email: currentUser!.email);
      notifyListeners();
    }
  }

  Future<void> removeFromFavList({required String idToRemove}) async {
    if (currentUser!.favList.contains(idToRemove)) {
      List<String> newList = currentUser!.favList;
      newList.remove(idToRemove);
      await firestore
          .collection(firebaseUsersCollection)
          .doc(currentUser!.email)
          .update({'favList': newList});
      await loadUser(email: currentUser!.email);
      notifyListeners();
    }
  }

  bool isThisSneakerAFavorite({required String idToCheck}) {
    return currentUser!.favList.contains(idToCheck);
  }

  int showCartcount() {
    int cartCount = 0;
    for (Map<String, dynamic> map in currentUser!.cart) {
      cartCount = cartCount + map['Quantity']! as int;
    }
    return cartCount;
  }

  Future<void> addToCart({required String sneakerId, required int size}) async {
    for (Map<String, dynamic> map in currentUser!.cart) {
      if (map['SneakerId'] == sneakerId && map['Size'] == size) {
        var newMapToReplace = map;
        newMapToReplace['Quantity']++;
        var newCart = currentUser!.cart;
        newCart.remove(map);
        newCart.add(newMapToReplace);
        await firestore
            .collection(firebaseUsersCollection)
            .doc(currentUser!.email)
            .update({'cart': newCart});
        // map['Quantity']++;
        // await currentUser!.save();

        notifyListeners();
        return;
      }
    }
    Map<String, dynamic> map = {
      'SneakerId': sneakerId,
      'Size': size,
      'Quantity': 1
    };
    List<Map<String, dynamic>> newCart = currentUser!.cart;
    newCart.add(map);
    await firestore
        .collection(firebaseUsersCollection)
        .doc(currentUser!.email)
        .update({'cart': newCart});

    notifyListeners();
  }

  Future<void> removeFromCart(
      {required String sneakerId, required int size}) async {
    currentUser!.cart.removeWhere((element) =>
        element['SneakerId'] == sneakerId && element['Size'] == size);
    var newCart = currentUser!.cart;
    await firestore
        .collection(firebaseUsersCollection)
        .doc(currentUser!.email)
        .update({'cart': newCart});

    notifyListeners();
  }

  Future<void> incrementASneakerCountInCart(
      {required String sneakerId, required int size}) async {
    for (int i = 0; i < currentUser!.cart.length; i++) {
      if (currentUser!.cart[i]['SneakerId'] == sneakerId &&
          currentUser!.cart[i]['Size'] == size) {
        if (currentUser!.cart[i]['Quantity'] != 10) {
          currentUser!.cart[i]['Quantity'] =
              currentUser!.cart[i]['Quantity']! + 1;
        }
        break;
      }
    }
    var newCart = currentUser!.cart;
    await firestore
        .collection(firebaseUsersCollection)
        .doc(currentUser!.email)
        .update({'cart': newCart});

    notifyListeners();
  }

  Future<void> decrementASneakerCountInCart(
      {required String sneakerId, required int size}) async {
    for (int i = 0; i < currentUser!.cart.length; i++) {
      if (currentUser!.cart[i]['SneakerId'] == sneakerId &&
          currentUser!.cart[i]['Size'] == size) {
        if (currentUser!.cart[i]['Quantity'] != 1) {
          currentUser!.cart[i]['Quantity'] =
              currentUser!.cart[i]['Quantity']! - 1;
        }
        break;
      }
    }
    var newCart = currentUser!.cart;
    await firestore
        .collection(firebaseUsersCollection)
        .doc(currentUser!.email)
        .update({'cart': newCart});

    notifyListeners();
  }

  Future<bool> stockLimitReached(
      {required String sneakerId,
      required int size,
      required currentCartQuantity}) async {
    late int currentStock;

    var shoeMap = await firestore
        .collection(firebaseShoesCollection)
        .doc(sneakerId)
        .get();
    var shoe = ShoeModel.fromMap(shoeMap.data()!);
    for (var map in shoe.availableSizesandStock) {
      if (map['Size'] == size) {
        currentStock = map['Stock']!;
      }
    }

    bool result = currentCartQuantity == currentStock;

    return result;
  }

  Future<bool> stockNotSufficient(
      {required int quantity,
      required String sneakerId,
      required int size}) async {
    // var shoesBox = await Hive.openBox<ShoeModel>('productsbox');
    // for (ShoeModel shoe in shoesBox.values) {
    //   if (shoe.shoeId == sneakerId) {
    var shoeMap = await firestore
        .collection(firebaseShoesCollection)
        .doc(sneakerId)
        .get();
    var shoe = ShoeModel.fromMap(shoeMap.data()!);
    for (Map<String, int> sizeAndStock in shoe.availableSizesandStock) {
      if (sizeAndStock['Size'] == size) {
        return (quantity > sizeAndStock['Stock']!);
      }
    }
    //   }
    // }
    return false;
  }

  Future<String> getImagePathofThisId({required String sneakerId}) async {
    var shoeMap = await firestore
        .collection(firebaseShoesCollection)
        .doc(sneakerId)
        .get();
    var shoe = ShoeModel.fromMap(shoeMap.data()!);
    return shoe.imagePath[0];
  }

  Future<String> getNameofThisId({required String sneakerId}) async {
    var shoeMap = await firestore
        .collection(firebaseShoesCollection)
        .doc(sneakerId)
        .get();
    var shoe = ShoeModel.fromMap(shoeMap.data()!);
    return shoe.name;
  }

  Future<double> getPriceofThisId({required String sneakerId}) async {
    var shoeMap = await firestore
        .collection(firebaseShoesCollection)
        .doc(sneakerId)
        .get();
    var shoe = ShoeModel.fromMap(shoeMap.data()!);
    return shoe.price;
  }

  Future<double> totalAmountDue() async {
    double amount = 0;
    await loadUser(email: currentUser!.email);
    // notifyListeners();
    for (Map<String, dynamic> map in currentUser!.cart) {
      if (!await stockNotSufficient(
          sneakerId: map['SneakerId'],
          quantity: map['Quantity'],
          size: map['Size'])) {
        amount += (await getPriceofThisId(sneakerId: map['SneakerId']) *
            map['Quantity']);
      }
    }
    return amount;
  }

  Future<void> checkOut() async {
    double amountToRevenue = 0;
    List<Map<String, dynamic>> toDeleteAfterCheckOut = [];
    for (Map<String, dynamic> itemInCart in currentUser!.cart) {
      var shoeMap = await firestore
          .collection(firebaseShoesCollection)
          .doc(itemInCart['SneakerId'])
          .get();
      var shoeInBox = ShoeModel.fromMap(shoeMap.data()!);
      for (Map<String, int> aSizeOfAShoeInBox
          in shoeInBox.availableSizesandStock) {
        if (aSizeOfAShoeInBox['Size'] == itemInCart['Size'] &&
            aSizeOfAShoeInBox['Stock']! > 0 &&
            aSizeOfAShoeInBox['Stock']! >= itemInCart['Quantity']!) {
          aSizeOfAShoeInBox['Stock'] =
              aSizeOfAShoeInBox['Stock']! - itemInCart['Quantity']! as int;
          amountToRevenue +=
              (await getPriceofThisId(sneakerId: itemInCart['SneakerId']!) *
                  itemInCart['Quantity']!);
          await addToRevenue(
            size: itemInCart['Size']!,
            amount: amountToRevenue,
            sneakerId: itemInCart['SneakerId']!,
            number: itemInCart['Quantity']!,
            email: currentUser!.email,
          );
          toDeleteAfterCheckOut.add(itemInCart);
        }
      }
    }

    for (var item in toDeleteAfterCheckOut) {
      currentUser!.cart.removeWhere((element) =>
          (element['SneakerId'] == item['SneakerId'] &&
              element['Size'] == item['Size']));
    }
    toDeleteAfterCheckOut.clear();
    var newCart = currentUser!.cart;
    await firestore
        .collection(firebaseUsersCollection)
        .doc(currentUser!.email)
        .update({'cart': newCart});

    getUsersOrders();
  }

  Future<bool> isAddButtonOn() async {
    // var shoesBox = await Hive.openBox<ShoeModel>('productsbox');
    bool result = false;
    for (var element in currentUser!.cart) {
      var shoeMap = await firestore
          .collection(firebaseShoesCollection)
          .doc(element['SneakerId'])
          .get();
      var shoe = ShoeModel.fromMap(shoeMap.data()!);
      // for (var shoe in shoesBox.values) {
      //   if (element['SneakerId'] == shoe.shoeId) {
      for (var size in shoe.availableSizesandStock) {
        if (element['Size'] == size['Size'] &&
            element['Quantity']! <= size['Stock']!) {
          return true;
        }
      }
      //   }
      // }
    }

    return result;
  }
}

  ///***********************END OF USER FUNCTIONS*******************/

