import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'ChangePasswordScreen.dart';
import 'Common/common_styles.dart';
import 'Common/custom_button.dart';
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
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFFf3e3ff),
            title: const Text(
              'My Profile',
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
            )),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Name',
                            style: CommonStyles.txSty_18w_fb,
                          ),
                          Text(
                            'user email',
                            style: CommonStyles.txSty_16w_fb,
                          ),
                        ],
                      ),
                      SvgPicture.asset(
                        'assets/pen_circle.svg',
                        width: 40.0,
                        height: 40.0,
                        color: CommonStyles.whiteColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: const BoxDecoration(
                  color: CommonStyles.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        userLayOut('assets/id_card_icon.svg', CommonStyles.primaryTextColor, 'User Name'),
                        userLayOut('assets/gender_symbol.svg', CommonStyles.statusGreenText, 'Male'),
                        userLayOut('assets/calendar_icon.svg', CommonStyles.statusRedText, '10-08-1999'),
                        userLayOut('assets/mobile_notch.svg', CommonStyles.statusYellowText, '+91 9999999999'),
                        userLayOut('assets/mobile_notch.svg', CommonStyles.statusBlueText, '+91 9999999999'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              buttonText: 'Change Password',
                              textColor: CommonStyles.primaryTextColor,
                              borderColor: CommonStyles.primaryTextColor,
                              color: CommonStyles.whiteColor,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ChangePasswordScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    //body: YourBodyWidget(),
  }

  Future<bool> onBackPressed(BuildContext context) {
    // Navigate back when the back button is pressed
    Navigator.pop(context);
    // Return false to indicate that we handled the back button press
    return Future.value(false);
  }

  Widget userLayOut(String icon, Color bgColor, String data) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: bgColor,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(
            icon,
            width: 30.0,
            height: 30.0,
            color: CommonStyles.whiteColor,
          ),
        ),
      ),
      title: Text(data),
    );
  }
}
