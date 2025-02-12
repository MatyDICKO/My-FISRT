import 'package:exercice/models/HomePage.dart';
import 'package:exercice/models/categories.dart';
//import 'Widgets/menu.dart';
import 'package:flutter/material.dart';
import 'Widgets/db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser sqflite pour Windows
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await DBHelper.initializeDB();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        colorSchemeSeed: Colors.black38,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: MenuScreen(),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        '/categories': (context) => CategoriesPage(),
      },
    );
  }
}