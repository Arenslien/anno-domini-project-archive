import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_list/auth.dart';
import 'package:to_do_list/create.dart';
import 'package:to_do_list/list.dart';
import 'task.dart';
import 'loginPage.dart';
import 'signupPage.dart';
import 'findPassword.dart';
import 'home.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TODOApp());
}

class TODOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TODO();
  }
}

class TODO extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TODOState();
  }
}

class TODOState extends State<TODO> {
  // final Authentication auth = new Authentication();
  // FirebaseUser user;

  // FirebaseAuth.instance.
  // void onLogin(FirebaseUser user) {
  //   setState(() {
  //     this.user = user;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '할 일',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/create': (context) => TODOCreate(),
        '/list': (context) => TODOList(),
        '/login': (context) => LoginPage(),
        '/find_password': (context) => FindPasswordPage(),
        '/sign_up': (context) => SignupPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
