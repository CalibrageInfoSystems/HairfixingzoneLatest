import 'package:flutter/material.dart';
import 'package:hairfixingzone/CommonUtils.dart';

import 'Common/custom_button.dart';
import 'Common/custome_form_field.dart';
import 'ForgotPasswordscreen.dart';
import 'HomeScreen.dart';

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<CustomerLoginScreen> {
  bool isTextFieldFocused = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonUtils.primaryColor,
      body:
      SingleChildScrollView(child:
      Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Expanded(
          //   child:
          //
          // ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
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
            child:
            Center(
              child: Column(
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
                    'Customer Login',
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
                    'Login your account',
                      style: CommonUtils.Sub_header_Styles
                  ),
                  const Text(
                    'to access all the services',
                style: CommonUtils.Sub_header_Styles
                  ),
                ],
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child:
          //
          // ),
         Form(key: _formKey,child: Container(
         // height: MediaQuery.of(context).size.height,
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
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    CustomeFormField(label: 'Email/User Name', validator: validateEmail,),
                    SizedBox(
                      height: 10,
                    ),
                    CustomeFormField(label: 'Password', validator: validatePassword,),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgotPasswordscreen()),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: CommonUtils.txSty_12b_fb,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen()),
                              );
                            },
                            child:  CustomButton(
                              buttonText: 'Login',
                              color: CommonUtils.primaryTextColor,
                              onPressed: loginUser,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New User?',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          ' Register Here',
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
         ) ],
      )),

    );
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Password';
    }
    if (value.length < 4) {
      return 'Password must be 4 characters or more';
    }
    if (value.length > 8) {
      return 'Password must be 8 characters or less';
    }
    return null;
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

  void loginUser() {
    if (_formKey.currentState!.validate()) {
      print('login: Login success!');
    }
  }
}
