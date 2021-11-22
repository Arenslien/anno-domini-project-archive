import 'package:aba_analysis_local/provider/db_notifier.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis_local/theme.dart';
import 'package:aba_analysis_local/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => DBNotifier()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      final db = openDatabase(
        Path.join(await getDatabasesPath(), 'aba_analysis.db'),
        onCreate: (db, version) async {
          await db.execute(
              "CREATE TABLE child(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, birthday TEXT, gender TEXT)");
          await db.execute(
              "CREATE TABLE test(id INTEGER PRIMARY KEY AUTOINCREMENT, childId INTEGER, date TEXT, title TEXT, isInput INTEGER)");
          await db.execute(
              "CREATE TABLE testItem(id INTEGER PRIMARY KEY AUTOINCREMENT, testId INTEGER, childId INTEGER, programField TEXT, subField TEXT, subItem TEXT)");
          await db.execute(
              "CREATE TABLE programField(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT)");
          await db.execute(
              "CREATE TABLE subField(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, programFieldId INTEGER, item1 TEXT, item2 TEXT, item3 TEXT, item4 TEXT, item5 TEXT, item6 TEXT, item7 TEXT, item8 TEXT, item9 TEXT, item10 TEXT)");
        },
        version: 1,
      );
      context.read<DBNotifier>().initDB();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ABA Analysis',
      theme: theme(),
      routes: routes,
      initialRoute: '/splash_screen',
    );
  }
}
