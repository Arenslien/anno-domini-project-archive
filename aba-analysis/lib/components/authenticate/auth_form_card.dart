import 'package:flutter/material.dart';

class AuthFormCard extends StatelessWidget {
  final int flex;
  final Widget? child;
  const AuthFormCard({
    Key? key, required this.child, required this.flex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), 
            topRight: Radius.circular(40),
          )
        ),
        child: child,
      )
    );
  }
}