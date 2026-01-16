import 'package:aba_analysis/components/setting/user_management/body.dart';
import 'package:aba_analysis/constants.dart';
import 'package:flutter/material.dart';

class UserManagementScreen extends StatefulWidget {
  static String routeName = '/user_management';
  const UserManagementScreen({ Key? key }) : super(key: key);

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainGreenColor,
      appBar: AppBar(
        backgroundColor: mainGreenColor,
        title: Text('사용자 관리', style: TextStyle(color: Colors.white)),
        centerTitle: false,
      ),
      body: Body(),
    );
  }
}
