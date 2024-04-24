import 'package:flutter/material.dart';
import 'package:hairfixingzone/CommonUtils.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomeFormField extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final int? maxLength;
  final VoidCallback? onTap;

  final String? Function(String?)? validator;
  final TextEditingController? controller; // Added controller parameter
  const CustomeFormField({
    Key? key,
    required this.label,
    this.validator,
    this.onTap,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLength,
  }) : super(key: key);

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
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const Text(
              '*',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),

        // textfield.
        GestureDetector(
          onTap: onTap,
          child: TextFormField(
            controller: controller, // Assigning the controller
            keyboardType: keyboardType,
            maxLength: maxLength,

            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF0f75bc),
                ),
                borderRadius: BorderRadius.circular(6.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey, // Changed to a default color
                ),
                borderRadius: BorderRadius.circular(6.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              hintText: 'Enter $label',
              counterText: "",
              hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
            ),
            validator: validator,
          ),
        )
      ],
    );
  }
}

//const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
// .copyWith(top: 5),
