import 'package:aba_analysis_local/services/db.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis_local/constants.dart';
import 'package:aba_analysis_local/models/test.dart';
import 'package:aba_analysis_local/models/child.dart';
import 'package:aba_analysis_local/models/test_item.dart';
import 'package:aba_analysis_local/provider/test_notifier.dart';
import 'package:aba_analysis_local/provider/test_item_notifier.dart';
import 'package:aba_analysis_local/components/show_date_picker.dart';
import 'package:aba_analysis_local/components/show_dialog_delete.dart';
import 'package:aba_analysis_local/components/build_text_form_field.dart';
import 'package:aba_analysis_local/provider/field_management_notifier.dart';

class TestModifyScreen extends StatefulWidget {
  const TestModifyScreen({required this.test, required this.child, Key? key}) : super(key: key);
  final Child child;
  final Test test;

  @override
  _TestInputScreenState createState() => _TestInputScreenState();
}

class _TestInputScreenState extends State<TestModifyScreen> {
  _TestInputScreenState();
  late String title;
  late DateTime date;
  final formkey = GlobalKey<FormState>();
  List<TestItem> testItemList = [];
  List<TestItemInfo> testItemInfoList = [];
  DBService db = DBService();
  bool flag = false;

  void initState() {
    super.initState();

    setState(() {
      title = widget.test.title;
      date = widget.test.date;
      testItemList = context.read<TestItemNotifier>().getTestItemList(widget.test.testId, true);

      for (TestItem testItem in testItemList) {
        TestItemInfo testItemInfo = TestItemInfo(
          programField: testItem.programField,
          subField: testItem.subField,
          subItem: testItem.subItem,
        );
        testItemInfoList.add(testItemInfo);
      }
    });
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
              '${widget.child.name} 테스트 수정',
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
                    title: '테스트 삭제',
                    text: '해당 테스트 데이터를 삭제 하시겠습니까?',
                    onPressed: () async {
                      if (!flag) {
                        flag = true;
                        List<TestItem> testItemList1 = context.read<TestItemNotifier>().getTestItemList(widget.test.testId, true);

                        for (TestItem testItem in testItemList1) {
                          // DB 에서 TestItem 제거
                          await db.deleteTestItem(testItem.testItemId);
                          // Provider에서 testItem 제거
                          context.read<TestItemNotifier>().removeTestItem(testItem);
                        }
                        // DB에서 Test 제거
                        await db.deleteTest(widget.test.testId);
                        // Provider에서 Test 제거
                        context.read<TestNotifier>().removeTest(widget.test);

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
                  if (!flag) {
                    flag = true;
                    // 완료 버튼 누르면 실행
                    if (formkey.currentState!.validate()) {
                      // 테스트의 날짜와 테스트 제목 수정
                      // db.updateTest(widget.test.testId, date, title, widget.test.isInput);
                      context.read<TestNotifier>().updateTest(widget.test.testId, date, title, widget.test.isInput);

                      // 기존의 테스트에 대한 테스트 아이템 모두 제거
                      List<TestItem> testItemList1 = context.read<TestItemNotifier>().getTestItemList(widget.test.testId, true);
                      for (TestItem testItem in testItemList1) {
                        // DB 에서 TestItem 제거
                        await db.deleteTestItem(testItem.testItemId);
                        // Provider에서 testItem 제거
                        context.read<TestItemNotifier>().removeTestItem(testItem);
                      }
                      // 테스트 만들기
                      for (TestItemInfo testItemInfo in testItemInfoList) {
                        // TestItem testItem = TestItem(
                        //   testItemId: await db.updateId(AutoID.testItem),
                        //   testId: widget.test.testId,
                        //   childId: widget.test.childId,
                        //   programField: testItemInfo.programField,
                        //   subField: testItemInfo.subField,
                        //   subItem: testItemInfo.subItem,
                        // );
                        // await db.createTestItem(testItem);
                        // context.read<TestItemNotifiser>().addTestItem(testItem);
                      }

                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
            backgroundColor: mainGreenColor,
          ),
          body: ListView.builder(
            itemCount: testItemInfoList.length + 1,
            itemBuilder: (BuildContext context, int index) {
              return index < 1
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: buildTextFormField(
                                text: '테스트 이름',
                                initialValue: title,
                                onChanged: (val) {
                                  setState(() {
                                    title = val;
                                  });
                                },
                                validator: (val) {
                                  if (val!.length < 1) {
                                    return '이름은 필수사항입니다.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: OutlinedButton(
                                onPressed: () async {
                                  DateTime? temp = await getDate(
                                    context: context,
                                    initialDate: date,
                                  );
                                  date = temp == null ? date : temp;
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      DateFormat('yyyyMMdd').format(date),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.black),
                                  minimumSize: Size(130, 50),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('테스트 아이템 목록'),
                              IconButton(
                                icon: Icon(Icons.add_rounded),
                                onPressed: () {
                                  String? selectedProgramField;
                                  String? selectedSubField;
                                  String? selectedSubItem;

                                  // 프로그램 영역 & 하위 영역 & 하위 목록 선택하는 드롭박스 형태 위젯
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context, setState1) {
                                          return AlertDialog(
                                            title: Text('테스트 아이템 선택'),
                                            content: Container(
                                              height: 180,
                                              width: 300,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  DropdownButton(
                                                    hint: Text('프로그램 영역 선택'),
                                                    value: selectedProgramField,
                                                    items: context.read<FieldManagementNotifier>().programFieldList.map((value) {
                                                      return DropdownMenuItem(
                                                        value: value.title,
                                                        child: Text(value.title),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      setState1(() {
                                                        selectedProgramField = value;
                                                        selectedSubField = null;
                                                        selectedSubItem = null;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ),
                                                  DropdownButton(
                                                    hint: Text('하위 영역 선택'),
                                                    value: selectedSubField,
                                                    items: selectedProgramField == null
                                                        ? null
                                                        : context.read<FieldManagementNotifier>().readSubFieldList(selectedProgramField!).map((value) {
                                                            return DropdownMenuItem(value: value.subFieldName, child: Text(value.subFieldName));
                                                          }).toList(),
                                                    onChanged: (String? value) {
                                                      setState1(() {
                                                        selectedSubField = value;
                                                        selectedSubItem = null;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ),
                                                  DropdownButton(
                                                    hint: Text('하위 목록 선택'),
                                                    value: selectedSubItem,
                                                    items: selectedProgramField == null || selectedSubField == null
                                                        ? null
                                                        : context.read<FieldManagementNotifier>().readSubItem(selectedSubField!).subItemList.map((value) {
                                                            return DropdownMenuItem(
                                                              value: value,
                                                              child: Text(value),
                                                            );
                                                          }).toList(),
                                                    onChanged: (String? value) {
                                                      setState1(() {
                                                        selectedSubItem = value;
                                                      });
                                                    },
                                                    isExpanded: true,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text(
                                                  "취소",
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                child: Text(
                                                  "확인",
                                                  style: TextStyle(color: Colors.blue),
                                                ),
                                                onPressed: () {
                                                  if (selectedSubItem != null) {
                                                    // 저장
                                                    // 리스트에 테스트 아이템 담기
                                                    TestItemInfo testItemInfo = TestItemInfo(
                                                      programField: selectedProgramField!,
                                                      subField: selectedSubField!,
                                                      subItem: selectedSubItem!,
                                                    );

                                                    // 리스트에 추가
                                                    setState(() {
                                                      testItemInfoList.add(testItemInfo);
                                                    });
                                                    Navigator.pop(context);
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: ListTile(
                        title: Text(testItemInfoList[index - 1].subItem),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_rounded),
                          color: Colors.black,
                          onPressed: () {
                            setState(() {
                              testItemInfoList.removeAt(index - 1);
                            });
                          },
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class TestItemInfo {
  final String programField;
  final String subField;
  final String subItem;

  TestItemInfo({required this.programField, required this.subField, required this.subItem});
}
