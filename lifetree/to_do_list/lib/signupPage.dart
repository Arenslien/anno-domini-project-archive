import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _validation = false;
  String errorText = 'Input the Confirm Password!';
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  List<String> labelTexts = ['First Name', 'last Name', 'ID', 'Password', 'Confirm Password'];
  List<bool> _checked = [false, false, false, false, false];

  Future<void> addUser2(String firstName, String lastName, String id, String password) {
    Map<String, Object> userInformation = {
      'first name': firstName,
      'last name': lastName,
      'password': password,
    };

    return users
        .doc(id)
        .set(userInformation)
        .then((value) => print("User Added"))
        .catchError((error) => print('Failed to add user: $error'));
  }

  void onPressed() async {
    if (checkAllField() && checkPasswordField() && !(await checkID())) {
        setState(() {
        _validation = true;
        });
      } else {
        setState(() {
        _validation = false;
        });
      }
    if (_validation) {
      addUser2(controllers[0].text, controllers[1].text, controllers[2].text, controllers[3].text);
    }
  }


  bool checkAllField() {
    bool check = true;
    setState(() {
      for (int i = 0; i < 5; i++) {
        if (controllers[i].text.isEmpty) {
          _checked[i] = true;
          check = false;
          if(i == 3) {
            errorText = "Input the Confirm Password!";
          } 
        } else {
          _checked[i] = false;
        }
      }
    });

    if (check) {
      return true;
    } else {
      return false;
    }
  }


  bool checkPasswordField() {
    if (controllers[3].text == controllers[4].text) {
      return true;
    } else {
      setState(() {
        _checked[4] = true;
        errorText = 'Reconfirm password!';
      });
      return false;
    }
  }


  Future<bool> checkID() async {
    bool _exist;
    await users.doc(controllers[2].text).get().then((DocumentSnapshot snapshot) {
      _exist = snapshot.exists;
    });
    return _exist;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign up')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 200.0, 20.0, 150.0),
          child: Center(
            child: Form(
                child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // 성에 대한 텍스트 필드
                    SizedBox(
                      width: 190.0,
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "First Name",
                            errorText:
                                _checked[0] ? 'Input the First Name!' : null,
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.text,
                        controller: controllers[0],
                      ),
                    ),
                    SizedBox(width: 20.0),
                    // 이름에 대한 텍스트 필드
                    Expanded(
                      child: SizedBox(
                        width: 100.0,
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Last Name",
                              errorText:
                                  _checked[1] ? 'Input the last Name!' : null,
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.text,
                          controller: controllers[1],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),

                //id에 대한 텍스트 필드
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "ID",
                      errorText: _checked[2] ? 'Input the ID!' : null,
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.text,
                  controller: controllers[2],
                ),
                SizedBox(height: 20.0),

                //password에 대한 텍스트 필드
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Password",
                      errorText: _checked[3] ? 'Input the Password!' : null,
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.text,
                  controller: controllers[3],
                  obscureText: true,
                ),
                SizedBox(height: 20.0),

                //confirm password에 대한 텍스트 필드
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Confirm Password",
                      errorText: _checked[4] ? errorText : null,
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.text,
                  controller: controllers[4],
                ),
                SizedBox(height: 20.0),

                //register 버튼
                FlatButton(
                  color: Colors.purple,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  minWidth: double.infinity,
                  onPressed: onPressed,
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}