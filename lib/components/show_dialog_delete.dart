import 'package:flutter/material.dart';

showDialogYesOrNo({
  required BuildContext context,
  required String title,
  required String text,
  void Function()? onPressed,
}) {
  bool flag = false;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          text,
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            child: Text(
              "아니오",
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              if (!flag) {
                flag = true;
                Navigator.pop(context);
              }
            },
          ),
          TextButton(
            child: Text(
              "예",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: onPressed,
          ),
        ],
      );
    },
  );
}
