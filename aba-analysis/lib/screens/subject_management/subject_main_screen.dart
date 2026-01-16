import 'package:aba_analysis/screens/field_management/sub_field_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/program_field.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/provider/field_management_notifier.dart';

class SubjectMainScreen extends StatefulWidget {
  const SubjectMainScreen({Key? key}) : super(key: key);

  @override
  _SubjectMainScreenState createState() => _SubjectMainScreenState();
}

class _SubjectMainScreenState extends State<SubjectMainScreen> {
  _SubjectMainScreenState();

  @override
  Widget build(BuildContext context) {
    List<ProgramField> programList =
        context.read<FieldManagementNotifier>().programFieldList;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '프로그램영역 확인 및 추가',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: mainGreenColor,
      ),
      body: ListView.builder(
        itemCount: programList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildListTile(
            titleText: programList[index].title,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SubFieldScreen(program: programList[index]),
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
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 44,
                    minHeight: 48,
                    maxWidth: 44,
                    maxHeight: 48,
                  ),
                  child: Image.asset('asset/basic_icon.png', fit: BoxFit.fill),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
