import 'package:aba_analysis_local/components/build_toggle_buttons.dart';
import 'package:aba_analysis_local/provider/db_notifier.dart';
import 'package:aba_analysis_local/services/db.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis_local/constants.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/models/test_item.dart';
import 'package:aba_analysis_local/components/show_date_picker.dart';
import 'package:aba_analysis_local/components/show_dialog_delete.dart';
import 'package:aba_analysis_local/components/build_text_form_field.dart';

class ChildModifyScreen extends StatefulWidget {
  const ChildModifyScreen({required this.child, Key? key}) : super(key: key);
  final Child child;
  @override
  _ChildModifyScreenState createState() => _ChildModifyScreenState();
}

class _ChildModifyScreenState extends State<ChildModifyScreen> {
  _ChildModifyScreenState();
  late String name;

  late DateTime? birth;

  late String gender;
  List<bool> genderSelected = [];

  final formkey = GlobalKey<FormState>();

  DBService db = DBService();

  bool flag = false;

  @override
  void initState() {
    super.initState();
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
              '${widget.child.name} 설정',
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
                      if (!flag) {
                        flag = true;
                        // 아이에 대한 test
                        List<Test> testList = context.read<DBNotifier>().getAllTestListOf(widget.child.id, false);

                        for (Test test in testList) {
                          // Child의 TestItem 제거
                          List<TestItem> testItemList = context.read<DBNotifier>().getTestItemList(test.testId, true);
                          for (TestItem testItem in testItemList) {
                            // DB에서 TestItem 제거
                            await db.deleteTestItem(testItem.testItemId);
                            // Provider에서 TestItem 제거
                            context.read<DBNotifier>().removeTestItem(testItem);
                          }

                          // DB에서 TestItem 제거
                          await db.deleteTest(test.testId);
                          // Provider에서 테스트 제거
                          context.read<DBNotifier>().removeTest(test);
                        }

                        // DB 에서 Child 제거
                        await db.deleteChild(widget.child.id);
                        // Provider에서 Child 제거
                        context.read<DBNotifier>().removeChild(widget.child);

                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
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
                    if (!flag) {
                      flag = true;

                      // child 생성
                      Child updatedChild = Child(
                        id: widget.child.id,
                        name: name,
                        birthday: birth!,
                        gender: gender,
                      );

                      // DB 수정
                      await db.updateChild(updatedChild);

                      // 업데이트
                      await context.read<DBNotifier>().updateChildren();

                      // 화면 전환
                      Navigator.pop(context);
                    }
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
                            DateTime? temp = await getDate(
                              context: context,
                              initialDate: birth,
                            );
                            birth = temp == null ? birth : temp;
                            setState(() {});
                          },
                          child: Text(
                            DateFormat('yyyyMMdd').format(birth!),
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
