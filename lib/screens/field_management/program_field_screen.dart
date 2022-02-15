import 'package:aba_analysis/components/build_floating_action_button.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';
import 'package:aba_analysis/provider/field_management_notifier.dart';
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
        itemCount: context.watch<FieldManagementNotifier>().programFieldList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildListTile(
            titleText: context.read<FieldManagementNotifier>().programFieldList[index].title,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubFieldScreen(program: context.read<FieldManagementNotifier>().programFieldList[index]),
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
                  child: Image.asset('asset/program_field_icon.png', fit: BoxFit.fill),
                ),
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
                          context.read<FieldManagementNotifier>().updateProgramFieldList(await store.readAllProgramField());

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
