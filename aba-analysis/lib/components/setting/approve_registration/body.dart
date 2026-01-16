import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/aba_user.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/services/auth.dart';
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
  final List<ABAUser> unapprovedUserList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // 카드 배경
                Container(
                    width: double.infinity,
                    margin:
                        EdgeInsets.only(top: getProportionateScreenHeight(0.1)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        )),
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                          getProportionateScreenWidth(padding / 2),
                          getProportionateScreenHeight(0.04),
                          getProportionateScreenWidth(padding / 2),
                          getProportionateScreenHeight(0.04)),
                      itemCount:
                          context.watch<UserNotifier>().unapprovedUsers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return UnapprovedUserTile(
                            abaUser: context
                                .watch<UserNotifier>()
                                .unapprovedUsers[index]);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UnapprovedUserTile extends StatelessWidget {
  final ABAUser abaUser;
  const UnapprovedUserTile({Key? key, required this.abaUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final FireStoreService store = FireStoreService();

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {},
        child: ListTile(
          title: Text(abaUser.nickname),
          subtitle: Text(abaUser.email),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                child: Text('승인'),
                style: ElevatedButton.styleFrom(primary: Colors.blue[400]),
                onPressed: () async {
                  // 회원가입 승인
                  await store.updateUser(abaUser.email, abaUser.nickname,
                      abaUser.duty, true, false);
                  context
                      .read<UserNotifier>()
                      .deleteUnapprovedUser(abaUser.email);
                  if (abaUser.password != null) {
                    auth.register(abaUser.email, abaUser.password!);
                  }
                },
              ),
              SizedBox(width: getProportionateScreenWidth(0.02)),
              ElevatedButton(
                child: Text('거부'),
                style: ElevatedButton.styleFrom(primary: Colors.red[400]),
                onPressed: () async {
                  // 회원가입 거절
                  await store.deleteUser(abaUser.email);
                  context
                      .read<UserNotifier>()
                      .deleteUnapprovedUser(abaUser.email);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
