import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  final bool selected;
  final VoidCallback? onTap;

  const CustomRadioButton({required this.selected, required this.onTap});

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 34,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color: widget.selected ? Color(0xFF163CF1) : Colors.grey,
          ),
        ),
        child: widget.selected
            ? Center(
          child: Container(
            width: 24,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFB4110),
            ),
          ),
        )
            : null,
      ),
    );
  }
}
