import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/program_field.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/provider/program_field_notifier.dart';
import 'package:aba_analysis/screens/subject_management/select_sub_field_screen.dart';

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
        context.read<ProgramFieldNotifier>().programFieldList;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '프로그램 선택',
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
                      SelectSubfieldScreen(program: programList[index]),
                ),
              );
            },
            trailing: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: Colors.black,
            ),
          );
        },
      ),
    );
  }
}
