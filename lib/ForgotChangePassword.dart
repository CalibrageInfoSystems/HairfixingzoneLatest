import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hairfixingzone/Common/custom_button.dart';
import 'package:hairfixingzone/Common/custome_form_field.dart';
import 'package:hairfixingzone/CommonUtils.dart';
import 'package:http/http.dart' as http;

class ForgotChangePassword extends StatefulWidget {
  const ForgotChangePassword({super.key});

  @override
  State<ForgotChangePassword> createState() => _ForgotChangePasswordState();
}

class _ForgotChangePasswordState extends State<ForgotChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

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
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // No shadow
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.2,
              decoration: const BoxDecoration(),
              child: Center(
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.height / 4.5,

                      child: Image.asset(
                          'assets/hfz_logo.png'),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Text(
                        'Forgot Password',
                        style:  TextStyle(
                          fontSize: 24,
                          fontFamily: "Calibri",
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: Color(0xFF662d91),
                        )
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                        'Reset Your Password For Recovery ',
                        style: CommonUtils.Sub_header_Styles
                    ),
                    const Text(
                        'And Log In to Your Account ',
                        style: CommonUtils.Sub_header_Styles
                    ),
                  ],
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     SizedBox(
                //       width: MediaQuery.of(context).size.height / 4.5,
                //       child: Image.asset('assets/hfz_logo.png'),
                //     ),
                //     const SizedBox(
                //       height: 5.0,
                //     ),
                //     const Text('Forgot Password',
                //         style: TextStyle(
                //           fontSize: 24,
                //           fontFamily: "Calibri",
                //           fontWeight: FontWeight.w700,
                //           letterSpacing: 2,
                //           color: Color(0xFF662d91),
                //         )),
                //     const SizedBox(
                //       height: 20,
                //     ),
                //     const Text('Login your account',
                //         style: CommonUtils.Sub_header_Styles),
                //     const Text('to access all the services',
                //         style: CommonUtils.Sub_header_Styles),
                //   ],
                // ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).size.height / 2,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Container(
                    // height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            CustomeFormField(
                              label: 'Password',
                              validator: validatePassword,
                              controller: _passwordController,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomeFormField(
                              label: 'Confirm Password',
                              validator: validateConfirmPassword,
                              controller: _confirmPasswordController,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    buttonText: 'Change Password',
                                    color: CommonUtils.primaryTextColor,
                                    onPressed: loginUser,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
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
                                  ' Click Here',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: CommonUtils.primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an password';
    }
    // if (value.length < 4) {
    //   return 'Password must be 4 characters or more';
    // }
    // if (value.length > 8) {
    //   return 'Password must be 8 characters or less';
    // }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a confirm password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void loginUser() {
    if (_formKey.currentState!.validate()) {
      print(
          '${_passwordController.text} and ${_confirmPasswordController.text}');

      changePassword(_passwordController.text, _confirmPasswordController.text);
    }
  }

  Future<void> changePassword(
      String newPassword, String confirmPassword) async {
    try {
      const apiUrl = 'http://182.18.157.215/SaloonApp/API/ResetPassword';

      final Map<String, dynamic> requestObject = {
        "id": 1,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };

      final jsonResponse = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestObject),
      );

      if (jsonResponse.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(jsonResponse.body);
        if (response['isSuccess']) {
          print('Password Reset Successfully');
          openDialog();
        } else {
          print('Failed');
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  void openDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 150,
                child: Image.asset('assets/password_success.png'),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Your password has been successfully changed',
                style: CommonUtils.txSty_18b_fb,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                  buttonText: 'Done',
                  color: CommonUtils.primaryTextColor,
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        );
      },
    );
  }
}
