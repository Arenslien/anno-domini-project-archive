import 'package:flutter/material.dart';

getDate({
  required BuildContext context,
  required DateTime? initialDate,
}) {
  return showDatePicker(
    context: context,
    cancelText: '취소',
    confirmText: '확인',
    fieldLabelText: '날짜 설정',
    initialDate: initialDate == null ? DateTime.now() : initialDate,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: ThemeData.dark(),
        child: child!,
      );
    },
  );
}
