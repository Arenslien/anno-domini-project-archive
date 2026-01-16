import 'package:aba_analysis/components/setting/setting_default_button.dart';
import 'package:aba_analysis/components/show_dialog_delete.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:aba_analysis/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  AuthService auth = AuthService();
  FireStoreService store = FireStoreService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // 백그라운드 배경
                Container(
                  width: double.infinity,
                  margin:
                      EdgeInsets.only(top: getProportionateScreenHeight(0.15)),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      )),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      getProportionateScreenWidth(padding),
                      getProportionateScreenWidth(0.25),
                      getProportionateScreenWidth(padding),
                      getProportionateScreenWidth(0),
                    ),
                    child: SettingButtonListView(
                      settingButtons: [
                        SettingDefaultButton(
                            text: '내정보 수정',
                            onTap: () {
                              // 내정보 수정 페이지로 이동
                              Navigator.pushNamed(context, '/edit_info');
                            }),
                        SettingDefaultButton(
                            text: '로그아웃',
                            onTap: () {
                              // Firebase Authentication 로그아웃
                              auth.signOut();
                              GoogleSignIn().signOut();
                              // FirebaseAuth.instance.signOut();
                              context.read<UserNotifier>().updateUser(null);
                            }),
                        SettingDefaultButton(
                            text: '회원 탈퇴',
                            onTap: () {
                              if (context.read<UserNotifier>().abaUser!.duty ==
                                  '관리자') {
                                makeToast('관리자는 회원 탈퇴할 수 없습니다.');
                              } else {
                                showDialogYesOrNo(
                                    context: context,
                                    title: '회원 탈퇴',
                                    text: '정말로 회원 탈퇴를 하시겠습니까?',
                                    onPressed: () async {
                                      // 데이터 삭제
                                      await store.updateUser(
                                          context
                                              .read<UserNotifier>()
                                              .abaUser!
                                              .email,
                                          context
                                              .read<UserNotifier>()
                                              .abaUser!
                                              .nickname,
                                          context
                                              .read<UserNotifier>()
                                              .abaUser!
                                              .duty,
                                          context
                                              .read<UserNotifier>()
                                              .abaUser!
                                              .approvalStatus,
                                          true);

                                      // 유저 삭제
                                      context
                                          .read<UserNotifier>()
                                          .deleteApprovedUser(context
                                              .read<UserNotifier>()
                                              .abaUser!
                                              .email);
                                      await store.deleteUser(context
                                          .read<UserNotifier>()
                                          .abaUser!
                                          .email);

                                      try {
                                        await auth.deleteAuthUser();
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'requires-recent-login') {
                                          print(
                                              'The user must reauthenticate before this operation can be executed.');
                                        }
                                      }
                                      makeToast('회원 탈퇴가 완료되었습니다.');
                                      context
                                          .read<UserNotifier>()
                                          .updateUser(null);
                                      await auth.signOut();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      GoogleSignIn().signOut();
                                      Navigator.pushNamed(
                                          context, Wrapper.routeName);
                                    });
                              }
                            }),
                        Visibility(
                          visible:
                              context.watch<UserNotifier>().abaUser!.duty ==
                                      '관리자'
                                  ? true
                                  : false,
                          child: SettingDefaultButton(
                              text: '사용자 관리',
                              onTap: () async {
                                context
                                    .read<UserNotifier>()
                                    .updateApprovedUsers(
                                        await store.readApprovedUser());
                                Navigator.pushNamed(
                                    context, '/user_management');
                              }),
                        ),
                        Visibility(
                          visible:
                              context.watch<UserNotifier>().abaUser!.duty ==
                                      '관리자'
                                  ? true
                                  : false,
                          child: SettingDefaultButton(
                              text: '회원가입 승인',
                              onTap: () async {
                                context
                                    .read<UserNotifier>()
                                    .updateUnapprovedUsers(
                                        await store.readUnapprovedUser());
                                Navigator.pushNamed(
                                    context, '/approve_registration');
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                UserInfoCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(padding),
        vertical: getProportionateScreenHeight(0.05),
      ),
      height: getProportionateScreenHeight(0.2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 15),
              blurRadius: 23,
              color: Colors.black26,
            )
          ]),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(0.04),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '닉네임: ${context.watch<UserNotifier>().abaUser!.nickname} ${context.watch<UserNotifier>().abaUser!.duty}',
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(0.045),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: getProportionateScreenHeight(0.01)),
                    Text(
                      '직   책: ${context.watch<UserNotifier>().abaUser!.duty}',
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(0.045),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: getProportionateScreenHeight(0.01)),
                    Text(
                      '이메일: ${context.watch<UserNotifier>().abaUser!.email}',
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(0.045),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingButtonListView extends StatelessWidget {
  final List<Widget> settingButtons;
  const SettingButtonListView({
    Key? key,
    required this.settingButtons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: settingButtons,
    );
  }
}
