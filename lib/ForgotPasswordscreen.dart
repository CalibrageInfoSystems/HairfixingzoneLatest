import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hairfixingzone/CommonUtils.dart';


import 'Common/custom_button.dart';
import 'Common/custome_form_field.dart';
import 'ForgotPasswordOtpScreen.dart';

class ForgotPasswordscreen extends StatefulWidget {
  const ForgotPasswordscreen({super.key});

  @override
  State<ForgotPasswordscreen> createState() => _ForgotPasswordscreen();
}

class _ForgotPasswordscreen extends State<ForgotPasswordscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonUtils.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: CommonUtils.primaryTextColor ,),
          onPressed: () {
            // Add your functionality here when the arrow button is pressed
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
                      const Text('Enter your email address and ',
                          style: CommonUtils.Sub_header_Styles),
                      const Text('we will send you a code',
                          style: CommonUtils.Sub_header_Styles),
                    ],
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child:
              //
              // ),
      SizedBox(
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 2, // Adjust the height here
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child:Form(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
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
                          const CustomeFormField(
                            label: 'User Name',
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          CustomButton(
                            buttonText: 'Send OTP',
                            color: CommonUtils.primaryTextColor,
                            onPressed: forgotUser,
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
              )
          )), ],
          )),
    );
  }

  void forgotUser() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordOtpScreen(),
      ),
    );
  }
}
