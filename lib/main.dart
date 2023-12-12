import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/model/revenuemodel.dart';
import 'package:sneaker_shop/model/status_adapter.dart';
import 'package:sneaker_shop/model/string_adapter.dart';
import 'package:sneaker_shop/model/shoemodel.dart';
import 'package:sneaker_shop/model/usermodel.dart';
import 'package:sneaker_shop/providers/bottomnavbarprovider.dart';
import 'package:sneaker_shop/providers/cartprovider.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/admin/adminaddbrand.dart';
import 'package:sneaker_shop/screens/admin/adminaddshoes.dart';
import 'package:sneaker_shop/screens/admin/admindashboard.dart';
import 'package:sneaker_shop/screens/admin/admininventory.dart';
import 'package:sneaker_shop/screens/admin/adminmanageorders.dart';
import 'package:sneaker_shop/screens/admin/adminrevenue.dart';
import 'package:sneaker_shop/screens/admin/screen_admin_settings.dart';
import 'package:sneaker_shop/screens/adminlogin.dart';
import 'package:sneaker_shop/screens/user/allitems.dart';
import 'package:sneaker_shop/screens/user/cart.dart';
import 'package:sneaker_shop/screens/user/login.dart';
import 'package:sneaker_shop/screens/user/userdashboard.dart';
import 'model/adminmodel.dart';
import 'screens/screen_splash.dart';
import 'screens/user/screen_signup.dart';

const adminLogStatus = 'Admin Logged';
const userLogStatus = 'User Logged';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  // Hive.deleteBoxFromDisk('revenuebox');
  // debugPrint('cleared once');
  final appDocumentsDirectory = await getApplicationDocumentsDirectory();
  dynamic imagefolder = '${appDocumentsDirectory.path}/images';
  final newDirectory = Directory(imagefolder);
  if (!Hive.isAdapterRegistered(ShoeModelAdapter().typeId)) {
    Hive.registerAdapter(ShoeModelAdapter());
  }
  if (!Hive.isAdapterRegistered(StringAdapter().typeId)) {
    Hive.registerAdapter(StringAdapter());
  }
  if (!Hive.isAdapterRegistered(AdminDataAdapter().typeId)) {
    Hive.registerAdapter(AdminDataAdapter());
  }
  if (!Hive.isAdapterRegistered(UserDataAdapter().typeId)) {
    Hive.registerAdapter(UserDataAdapter());
  }

  if (!Hive.isAdapterRegistered(RevenueDataAdapter().typeId)) {
    Hive.registerAdapter(RevenueDataAdapter());
  }

  if (!Hive.isAdapterRegistered(StatusAdapter().typeId)) {
    Hive.registerAdapter(StatusAdapter());
  }

  if (!newDirectory.existsSync()) {
    newDirectory.createSync(recursive: true);
  }
  final adminBox = await Hive.openBox<AdminData>('AdminBox');
  if (adminBox.isEmpty) {
    final defaultAdmin =
        AdminData(adminName: 'Admin', password: 'Password@123');
    adminBox.add(defaultAdmin);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SneakerShopProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNavBarProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
      ],
      builder: (context, child) => MaterialApp(
        navigatorKey: context.read<SneakerShopProvider>().navigatorKey,
        routes: {
          '/allitems': (context) => const ScreenAllItems(),
          '/createuseraccount': (context) => const ScreenSignup(),
          '/userlogin': (context) => const ScreenUserLogin(),
          '/adminlogin': (context) => const ScreenAdminLogin(),
          '/admindashboard': (context) => const ScreenAdminDashboard(),
          '/userdashboard': (context) => ScreenUserDashboard(),
          '/adminaddbrand': (context) => const ScreenAdminAddBrand(),
          '/adminaddshoes': (context) => const ScreenAdminAddShoes(),
          '/admininventory': (context) => const ScreenInventory(),
          '/adminsettings': (context) => const ScreenAdminSettings(),
          '/cart': (context) => ScreenCart(),
          '/revenue': (context) => const ScreenRevenue(),
          '/manageorders': (context) => const ScreenManageOrders()
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: Typography.whiteRedmond,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue)),
            //colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber),
            // primaryColor: Colors.white,
            appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: Colors.white))),
        home: const Scaffold(
          body: ScreenSplash(),
        ),
      ),
    );
  }
}
