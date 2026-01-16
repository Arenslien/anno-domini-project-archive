import 'package:flutter/material.dart';

class RegisterText extends StatelessWidget {
  const RegisterText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Spacer(),
        Text(
          '계정이 없으신가요?'
        ),
        Spacer(),
        TextButton(
          child: Text('새로 회원가입을 해주세요!'),
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
        ),
      ],
    );
  }
}