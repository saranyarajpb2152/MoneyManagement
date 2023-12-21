import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneymanager/db/category/category_db.dart';
import 'package:moneymanager/models/transaction/transaction_model.dart';
import 'package:moneymanager/screens/add_transaction/screen_add_transaction.dart';
import 'package:moneymanager/screens/home/screen_home.dart';
import 'package:hive/hive.dart';
import 'package:moneymanager/models/category/category_model.dart';





Future<void> main() async {
  final obj1 = CategoryDB();
  final obj2 = CategoryDB();
  // print('objects comparing');
  // print(obj1 == obj2);

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }

  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }
  runApp(const MyApp());
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
      home: const Screenhome(),
      routes: {
        ScreenaddTransaction.routeName:(ctx)=> const ScreenaddTransaction(),
      },
    );
  }
}

