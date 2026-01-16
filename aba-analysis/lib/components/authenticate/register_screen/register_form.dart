import 'dart:collection';

import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/aba_user.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../auth_default_button.dart';
import '../auth_input_decoration.dart';
import '../form_error_text.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({ Key? key }) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  // Form Key
  final _formKey = GlobalKey<FormState>();

  // auth instance
  AuthService auth = AuthService();
  FireStoreService fireStore = FireStoreService();

  // 이메일 & 패스워드 & 이름 휴대 전화 번호
  String email = '';
  String password = '';
  String confirmPassword = '';
  String name = '';
  String phone = '';

  HashSet<String> errors = new HashSet(); 

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(padding)
        ),
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(0.1)),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: buildAuthInputDecoration('이메일', Icons.email),
              onChanged: (String? val) {
                setState(() {
                  email = val!;
                  if (val.isNotEmpty) {
                    setState(() => errors.remove(kEmailNullError));
                  }
                  if (emailValidatorRegExp.hasMatch(val)) {
                    setState(() => errors.remove(kInvalidEmailError));
                  }
                });
              },
            ),
            SizedBox(height: getProportionateScreenHeight(0.03)),
            TextFormField(
              textInputAction: TextInputAction.next,
              obscureText: true,
              decoration: buildAuthInputDecoration('비밀번호', Icons.lock),
              onChanged: (String? val) {
                setState(() {
                  password = val!;
                  if (val.isNotEmpty) {
                    setState(() => errors.remove(kPassNullError));
                  }
                  if (val.length >= 8) {
                    setState(() => errors.remove(kShortPassError));
                  }
                });
              },
            ),
            SizedBox(height: getProportionateScreenHeight(0.03)),
            TextFormField(
              textInputAction: TextInputAction.next,
              obscureText: true,
              decoration: buildAuthInputDecoration('비밀번호 확인', Icons.check),
              onChanged: (String? val) {
                setState(() {
                  confirmPassword = val!;
                  if (val.isNotEmpty) {
                    setState(() => errors.remove(kConfirmPassNullError));
                  }
                  if (password == confirmPassword) {
                    setState(() => errors.remove(kMatchPassError));
                  }
                });
              },
            ),
            SizedBox(height: getProportionateScreenHeight(0.03)),
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next, 
              decoration: buildAuthInputDecoration('닉네임', Icons.person),
              onChanged: (String? val) {
                setState(() {
                  name = val!;
                  if (val.isNotEmpty) {
                    setState(() => errors.remove(kNameNullError));
                  }
                });
              },
            ),
            SizedBox(height: getProportionateScreenHeight(0.02)),
            Column(
              children: errors.map((e) => FormErrorText(error: e)).toList(),
            ),
            Spacer(),
            AuthDefaultButton(
              text: '회원 가입',
              onPress: () async {
                if (await checkEmailForm() && checkPasswordAndConfirmPasswordForm() && 
                    checkNameForm()) {
                  // 회원가입 승인 요청
                  await fireStore.createUser(ABAUser(
                    email: email,
                    password: password,
                    nickname: name, 
                    duty: '치료사', 
                    approvalStatus: false,
                    deleteRequest: false,
                  ));                  

                  // 토스트 메시지
                  makeToast('회원가입 승인 요청이 되었습니다.');
                  Navigator.pop(context);
                }
              },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Future<bool> checkEmailForm() async {
    bool result = true;
    if (email.isEmpty) {
      setState(() => errors.add(kEmailNullError));
      result = false;
    }
    else if (!emailValidatorRegExp.hasMatch(email)) {
      setState(() => errors.add(kInvalidEmailError));
      result = false;
    }
    else if ((await fireStore.checkUserWithEmail(email))) {
      setState(() => errors.add(kExistedEmailError));
      result = false;
    }
    else if (!(await fireStore.checkUserWithEmail(email))) {
      setState(() => errors.remove(kExistedEmailError));
    }
    
    return result;
  }

  bool checkPasswordAndConfirmPasswordForm() {
    bool result = true;

    if(password.isEmpty) {
      setState(() => errors.add(kPassNullError));
      result = false;
    }
    else if(password.length < 8) {
      setState(() => errors.add(kShortPassError));
      result = false;

    }
    else if (confirmPassword.isEmpty) {
      setState(() => errors.add(kConfirmPassNullError));
      result = false;
    }
    else if (password != confirmPassword) {
      setState(() => errors.add(kMatchPassError));
      result = false;
    }
    return result;
  }

  bool checkNameForm() {
    bool result = true;
    if (name.isEmpty) {
      setState(() => errors.add(kNameNullError));
      result = false;
    }
    return result;
  }
}