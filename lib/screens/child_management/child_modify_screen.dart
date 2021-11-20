import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis_local/constants.dart';
import 'package:aba_analysis_local/services/db.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/models/test_item.dart';
import 'package:aba_analysis_local/components/show_date_picker.dart';
import 'package:aba_analysis_local/components/show_dialog_delete.dart';
import 'package:aba_analysis_local/components/build_toggle_buttons.dart';
import 'package:aba_analysis_local/components/build_text_form_field.dart';

class ChildModifyScreen extends StatefulWidget {
  const ChildModifyScreen({required this.child, Key? key}) : super(key: key);
  final Child child;
  @override
  _ChildModifyScreenState createState() => _ChildModifyScreenState();
}

class _ChildModifyScreenState extends State<ChildModifyScreen> {
  _ChildModifyScreenState();

  late DBService db;

  late String name;
  late DateTime birth;
  late String gender;
  List<bool> genderSelected = [];

  final formkey = GlobalKey<FormState>();

  bool flag = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 0), () async {
      await db.initDatabase();
    });

    name = widget.child.name;
    birth = widget.child.birthday;
    gender = widget.child.gender;
    if (gender == '남자') {
      genderSelected.add(true);
      genderSelected.add(false);
    } else {
      genderSelected.add(false);
      genderSelected.add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: formkey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '아동 설정',
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
                  Icons.delete,
                  color: Colors.black,
                ),
                onPressed: () {
                  showDialogYesOrNo(
                    context: context,
                    title: '아동 삭제',
                    text: '해당 아동에 데이터를 삭제 하시겠습니까?',
                    onPressed: () async {
                      // 아이에 대한 test
                      List<Test> testList = await db.readTestList(widget.child.id!);

                      for (Test test in testList) {
                        List<TestItem> testItemList = await db.readTestItemList(test.id!);
                        for (TestItem testItem in testItemList) {
                          // DB 에서 TestItem 제거
                          db.deleteTestItem(testItem.id!);
                        }
                        // DB 에서 Test 제거
                        db.deleteTest(test.id!);
                      }

                      // DB 에서 Child 제거
                      db.deleteChild(widget.child.id!);

                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.check_rounded,
                  color: Colors.black,
                ),
                onPressed: () async {
                  if (formkey.currentState!.validate()) {
                    // 수정된 child 생성
                    Child newChild = Child(
                      id: widget.child.id,
                      name: name,
                      birthday: birth,
                      gender: gender,
                    );

                    // 기존의 child 수정
                    db.updateChild(newChild);

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
                      initialValue: name,
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
                        OutlinedButton(
                          onPressed: () async {
                            birth = await getDate(
                              context: context,
                              initialDate: birth,
                            );
                            setState(() {});
                          },
                          child: Text(
                            DateFormat('yyyyMMdd').format(birth),
                            style: TextStyle(color: Colors.black),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black),
                            minimumSize: Size(120, 50),
                          ),
                        ),
                        buildToggleButtons(
                          text: ['남자', '여자'],
                          isSelected: genderSelected,
                          onPressed: (index) {
                            if (!genderSelected[index])
                              setState(() {
                                if (index == 0)
                                  gender = '남자';
                                else
                                  gender = '여자';
                                for (int buttonIndex = 0; buttonIndex < genderSelected.length; buttonIndex++) {
                                  if (buttonIndex == index) {
                                    genderSelected[buttonIndex] = true;
                                  } else {
                                    genderSelected[buttonIndex] = false;
                                  }
                                }
                              });
                          },
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
