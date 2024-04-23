import 'package:flutter/material.dart';
import 'package:hairfixingzone/CommonUtils.dart';


import 'package:flutter/material.dart';


class CustomeFormField extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  const CustomeFormField({super.key, required this.label, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label text
        Row(
          children: [
            Text(
              '$label ',
              style: CommonUtils.txSty_12p_fb,
            ),
            const Text(
              '*',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),

        // textfield
        TextFormField(
          decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF0f75bc),
              ),
              borderRadius: BorderRadius.circular(6.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CommonUtils.primaryTextColor,
              ),
              borderRadius: BorderRadius.circular(6.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),

            ),
            hintText: 'Enter $label',
           // hintStyle: CommonUtils.txSty_12bs_fb,
          ),
          validator: validator,
        ),

      ],
    );
  }
}


 //const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
        // .copyWith(top: 5),