import 'package:aba_analysis_local/models/program_field.dart';
import 'package:aba_analysis_local/models/sub_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// 어플 테마 컬러
const mainYellowColor = Color(0xFFFFE082);
const mainPurpleColor = Color(0xFFE1BEE7);
const mainGreenColor = Color(0xFFA5D6A7);

// ENUM 타입
enum AutoID { child, test, testItem }

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

final List<ProgramField> programFieldList = [
  ProgramField(id: 0, title: "수용 언어"),
  ProgramField(id: 1, title: "동적 모방"),
  ProgramField(id: 2, title: "표현 언어"),
  ProgramField(id: 3, title: "매칭"),
  ProgramField(id: 4, title: "수학"),
  ProgramField(id: 5, title: "놀이 기술"),
  ProgramField(id: 6, title: "자조 기술"),
  ProgramField(id: 7, title: "사회성 기술"),
  ProgramField(id: 8, title: "쓰기"),
];

final List<SubField> defaultSubFieldList = [
  SubField(id: 0, programFieldId: 0, title: "교사가 지시한 한 단계 동작 지시 10가지 따르기", subItemList: ["박수쳐", "만세", "최고", "이리와", "담아", "버려", "앉아", "일어나", "꽃받침", "정리해"]),
  SubField(id: 1, programFieldId: 1, title: "교사가 보여주는 동작을 보고 따라하기", subItemList: ["손 흔들기", "반짝반짝", "무릎 두드리기", "만세", "책상 두드리기", "뽀뽀입술", "손머리", "하트 손가락", "배꼽손", "인사"]),
  SubField(id: 2, programFieldId: 2, title: "사물의 사진을 보고 이름 말하기", subItemList: ["양말", "의자", "신발", "밥", "컵", "자동차", "휴지", "배", "바나나", "하마"]),
  SubField(id: 3, programFieldId: 3, title: "같은 모양이나 그림 10가지 매칭하기", subItemList: ["자동차", "신발", "엄마", "숟가락", "빵", "공룡", "상어", "양말", "가방", "이름"]),
  SubField(id: 4, programFieldId: 4, title: "1~10까지 숫자 읽기", subItemList: ["숫자 1 읽기", "숫자 2 읽기", "숫자 3 읽기", "숫자 4 읽기", "숫자 5 읽기", "숫자 6 읽기", "숫자 7 읽기", "숫자 8 읽기", "숫자 9 읽기", "숫자 10 읽기"]),
  SubField(id: 5, programFieldId: 5, title: "교사가 지시하는 인형 놀이동작 하기", subItemList: ["인형 안아주기", "침대에 눕히기", "이불 덮어주기", "토닥토닥하기", "물 먹이기", "주사 놓기", "머리 감기기", "밥 먹여주기", "옷 입히기", "신발 신기기"]),
  SubField(id: 6, programFieldId: 6, title: "자조기술 5가지", subItemList: ["손씻기", "비누칠하기", "휴지로 손 닦기", "컵으로 물 마시기", "빨대 사용하기", "숟가락 사용하기", "싫어하는 반찬 먹기", "신발 신기", "양말 신기", "실내화 신기"]),
  SubField(id: 7, programFieldId: 7, title: "친구와 함께하는 기술", subItemList: ["인사하기", "손 잡기", "눈 마주치기", "친구 옆에 앉기", "친구에게 장난감 건네주기", "친구를 이름으로 부르기", "차례 지키기", "학용품 나눠쓰기", "공동작품 만들기", "친구와 율동하기"]),
  SubField(id: 8, programFieldId: 8, title: "여러가지 모양의 선과 모양 따라 그리기", subItemList: ["가로선", "세로선", "사선", "동그라미", "세모", "네모", "별 그리기", "하트 그리기", "ㄱ 그리기", "ㄴ 그리기"]),
];

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
  Fluttertoast.showToast(msg: text, toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.green[400], fontSize: 16.0);
}

double padding = 0.1;

// 폼 에러
final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "이메일을 입력해 주세요";
const String kInvalidEmailError = "이메일이 올바르지 않습니다";
const String kExistedEmailError = "이미 존재하는 이메일입니다.";
const String kPassNullError = "비밀번호를 입력해 주세요";
const String kConfirmPassNullError = "비밀번호를 한 번 더 입력해주세요";
const String kShortPassError = "비밀번호를 8자리 이상 입력해 주세요";
const String kMatchPassError = "비밀번호가 일치하지 않습니다";
const String kNameNullError = "이름을 입력해 주세요";
const String kPhoneNumberNullError = "전화 번호를 입력해 주세요";

// 그래프 관련
const String graphDateFormat = "yyyy년MM월dd일H시";
