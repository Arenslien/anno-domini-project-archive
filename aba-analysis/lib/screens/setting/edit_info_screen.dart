import 'package:aba_analysis/components/setting/edit_info_screen/body.dart';
import 'package:aba_analysis/constants.dart';
import 'package:flutter/material.dart';

class EditInfoScreen extends StatefulWidget {
  static String routeName = '/edit_info';
  const EditInfoScreen({ Key? key }) : super(key: key);

  @override
  _EditInfoScreenState createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainGreenColor,
      appBar: AppBar(
        backgroundColor: mainGreenColor,
        title: Text('내 정보 수정', style: TextStyle(color: Colors.white),),
        centerTitle: false,
      ),
      body: Body(),
    );
  }
}
