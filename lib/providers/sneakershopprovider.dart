import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sneaker_shop/db/dbhelper.dart';
import 'package:sneaker_shop/model/revenuemodel.dart';
import 'package:sneaker_shop/model/shoemodel.dart';
import 'package:sneaker_shop/model/usermodel.dart';

class SneakerShopProvider extends ChangeNotifier {
  String? selectedBrand;
  ShoeModel? selectedShoe;
  FilePickerResult? pickedFiles;
  List<String> copiedPaths = [];
  List<String> tempPreviewPaths = [];
  List<String> pathsToDeleteFromStoragePermanently = [];
  List brands = [];
  List products = [];
  String? tempProfPath;

  /// *******************START OF ADMIN FUNCTIONS*******************/
  void loadSavedImagesPaths(List<String> imagesPath) {
    tempPreviewPaths = List.from(imagesPath);

    debugPrint('loadSavedImagesPaths $tempPreviewPaths ');
  }

  String extractFileName(String path) {
    String fileName;

    // Find the last occurrence of '/' in the path
    int lastIndex = path.lastIndexOf('/');

    // Extract the substring after the last '/'
    if (lastIndex != -1 && lastIndex < path.length - 1) {
      fileName = path.substring(lastIndex + 1);
    } else {
      // If there's no '/' or it's the last character, use the whole path
      fileName = path;
    }

    return fileName;
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

  Future<void> deleteTheseImageFiles(List<String> paths) async {
    for (String path in paths) {
      if (!tempPreviewPaths.contains(path)) {
        if (await File(path).exists()) {
          await File(path).delete(recursive: true);
        }
      }
    }
    pathsToDeleteFromStoragePermanently.clear();
  }

  void queuePathForPermanentDeletion(String path) {
    pathsToDeleteFromStoragePermanently.add(path);
  }

  void deleteImageFromPanel(String path) {
    tempPreviewPaths.remove(path);
    notifyListeners();
    queuePathForPermanentDeletion(path);
  }

  void clearTempPreviewPaths() {
    tempPreviewPaths = [];

    pickedFiles = null;
  }

  Future<void> saveSelectedImagesinApplicationDirectory(
      {required int shoeId}) async {
    copiedPaths = [];

    // Get the app's documents directory

    for (int i = 0; i < tempPreviewPaths.length; i++) {
      debugPrint('the for loop inside');
      String fileName = extractFileName(tempPreviewPaths[i]);
      String filePath = tempPreviewPaths[i];

      // Get the app's documents directory
      Directory documentsDir = await getApplicationDocumentsDirectory();

      // Create the destination directory if it doesn't exist
      Directory destinationDir =
          Directory('${documentsDir.path}/images/$shoeId');
      if (!await destinationDir.exists()) {
        await destinationDir.create(recursive: true);
      }

      // Create a unique destination path for each file
      String destinationPath = '${destinationDir.path}/$fileName';
      // Copy the file to the documents directory
      File sourceFile = File(filePath);
      if (!await File(destinationPath).exists()) {
        await sourceFile.copy(destinationPath);
      }

      copiedPaths.add(destinationPath);
      debugPrint('copiedPaths working');
    }
    deleteTheseImageFiles(pathsToDeleteFromStoragePermanently);
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  List<Map<String, int>> mappedListOfSizesAndStock = [];
  putSneakerById(int id) async {
    var boxOfProducts = await Hive.openBox<ShoeModel>('productsbox');
    selectedShoe = boxOfProducts.get(id);
  }

  void adminLogin() async {
    // await Hive.openBox<TransactionData>('transactionsbox');
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      '/admindashboard',
      (route) => false,
    );
  }

  Future<void> checkIfBrandAlreadyExist(String name) async {
    var boxBrands = await Hive.openBox<String>('brandsbox');
    boxBrands.values.contains(name);
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
    var boxBrands = await Hive.openBox<String>('brandsbox');

    brands.clear();
    brands.addAll(boxBrands.values);
    debugPrint('getBrandData has been invoked');
    notifyListeners();
  }

  Future<void> getAllStock() async {
    var shoesBox = await Hive.openBox<ShoeModel>('productsbox');

    products.clear();
    products.addAll(shoesBox.values);
    notifyListeners();
  }

  List revenue = [];
  Future<void> getRevenue() async {
    var revenueBox = await Hive.openBox<RevenueData>('revenuebox');

    revenue.clear();
    revenue.addAll(revenueBox.values);
    revenue = revenue.reversed.toList();
    notifyListeners();
  }

  List orders = [];
  Future<void> getUsersOrders() async {
    var revenueBox = await Hive.openBox<RevenueData>('revenuebox');

    orders.clear();
    orders.addAll(revenueBox.values
        .where((element) => element.email == currentUser!.email));
    orders = orders.reversed.toList();

    notifyListeners();
  }

  Future<void> clearRevenueDB() async {
    var revenueBox = await Hive.openBox<RevenueData>('revenuebox');

    revenueBox.clear();

    getRevenue();
    notifyListeners();
  }

  Future<void> clearProductsDB() async {
    var shoesBox = await Hive.openBox<ShoeModel>('productsbox');

    shoesBox.clear();

    getAllStock();
    notifyListeners();
  }

  Future<bool> isProductsEmpty() async {
    var boxOfProducts = await Hive.openBox('productsbox');
    return boxOfProducts.isEmpty;
  }

  void adminLogout() async {
    await Hive.close();
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      '/userlogin',
      (route) => false,
    );
  }

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
    var shoesBox = await Hive.openBox<ShoeModel>('productsbox');
    newProductsList.clear();
    oldProductsList.clear();
    shoesBoxEmpty = shoesBox.isEmpty;
    newProductsList.addAll(
        shoesBox.values.where((ShoeModel sneaker) => sneaker.isNew == true));
    newProductsList = newProductsList.reversed.toList();
    oldProductsList.addAll(
        shoesBox.values.where((ShoeModel sneaker) => sneaker.isNew != true));
    oldProductsList = oldProductsList.reversed.toList();
    notifyListeners();
  }

  List<ShoeModel> favshoes = [];

  Future<void> loadFavoriteShoes() async {
    favshoes.clear();
    if (currentUser!.favList.isNotEmpty) {
      for (var id in currentUser!.favList) {
        // debugPrint('favList id $id');
        // debugPrint(products.length.toString());
        favshoes.add(products.singleWhere((shoe) => shoe.shoeId == id));
      }
    }
    notifyListeners();
  }

  void unLoadFavoriteShoes() {
    favshoes.clear();
  }

  Future<void> loadUser({required String email}) async {
    var usersBox = await Hive.openBox<UserData>('usersbox');
    currentUser =
        usersBox.values.singleWhere((element) => element.email == email);
    // currentUser!.cart.clear();
    // currentUser!.save();
    await loadSortedProductsList();
    // currentUser!.favList = [];
    // currentUser!.save();
    await getAllStock();
    await loadFavoriteShoes();
  }

  void unLoadUser() {
    currentUser = null;
    unLoadFavoriteShoes();
  }

  void addToFavList({required int idToAdd}) async {
    if (!currentUser!.favList.contains(idToAdd)) {
      currentUser!.favList.add(idToAdd);
      await currentUser!.save();
    }
    await loadFavoriteShoes();
  }

  Future<void> removeFromFavList({required int idToRemove}) async {
    if (currentUser!.favList.contains(idToRemove)) {
      currentUser!.favList.remove(idToRemove);
      await currentUser!.save();
    }
    await loadFavoriteShoes();
  }

  bool isThisSneakerAFavorite({required int idToCheck}) {
    return currentUser!.favList.contains(idToCheck);
  }

  int showCartcount() {
    int cartCount = 0;
    for (Map<String, int> map in currentUser!.cart) {
      cartCount = cartCount + map['Quantity']!;
    }
    return cartCount;
  }

  Future<double> totalAmountDue() async {
    double amount = 0;
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

  Future<void> addToCart({required int sneakerId, required int size}) async {
    for (Map<String, dynamic> map in currentUser!.cart) {
      if (map['SneakerId'] == sneakerId && map['Size'] == size) {
        map['Quantity']++;
        await currentUser!.save();

        notifyListeners();
        return;
      }
    }
    Map<String, int> map = {
      'SneakerId': sneakerId,
      'Size': size,
      'Quantity': 1
    };
    currentUser!.cart.add(map);
    await currentUser!.save();

    notifyListeners();
  }

  void removeFromCart({required int sneakerId, required int size}) async {
    currentUser!.cart.removeWhere((element) =>
        element['SneakerId'] == sneakerId && element['Size'] == size);

    await currentUser!.save();
    notifyListeners();
  }

  void incrementASneakerCountInCart(
      {required int sneakerId, required int size}) async {
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
    await currentUser!.save();
    notifyListeners();
  }

  void decrementASneakerCountInCart(
      {required int sneakerId, required int size}) async {
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

    await currentUser!.save();
    notifyListeners();
  }

  Future<bool> stockLimitReached(
      {required int sneakerId,
      required int size,
      required currentCartQuantity}) async {
    late int currentStock;

    var shoesBox = await Hive.openBox<ShoeModel>('productsbox');
    for (var shoe in shoesBox.values) {
      if (shoe.shoeId == sneakerId) {
        for (var map in shoe.availableSizesandStock) {
          if (map['Size'] == size) {
            currentStock = map['Stock']!;
          }
        }
      }
    }

    bool result = currentCartQuantity == currentStock;

    return result;
  }

  Future<bool> stockNotSufficient(
      {required int quantity,
      required int sneakerId,
      required int size}) async {
    var shoesBox = await Hive.openBox<ShoeModel>('productsbox');
    for (ShoeModel shoe in shoesBox.values) {
      if (shoe.shoeId == sneakerId) {
        for (Map<String, int> sizeAndStock in shoe.availableSizesandStock) {
          if (sizeAndStock['Size'] == size) {
            return (quantity > sizeAndStock['Stock']!);
          }
        }
      }
    }
    return false;
  }

  Future<String?> getImagePathofThisId({required int sneakerId}) async {
    var shoesBox = await Hive.openBox<ShoeModel>('productsbox');
    return shoesBox.get(sneakerId)!.imagePath[0];
  }

  Future<String> getNameofThisId({required int sneakerId}) async {
    var shoesBox = await Hive.openBox<ShoeModel>('productsbox');
    return shoesBox.get(sneakerId)!.name;
  }

  Future<double> getPriceofThisId({required int sneakerId}) async {
    var shoesBox = await Hive.openBox<ShoeModel>('productsbox');
    return shoesBox.get(sneakerId)!.price;
  }

  Future<void> checkOut() async {
    late double amountToRevenue;
    List<Map<String, int>> toDeleteAfterCheckOut = [];
    var shoesBox = await Hive.openBox<ShoeModel>('productsbox');

    for (Map<String, int> itemInCart in currentUser!.cart) {
      for (ShoeModel shoeInBox in shoesBox.values) {
        if (shoeInBox.shoeId == itemInCart['SneakerId']) {
          for (Map<String, int> aSizeOfAShoeInBox
              in shoeInBox.availableSizesandStock) {
            if (aSizeOfAShoeInBox['Size'] == itemInCart['Size'] &&
                aSizeOfAShoeInBox['Stock']! > 0 &&
                aSizeOfAShoeInBox['Stock']! >= itemInCart['Quantity']!) {
              aSizeOfAShoeInBox['Stock'] =
                  aSizeOfAShoeInBox['Stock']! - itemInCart['Quantity']!;
              amountToRevenue =
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
      }
    }

    for (var item in toDeleteAfterCheckOut) {
      currentUser!.cart.removeWhere((element) =>
          (element['SneakerId'] == item['SneakerId'] &&
              element['Size'] == item['Size']));
    }
    toDeleteAfterCheckOut.clear();
    await currentUser!.save();

    getUsersOrders();
  }

  Future<bool> isAddButtonOn() async {
    var shoesBox = await Hive.openBox<ShoeModel>('productsbox');
    bool result = false;
    for (var element in currentUser!.cart) {
      for (var shoe in shoesBox.values) {
        if (element['SneakerId'] == shoe.shoeId) {
          for (var size in shoe.availableSizesandStock) {
            if (element['Size'] == size['Size'] &&
                element['Quantity']! <= size['Stock']!) {
              result = true;
            }
          }
        }
      }
    }

    return result;
  }
}

  ///***********************END OF USER FUNCTIONS*******************/

