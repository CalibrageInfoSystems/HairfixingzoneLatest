import 'package:flutter/material.dart';
import 'package:hairfixingzone/CommonUtils.dart';


class CustomeFormField extends StatelessWidget {
  final String label;
  const CustomeFormField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label text
        Text(
          '$label *',
          style: CommonUtils.txSty_12p_fb,
        ),

        // textfield
        TextFormField(
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(color: CommonUtils.primaryColor),
            ),
            // labelText: label,
            hintText: 'Enter $label',
            hintStyle: CommonUtils.txSty_12bs_fb,
          ),
          validator: (value) {
            return null;
          },
        ),
      ],
    );
  }
}


 //const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
        // .copyWith(top: 5),