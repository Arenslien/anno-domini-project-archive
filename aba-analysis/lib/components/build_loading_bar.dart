import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';

Widget buildLoadingBar(Future<Object?>? future, Widget widget) {
  return FutureBuilder(
    future: future,
    builder: (context, snapshot) {
      List<Widget> children;
      if (snapshot.hasData) {
        return widget;
      } else if (snapshot.hasError) {
        children = [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('에러 발생: ${snapshot.error}'),
          )
        ];
      } else {
        children = [
          SizedBox(
            child: CircularProgressIndicator(
              color: mainGreenColor,
            ),
            width: 60,
            height: 60,
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('로딩중...'),
          )
        ];
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      );
    },
  );
}
