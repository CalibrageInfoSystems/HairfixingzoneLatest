import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Commonutils.dart';
import 'HomeScreen.dart';

class feedback_Screen extends StatefulWidget {
  @override
  _feedback_Screen_screenState createState() => _feedback_Screen_screenState();
}

class _feedback_Screen_screenState extends State<feedback_Screen> {
  TextEditingController _commentstexteditcontroller = TextEditingController();
  double rating_star = 0.0;
  String accessToken = '';

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        loadAccessToken();
      } else {
        print('The Internet Is not  Connected');
      }
    });
  }

  Future<void> loadAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString("accessToken") ?? "";
    });
    print("accestokeninfeedbackscreen$accessToken");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Handle back button press here
          //
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );

          // You can add any custom logic before closing the app
          return true; // Return true to allow back button press and close the app
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color(0xFFf15f22),
              title: Text(
                'HRMS',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Implement your logic to navigate back
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: Stack(
              children: [
                // Image.asset(
                //   'assets/background_layer_2.png',
                //   fit: BoxFit.cover,
                //   width: MediaQuery.of(context).size.width,
                //   height: MediaQuery.of(context).size.height,
                // ),

                SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Feedback',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFFf15f22),
                            fontFamily: 'Calibri',
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Rating',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFf15f22),
                            fontFamily: 'Calibri',
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            child: RatingBar.builder(
                              initialRating: 0,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  rating_star = rating;
                                  print('rating_star$rating_star');
                                });
                              },
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: 0, top: 10.0, right: 0),
                          child: GestureDetector(
                            onTap: () async {},
                            child: Container(
                              height: 180,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFf15f22), width: 1.5),
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                controller: _commentstexteditcontroller,
                                style: TextStyle(
                                  fontFamily: 'Calibri',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: null,

                                // Set maxLines to null for multiline input
                                decoration: InputDecoration(
                                  hintText: 'Comments',
                                  hintStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Calibri',
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 12.0,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFFf15f22),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                validaterating();
                              },
                              child: Text(
                                'Submit',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Calibri'),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> validaterating() async {
    bool isValid = true;
    bool hasValidationFailed = false;
    if (rating_star != null && rating_star <= 0.0) {
      CommonUtils.showCustomToastMessageLong('Please Give Rating', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
      FocusScope.of(context).unfocus();
    }

    if (isValid && _commentstexteditcontroller.text.trim().isEmpty) {
      CommonUtils.showCustomToastMessageLong('Please Enter Comments', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
      FocusScope.of(context).unfocus();
    }
    if (isValid) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String? storedEmployeeId = sharedPreferences.getString("employeeId");
      print('employidinfeedback$storedEmployeeId');
      String comments = _commentstexteditcontroller.text.toString();
      int myInt = rating_star.toInt();
      print('changedintoint$myInt');
    }
  }
}
