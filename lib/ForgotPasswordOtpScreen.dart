import 'package:flutter/material.dart';
import 'package:hairfixingzone/Common/custom_button.dart';
import 'package:hairfixingzone/CommonUtils.dart';
import 'package:hairfixingzone/ForgotChangePassword.dart';
import 'package:pin_code_fields/pin_code_fields.dart';



class ForgotPasswordOtpScreen extends StatefulWidget {
  const ForgotPasswordOtpScreen({super.key});

  @override
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
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
                      const Text('Please check your email to',
                          style: CommonUtils.Sub_header_Styles),
                      const Text('take 6 digit code for continue',
                          style: CommonUtils.Sub_header_Styles),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).size.height /
                          2, // Adjust the height here
                  child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Form(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 40),
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
                                      activeColor:
                                      const Color.fromARGB(255, 63, 3, 109),
                                      selectedColor:
                                      const Color.fromARGB(255, 63, 3, 109),
                                      selectedFillColor: Colors.white,
                                      activeFillColor: Colors.white,
                                      inactiveFillColor: Colors.white,
                                      inactiveColor:
                                      CommonUtils.primaryTextColor,
                                    ),
                                    animationDuration:
                                    const Duration(milliseconds: 300),
                                    // backgroundColor: Colors
                                    //     .blue.shade50, // Set background color
                                    enableActiveFill: true,
                                    controller: _otpController,
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
                                ],
                              ),
                              const Row(
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
                        ),
                      )))
            ],
          )),
    );
  }

  void validateOtp() {
    print('OTP: ${_otpController.text}');
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => const ForgotChangePassword(),
    //   ),
    // );
  }
}
