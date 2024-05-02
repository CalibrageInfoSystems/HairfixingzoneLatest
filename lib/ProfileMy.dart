import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hairfixingzone/EditProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'ChangePasswordScreen.dart';
import 'Common/common_styles.dart';
import 'Common/custom_button.dart';
import 'CommonUtils.dart';

class ProfileMy extends StatefulWidget {
  @override
  Profile_screenState createState() => Profile_screenState();
}

class Profile_screenState extends State<ProfileMy> {
  String? fullusername;
  String? phonenumber;
  String? email;
  String? contactNumber;
  String? gender;
  int Id = 0;
  String? username;
  String? dob;
  String? formattedDate;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    CommonUtils.checkInternetConnectivity().then((isConnected) async {
      if (isConnected) {
        print('The Internet Is Connected');
        setState(() async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Id = prefs.getInt('userId') ?? 0;
          fullusername = prefs.getString('userFullName');
          phonenumber = prefs.getString('contactNumber');
          username = prefs.getString('username');
          email = prefs.getString('email');
          contactNumber = prefs.getString('contactNumber');
          gender = prefs.getString('gender');
          dob = prefs.getString('dateofbirth');
          DateTime date = DateTime.parse(dob!);
          print('fullusername:$fullusername');
          print('username$username');
          print('usernameId:$Id');
          formattedDate = DateFormat('dd-MM-yyyy').format(date);
        });

        // fetchMyAppointments(userId);
      } else {
        print('The Internet Is not  Connected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonStyles.primaryTextColor,
      appBar: AppBar(
          backgroundColor: const Color(0xFFf3e3ff),
          title: Text(
            'My Profile',
            style: TextStyle(
              color: Color(0xFF0f75bc),
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditProfile(),
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/pen-circle.svg',
                        width: 40.0,
                        height: 40.0,
                        color: CommonStyles.whiteColor,
                      ),
                    )
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
                      userLayOut('assets/id-card-clip-alt.svg', CommonStyles.primaryTextColor, 'User Name'),
                      userLayOut('assets/venus-mars.svg', CommonStyles.statusGreenText, 'Male'),
                      userLayOut('assets/calendar_icon.svg', CommonStyles.statusRedText, '10-08-1999'),
                      userLayOut('assets/mobile-notch.svg', CommonStyles.statusYellowText, '+91 9999999999'),
                      userLayOut('assets/mobile-notch.svg', CommonStyles.statusBlueText, '+91 9999999999'),
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
                                    builder: (context) => ChangePasswordScreen(
                                      id: Id,
                                    ),
                                  ),
                                );
                              }),
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
    );
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
