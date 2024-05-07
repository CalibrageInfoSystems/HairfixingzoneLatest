import 'dart:convert';

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
import 'package:http/http.dart' as http;

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
  String? createdDate;
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
        fetchdetailsofcustomer(Id);
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
                            builder: (context) => EditProfile(createdDate: "$createdDate"),
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
                      userLayOut('assets/mobile-notch.svg', CommonStyles.statusBlueText, ''),
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

  Future<void> fetchdetailsofcustomer(int id) async {
    String apiurl = 'http://182.18.157.215/SaloonApp/API/GetCustomerData?id=$id';
    print('apirul:$apiurl');
    final response = await http.get(
      Uri.parse(apiurl),
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> data = json.decode(response.body);

      // Extract the necessary information
      bool isSuccess = data['isSuccess'];
      String statusMessage = data['statusMessage'];

      // Print the result
      print('Is Success: $isSuccess');
      print('Status Message: $statusMessage');

      // Handle the data accordingly
      if (isSuccess) {
        // If the user is valid, you can extract more data from 'listResult'

        if (data['listResult'] != null) {
          List<dynamic> listResult = data['listResult'];
          Map<String, dynamic> user = listResult.first;

          print('CreatedDate ${user['createdDate']}');
          setState(() {
            createdDate = user['createdDate'];
          });

          // Extract other user information as needed
        } else {
          FocusScope.of(context).unfocus();

          CommonUtils.showCustomToastMessageLong("${data["statusMessage"]}", context, 1, 3, toastPosition: MediaQuery.of(context).size.height / 2);
          // Handle the case where the user is not valid
          List<dynamic> validationErrors = data['validationErrors'];
          if (validationErrors.isNotEmpty) {
            // Print or handle validation errors if any
          }
        }
      } else {
        // Handle any error cases here
        print('Failed to connect to the API. Status code: ${response.statusCode}');
      }
    }
  }
}
