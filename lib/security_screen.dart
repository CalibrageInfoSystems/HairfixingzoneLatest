// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hairfixingzone/CommonUtils.dart';
// import 'package:hairfixingzone/UserLoginScreen.dart';
//
// import 'main.dart';
//
// class securityscreen extends StatefulWidget {
//   @override
//   _securityscreenscreenState createState() => _securityscreenscreenState();
// }
//
// class _securityscreenscreenState extends State<securityscreen> with TickerProviderStateMixin {
//   int currentstep = 0;
//   bool isCompleted = false;
//   final TextEditingController _usernamecontroller = TextEditingController();
//   final TextEditingController _confirmcontroller = TextEditingController();
//   final TextEditingController _reconfirmcontroller = TextEditingController();
//   final TextEditingController _answer_1_controller = TextEditingController();
//   final TextEditingController _answer_2_controller = TextEditingController();
//   bool isLoading = false;
//   bool isFirstApiCall = true;
//   bool _obscureText_confirm = true;
//   bool _obscureText_reconfirm = true;
//   List<Map<String, dynamic>> questionsAndAnswers = [];
//   List<Map<String, dynamic>> additionalQuestionsAndAnswers = [];
//   int noofquestionavaiable = 0;
//   String? Question_1, Question_2, Answer_1, Answer_2, api_answer_1, api_answer_2;
//   Map<int, TextEditingController> _answerControllers = {};
//
//   @override
//   void initState() {
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery
//         .of(context)
//         .size
//         .height;
//     double screenWidth = MediaQuery
//         .of(context)
//         .size
//         .width;
//     return WillPopScope(
//         onWillPop: () async {
//           // Handle back button press here
//           // You can add any custom logic before closing the app
//           return true; // Return true to allow back button press and close the app
//         },
//         child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           home: Scaffold(
//             appBar: AppBar(
//               elevation: 0,
//               title: Column(
//                 children: [
//                   Align(
//                       alignment: Alignment.topLeft,
//                       child: Container(
//                         padding: EdgeInsets.only(left: 10.0, top: 5.0),
//                         child: GestureDetector(
//                           onTap: () {
//                             // Handle the back button press here
//                             // Navigator.pop(context);
//                             Navigator.maybePop(context);
//                           },
//                           child: Container(
//                             width: 40.0,
//                             height: 40.0,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white, // Change the color as needed
//                             ),
//                             child: Icon(
//                               Icons.arrow_back,
//                               color: Color(0xFFF44614), // Change the color as needed
//                             ),
//                           ),
//                         ),
//                       )),
//                 ],
//               ),
//             ),
//             body: Theme(
//               data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Color(0xFFf15f22))),
//               child:
//               Container(
//                   height: screenHeight,
//                   width: screenWidth,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage(
//                         'assets/background.png',
//                       ), // Replace with your image path
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//
//                       Padding(
//                         padding: EdgeInsets.only(top: 35.0),
//
//                       ),
//                       SizedBox(height: 5.0),
//                       Container(
//                         width: double.infinity,
//                         child: Text(
//                           'Add Appointment',
//                           style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Calibri', fontWeight: FontWeight.bold),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       SizedBox(height: 10.0),
//                       SingleChildScrollView(
//                         child: Stepper(
//                           type: StepperType.vertical,
//                           currentStep: currentstep,
//                           onStepTapped: (step) {
//                             List<bool> completedSteps = List.generate(getSteps().length, (index) => false);
//
//                             //setState(() => currentstep = step);
//                             if (step > 0 && !completedSteps[step - 1]) {
//                               CommonUtils.showCustomToastMessageLong('Please Complete Previous Steps', context, 1, 4);
//                               // You may show a message or take other actions to inform the user
//                               // that they need to complete the previous step first.
//                               return;
//                             }
//                             if (currentstep == 0) {
//                               // Check if the username field is empty
//                               if (_usernamecontroller.text.isEmpty) {
//                                 // Show a toast message indicating that the username field is required
//                                 CommonUtils.showCustomToastMessageLong('Complete the Username', context, 1, 4);
//                                 return; // Return to prevent proceeding to the next step
//                               }
//                             }
//                           },
//                           controlsBuilder: (BuildContext context, ControlsDetails details) {
//                             return Row(
//                               children: <Widget>[
//                                 if (currentstep > 0)
//                                   Padding(
//                                     padding: EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0),
//                                     child: Container(
//                                       height: 35,
//                                       decoration: BoxDecoration(
//                                         color: Color(0xFFf15f22),
//                                         borderRadius: BorderRadius.circular(6.0),
//                                       ),
//                                       child: ElevatedButton(
//                                         onPressed: details.onStepCancel,
//                                         child: Text(
//                                           'Previous',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 16,
//                                             fontFamily: 'Calibri',
//                                           ),
//                                         ),
//                                         style: ElevatedButton.styleFrom(
//                                           primary: Colors.transparent,
//                                           elevation: 0,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(4.0),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 Spacer(),
//                                 Padding(
//                                   padding: EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0),
//                                   child: Container(
//                                     height: 35,
//                                     decoration: BoxDecoration(
//                                       color: Color(0xFFf15f22),
//                                       borderRadius: BorderRadius.circular(6.0),
//                                     ),
//                                     child: ElevatedButton(
//                                       onPressed: details.onStepContinue,
//                                       child: Text(
//                                         currentstep == getSteps().length - 1 ? 'Submit' : 'Next',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                           fontFamily: 'Calibri',
//                                         ),
//                                       ),
//                                       style: ElevatedButton.styleFrom(
//                                         primary: Colors.transparent,
//                                         elevation: 0,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(4.0),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                           onStepContinue: () async {
//                             switch (currentstep) {
//                               case 0:
//                               // Call API for Step 1
//                                 if (_usernamecontroller.text.trim().isEmpty) {
//                                   FocusScope.of(context).unfocus();
//                                   CommonUtils.showCustomToastMessageLong('Please Enter The User Name', context, 1, 4);
//                                   return; // Return to prevent proceeding to the next step
//                                 } else {
//                                   setState(() => currentstep += 1);
//                                   // await fetchquestion(_usernamecontroller.text.trim());
//                                 }
//                                 break;
//                               case 1:
//                               // Call API for Step 2
//                                 await validatinganswer();
//                                 break;
//                               case 2:
//                               // Call API for Step 3.
//                                 await checkingpassword();
//                                 break;
//                             // Add more cases for additional steps as needed
//                             }
//                           },
//                           onStepCancel: () {
//                             setState(() => currentstep -= 1);
//                           },
//                           steps: getSteps(),
//                         ),
//                       )
//
//
//                     ],
//                   ),
//                 ),
//
//             ),
//           ),
//         ));
//   }
//   List<Step> getSteps(BuildContext context) {
//     return <Step>[
//       Step(
//         state: currentstep > 0 ? StepState.complete : StepState.indexed,
//         isActive: currentstep >= 0,
//         title: const Text("Account Info"),
//         content: Column(
//           children: [
//             CustomInput(
//               hint: "First Name",
//               inputBorder: OutlineInputBorder(),
//               controller: _firstNameController,
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return 'Please enter your first name';
//                 }
//                 return null;
//               },
//             ),
//             CustomInput(
//               hint: "Last Name",
//               inputBorder: OutlineInputBorder(),
//               controller: _lastNameController,
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return 'Please enter your last name';
//                 }
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//       Step(
//         state: currentStep > 1 ? StepState.complete : StepState.indexed,
//         isActive: currentStep >= 1,
//         title: const Text("Address"),
//         content: Column(
//           children: [
//             CustomInput(
//               hint: "City and State",
//               inputBorder: OutlineInputBorder(),
//               controller: _cityAndStateController,
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return 'Please enter your city and state';
//                 }
//                 return null;
//               },
//             ),
//             CustomInput(
//               hint: "Postal Code",
//               inputBorder: OutlineInputBorder(),
//               controller: _postalCodeController,
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return 'Please enter your postal code';
//                 }
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//       Step(
//         state: currentStep > 2 ? StepState.complete : StepState.indexed,
//         isActive: currentStep >= 2,
//         title: const Text("Misc"),
//         content: Column(
//           children: [
//             CustomInput(
//               hint: "Bio",
//               inputBorder: OutlineInputBorder(),
//               controller: _bioController,
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return 'Please enter your bio';
//                 }
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//     ];
//   }
//
//   // List<Step> getSteps() =>
//   //     [
//   //       Step(
//   //         state: currentstep > 0 ? StepState.complete : StepState.indexed,
//   //         isActive: currentstep >= 0,
//   //         title: Text('User Name'),
//   //         content: Padding(
//   //           padding: EdgeInsets.only(top: 5.0, left: 0.0, right: 0.0),
//   //           child: TextFormField(
//   //
//   //             ///     keyboardType: TextInputType.name,
//   //             maxLength: 8,
//   //             controller: _usernamecontroller,
//   //             onTap: () {
//   //               // requestPhonePermission();
//   //             },
//   //             decoration: InputDecoration(
//   //                 hintText: 'Enter User Name',
//   //                 filled: true,
//   //                 fillColor: Colors.white,
//   //                 focusedBorder: OutlineInputBorder(
//   //                   borderSide: BorderSide(
//   //                     color: Color(0xFFf15f22),
//   //                   ),
//   //                   borderRadius: BorderRadius.circular(6.0),
//   //                 ),
//   //                 enabledBorder: OutlineInputBorder(
//   //                   borderSide: BorderSide(
//   //                     color: Color(0xFFf15f22),
//   //                   ),
//   //                   borderRadius: BorderRadius.circular(6.0),
//   //                 ),
//   //                 hintStyle: TextStyle(
//   //                   color: Colors.black26, // Label text color
//   //                 ),
//   //                 border: InputBorder.none,
//   //                 contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//   //                 alignLabelWithHint: true,
//   //                 counterText: ""),
//   //             textAlign: TextAlign.start,
//   //             style: TextStyle(
//   //               color: Colors.black,
//   //               fontFamily: 'Calibri',
//   //               fontSize: 16,
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //       Step(
//   //         isActive: currentstep >= 1,
//   //         state: currentstep > 1 ? StepState.complete : StepState.indexed,
//   //         title: Text('Security Questions'),
//   //         content: SingleChildScrollView(
//   //             child: Column(
//   //               children: [
//   //                 Visibility(
//   //                   visible: noofquestionavaiable > 2,
//   //                   child: Row(
//   //                     children: [
//   //                       Container(
//   //                         child: Row(
//   //                           children: [
//   //                             Text(
//   //                               'Available Questions: ',
//   //                               style: TextStyle(
//   //                                 color: Colors.black,
//   //                                 fontSize: 18,
//   //                                 fontFamily: 'Calibri',
//   //                               ),
//   //                               textAlign: TextAlign.start,
//   //                             ),
//   //                             Text(
//   //                               ' $noofquestionavaiable',
//   //                               style: TextStyle(color: Color(0xFFf15f22), fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Calibri'),
//   //                               textAlign: TextAlign.start,
//   //                             ),
//   //                           ],
//   //                         ),
//   //                       ),
//   //                       Spacer(),
//   //                       FloatingActionButton(
//   //                         mini: true,
//   //                         onPressed: () {
//   //                           setState(() {
//   //                             isLoading = true;
//   //                           });
//   //                           // fetchrefreshquestion(_usernamecontroller.text).then((_) {
//   //                           //   setState(() {
//   //                           //     isLoading = false;
//   //                           //   });
//   //                           // });
//   //                           print('Floating Action Button Pressed');
//   //                         },
//   //                         child: isLoading
//   //                             ? RotationTransition(
//   //                           turns: Tween(begin: 0.0, end: 1.0).animate(
//   //                             CurvedAnimation(
//   //                               curve: Curves.fastOutSlowIn,
//   //                               parent: AnimationController(
//   //                                 vsync: this,
//   //                                 duration: Duration(seconds: 1),
//   //                               )
//   //                                 ..repeat(),
//   //                             ),
//   //                           ),
//   //                           child: Icon(Icons.refresh),
//   //                         )
//   //                             : Icon(Icons.refresh),
//   //                       )
//   //                     ],
//   //                   ),
//   //                 ),
//   //                 Column(
//   //                   crossAxisAlignment: CrossAxisAlignment.start,
//   //                   mainAxisAlignment: MainAxisAlignment.start,
//   //                   children: [
//   //                     Text(
//   //                       '${Question_1}',
//   //                       style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Calibri'),
//   //                       textAlign: TextAlign.start,
//   //                     ),
//   //                     Padding(
//   //                       padding: EdgeInsets.only(top: 5.0, left: 0.0, right: 0.0),
//   //                       child: TextFormField(
//   //                         controller: _answer_1_controller,
//   //                         decoration: InputDecoration(
//   //                           hintText: 'Please Enter your Answer',
//   //                           filled: true,
//   //                           fillColor: Colors.white,
//   //                           focusedBorder: OutlineInputBorder(
//   //                             borderSide: BorderSide(
//   //                               color: Color(0xFFf15f22),
//   //                             ),
//   //                             borderRadius: BorderRadius.circular(6.0),
//   //                           ),
//   //                           enabledBorder: OutlineInputBorder(
//   //                             borderSide: BorderSide(
//   //                               color: Color(0xFFf15f22),
//   //                             ),
//   //                             borderRadius: BorderRadius.circular(6.0),
//   //                           ),
//   //                           hintStyle: TextStyle(
//   //                             color: Colors.black26,
//   //                           ),
//   //                           border: InputBorder.none,
//   //                           contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//   //                           alignLabelWithHint: true,
//   //                           counterText: "",
//   //                         ),
//   //                         maxLength: 50,
//   //                         textAlign: TextAlign.start,
//   //                         style: TextStyle(
//   //                           color: Colors.black,
//   //                           fontFamily: 'Calibri',
//   //                           fontSize: 16,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                     SizedBox(height: 16),
//   //                   ],
//   //                 ),
//   //                 Column(
//   //                   crossAxisAlignment: CrossAxisAlignment.start,
//   //                   mainAxisAlignment: MainAxisAlignment.start,
//   //                   children: [
//   //                     Text(
//   //                       '${Question_2}',
//   //                       style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Calibri'),
//   //                       textAlign: TextAlign.start,
//   //                     ),
//   //                     Padding(
//   //                       padding: EdgeInsets.only(top: 5.0, left: 0.0, right: 0.0),
//   //                       child: TextFormField(
//   //                         controller: _answer_2_controller,
//   //                         decoration: InputDecoration(
//   //                           hintText: 'Please Enter your Answer',
//   //                           filled: true,
//   //                           fillColor: Colors.white,
//   //                           focusedBorder: OutlineInputBorder(
//   //                             borderSide: BorderSide(
//   //                               color: Color(0xFFf15f22),
//   //                             ),
//   //                             borderRadius: BorderRadius.circular(6.0),
//   //                           ),
//   //                           enabledBorder: OutlineInputBorder(
//   //                             borderSide: BorderSide(
//   //                               color: Color(0xFFf15f22),
//   //                             ),
//   //                             borderRadius: BorderRadius.circular(6.0),
//   //                           ),
//   //                           hintStyle: TextStyle(
//   //                             color: Colors.black26,
//   //                           ),
//   //                           border: InputBorder.none,
//   //                           contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//   //                           alignLabelWithHint: true,
//   //                           counterText: "",
//   //                         ),
//   //                         maxLength: 50,
//   //                         textAlign: TextAlign.start,
//   //                         style: TextStyle(
//   //                           color: Colors.black,
//   //                           fontFamily: 'Calibri',
//   //                           fontSize: 16,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                     SizedBox(height: 16),
//   //                   ],
//   //                 ),
//   //               ],
//   //             )),
//   //       ),
//   //       Step(
//   //         isActive: currentstep >= 2,
//   //         state: currentstep > 2 ? StepState.complete : StepState.indexed,
//   //         title: Text('Change Password'),
//   //         content: Column(
//   //           children: [
//   //             Padding(
//   //               padding: EdgeInsets.only(top: 5.0, left: 0.0, right: 0.0),
//   //               child: TextFormField(
//   //
//   //                 ///     keyboardType: TextInputType.name,
//   //                 obscureText: _obscureText_confirm,
//   //                 controller: _confirmcontroller,
//   //                 onTap: () {},
//   //
//   //                 decoration: InputDecoration(
//   //                   hintText: 'New Password',
//   //                   filled: true,
//   //                   fillColor: Colors.white,
//   //                   focusedBorder: OutlineInputBorder(
//   //                     borderSide: BorderSide(
//   //                       color: Color(0xFFf15f22),
//   //                     ),
//   //                     borderRadius: BorderRadius.circular(6.0),
//   //                   ),
//   //                   enabledBorder: OutlineInputBorder(
//   //                     borderSide: BorderSide(
//   //                       color: Color(0xFFf15f22),
//   //                     ),
//   //                     borderRadius: BorderRadius.circular(6.0),
//   //                   ),
//   //                   hintStyle: TextStyle(
//   //                     color: Colors.black26, // Label text color
//   //                   ),
//   //                   border: InputBorder.none,
//   //                   contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//   //                   alignLabelWithHint: true,
//   //                   counterText: "",
//   //
//   //                 ),
//   //                 maxLength: 25,
//   //                 textAlign: TextAlign.start,
//   //                 style: TextStyle(
//   //                   color: Colors.black,
//   //                   fontFamily: 'Calibri',
//   //                   fontSize: 16,
//   //                 ),
//   //               ),
//   //             ),
//   //             SizedBox(
//   //               height: 5.0,
//   //             ),
//   //
//   //           ],
//   //         ),
//   //       ),
//   //
//   //     ];
//   //
//
//   Future<void> validatinganswer() async {
//     FocusScope.of(context).unfocus();
//     String answer1 = _answer_1_controller.text.trim();
//     String answer2 = _answer_2_controller.text.trim();
//
//     if (answer1.isEmpty || answer2.isEmpty) {
//       CommonUtils.showCustomToastMessageLong('Please Enter Your Answer', context, 1, 4);
//       return;
//     }
//
//     if (answer1 == api_answer_1 && answer2 == api_answer_2) {
//       // Answers match, navigate to the next step
//       setState(() {
//         currentstep += 1;
//         //  Commonutils.showCustomToastMessageLong('Answers are Correct', context, 0, 2);
//       });
//     } else {
//       // Answers do not match, show an error message
//       CommonUtils.showCustomToastMessageLong('Incorrect Answers. Please try again.', context, 1, 4);
//     }
//   }
//
//
//   Future<void> checkingpassword() async {
//     String password1 = _confirmcontroller.text.trim().toString();
//     String password2 = _reconfirmcontroller.text.trim().toString();
//
//     // if (password1.isEmpty || password2.isEmpty) {
//     //   if (password1.isEmpty) {
//     //     Commonutils.showCustomToastMessageLong(
//     //         'Please enter Confirm Password', context, 1, 4);
//     //   }
//     //   if (password2.isEmpty) {
//     //     Commonutils.showCustomToastMessageLong(
//     //         'Please enter Re Confirm Password', context, 1, 4);
//     //   }
//     // }
//     // if (password1.trim().isEmpty && password2.trim().isEmpty) {
//     //   Commonutils.showCustomToastMessageLong(
//     //       'Please Enter password', context, 1, 4);
//     //   return;
//     // } else
//
//     if (password1
//         .trim()
//         .isEmpty) {
//       CommonUtils.showCustomToastMessageLong('Please Enter New Password', context, 1, 4);
//       return;
//     } else if (password2
//         .trim()
//         .isEmpty) {
//       CommonUtils.showCustomToastMessageLong('Please Enter Confirm Password', context, 1, 4);
//       return;
//     }
//     if (password1.trim() == password2.trim()) {
//       if (isPasswordValid(password2.trim())) {
//         //changepasswordapi(password2.trim());
//       } else {
//         CommonUtils.showCustomToastMessageLong(
//             'Password must Contain 1 Lowercase, 1 Uppercase, Numbers, Special Characters, and be Between 8 to 25 Characters in Length. Please Correct it.',
//             context,
//             1,
//             6);
//       }
//     } else {
//       // setState(() {
//       //   _confirmcontroller.clear(); // Clear the text in the TextEditingController
//       //   _reconfirmcontroller.clear(); // Clear the text in the TextEditingController
//       // });
//       CommonUtils.showCustomToastMessageLong('Passwords do not match Please Correct it', context, 1, 4);
//     }
//   }
//
//   bool isPasswordValid(String password) {
//     // Password must contain 1 lowercase, 1 uppercase, numbers, special characters, and be between 8 to 20 characters in length.
//     RegExp passwordRegex = RegExp(r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,25}$');
//     return passwordRegex.hasMatch(password);
//   }
//
// }
