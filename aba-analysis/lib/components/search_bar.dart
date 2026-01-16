import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';

AppBar searchBar({
  TextEditingController? controller,
  Function(String)? onChanged,
  Function()? clear,
}) {
  return AppBar(
    title: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: '아동 검색',
        hintStyle: TextStyle(fontFamily: 'korean', color: Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: mainGreenColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: mainGreenColor),
        ),
        prefixIcon: Icon(
          Icons.search_outlined,
          color: Colors.black,
          size: 30,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: clear,
        ),
      ),
      onChanged: onChanged,
      cursorColor: Colors.black,
      style: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontFamily: 'korean',
      ),
    ),
    backgroundColor: mainGreenColor,
  );
}
