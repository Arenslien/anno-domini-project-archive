import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';

class SettingDefaultButton extends StatelessWidget {
  final String text;
  final Function() onTap; 
  const SettingDefaultButton({
    Key? key, required this.text, required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        child: Container(
          height: getProportionateScreenHeight(0.06),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text, style: TextStyle(color: Colors.black, fontSize: getProportionateScreenWidth(0.048), fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_forward_ios, size: 20.0, color: Colors.grey),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}



