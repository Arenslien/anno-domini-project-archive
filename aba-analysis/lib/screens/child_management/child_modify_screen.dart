import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/provider/test_notifier.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/provider/child_notifier.dart';
import 'package:aba_analysis/provider/test_item_notifier.dart';
import 'package:aba_analysis/components/show_date_picker.dart';
import 'package:aba_analysis/components/show_dialog_delete.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

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
  FireStoreService store = FireStoreService();
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
                        List<Test> testList = context
                            .read<TestNotifier>()
                            .getAllTestListOf(widget.child.childId, false);

                        for (Test test in testList) {
                          // Child의 TestItem 제거
                          List<TestItem> testItemList = context
                              .read<TestItemNotifier>()
                              .getTestItemList(test.testId, true);
                          for (TestItem testItem in testItemList) {
                            // DB에서 TestItem 제거
                            await store.deleteTestItem(testItem.testItemId);
                          }

                          // DB에서 TestItem 제거
                          await store.deleteTest(test.testId);
                        }

                        // DB 에서 Child 제거
                        await store.deleteChild(widget.child.childId);

                        context
                            .read<TestItemNotifier>()
                            .updateTestItemList(await store.readAllTestItem());

                        context
                            .read<TestNotifier>()
                            .updateTestList(await store.readAllTest());
                        context.read<ChildNotifier>().updateChildren(
                            await store.readAllChild(
                                context.read<UserNotifier>().abaUser!.email));
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
                      // 기존의 child 제거
                      context.read<ChildNotifier>().removeChild(widget.child);

                      // child 생성
                      Child updatedChild = Child(
                          childId: widget.child.childId,
                          teacherEmail:
                              context.read<UserNotifier>().abaUser!.email,
                          name: name,
                          birthday: birth!,
                          gender: gender);

                      // ChildNotifier 수정
                      context.read<ChildNotifier>().addChild(updatedChild);

                      // DB 수정
                      await store.updateChild(
                          widget.child.childId, name, birth!, gender);

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
