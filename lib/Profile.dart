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

class Profile extends StatefulWidget {
  @override
  Profile_screenState createState() => Profile_screenState();
}

class Profile_screenState extends State<Profile> {
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
    // getUserDataFromSharedPreferences();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    CommonUtils.checkInternetConnectivity().then((isConnected) async {
      if (isConnected) {
        print('The Internet Is Connected');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
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

  void getUserDataFromSharedPreferences() async {
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

    formattedDate = DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonStyles.primaryTextColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$fullusername',
                          style: CommonStyles.txSty_18w_fb,
                        ),
                        Text(
                          '$email',
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
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
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
                      userLayOut('assets/id-card-clip-alt.svg', CommonStyles.primaryTextColor, '$username'),
                      userLayOut('assets/venus-mars.svg', CommonStyles.statusGreenText, '$gender'),
                      userLayOut('assets/calendar_icon.svg', CommonStyles.statusRedText, '$formattedDate'),
                      userLayOut('assets/mobile-notch.svg', CommonStyles.statusYellowText, '+91 $contactNumber'),
                      userLayOut('assets/mobile-notch.svg', CommonStyles.statusBlueText, '+91 $contactNumber'),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
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
          padding: EdgeInsets.all(10),
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
