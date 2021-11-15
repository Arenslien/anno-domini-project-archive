import 'package:aba_analysis_local/constants.dart';
import 'package:flutter/material.dart';

ToggleButtons buildToggleButtons(
    {required List<String> text,
    List<bool>? isSelected,
    Function(int)? onPressed,
    double minWidth = 80,
    double minHeight = 50}) {
  List<Text> textList = [];
  List<bool> selecte = [];

  for (int i = 0; i < text.length; i++) {
    textList.add(Text(
      text[i],
      style: TextStyle(fontFamily: 'KoreanGothic'),
    ));
    selecte.add(false);
  }

  return ToggleButtons(
    children: textList,
    isSelected: isSelected == null ? selecte : isSelected,
    onPressed: onPressed,
    constraints: BoxConstraints(minWidth: minWidth, minHeight: minHeight),
    color: isSelected == null ? null : Colors.grey,
    fillColor: mainGreenColor,
    borderColor: Colors.black,
    splashColor: mainGreenColor,
    selectedColor: Colors.black,
    selectedBorderColor: Colors.black,
    disabledColor: Colors.black,
    disabledBorderColor: Colors.black,
  );
}
