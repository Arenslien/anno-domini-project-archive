import 'package:aba_analysis_local/constants.dart';
import 'package:aba_analysis_local/models/sub_field.dart';
import 'package:aba_analysis_local/provider/db_notifier.dart';
import 'package:provider/provider.dart';
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
      await context.read<DBNotifier>().connectDB();
      // Default SubField 값 확인
      // List<SubField> subFieldList = await context.read<DBNotifier>().database!.readAllSubFieldList();

      // if (subFieldList.isEmpty) {
      //   for (SubField subField in subFieldList) {
      //     context.read<DBNotifier>().database!.addSubField(subField);
      //   }
      // }
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
