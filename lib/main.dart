import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:appwrite/appwrite.dart';

import 'package:users_auth/core/config/app_config.dart';
import 'package:users_auth/core/constants/appwrite_constants.dart';

import 'package:users_auth/data/repositories/auth_repository.dart';
import 'package:users_auth/data/repositories/inventory_repository.dart';

import 'package:users_auth/controllers/auth_controller.dart';
import 'package:users_auth/controllers/inventory_controller.dart';
import 'package:users_auth/presentation/pages/edit_material_page.dart';

import 'package:users_auth/presentation/pages/splash_page.dart';
import 'package:users_auth/presentation/pages/login_page.dart';
import 'package:users_auth/presentation/pages/register_page.dart';
import 'package:users_auth/presentation/pages/inventory_page.dart';
import 'package:users_auth/presentation/pages/add_material_page.dart';
import 'package:users_auth/presentation/pages/ingreso_page.dart';
import 'package:users_auth/presentation/pages/salida_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final client = AppwriteConfig.initClient();
  final account = Account(client);
  final databases = Databases(client);

  Get.put<Account>(account);
  Get.put<AuthRepository>(AuthRepository(account));
  Get.put<AuthController>(AuthController(Get.find<AuthRepository>()));
  Get.put<InventoryRepository>(InventoryRepository(databases));
  Get.put<InventoryController>(InventoryController(repository: Get.find<InventoryRepository>()));


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Control de Inventario',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: false,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashPage()),
        GetPage(name: '/LoginPage', page: () => LoginPage()),
        GetPage(name: '/RegisterPage', page: () => RegisterPage()),
        GetPage(name: '/InventoryPage', page: () => const InventoryPage()),
        GetPage(name: '/AddMaterialPage', page: () => const AddMaterialPage()),
        GetPage(name: '/IngresoPage', page: () => const IngresoPage()),
        GetPage(name: '/SalidaPage', page: () => const SalidaPage()),
        GetPage(name: '/EditMaterialPage', page: () => const EditMaterialPage()),

      ],
    );
  }
}
