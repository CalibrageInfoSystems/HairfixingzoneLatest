
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
class CommonUtils{

  static  void showCustomToastMessageLong(String message,
      BuildContext context,
      int backgroundColorType,
      int length,) {
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double textWidth = screenWidth / 1.5; // Adjust multiplier as needed

    final double toastWidth = textWidth + 32.0; // Adjust padding as needed
    final double toastOffset = (screenWidth - toastWidth) / 2;

    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) =>
          Positioned(
            bottom: 16.0,
            left: toastOffset,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: toastWidth,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: backgroundColorType == 0 ? Colors.green : Colors.red,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Center(
                    child: Text(
                      message,
                      style: TextStyle(fontSize: 16.0, color: Colors.black,fontFamily: 'Calibri'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
    );


    Overlay.of(context).insert(overlayEntry);
    Future.delayed(Duration(seconds: length)).then((value) {
      overlayEntry.remove();
    });
  }

  static const blackColor = Colors.black;
  static const blackColorShade = Color(0xFF5f5f5f);
  static const primaryColor = Color(0xFFf7ebff);
  static const primaryTextColor = Color(0xFF662e91);
  static const formFieldErrorBorderColor = Color(0xFFff0000);
  static const blueColor = Color(0xFF0f75bc);
  static const TextStyle header_Styles = TextStyle(
    fontSize: 24,
    fontFamily: "Calibri",
    fontWeight: FontWeight.w700,
    color: Color(0xFF662d91),
  );
  static const TextStyle Sub_header_Styles = TextStyle(
    fontSize: 24,
    fontFamily: "Calibri",
    fontWeight: FontWeight.w500,
    color: Color(0xFF5f5f5f)
  );
  static const TextStyle Mediumtext_o_14 = TextStyle(
    fontSize: 20,
    fontFamily: "Calibri",
    fontWeight: FontWeight.w500,
    color: Color(0xFF0f75bc),
  );
  static const TextStyle Mediumtext_14 = TextStyle(
    fontSize: 20,
    fontFamily: "Calibri",
    fontWeight: FontWeight.w500,
    color: Color(0xFF5f5f5f),
  );

  static const txSty_14w_fb = TextStyle(
    fontSize: 14,
    fontFamily: 'Calibri',
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
  );
  static const txSty_12b_fb = TextStyle(
    fontSize: 12.0,
    color: blackColor,
    fontWeight: FontWeight.bold,
    fontFamily: "Calibri",
  );
  static const txSty_12bs_fb = TextStyle(
    fontSize: 12.0,

    fontWeight: FontWeight.bold,
    fontFamily: "Calibri",
  );
  static const txSty_12p_fb = TextStyle(
    fontSize: 12.0,
    color: primaryTextColor,
    fontWeight: FontWeight.w500,
    fontFamily: "Calibri",
  );
  static const txSty_18b_fb = TextStyle(
    fontSize: 18,
    fontFamily: 'Calibri',
    fontWeight: FontWeight.bold,
    color: blackColor,
  );
  static const txSty_18p_f7 = TextStyle(
    fontSize: 18,
    fontFamily: 'Calibri',
    fontWeight: FontWeight.w500,
    color: primaryTextColor,
  );
  static Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true; // Connected to the internet
    } else {
      return false; // Not connected to the internet
    }
  }
    static void myCommonMethod() {
      // Your common method logic here
      print('This is a common method');
    }

}