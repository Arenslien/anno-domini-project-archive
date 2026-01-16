import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  TextEditingController _idController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  String _idErrorText = "";
  String _pwErrorText = "";
  bool _idcheck = false;
  bool _pwcheck = false;

  

  void onPressed() async {
    if (checkAllField() && (await checkID()) && (await checkPassword(_pwController.text))) {
      Navigator.pushNamed(context, '/home');
    } else {}
  }

  bool checkAllField() {
    bool _check = true;
    setState(() {
      if(_idController.text.isEmpty) {
        _check = false;
        _idcheck = true;
        _idErrorText = "Input the ID!";
      } else {
        _idcheck = false;
      }
      if(_pwController.text.isEmpty) {
        _check = false;
        _pwcheck = true;
        _pwErrorText = "Input the Password!";
      } else {
        _pwcheck = false;
      }
    });

    return _check;
  }

  Future<bool> checkID() async {
    bool _exist;
    await users.doc(_idController.text).get().then((DocumentSnapshot snapshot) {
      _exist = snapshot.exists;
    }).catchError((error) => print('[ERROR] : $error'));
    return _exist;
  }

  Future<bool> checkPassword(String inputtedPW) async {
    String password;
    await users
        .doc(_idController.text)
        .get()
        .then((DocumentSnapshot snapshot) {
          password = snapshot.data()['password'];
        })
        .catchError((error) => print('[ERROR] : $error'));
    return inputtedPW == password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 250.0, 20.0, 150.0),
            child: Center(
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        controller: _idController,
                        decoration: InputDecoration(
                            errorText: _idcheck ? _idErrorText : null,
                            labelText: 'ID',
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.text),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _pwController,
                      decoration: InputDecoration(
                          errorText: _pwcheck ? _pwErrorText : null,
                          labelText: 'Password',
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),
                    FlatButton(
                      color: Colors.purple,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      minWidth: double.infinity,
                      onPressed: onPressed,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton(
                          child: Text('Forgot password?'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/find_password');
                          },
                        ),
                        TextButton(
                          child: Text('Create account'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/sign_up');
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
