import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';

Widget bulidFloatingActionButton({required void Function()? onPressed}) {
  return FloatingActionButton(
    child: Icon(
      Icons.add_rounded,
      size: 40,
    ),
    onPressed: onPressed,
    backgroundColor: mainGreenColor,
  );
}
