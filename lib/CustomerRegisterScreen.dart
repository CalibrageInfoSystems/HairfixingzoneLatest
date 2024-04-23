import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hairfixingzone/CommonUtils.dart';


class CustomerRegisterScreen extends StatefulWidget {
  const CustomerRegisterScreen({super.key});

  @override
  State<CustomerRegisterScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<CustomerRegisterScreen> {
  bool isTextFieldFocused = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonUtils.primaryColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
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
                    Container(
                      color: Colors.grey,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image.asset('assets/hair_fixing_logo.png'),
                    ),
                    const Text(
                      'Customer Login',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: CommonUtils.primaryTextColor,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Login your account',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    const Text(
                      'to access all the services',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              height: MediaQuery.of(context).size.height / 2.1,
              width: MediaQuery.of(context).size.width,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Column(
                  //   children: [
                  //     SizedBox(
                  //       height: 30,
                  //     ),
                  //     CustomeFormField(label: 'User Name'),
                  //     SizedBox(
                  //       height: 30,
                  //     ),
                  //     CustomeFormField(label: 'Password'),
                  //     SizedBox(
                  //       height: 5,
                  //     ),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.end,
                  //       children: [
                  //         Text(
                  //           'Forgot Password?',
                  //           style: CommonStyles.txSty_12b_fb,
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(
                  //       height: 50,
                  //     ),
                  //     Row(
                  //       children: [
                  //         Expanded(child: CustomButton(buttonText: 'Login')),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       'New User?',
                  //       style: CommonStyles.txSty_18b_fb,
                  //     ),
                  //     Text(
                  //       ' Register Here',
                  //       style: CommonStyles.txSty_18p_f7,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
