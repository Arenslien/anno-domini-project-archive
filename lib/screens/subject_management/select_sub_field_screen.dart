import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis_local/constants.dart';
import 'package:aba_analysis_local/services/db.dart';
import 'package:aba_analysis_local/models/sub_field.dart';
import 'package:aba_analysis_local/models/test_item.dart';
import 'package:aba_analysis_local/models/program_field.dart';
import 'package:aba_analysis_local/components/build_list_tile.dart';
import 'package:aba_analysis_local/components/show_dialog_delete.dart';
import 'package:aba_analysis_local/components/build_floating_action_button.dart';
import 'package:aba_analysis_local/screens/subject_management/sub_field_view_screen.dart';
import 'package:aba_analysis_local/screens/subject_management/sub_field_input_screen.dart';

class SelectSubfieldScreen extends StatefulWidget {
  final ProgramField program;
  const SelectSubfieldScreen({Key? key, required this.program})
      : super(key: key);
  @override
  _SelectSubfieldScreenState createState() => _SelectSubfieldScreenState();
}

class _SelectSubfieldScreenState extends State<SelectSubfieldScreen> {
  late DBService db;
  late List<SubField> subFieldList;
  _SelectSubfieldScreenState();
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 0), () async {
      await db.initDatabase();
      subFieldList = await db.readSubFieldList(widget.program.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.program.title,
          style: TextStyle(
            fontFamily: 'KoreanGothic',
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: mainGreenColor,
      ),
      body: ListView.builder(
        itemCount: subFieldList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildListTile(
              titleText: subFieldList[index].title,
              titleSize: 20,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectSubitemScreen(
                      subField: subFieldList[index],
                      index: index,
                    ),
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
                      maxHeight: 48,
                    ),
                    child: Image.asset('asset/sub_field_icon.png',
                        fit: BoxFit.fill),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 44,
                      minHeight: 48,
                      maxWidth: 64,
                      maxHeight: 48,
                    ),
                    child: index == 0
                        ? Image.asset('asset/basic_icon.png', fit: BoxFit.fill)
                        : Image.asset('asset/add_icon.png', fit: BoxFit.fill),
                  ),
                  // 삭제 버튼
                  Visibility(
                    visible: index != 0,
                    child: IconButton(
                        onPressed: () {
                          // DB에서 SubField 가져와서 삭제
                          showDialogYesOrNo(
                              context: context,
                              title: '하위영역 삭제',
                              text: '정말 삭제하시겠습니까?',
                              onPressed: () async {
                                // DB에서 삭제한 서브필드의 테스트 아이템 삭제
                                List<TestItem> testItemList =
                                    await db.readTestItemListBySubField(
                                        subFieldList[index]);
                                for (TestItem testItem in testItemList) {
                                  await db.deleteTestItem(testItem.id!);
                                }

                                await db.deleteSubField(subFieldList[index].id);
                                Navigator.pop(context);
                              });
                        },
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Colors.black,
                        )),
                  ),
                ],
              ));
        },
      ),
      floatingActionButton: bulidFloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SubFieldInputScreen(program: widget.program)),
        );
      }),
    );
  }
}
