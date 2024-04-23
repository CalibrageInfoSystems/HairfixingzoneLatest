import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hairfixingzone/CommonUtils.dart';

import 'Common/custom_button.dart';
import 'Common/custome_form_field.dart';
import 'HomeScreen.dart';


class ForgotPasswordscreen extends StatefulWidget {
  const ForgotPasswordscreen({super.key});

  @override
  State<ForgotPasswordscreen> createState() => _ForgotPasswordscreen();
}

class _ForgotPasswordscreen extends State<ForgotPasswordscreen> {
  bool isTextFieldFocused = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonUtils.primaryColor,
      body:    SingleChildScrollView(child:
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
          Form(child: Container(
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
                // Column(
                //   children: [
                //     SizedBox(
                //       height: 30,
                //     ),
                //     CustomeFormField(label: 'User Name', validator: validateEmail,),
                //     SizedBox(
                //       height: 30,
                //     ),
                //     CustomeFormField(label: 'Password', validator: validatePassword,),
                //     SizedBox(
                //       height: 5,
                //     ),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(builder: (context) => ForgotPasswordscreen()),
                //             );
                //           },
                //           child: Text(
                //             'Forgot Password?',
                //             style: CommonUtils.txSty_12b_fb,
                //           ),
                //         ),
                //       ],
                //     ),
                //     SizedBox(
                //       height: 50,
                //     ),
                //     Row(
                //       children: [
                //         Expanded(
                //           child: GestureDetector(
                //             onTap: () {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(builder: (context) => HomeScreen()),
                //               );
                //             },
                //             child:  CustomButton(
                //               buttonText: 'Login',
                //               color: CommonUtils.primaryTextColor,
                //               onPressed: loginUser,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),


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
          ),
          ) ],
      )),

    );
  }
}
