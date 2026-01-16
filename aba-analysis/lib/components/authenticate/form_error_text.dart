import 'package:flutter/material.dart';

class FormErrorText extends StatelessWidget {
  const FormErrorText({
    Key? key,
    required this.error,
  }) : super(key: key);

  final String error;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 11.0),
        Icon(Icons.cancel, color: Colors.red),
        SizedBox(width: 15.0),
        Text(
          error,
          style: TextStyle(color: Colors.red[300]),
        ),
      ],
    );
  }
}