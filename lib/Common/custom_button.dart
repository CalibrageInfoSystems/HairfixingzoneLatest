import 'package:flutter/material.dart';

import '../CommonUtils.dart';


class CustomButton extends StatelessWidget {
  final String buttonText;
  const CustomButton({super.key, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 174, 112, 224),
      ),
      child: Center(
        child: Text(
          buttonText,
          style: CommonUtils.txSty_14w_fb,
        ),
      ),
    );
  }
}
