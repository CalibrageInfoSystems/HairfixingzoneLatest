import 'dart:ui';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_progress/loading_progress.dart';

import '../NewScreen.dart';

class CommonStyles {
  // colors
  static const statusBlueBg = Color(0xFFd9edfd);
  static const statusBlueText = Color(0xFF004998);
  static const statusGreenBg = Color(0xFFe5ffeb);
  static const statusGreenText = Color(0xFF287d02);
  static const statusYellowBg = Color(0xFFfcf2dd);
  static const statusYellowText = Color(0xFFd48202);
  static const statusRedBg = Color(0xFFffdedf);
  static const statusRedText = Color.fromARGB(255, 236, 62, 68);
  static const startColor = Color(0xFF59ca6b);

  static const blackColor = Colors.black;
  static const blackColorShade = Color(0xFF5f5f5f);
  static const primaryColor = Color(0xFFf7ebff);
  static const primaryTextColor = Color(0xFF662e91);
  static const formFieldErrorBorderColor = Color(0xFFff0000);
  static const blueColor = Color(0xFF0f75bc);
  static const branchBg = Color(0xFFcfeaff);
  static const greenColor = Colors.greenAccent;
  static const whiteColor = Colors.white;
  // styles
  static const TextStyle txSty_12b_f5 = TextStyle(
    fontSize: 12,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.w500,
    color: blackColor,
  );

  static const TextStyle txSty_14b_f5 = TextStyle(
    fontSize: 14,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.w500,
    color: blackColor,
  );
  static const TextStyle txSty_14p_f5 = TextStyle(
    fontSize: 14,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.w500,
    color: primaryTextColor,
  );
  static const TextStyle txSty_14g_f5 = TextStyle(
    fontSize: 16,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.w600,
    color: greenColor,
  );
  static const TextStyle txSty_14blu_f5 = TextStyle(
    fontSize: 14,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.w500,
    color: Color(0xFF0f75bc),
  );
  static const TextStyle txSty_16blu_f5 = TextStyle(
    fontSize: 16,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.w500,
    color: Color(0xFF0f75bc),
  );
  static const TextStyle txSty_16black_f5 = TextStyle(
    fontSize: 16,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.w500,
    color: Color(0xFF5f5f5f),
  );
  static const TextStyle txSty_14black_f5 = TextStyle(
    fontSize: 14,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.w500,
    color: Color(0xFF5f5f5f),
  );
  static const TextStyle txSty_16p_fb = TextStyle(
    fontSize: 16,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.bold,
    color: primaryTextColor,
  );
  static const TextStyle txSty_18b_fb = TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );
  static const TextStyle txSty_16b_fb = TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );
  static const TextStyle header_Styles = TextStyle(
    fontSize: 26,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.w700,
    color: Color(0xFF0f75bc),
  );
  static const TextStyle txSty_16w_fb = TextStyle(
    fontSize: 16,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.bold,
    color: whiteColor,
  );
  static const TextStyle txSty_18w_fb = TextStyle(
      fontSize: 22,
      fontFamily: "OpenSans",
      fontWeight: FontWeight.bold,
      color: whiteColor,
      letterSpacing: 1);
  static const TextStyle txSty_16p_f5 = TextStyle(
    fontSize: 16,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.w500,
    color: primaryTextColor,
  );
  static const TextStyle txSty_20p_fb = TextStyle(
    fontSize: 20,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.bold,
    color: primaryTextColor,
    letterSpacing: 2,
  );
  static const TextStyle txSty_20b_fb = TextStyle(
    fontSize: 20,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.bold,
    color: blackColor,
  );

  static const TextStyle txSty_12b_fb = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 12,
    color: Color(0xFF000000),
  );
  static const TextStyle txSty_12bl_fb = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 12,
    color: Color(0xA1000000),
  );
  static const TextStyle txSty_12blu_fb = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 12,
    color: Color(0xFF8d97e2),
  );
  static const TextStyle txSty_20black_fb = TextStyle(
    fontSize: 20,
    fontFamily: "OpenSans",
    color: blackColor,
  );
  static const TextStyle txSty_20blu_fb = TextStyle(
    fontSize: 20,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.bold,
    color: blueColor,
  );
  static const TextStyle txSty_20w_fb = TextStyle(
    fontSize: 20,
    fontFamily: "OpenSans",
    color: whiteColor,
  );
  static const TextStyle text16white = TextStyle(
    fontSize: 16,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.w600,
    color: CommonStyles.whiteColor,
  );
  static TextStyle dayTextStyle =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.w700);

  static void progressBar(BuildContext context) {
    LoadingProgress.start(
      context,
      widget: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.withOpacity(0.6),
        ),
        width: MediaQuery.of(context).size.width / 4,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 13),
        child: const AspectRatio(
          aspectRatio: 1,
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }

  static void startProgress(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
                padding: const EdgeInsets.all(20),
                child: const CircularProgressIndicator.adaptive()));
      },
    );
  }

  static CalendarDatePicker2WithActionButtonsConfig config =
      CalendarDatePicker2WithActionButtonsConfig(
    firstDate: DateTime(2012),
    lastDate: DateTime(2030),
    dayTextStyle: CommonStyles.dayTextStyle,
    calendarType: CalendarDatePicker2Type.range,
    selectedDayHighlightColor: Colors.purple[800],
    closeDialogOnCancelTapped: true,
    firstDayOfWeek: 1,
    weekdayLabelTextStyle: const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    controlsTextStyle: const TextStyle(
      color: Color.fromARGB(255, 224, 18, 18),
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    centerAlignModePicker: true,
    customModePickerIcon: const SizedBox(),
    selectedDayTextStyle:
        CommonStyles.dayTextStyle.copyWith(color: Colors.white),
  );

  static void stopProgress(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Widget customAppBar(BuildContext context, {required String title}) {
    return Container(
      color: const Color(0xFFf3e3ff),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF0f75bc), fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  // static AppBar homeAppBar({
  //   required BuildContext context, // Add context parameter
  //   required String userName,
  // }) {
  //   return AppBar(
  //     backgroundColor: const Color(0xFFf3e3ff),
  //     automaticallyImplyLeading: false,
  //     title: SizedBox(
  //       width: 85,
  //       height: 40,
  //       child: FractionallySizedBox(
  //         widthFactor: 1,
  //         child: Image.asset(
  //           'assets/hfz_logo.png',
  //           fit: BoxFit.fitWidth,
  //         ),
  //       ),
  //     ),
  //     actions: [
  //       IconButton(
  //         icon: Container(
  //           padding: const EdgeInsets.all(10).copyWith(bottom: 10),
  //           decoration: const BoxDecoration(
  //             color: CommonStyles.primaryTextColor,
  //             shape: BoxShape.circle,
  //           ),
  //           child: Text(
  //             userName, // 'X',
  //             style: const TextStyle(fontSize: 22, color: Colors.white),
  //           ),
  //         ),
  //         onPressed: () {
  //           // Navigate to the new screen
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => const NewScreen()),
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  static AppBar homeAppBar({
    required BuildContext context, // Add context parameter
    required String userName,
    required String userFullName,
    required String email,
  }) {
    return AppBar(
      backgroundColor: const Color(0xffffffff),
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 85,
            height: 40,
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Image.asset(
                'assets/hfz_logo.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: CommonStyles.primaryTextColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                userName, // 'X',
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
          onPressed: () {
            // Navigate to the new screen
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NewScreen(userName: userFullName)),
            );
          },
        ),
      ],
    );
  }

  static AppBar customerAppbar({
    required BuildContext context,
    required String userName,
    required String userFullName,
    required String email,
    required Widget  title,
  }) {
    return AppBar(
      backgroundColor: const Color(0xffffffff),
      automaticallyImplyLeading: false,
      title: title,
     //  title: Text(
     //    title,
     // style: GoogleFonts.outfit(fontWeight: FontWeight.w500,fontSize: 22,color: Colors.black),
     //  ),
      // actions: [
      //   IconButton(
      //     icon: Container(
      //       width: 40,
      //       height: 40,
      //       decoration:  BoxDecoration(
      //         color: CommonStyles.whiteColor,
      //         shape: BoxShape.circle,
      //         border:Border.all(
      //
      //             color: Colors.grey,
      //             //  color: const Color(0xFF8d97e2), // Add your desired border color here
      //             width: 1.0, // Set the border width
      //           ),
      //         ) ,
      //
      //       child: Center(
      //         child: Text(
      //           userName, // 'X',
      //           style: const TextStyle(fontSize: 22, color: Color(0xFF5f5f5f)),
      //         ),
      //       ),
      //     ),
      //     onPressed: () {
      //       // Navigate to the new screen
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) =>
      //                 NewScreen(userName: userFullName, email: email)),
      //       );
      //     },
      //   ),
      // ],
    );
  }

  static AppBar agentAppbar(
      {required BuildContext context,
      required String userName,
      required String title,
      required void Function()? onTap}) {
    return AppBar(
      backgroundColor: const Color(0xffffffff),
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: CommonStyles.txSty_20b_fb.copyWith(fontSize: 20),
      ),
      actions: [
        IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: CommonStyles.primaryTextColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                userName,
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
          onPressed: onTap,
        ),
      ],
    );
  }

  // static AppBar homeAppBar({
  //   required BuildContext context, // Add context parameter
  //   required String userName,
  // }) {
  //   return AppBar(
  //     backgroundColor: const Color(0xFFf3e3ff),
  //     automaticallyImplyLeading: false,
  //     title: SizedBox(
  //       width: 85,
  //       height: 40,
  //       child: FractionallySizedBox(
  //         widthFactor: 1,
  //         child: Image.asset(
  //           'assets/hfz_logo.png',
  //           fit: BoxFit.fitWidth,
  //         ),
  //       ),
  //     ),
  //     actions: [
  //       IconButton(
  //         icon: Container(
  //           width: 40,
  //           height: 40,
  //           decoration: const BoxDecoration(
  //             color: CommonStyles.primaryTextColor,
  //             shape: BoxShape.circle,
  //           ),
  //           child: Center(
  //             child: Text(
  //               userName, // 'X',
  //               style: const TextStyle(fontSize: 22, color: Colors.white),
  //             ),
  //           ),
  //         ),
  //         onPressed: () {
  //           // Navigate to the new screen
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => const NewScreen()),
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  static AppBar AgenthomeAppBar(
      {required String userName, required void Function()? onPressed}) {
    return AppBar(
      backgroundColor: const Color(0xFFf3e3ff),
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 85,
            height: 40,
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Image.asset(
                'assets/hfz_logo.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: CommonStyles.primaryTextColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                userName, // 'X',
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }

  static AppBar remainingAppBars(BuildContext context,
      {required String title, required void Function()? onPressed}) {
    return AppBar(
      backgroundColor: const Color(0xFFf3e3ff),
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          //   icon: const Icon(
          //     Icons.arrow_back_ios,
          //     size: 20,
          //   ),
          // ),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF0f75bc), fontSize: 16.0),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/sign-out-alt.svg',
            color: const Color(0xFF662e91),
            width: 24,
            height: 24,
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class ProgressDialog {
  final BuildContext context;
  late bool _isShowing;

  ProgressDialog(this.context) {
    _isShowing = false;
    show();
  }

  Future<void> show() async {
    if (!_isShowing) {
      _isShowing = true;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const CircularProgressIndicator.adaptive()));
        },
      );
      _isShowing =
          false; // Set _isShowing back to false after dialog is dismissed
    }
  }

  void dismiss() {
    if (_isShowing) {
      _isShowing = false;
      Navigator.of(context).pop();
    }
  }
}

void showSnackBarMessage(
    {required String message,
    Widget? icon,
    Color messageColor = Colors.white,
    required BuildContext context}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Row(
        children: [
          if (icon != null) icon,
          if (icon != null) const HorizontalSpacer(),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                color: messageColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.fade,
            ),
          )
        ],
      )));
}

class HorizontalSpacer extends StatelessWidget {
  final double width;
  const HorizontalSpacer([this.width = 8.0, Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

// class ProgressManager {
//   static late ProgressDialog _progressDialog;
//
//   static void startProgress(BuildContext context) {
//     _progressDialog = ProgressDialog(context);
//     _progressDialog.show();
//   }
//
//   static void stopProgress() {
//     if (_progressDialog != null) {
//       _progressDialog.dismiss();
//     }
//   }
// }
//
// class ProgressDialog {
//   final BuildContext context;
//   late AlertDialog _dialog;
//   late bool _isShowing;
//
//   ProgressDialog(this.context) {
//     _isShowing = false;
//     _dialog = AlertDialog(
//         content: Center(
//             child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.grey,
//                 ),
//                 padding: const EdgeInsets.all(20),
//                 child: const CircularProgressIndicator.adaptive())));
//   }
//
//   void show() {
//     if (!_isShowing) {
//       _isShowing = true;
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) => _dialog,
//       );
//     }
//   }
//
//   void dismiss() {
//     if (_isShowing) {
//       _isShowing = false;
//       Navigator.of(context).pop();
//     }
//   }
// }
class TooltipOverlay extends StatelessWidget {
  final String message;

  const TooltipOverlay({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
