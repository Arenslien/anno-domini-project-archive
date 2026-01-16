import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// 어플 테마 컬러
const mainYellowColor = Color(0xFFFFE082);
const mainPurpleColor = Color(0xFFE1BEE7);
const mainGreenColor = Color(0xFFA5D6A7);

// ENUM 타입
enum AutoID { child, test, testItem, programField, subField, subItem, childResult }

final Map<String, String> korToEngAboutPF = {
  "수용 언어": "acceptance",
  "동적 모방": "dynamic-imitation",
  "표현 언어": "expression",
  "매칭": "match",
  "수학": "math",
  "놀이 기술": "play-skills",
  "자조 기술": "self-help-skills",
  "사회성 기술": "social-skills",
  "쓰기": "write",
};

String? convertProgramFieldTitle(String title) {
  String? docTitle = korToEngAboutPF[title];
  return docTitle;
}

SnackBar makeSnackBar(String text, bool success) {
  final snackBar = SnackBar(
    content: Text(text),
    backgroundColor: success ? Colors.green[400] : Colors.red[400],
    duration: Duration(milliseconds: 1500),
  );
  return snackBar;
}

void makeToast(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.green[400],
      fontSize: 16.0);
}

double padding = 0.1;

// 폼 에러
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "이메일을 입력해 주세요";
const String kInvalidEmailError = "이메일이 올바르지 않습니다";
const String kExistedEmailError = "이미 존재하는 이메일입니다.";
const String kPassNullError = "비밀번호를 입력해 주세요";
const String kConfirmPassNullError = "비밀번호를 한 번 더 입력해주세요";
const String kShortPassError = "비밀번호를 8자리 이상 입력해 주세요";
const String kMatchPassError = "비밀번호가 일치하지 않습니다";
const String kNameNullError = "이름을 입력해 주세요";
const String kPhoneNumberNullError = "전화 번호를 입력해 주세요";
const String kExistGoogleEmailError = "구글 로그인으로 로그인해주세요.";
const String kNotExistEmailError = "존재하지 않는 이메일입니다.";

// 그래프 관련
const String graphDateFormat = "yyyy년MM월dd일H시";
const String graphDateFormatNoTime = "yyyy년MM월dd일";
