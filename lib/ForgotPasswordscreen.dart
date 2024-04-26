import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hairfixingzone/CommonUtils.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'Common/custom_button.dart';
import 'Common/custome_form_field.dart';
import 'ForgotPasswordOtpScreen.dart';
import 'api_config.dart';

class ForgotPasswordscreen extends StatefulWidget {
  const ForgotPasswordscreen({super.key});

  @override
  State<ForgotPasswordscreen> createState() => _ForgotPasswordscreen();
}

class _ForgotPasswordscreen extends State<ForgotPasswordscreen> {
  final TextEditingController username = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonUtils.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: CommonUtils.primaryTextColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // No shadow
      ),
      body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Form(
              //   key: _formKey,
              //   child:
              Container(
                height: MediaQuery.of(context).size.height / 2.2,
                decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.only(
                    //   bottomLeft: Radius.circular(20.0),
                    //   bottomRight: Radius.circular(20.0),
                    // ),
                    // image: DecorationImage(
                    //   image: AssetImage('assets/befor_login_illustration.png'),
                    //   fit: BoxFit.cover,
                    //   alignment: Alignment.center,
                    // ),
                    ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.height / 4.5,
                        child: Image.asset('assets/hfz_logo.png'),
                      ),
                      Text('Forgot Password',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: "Calibri",
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: Color(0xFF662d91),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Enter your email address and we will send you a code', style: CommonUtils.Sub_header_Styles),
                      Text('we will send you a code', style: CommonUtils.Sub_header_Styles),
                    ],
                  ),
                ),
              ),
              // ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child:
              //
              // ),
              _isloading
                  ? LoadingAnimationWidget.fourRotatingDots(
                      color: Color(0xFF662e91),
                      size: 40.0,
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 2, // Adjust the height here
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Form(
                            key: _formKey,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                              ),
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(),
                                  // Form(
                                  //   key: _formKey,
                                  //   child:
                                  Column(
                                    children: [
                                      CustomeFormField(
                                        label: 'Email/User Name',
                                        validator: validateEmail,
                                        controller: username,
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      CustomButton(
                                        buttonText: 'Send OTP',
                                        color: CommonUtils.primaryTextColor,
                                        onPressed: forgotUser,
                                      ),
                                    ],
                                  ),
                                  // ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Back to login?',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        ' Click here',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: CommonUtils.primaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      )),
            ],
          )),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Email/User Name';
    }
    // else if (!RegExp(
    //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //     .hasMatch(value)) {
    //   return 'Please enter a valid email address';
    // }
    return null;
  }

  Future<void> forgotUser() async {
    if (_formKey.currentState!.validate()) {
      print('login: Login success!');
      String? _username = username.text.toString();

      // Print the username and password
      //  print('Username: $email');
      print('Password: $_username');
      setState(() {
        _isloading = true; //Enable loading before getQuestions
      });
      final String apiUrl = baseUrl + validateusername;

      // Prepare the request body
      Map<String, String> requestBody = {
        'userName': _username,
      };

      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
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
        setState(() {
          _isloading = false; //Enable loading before getQuestions
        });
        // Handle the data accordingly
        if (isSuccess) {
          // If the user is valid, you can extract more data from 'listResult'

          if (data['listResult'] != null) {
            List<dynamic> listResult = data['listResult'];
            Map<String, dynamic> user = listResult.first;
            print('userid: ${user['id']}');
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ForgotPasswordOtpScreen(
                        id: user['id'], userName: user['userName']
                      )),
            );
            CommonUtils.showCustomToastMessageLong('Otp has Sent to Your Mail', context, 0, 3, toastPosition: MediaQuery.of(context).size.height / 2);
          } else {
            FocusScope.of(context).unfocus();
            CommonUtils.showCustomToastMessageLong('Invalid User ', context, 1, 3, toastPosition: MediaQuery.of(context).size.height / 2);
          }
        } else {
          FocusScope.of(context).unfocus();
          CommonUtils.showCustomToastMessageLong("${data["statusMessage"]}", context, 1, 3, toastPosition: MediaQuery.of(context).size.height / 2);
          // Handle the case where the user is not valid
          setState(() {
            _isloading = false; //Enable loading before getQuestions
          });
          List<dynamic> validationErrors = data['validationErrors'];
          if (validationErrors.isNotEmpty) {
            // Print or handle validation errors if any
          }
        }
      } else {
        setState(() {
          _isloading = false; //Enable loading before getQuestions
        });
        // Handle any error cases here
        print('Failed to connect to the API. Status code: ${response.statusCode}');
      }
    }
  }
}
