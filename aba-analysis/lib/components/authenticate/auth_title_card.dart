import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';

class AuthTitleCard extends StatelessWidget {
  final String title;
  final String subInformation;
  const AuthTitleCard({
    Key? key, required this.title, required this.subInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(0.09),
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(0.01),
            ),
            Text(
              subInformation,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(0.045),
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}