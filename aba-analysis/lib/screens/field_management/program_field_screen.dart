import 'package:aba_analysis/components/build_floating_action_button.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';
import 'package:aba_analysis/components/show_dialog_delete.dart';
import 'package:aba_analysis/models/program_field.dart';
import 'package:aba_analysis/models/sub_field.dart';
import 'package:aba_analysis/models/sub_item.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/provider/field_management_notifier.dart';
import 'package:aba_analysis/provider/test_item_notifier.dart';
import 'package:aba_analysis/screens/field_management/sub_field_screen.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/components/build_list_tile.dart';

class ProgramFieldScreen extends StatefulWidget {
  const ProgramFieldScreen({Key? key}) : super(key: key);

  @override
  _ProgramFieldScreenState createState() => _ProgramFieldScreenState();
}

class _ProgramFieldScreenState extends State<ProgramFieldScreen> {
  _ProgramFieldScreenState();

  String? title;

  FireStoreService store = FireStoreService();

  final formkey = GlobalKey<FormState>();

  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '프로그램영역 확인 및 추가',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: mainGreenColor,
      ),
      body: ListView.builder(
        itemCount:
            context.watch<FieldManagementNotifier>().programFieldList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildListTile(
            titleText: context
                .read<FieldManagementNotifier>()
                .programFieldList[index]
                .title,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubFieldScreen(
                      program: context
                          .read<FieldManagementNotifier>()
                          .programFieldList[index]),
                ),
              );
            },
            trailing: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 44,
                    minHeight: 48,
                    maxWidth: 64,
                    maxHeight: 64,
                  ),
                  child: Image.asset('asset/program_field_icon.png',
                      fit: BoxFit.fill),
                ),
                // 삭제 버튼
                IconButton(
                    onPressed: () {
                      // DB에서 SubField 가져와서 삭제
                      showDialogYesOrNo(
                        context: context,
                        title: '프로그램영역 삭제',
                        text: '정말 삭제하시겠습니까?',
                        onPressed: () async {
                          if (!flag) {
                            flag = true;
                            ProgramField? programField = context
                                .read<FieldManagementNotifier>()
                                .readProgramField(context
                                    .read<FieldManagementNotifier>()
                                    .programFieldList[index]
                                    .title);

                            List<SubField> subFieldList = context
                                .read<FieldManagementNotifier>()
                                .readSubFieldList(programField!.title);
                            List<String> subItemList = context
                                .read<FieldManagementNotifier>()
                                .readAllSubFieldItemList();
                            // DB에서 삭제한 서브필드의 테스트 아이템 삭제
                            List<TestItem> testItemList =
                                context.read<TestItemNotifier>().testItemList;
                            for (SubField sf in subFieldList) {
                              for (TestItem testItem in testItemList) {
                                if (testItem.subField == sf.subFieldName) {
                                  // 테스트아이템 삭제
                                  await store
                                      .deleteTestItem(testItem.testItemId);
                                }
                              }
                              SubItem subItem = context
                                  .read<FieldManagementNotifier>()
                                  .readSubItem(sf.subFieldName);

                              if (sf.id == subItem.subFieldId) {
                                // DB에서 서브아이템 삭제
                                await store.deleteSubItem(context
                                    .read<FieldManagementNotifier>()
                                    .readSubItem(sf.subFieldName)
                                    .id);
                              }
                              // 서브필드 삭제
                              await store.deleteSubField(sf.id);
                            }

                            // DB에서 프로그램영역을 삭제한다.
                            await store.deleteProgramField(programField.id);

                            // DB에서 지운 데이터들 프로바이더에 업데이트
                            context.read<TestItemNotifier>().updateTestItemList(
                                await store.readAllTestItem());
                            context
                                .read<FieldManagementNotifier>()
                                .updateSubFieldList(
                                    await store.readAllSubField());
                            context
                                .read<FieldManagementNotifier>()
                                .updateSubItemList(
                                    await store.readAllSubItem());
                            context
                                .read<FieldManagementNotifier>()
                                .updateProgramFieldList(
                                    await store.readAllProgramField());

                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Colors.black,
                    )),
              ],
            ),
          );
        },
      ),
      floatingActionButton: bulidFloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Form(
                key: formkey,
                child: AlertDialog(
                  title: Text('프로그램 영역 추가'),
                  content: buildTextFormField(
                    hintText: 'ex) 동적모방',
                    onChanged: (val) {
                      setState(() {
                        title = val;
                      });
                    },
                    validator: (val) {
                      if (val!.length < 1) {
                        return '제목을 입력해 주세요.';
                      }
                      return null;
                    },
                    autofocus: true,
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        "취소",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        flag = false;
                      },
                    ),
                    TextButton(
                      child: Text(
                        "저장",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () async {
                        if (formkey.currentState!.validate() && !flag) {
                          flag = true;

                          //DB추가
                          await store.addProgramField(title!);
                          context
                              .read<FieldManagementNotifier>()
                              .updateProgramFieldList(
                                  await store.readAllProgramField());

                          Navigator.pop(context);
                          title = null;
                          flag = false;
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
