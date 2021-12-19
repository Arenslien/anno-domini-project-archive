import 'package:flutter/material.dart';

Widget buildListTile({
  IconData? icon,
  String? titleText,
  String? subtitleText,
  double? titleSize,
  Function()? onTap,
  Widget? trailing,
  double? top,
  double? bottom,
}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(
        16, top == null ? 8 : top, 16, bottom == null ? 8 : bottom),
    child: ListTile(
      leading: icon == null
          ? null
          : Icon(
              Icons.person,
              size: 50,
            ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 0,
          ),
          Text(
            titleText!,
            style: TextStyle(
                fontSize: titleSize ?? 25,
                fontFamily: 'KoreanGothic',
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 7,
          ),
        ],
      ),
      subtitle: subtitleText == null
          ? null
          : Text(
              subtitleText,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'KoreanGothic',
              ),
            ),
      onTap: onTap,
      trailing: trailing,
      dense: true,
    ),
  );
}
