import 'package:flutter/material.dart';
import 'package:calendar/constants.dart';
import 'package:calendar/screens/authentication/register.dart';

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  String _id = "";
  String _pw = "";
  
  Future<bool> onPressed() async {
      bool _result = false;
      // final id = await findId(_id);
      // final pw = await findPassword(_id);

      if (_id != "admin") {
        print("존재하지 않는 아이디입니다."); 
      } else if (_pw != "master") {
        print("비밀번호가 틀렸습니다.");
      } else {
        print("성공적으로 로그인 했습니다.");
        _result = true;
      }
      return _result;
    }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LOGIN',
              style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryLightColor),
            ),
            Container(
              width: size.width * 0.8,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person, color: Colors.white),
                  hintText: "ID",
                  hintStyle: TextStyle(color: Colors.grey[200]),
                  border: InputBorder.none
                ),
                onChanged: (id) {
                  setState(() {
                    _id = id;
                  });
                },
              ),
            ),
            Container(
              width: size.width * 0.8,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock, color: Colors.white),
                  hintText: "비밀번호",
                  hintStyle: TextStyle(color: Colors.grey[200]),
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.visibility, color: Colors.grey[200],)
                ),
                onChanged: (pw) {
                  _pw = pw;
                },
              ),
            ),
            
            ElevatedButton(
              child: Text("로그인"),
              style: ElevatedButton.styleFrom(
                primary: kPrimaryColor,
                minimumSize: Size(size.width * 0.8, 50),
                shape: StadiumBorder()
              ),
              onPressed: onPressed,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ID가 없으신가요?"),
                TextButton(
                  child: Text("회원가입"),
                  style: TextButton.styleFrom(primary: kPrimaryLightColor),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                  },
                )
              ],
            ),
            Divider(
              height: 20, 
              indent: size.width * 0.1,
              endIndent: size.width * 0.1,
              thickness: 2,
              color: kPrimaryLightColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1),
                    color: kPrimaryLightColor,
                  ),
                  height: 20,
                  width: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1),
                    color: Colors.green[300],
                  ),
                  height: 20,
                  width: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1),
                    color: Colors.green[300],
                  ),
                  height: 20,
                  width: 20,
                ),
              ],
            ),
          ],
        )
      );
  }
}