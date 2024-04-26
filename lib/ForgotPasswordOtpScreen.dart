import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:hairfixingzone/Common/custom_button.dart';
import 'package:hairfixingzone/CommonUtils.dart';
import 'package:hairfixingzone/ForgotChangePassword.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'api_config.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final int id;

  ForgotPasswordOtpScreen({required this.id});

  @override
  State<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  late Timer _timer;
  int _secondsRemaining = 600;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
          // Handle timeout here
        }
      });
    });
  }

  String? currentText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonUtils.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: CommonUtils.primaryTextColor,
          ),
          onPressed: () {
            // Add your functionality here when the arrow button is pressed
          },
        ),
        backgroundColor: CommonUtils.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
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
                      const Text('Forgot Password',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: "Calibri",
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: Color(0xFF662d91),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Please check your email to', style: CommonUtils.Sub_header_Styles),
                      const Text('take 6 digit code for continue', style: CommonUtils.Sub_header_Styles),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 2, // Adjust the height here
                  child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Form(
                        key: _formKey,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
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
                              const SizedBox(),
                              Column(
                                children: [
                                  PinCodeTextField(
                                    appContext: context,
                                    length: 6,
                                    obscureText: false,
                                    animationType: AnimationType.fade,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(10),
                                      fieldHeight: 50,
                                      fieldWidth: 45,
                                      activeColor: const Color.fromARGB(255, 63, 3, 109),
                                      selectedColor: const Color.fromARGB(255, 63, 3, 109),
                                      selectedFillColor: Colors.white,
                                      activeFillColor: Colors.white,
                                      inactiveFillColor: Colors.white,
                                      inactiveColor: CommonUtils.primaryTextColor,
                                    ),
                                    animationDuration: const Duration(milliseconds: 300),
                                    // backgroundColor: Colors
                                    //     .blue.shade50, // Set background color
                                    enableActiveFill: true,
                                    controller: _otpController,

                                    keyboardType: TextInputType.number,
                                    validator: validateotp,
                                    onCompleted: (v) {
                                      print("Completed");
                                    },
                                    onChanged: (value) {
                                      print(value);
                                      setState(() {
                                        currentText = value;
                                      });
                                    },
                                    beforeTextPaste: (text) {
                                      print("Allowing to paste $text");
                                      return true;
                                    },
                                  ),

                                  // OTPTextField(
                                  //   length: 6,
                                  //   spaceBetween: 10,
                                  //   width: MediaQuery.of(context).size.width,
                                  //   fieldWidth: 40,
                                  //   style: const TextStyle(fontSize: 20),
                                  //   textFieldAlignment:
                                  //       MainAxisAlignment.center,
                                  //   fieldStyle: FieldStyle.box,
                                  //   otpFieldStyle: OtpFieldStyle(
                                  //     borderColor: CommonUtils.primaryTextColor,
                                  //     enabledBorderColor:
                                  //         CommonUtils.primaryTextColor,
                                  //   ),
                                  //   onCompleted: (pin) {
                                  //     print("Completed: ");
                                  //   },
                                  // ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'OTP Validate For ${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')} Minutes',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Didn\'t receive code?',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        ' Resend code',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: CommonUtils.primaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  CustomButton(
                                    buttonText: 'Validate OTP',
                                    color: CommonUtils.primaryTextColor,
                                    onPressed: validateOtp,
                                  ),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    ' ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: CommonUtils.primaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )))
            ],
          )),
    );
  }

  String? validateotp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter OTP';
    }
    // if (value.length != 6) {
    //   return 'OTP should be exactly 6 characters long';
    // }
    return null;
  }

  Future<void> validateOtp() async {
    print('OTP: ${_otpController.text}');
    if (_formKey.currentState!.validate()) {
      String otpentered = _otpController.text;
      print('otpentered: $otpentered');

      Map<String, String> requestBody = {"id": widget.id.toString(), "otp": "$otpentered"};

      final String apiUrl = baseUrl + validateusernameotp;
      final response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );
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
            print('userid: ${user['id']}');
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ForgotChangePassword(),
              ),
            );
            CommonUtils.showCustomToastMessageLong('${data["statusMessage"]}', context, 0, 3, toastPosition: MediaQuery.of(context).size.height / 2);
          } else {
            FocusScope.of(context).unfocus();
            CommonUtils.showCustomToastMessageLong('${data["statusMessage"]} ', context, 1, 3, toastPosition: MediaQuery.of(context).size.height / 2);
          }
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
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => const ForgotChangePassword(),
    //   ),
    // );
  }
}