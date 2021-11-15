import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis_local/theme.dart';
import 'package:aba_analysis_local/routes.dart';
import 'package:aba_analysis_local/provider/user_notifier.dart';
import 'package:aba_analysis_local/provider/test_notifier.dart';
import 'package:aba_analysis_local/provider/child_notifier.dart';
import 'package:aba_analysis_local/provider/test_item_notifier.dart';
import 'package:aba_analysis_local/provider/program_field_notifier.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserNotifier()),
    ChangeNotifierProvider(create: (_) => ChildNotifier()),
    ChangeNotifierProvider(create: (_) => ProgramFieldNotifier()),
    ChangeNotifierProvider(create: (_) => TestNotifier()),
    ChangeNotifierProvider(create: (_) => TestItemNotifier()),
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ABA Analysis',
      theme: theme(),
      routes: routes,
      initialRoute: '/wrapper',
    );
  }
}
