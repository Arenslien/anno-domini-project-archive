import 'dart:collection';

import 'package:aba_analysis/components/authenticate/auth_google_button.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/aba_user.dart';
import 'package:aba_analysis/provider/child_notifier.dart';
import 'package:aba_analysis/provider/field_management_notifier.dart';
import 'package:aba_analysis/provider/test_item_notifier.dart';
import 'package:aba_analysis/provider/test_notifier.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../auth_default_button.dart';
import '../auth_input_decoration.dart';
import '../form_error_text.dart';
import 'register_text.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  AuthService _auth = AuthService();

  FireStoreService _store = FireStoreService();

  final _formKey = GlobalKey<FormState>();
  // 텍스트 필드 값
  String email = '';
  String password = '';

  HashSet<String> errors = new HashSet();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(padding)),
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(0.1)),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: buildAuthInputDecoration('아이디(이메일)', Icons.email),
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
            SizedBox(
              height: getProportionateScreenHeight(0.03),
            ),
            TextFormField(
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
            SizedBox(
              height: getProportionateScreenHeight(0.01),
            ),
            SizedBox(height: getProportionateScreenHeight(0.01)),
            Column(
              children: errors.map((e) => FormErrorText(error: e)).toList(),
            ),
            SizedBox(height: getProportionateScreenHeight(0.02)),
            AuthDefaultButton(
              text: '로그인',
              onPress: () async {
                if (await checkEmailForm() && checkPasswordForm()) {
                  // 로그인 시도
                  String result = await _auth.signIn(email, password);
                  if (result != '로그인 성공') {
                    ScaffoldMessenger.of(context).showSnackBar(makeSnackBar(result, false));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(makeSnackBar(result, true));

                    // Provider 업데이트
                    ABAUser? abaUser = await _store.readUser(email);
                    context.read<ChildNotifier>().updateChildren(await _store.readAllChild(email));
                    context.read<FieldManagementNotifier>().updateProgramFieldList(await _store.readAllProgramField());
                    context.read<TestNotifier>().updateTestList(await _store.readAllTest());
                    context.read<TestItemNotifier>().updateTestItemList(await _store.readAllTestItem());
                    context.read<UserNotifier>().updateUser(abaUser);
                  }
                }
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(0.01),
            ),
            AuthGoogleButton(
              text: 'Sign in with Google',
              onPress: signInWithGoogle,
            ),
            RegisterText(),
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
    } else if (!emailValidatorRegExp.hasMatch(email)) {
      setState(() => errors.add(kInvalidEmailError));
      result = false;
    } else if ((await _store.readUser(email)) == null) {
      setState(() => errors.add(kNotExistEmailError));
      result = false;
    } else if ((await _store.readUser(email))!.password == null) {
      setState(() => errors.add(kExistGoogleEmailError));
      result = false;
    }
    return result;
  }

  bool checkPasswordForm() {
    bool result = true;
    if (password.isEmpty) {
      setState(() => errors.add(kPassNullError));
      result = false;
    } else if (password.length < 8) {
      setState(() => errors.add(kShortPassError));
      result = false;
    }
    return result;
  }

  Future<void> signInWithGoogle() async {
    // 구글로그인 클릭시

    // FirebaseAuth 싱클턴 객체를 갖고오고 GoogleSignIn 객체를 할당한다.
    GoogleSignIn googleSignIn = GoogleSignIn();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("User is currently signed out!");
      } else {
        print("User is signed in!");
      }
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account != null) {
      GoogleSignInAuthentication authentication = await account.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken,
      );

      UserCredential authResult = await auth.signInWithCredential(authCredential);
      // 로그인 결과에 따라 구글 로그인 정보를 받아온다.
      User? user = authResult.user;

      // 이메일로 유저를 읽어온다.
      ABAUser? abaUser = await _store.readUser(user!.email!);
      if (abaUser == null) {
        // 등록도 안되어있는 경우
        abaUser = ABAUser(email: user.email!, password: null, nickname: user.displayName == null ? "nickname1" : user.displayName!, duty: "치료사", approvalStatus: false, deleteRequest: false);
        await _store.createUser(abaUser);

        // 토스트 메시지
        makeToast('회원가입 승인 요청이 되었습니다.');
        FirebaseAuth.instance.signOut();
        GoogleSignIn().signOut();
      } else if (abaUser.approvalStatus == false) {
        // 아직 승인이 안된 회원인 경우
        makeToast('이미 승인 요청이 되어져 있습니다.');
        FirebaseAuth.instance.signOut();
        GoogleSignIn().signOut();
      } else if (abaUser.password != null) {
        // 일반 회원가입으로 가입한 경우
        makeToast('이메일이 이미 존재합니다. 일반 로그인으로 로그인해주세요.');
        FirebaseAuth.instance.signOut();
        GoogleSignIn().signOut();
      } else {
        // 로그인 성공. 데이터 읽기
        ScaffoldMessenger.of(context).showSnackBar(makeSnackBar('로그인 성공', true));
        abaUser = await _store.readUser(user.email!);
        context.read<ChildNotifier>().updateChildren(await _store.readAllChild(user.email!));
        context.read<FieldManagementNotifier>().updateProgramFieldList(await _store.readAllProgramField());
        context.read<FieldManagementNotifier>().updateSubFieldList(await _store.readAllSubField());
        context.read<FieldManagementNotifier>().updateSubItemList(await _store.readAllSubItem());
        context.read<TestNotifier>().updateTestList(await _store.readAllTest());
        context.read<TestItemNotifier>().updateTestItemList(await _store.readAllTestItem());
        context.read<UserNotifier>().updateUser(abaUser);
      }
    }
  }
}
