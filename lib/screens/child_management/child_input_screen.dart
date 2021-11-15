import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/provider/child_notifier.dart';
import 'package:aba_analysis/components/show_date_picker.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class ChildInputScreen extends StatefulWidget {
  const ChildInputScreen({Key? key}) : super(key: key);

  @override
  _ChildInputScreenState createState() => _ChildInputScreenState();
}

class _ChildInputScreenState extends State<ChildInputScreen> {
  _ChildInputScreenState();
  late String name;
  DateTime? birth;
  late String gender;
  final List<bool> genderSelected = [false, false];
  bool? isGenderSelected;
  bool? isBirthSelected;
  FireStoreService _store = FireStoreService();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: formkey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '아동 추가',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.check_rounded,
                  color: Colors.black,
                ),
                onPressed: () async {
                  if (isGenderSelected != true)
                    setState(() {
                      isGenderSelected = false;
                    });
                  if (isBirthSelected != true)
                    setState(() {
                      isBirthSelected = false;
                    });
                  if (formkey.currentState!.validate() &&
                      isGenderSelected! &&
                      isBirthSelected!) {
                    Child child = Child(
                        childId: await _store.updateId(AutoID.child),
                        teacherEmail:
                            context.read<UserNotifier>().abaUser!.email,
                        name: name,
                        birthday: birth!,
                        gender: gender);

                    // Firestore에 아동 추가
                    await _store.createChild(child);

                    // Provider ChildNotifier 수정
                    context.read<ChildNotifier>().addChild(child);

                    Navigator.pop(context);
                  }
                },
              ),
            ],
            backgroundColor: mainGreenColor,
          ),
          body: ListView(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: buildTextFormField(
                      text: '이름',
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      validator: (val) {
                        if (val!.length < 1) {
                          return '이름을 입력해 주세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            OutlinedButton(
                              onPressed: () async {
                                birth = await getDate(
                                  context: context,
                                  initialDate: birth,
                                );
                                setState(() {
                                  isBirthSelected = true;
                                });
                              },
                              child: Text(
                                birth == null
                                    ? '생년월일 선택'
                                    : DateFormat('yyyyMMdd').format(birth!),
                                style: TextStyle(color: Colors.black),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.black),
                                minimumSize: Size(120, 50),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                '생년월일을 선택해 주세요.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isBirthSelected == false
                                      ? Colors.redAccent[700]
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            buildToggleButtons(
                              text: ['남자', '여자'],
                              isSelected: genderSelected,
                              onPressed: (index) {
                                if (!genderSelected[index])
                                  setState(() {
                                    isGenderSelected = true;
                                    if (index == 0)
                                      gender = '남자';
                                    else
                                      gender = '여자';
                                    for (int buttonIndex = 0;
                                        buttonIndex < genderSelected.length;
                                        buttonIndex++) {
                                      if (buttonIndex == index) {
                                        genderSelected[buttonIndex] = true;
                                      } else {
                                        genderSelected[buttonIndex] = false;
                                      }
                                    }
                                  });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                '성별을 선택해 주세요.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isGenderSelected == false
                                      ? Colors.redAccent[700]
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
