// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:hairfixingzone/Common/custom_button.dart';
// import 'package:hairfixingzone/Common/custome_form_field.dart';
// import 'package:hairfixingzone/CommonUtils.dart';
// import 'package:http/http.dart' as http;
//
// import 'CustomerLoginScreen.dart';
//
// class ForgotChangePassword extends StatefulWidget {
//   const ForgotChangePassword({super.key});
//
//   @override
//   State<ForgotChangePassword> createState() => _ForgotChangePasswordState();
// }
//
// class _ForgotChangePasswordState extends State<ForgotChangePassword> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CommonUtils.primaryColor,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: CommonUtils.primaryTextColor,
//           ),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         backgroundColor: Colors.transparent, // Transparent app bar
//         elevation: 0, // No shadow
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height / 2.2,
//               decoration: const BoxDecoration(),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: MediaQuery.of(context).size.height / 4.5,
//                       child: Image.asset('assets/hfz_logo.png'),
//                     ),
//                     const SizedBox(
//                       height: 5.0,
//                     ),
//                     const Text('Forgot Password',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontFamily: "Calibri",
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 2,
//                           color: Color(0xFF662d91),
//                         )),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     const Text('Reset Your Password For Recovery ', style: CommonUtils.Sub_header_Styles),
//                     const Text('And Log In to Your Account ', style: CommonUtils.Sub_header_Styles),
//                   ],
//                 ),
//                 // Column(
//                 //   mainAxisAlignment: MainAxisAlignment.center,
//                 //   children: [
//                 //     SizedBox(
//                 //       width: MediaQuery.of(context).size.height / 4.5,
//                 //       child: Image.asset('assets/hfz_logo.png'),
//                 //     ),
//                 //     const SizedBox(
//                 //       height: 5.0,
//                 //     ),
//                 //     const Text('Forgot Password',
//                 //         style: TextStyle(
//                 //           fontSize: 24,
//                 //           fontFamily: "Calibri",
//                 //           fontWeight: FontWeight.w700,
//                 //           letterSpacing: 2,
//                 //           color: Color(0xFF662d91),
//                 //         )),
//                 //     const SizedBox(
//                 //       height: 20,
//                 //     ),
//                 //     const Text('Login your account',
//                 //         style: CommonUtils.Sub_header_Styles),
//                 //     const Text('to access all the services',
//                 //         style: CommonUtils.Sub_header_Styles),
//                 //   ],
//                 // ),
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 2,
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 child: Form(
//                   key: _formKey,
//                   child: Container(
//                     // height: MediaQuery.of(context).size.height,
//                     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30.0),
//                         topRight: Radius.circular(30.0),
//                       ),
//                     ),
//                     height: MediaQuery.of(context).size.height / 2,
//                     width: MediaQuery.of(context).size.width,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Column(
//                           children: [
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             CustomeFormField(
//                               label: 'Password',
//                               validator: validatePassword,
//                               controller: _passwordController,
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             CustomeFormField(
//                               label: 'Confirm Password',
//                               validator: validateConfirmPassword,
//                               controller: _confirmPasswordController,
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: CustomButton(
//                                     buttonText: 'Change Password',
//                                     color: CommonUtils.primaryTextColor,
//                                     onPressed: loginUser,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text('Back to login?', style: CommonUtils.Mediumtext_14),
//                                 GestureDetector(
//                                   onTap: () {
//                                     // Handle the click event for the "Click here!" text
//                                     print('Click here! clicked');
//                                     // Add your custom logic or navigation code here
//                                     Navigator.of(context).push(
//                                       MaterialPageRoute(
//                                         builder: (context) => CustomerLoginScreen(),
//                                       ),
//                                     );
//                                   },
//                                   child: Text(' Click here!',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontFamily: "Calibri",
//                                         fontWeight: FontWeight.w700,
//                                         color: Color(0xFF0f75bc),
//                                       )),
//                                 )
//                               ],
//                             ),
//                             // const Row(
//                             //   mainAxisAlignment: MainAxisAlignment.center,
//                             //   children: [
//                             //     Text(
//                             //       'Back to login?',
//                             //       style: TextStyle(
//                             //         fontSize: 15,
//                             //         color: Colors.black,
//                             //       ),
//                             //     ),
//                             //     Text(
//                             //       ' Click Here',
//                             //       style: TextStyle(
//                             //         fontSize: 15,
//                             //         color: CommonUtils.primaryTextColor,
//                             //       ),
//                             //     ),
//                             //   ],
//                             // ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter an password';
//     }
//     // if (value.length < 4) {
//     //   return 'Password must be 4 characters or more';
//     // }
//     // if (value.length > 8) {
//     //   return 'Password must be 8 characters or less';
//     // }
//     return null;
//   }
//
//   String? validateConfirmPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter a confirm password';
//     }
//     if (value != _passwordController.text) {
//       return 'Passwords do not match';
//     }
//     return null;
//   }
//
//   void loginUser() {
//     if (_formKey.currentState!.validate()) {
//       print('${_passwordController.text} and ${_confirmPasswordController.text}');
//
//       changePassword(_passwordController.text, _confirmPasswordController.text);
//     }
//   }
//
//   Future<void> changePassword(String newPassword, String confirmPassword) async {
//     try {
//       const apiUrl = 'http://182.18.157.215/SaloonApp/API/ResetPassword';
//
//       final Map<String, dynamic> requestObject = {
//         "id": 1, //userid
//         "newPassword": newPassword,
//         "confirmPassword": confirmPassword,
//       };
//
//       final jsonResponse = await http.post(
//         Uri.parse(apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(requestObject),
//       );
//
//       if (jsonResponse.statusCode == 200) {
//         final Map<String, dynamic> response = jsonDecode(jsonResponse.body);
//         if (response['isSuccess']) {
//           print('Password Reset Successfully');
//           openDialog();
//         } else {
//           print('Failed');
//         }
//       }
//     } catch (error) {
//       rethrow;
//     }
//   }
//
//   void openDialog() async {
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               SizedBox(
//                 width: 150,
//                 child: Image.asset('assets/password_success.png'),
//               ),
//               const SizedBox(
//                 height: 50,
//               ),
//               Center(
//                 // Center the text
//                 child: const Text(
//                   'Your Password Has Been Successfully Changed',
//                   style: CommonUtils.txSty_18b_fb,
//                   textAlign: TextAlign.center, // Optionally, align the text center
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               CustomButton(
//                 buttonText: 'Done',
//                 color: CommonUtils.primaryTextColor,
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => CustomerLoginScreen(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // void openDialog() async {
//   //   await showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return AlertDialog(
//   //         content: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           mainAxisAlignment: MainAxisAlignment.center,
//   //           children: [
//   //             const SizedBox(
//   //               height: 10,
//   //             ),
//   //             SizedBox(
//   //               width: 150,
//   //               child: Image.asset('assets/password_success.png'),
//   //             ),
//   //             const SizedBox(
//   //               height: 50,
//   //             ),
//   //             const Text(
//   //               'Your Password Has Been Successfully Changed',
//   //               style: CommonUtils.txSty_18b_fb,
//   //             ),
//   //             const SizedBox(
//   //               height: 30,
//   //             ),
//   //             CustomButton(
//   //                 buttonText: 'Done',
//   //                 color: CommonUtils.primaryTextColor,
//   //                 onPressed: () {
//   //                   Navigator.pop(context);
//   //                 })
//   //           ],
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hairfixingzone/Common/custom_button.dart';
import 'package:hairfixingzone/Common/custome_form_field.dart';
import 'package:hairfixingzone/CommonUtils.dart';
import 'package:http/http.dart' as http;

import 'CustomerLoginScreen.dart';

class ForgotChangePassword extends StatefulWidget {
  final int id;

  ForgotChangePassword({required this.id});

  @override
  State<ForgotChangePassword> createState() => _ForgotChangePasswordState();
}

class _ForgotChangePasswordState extends State<ForgotChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _password_obscureText = true;
  bool confirmpassword_obscuretext = true;
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
        backgroundColor: CommonUtils.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.2,
              decoration: const BoxDecoration(),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.height / 4.5,
                      child: Image.asset('assets/hfz_logo.png'),
                    ),
                    const SizedBox(
                      height: 5.0,
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
                    const Text('Reset Your Password For Recovery ', style: CommonUtils.Sub_header_Styles),
                    const Text('And Log In to Your Account ', style: CommonUtils.Sub_header_Styles),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 2,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            // CustomeFormField(
                            //   label: 'New Password',
                            //   validator: validatePassword,
                            //   controller: _passwordController,
                            // ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // CustomeFormField(
                            //   label: 'Confirm Password',
                            //   validator: validateConfirmPassword,
                            //   controller: _confirmPasswordController,
                            // ),
                            Row(
                              children: [
                                Text(
                                  'New Password',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            TextFormField(
                              obscureText: _password_obscureText,

                              controller: _passwordController, // Assigning the controller
                              keyboardType: TextInputType.visiblePassword,
                              // obscureText: true,
                              onTap: () {},
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: CommonUtils.primaryTextColor,
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: CommonUtils.primaryTextColor,
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                hintText: 'Enter Password',
                                counterText: "",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _password_obscureText ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    // Toggle the password visibility
                                    setState(() {
                                      _password_obscureText = !_password_obscureText;
                                    });
                                  },
                                ),
                                hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                              ),
                              validator: validatePassword,
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Confirm Password',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            TextFormField(
                              obscureText: confirmpassword_obscuretext,

                              controller: _confirmPasswordController, // Assigning the controller
                              keyboardType: TextInputType.visiblePassword,
                              // obscureText: true,
                              onTap: () {},
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: CommonUtils.primaryTextColor,
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: CommonUtils.primaryTextColor,
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                hintText: 'Enter Confirm Password',
                                counterText: "",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    confirmpassword_obscuretext ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    // Toggle the password visibility
                                    setState(() {
                                      confirmpassword_obscuretext = !confirmpassword_obscuretext;
                                    });
                                  },
                                ),
                                hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                              ),
                              validator: validatePassword,
                            ),
                            //  SizedBox(
                            //   height: 5,
                            // ),
                            SizedBox(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Back to login?', style: CommonUtils.Mediumtext_14),
                                GestureDetector(
                                  onTap: () {
                                    // Handle the click event for the "Click here!" text
                                    print('Click here! clicked');
                                    // Add your custom logic or navigation code here
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const CustomerLoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(' Click here!',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Calibri",
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0f75bc),
                                      )),
                                )
                              ],
                            ),
                            // const Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //       'Back to login?',
                            //       style: TextStyle(
                            //         fontSize: 15,
                            //         color: Colors.black,
                            //       ),
                            //     ),
                            //     Text(
                            //       ' Click Here',
                            //       style: TextStyle(
                            //         fontSize: 15,
                            //         color: CommonUtils.primaryTextColor,
                            //       ),
                            //     ),
                            //   ],
                            // ),
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
      return 'Please Enter Password';
    } else if (value.length < 8) {
      return 'Password must be 8 characters or above';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Confirm Password';
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      return 'Confirm Password must be same as Password';
    }
    return null;
  }

  void loginUser() {
    if (_formKey.currentState!.validate()) {
      print('${_passwordController.text} and ${_confirmPasswordController.text}');

      changePassword(_passwordController.text, _confirmPasswordController.text);
    }
  }

  Future<void> changePassword(String newPassword, String confirmPassword) async {
    try {
      const apiUrl = 'http://182.18.157.215/SaloonApp/API/ResetPassword';

      final Map<String, dynamic> requestObject = {
        "id": widget.id, //userid
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };
      print('requestObject${jsonEncode(requestObject)}');
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
      barrierDismissible: false,
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
              const Center(
                // Center the text
                child: Text(
                  'Your Password Has Been Successfully Changed',
                  style: CommonUtils.txSty_18b_fb,
                  textAlign: TextAlign.center, // Optionally, align the text center
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                buttonText: 'Done',
                color: CommonUtils.primaryTextColor,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CustomerLoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

// void openDialog() async {
//   await showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(
//               height: 10,
//             ),
//             SizedBox(
//               width: 150,
//               child: Image.asset('assets/password_success.png'),
//             ),
//             const SizedBox(
//               height: 50,
//             ),
//             const Text(
//               'Your Password Has Been Successfully Changed',
//               style: CommonUtils.txSty_18b_fb,
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             CustomButton(
//                 buttonText: 'Done',
//                 color: CommonUtils.primaryTextColor,
//                 onPressed: () {
//                   Navigator.pop(context);
//                 })
//           ],
//         ),
//       );
//     },
//   );
// }
}
