import 'package:aba_analysis/components/authenticate/auth_default_button.dart';
import 'package:aba_analysis/components/authenticate/auth_input_decoration.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/aba_user.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // FirebStoreService 인스턴스
  FireStoreService store = FireStoreService();

  String nickname = '';
  String duty = '';
  void initState() {
    super.initState();
    nickname = context.read<UserNotifier>().abaUser!.nickname;
    duty = context.read<UserNotifier>().abaUser!.duty;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin:
                    EdgeInsets.only(top: getProportionateScreenHeight(0.15)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      getProportionateScreenWidth(padding),
                      getProportionateScreenWidth(0.25),
                      getProportionateScreenWidth(padding),
                      getProportionateScreenWidth(0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: buildAuthInputDecoration(
                              context.watch<UserNotifier>().abaUser!.nickname,
                              Icons.person),
                          onChanged: (String? val) {
                            setState(() {
                              nickname = val!;
                            });
                          },
                        ),
                        SizedBox(height: getProportionateScreenHeight(0.03)),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: buildAuthInputDecoration(
                              context.watch<UserNotifier>().abaUser!.duty,
                              Icons.star),
                          readOnly:
                              context.read<UserNotifier>().abaUser!.duty ==
                                  '관리자',
                          onChanged: (String? val) {
                            setState(() {
                              duty = val!;
                            });
                          },
                        ),
                        SizedBox(height: getProportionateScreenHeight(0.06)),
                        AuthDefaultButton(
                            text: '수정 완료',
                            onPress: () async {
                              ABAUser abaUser =
                                  context.read<UserNotifier>().abaUser!;
                              // 해당 Form 내용으로 사용자 정보 수정
                              store.updateUser(
                                  abaUser.email, nickname, duty, true, false);

                              // 수정 완료 메시지

                              // 서버로부터 ABAUser 정보 받기
                              ABAUser? updatedAbaUser =
                                  await store.readUser(abaUser.email);

                              // abaUser 수정
                              context
                                  .read<UserNotifier>()
                                  .updateUser(updatedAbaUser);

                              // 화면 Pop
                              Navigator.pop(context);
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
