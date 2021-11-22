import 'package:flutter/material.dart';
import 'package:aba_analysis_local/constants.dart';
import 'package:aba_analysis_local/components/build_list_tile.dart';
import 'package:aba_analysis_local/screens/subject_management/select_sub_field_screen.dart';

class SubjectMainScreen extends StatefulWidget {
  const SubjectMainScreen({Key? key}) : super(key: key);

  @override
  _SubjectMainScreenState createState() => _SubjectMainScreenState();
}

class _SubjectMainScreenState extends State<SubjectMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '프로그램 선택',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: mainGreenColor,
      ),
      body: ListView.builder(
        itemCount: programFieldList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildListTile(
            titleText: programFieldList[index].title,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectSubfieldScreen(program: programFieldList[index]),
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
