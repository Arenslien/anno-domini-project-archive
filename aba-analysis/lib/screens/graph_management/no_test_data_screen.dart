import 'package:aba_analysis/components/select_appbar.dart';
import 'package:flutter/material.dart';

class NoTestData extends StatelessWidget {
  const NoTestData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: selectAppBar(context, "테스트 데이터가 없습니다."),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_graph,
              color: Colors.grey,
              size: 150,
            ),
            Text(
              'No Test Data',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 40,
                  fontFamily: 'korean'),
            ),
          ],
        ),
      ),
    );
  }
}
