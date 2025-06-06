import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_inventory_tracking_app/firebase_options.dart';
import 'package:food_inventory_tracking_app/pages/Inventory/add_inventory.dart';
import 'package:food_inventory_tracking_app/pages/Inventory/inventory.dart';
import 'package:food_inventory_tracking_app/pages/auth/login_page.dart';
import 'package:food_inventory_tracking_app/pages/bottom_navigation/bottom_navigation.dart';
import 'package:food_inventory_tracking_app/pages/recipe/provider/recipe_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RecipeProvider())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BottomNavigation(),
    );
  }
}
