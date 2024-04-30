// import 'package:flutter/material.dart';
//
// import '../CommonUtils.dart';
//
//
//
// import 'package:flutter/material.dart';
//
// class CustomButton extends StatelessWidget {
//   final String buttonText;
//   final Color color;
//   final VoidCallback onPressed;
//   final double textSize; // Add this parameter
//   const CustomButton(
//       {super.key,
//         required this.buttonText,
//         required this.color,
//         required this.onPressed,
//   this.textSize = 16.0, });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: color,
//         ),
//         child: Center(
//           child: Text(
//             buttonText,
//             style: const TextStyle(
//               fontSize: 15,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../CommonUtils.dart';

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color color;
  final VoidCallback onPressed;
  final double textSize;
  final Color textColor;
  final Color borderColor;
  const CustomButton({
    super.key,
    required this.buttonText,
    required this.color,
    required this.onPressed,
    this.textSize = 16.0,
    this.textColor = Colors.white,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // minimumSize: const Size.fromHeight(33),
        padding: const EdgeInsets.all(10),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: borderColor),
        ),
        backgroundColor: color,
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 15,
          color: textColor,
        ),
      ),
    );
  }
}
