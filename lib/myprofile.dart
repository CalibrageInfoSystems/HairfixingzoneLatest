import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CommonUtils.dart';

class myprofile extends StatefulWidget {

  @override
  _myprofileState createState() => _myprofileState();
}



class _myprofileState extends State<myprofile> {


  @override
  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    // getcitylist();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPressed(context),
      child:
      Scaffold(
          appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xFFf3e3ff),
              title: const Text(
                'Select City and Branch',
                style: TextStyle(color: Color(0xFF0f75bc), fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
              // actions: [
              //   IconButton(
              //     icon: SvgPicture.asset(
              //       'assets/sign-out-alt.svg', // Path to your SVG asset
              //       color: Color(0xFF662e91),
              //       width: 24, // Adjust width as needed
              //       height: 24, // Adjust height as needed
              //     ),
              //     onPressed: () {
              //       logOutDialog(context);
              //       // Add logout functionality here
              //     },
              //   ),
              // ],
              // centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: CommonUtils.primaryTextColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ))),);
    //body: YourBodyWidget(),

  }


  Future<bool> onBackPressed(BuildContext context) {
    // Navigate back when the back button is pressed
    Navigator.pop(context);
    // Return false to indicate that we handled the back button press
    return Future.value(false);
  }

}