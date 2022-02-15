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
          '프로그램영역 확인 및 추가',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: mainGreenColor,
      ),
      body: ListView.builder(
        // itemCount: programFieldList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildListTile(
            // titleText: programFieldList[index].title,
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         // SelectSubfieldScreen(program: programFieldList[index]),
              //   ),
              // );
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
