// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:hairfixingzone/services/local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'Branches_screen.dart';
// import 'CommonUtils.dart';
// import 'api_config.dart';
// // import 'package:hairfixingservice/services/local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class agentloginscreen extends StatefulWidget {
//   @override
//   _AgentScreenState createState() => _AgentScreenState();
// }
//
// class _AgentScreenState extends State<agentloginscreen> {
//   bool _isLoading = false;
//   TextEditingController _usernameController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   bool _obscureText = true;
//
//   String notificationMsg = "Waiting for notifications";
//   String firebaseToken = "";
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     // LocalNotificationService.initialize();
//
//     // Terminated State
//     FirebaseMessaging.instance.getInitialMessage().then((event) {
//       if (event != null) {
//         setState(() {
//           notificationMsg = "${event.notification!.title} ${event.notification!.body} I am coming from terminated state";
//         });
//       }
//     });
//
//     // Foregrand State
//     FirebaseMessaging.onMessage.listen((event) {
//       LocalNotificationService.showNotificationOnForeground(context, event);
//       setState(() {
//         notificationMsg = "${event.notification!.title} ${event.notification!.body} I am coming from foreground";
//       });
//     });
//
//     // background State
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       setState(() {
//         notificationMsg = "${event.notification!.title} ${event.notification!.body} I am coming from background";
//       });
//     });
//     // Get Firebase Token
//     FirebaseMessaging.instance.getToken().then((token) {
//       setState(() {
//         firebaseToken = token ?? "";
//         print('firebaseToken==>61===>   $firebaseToken');
//       });
//     });
//   }
//
//   // FirebaseMessaging.instance.getToken().then((token) {
//   // setState(() {
//   // firebaseToken = token ?? "";
//   // print('firebaseToken: $firebaseToken');
//   // }).catchError((error) {
//   // print('Error getting FCM token: $error');
//   // });
//   // });
//
//   Future<void> login(String usename, String password) async {
//     final String apiUrl = baseUrl + ValidateUser;
//     final String addSlotUrl = baseUrl + AddAgentSlotInformation;
//     setState(() {
//       _isLoading = true; //Enable loading before getQuestions
//     });
//     List<int> userIds = [];
//     List<int> branchIds = [];
//     int user_Id;
//
//     final Map<String, dynamic> requestObject = {
//       "UserName": usename,
//       "Password": password,
//       "deviceTokens": [firebaseToken],
//     };
//
//     print('requestObject==${jsonEncode(requestObject)}');
//
//     try {
//       final http.Response response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(requestObject),
//       );
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//
//         if (responseData["isSuccess"]) {
//           List<dynamic>? listResult = responseData["listResult"];
//
//           if (listResult != null && listResult.isNotEmpty && listResult[0]['roleID'] == 3  && listResult[0]['roleID'] == 1) {
//             user_Id = listResult[0]["id"];
//
//             final Map<String, dynamic> agentSlotsDetailsMap = {
//               "AgentSlotsdetails": [],
//             };
//
//             for (var item in listResult) {
//               userIds.add(item["id"]);
//               branchIds.add(item["branchId"]);
//             }
//
//             for (int i = 0; i < userIds.length; i++) {
//               final Map<String, dynamic> agentSlotDetail = {
//                 "id": null,
//                 "userId": userIds[i],
//                 "branchId": branchIds[i],
//                 "devicetoken": firebaseToken,
//               };
//
//               print('agentSlotDetail==$agentSlotDetail');
//               print("Slot information added for User ID: ${userIds[i]}, Branch ID: ${branchIds[i]}");
//
//               agentSlotsDetailsMap["AgentSlotsdetails"].add(agentSlotDetail);
//             }
//
//             // Send the agentSlotsDetailsMap as the body of the request
//             await addAgentSlotInformation(agentSlotsDetailsMap, user_Id);
//           }
//           else {
//             setState(() {
//               _isLoading = false;
//
//             });
//             FocusScope.of(context).unfocus();
//             CommonUtils.showCustomToastMessageLong('Invalid user ', context, 1, 4);
//             print("ListResult is null");
//           }
//         } else {
//           setState(() {
//             _isLoading = false;
//
//           });
//           FocusScope.of(context).unfocus();
//           CommonUtils.showCustomToastMessageLong(responseData["statusMessage"], context, 1, 4);
//           print("API returned an error: ${responseData["statusMessage"]}");
//         }
//       } else {
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//     }
//   }
//
//   Future<void> addAgentSlotInformation(Map<String, dynamic> agentSlotsDetailsMap, int user_id) async {
//     //  final String baseUrl = "http://182.18.157.215/SaloonApp/API/";
//     final String addSlotUrl = baseUrl + "AddAgentSlotInformation";
//     print('agentSlotDetail==${jsonEncode(agentSlotsDetailsMap)}');
//     print('addSlotUrl==$addSlotUrl');
//     print('user_id==$user_id');
//     setState(() {
//       _isLoading = true;
//
//     });
//     try {
//       final http.Response addSlotResponse = await http.post(
//         Uri.parse(addSlotUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(agentSlotsDetailsMap),
//       );
//
//       if (addSlotResponse.statusCode == 200) {
//         final Map<String, dynamic> responseJson = jsonDecode(addSlotResponse.body);
//
//         if (responseJson["isSuccess"]) {
//           setState(() {
//             _isLoading = false;
//
//           });
//           print("Agent slots information added successfully.");
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           prefs.setBool('isLoggedIn', true);
//           int userId = user_id; // Replace with the actual user ID
//           print('userId==$userId');
//           prefs.setInt('userId', userId); // Save the user ID
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => Branches_screen(userId: user_id),
//               ));
//         } else {
//           print("Error: ${responseJson["statusMessage"]}");
//           setState(() {
//             _isLoading = false;
//
//           });
//           if (responseJson["statusMessage"] == "This token is already used") {
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             prefs.setBool('isLoggedIn', true);
//             int userId = user_id; // Replace with the actual user ID
//             print('userId==$userId');
//             prefs.setInt('userId', userId);
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Branches_screen(userId: user_id),
//                 ));
//           } else {
//             setState(() {
//               _isLoading = false;
//
//             });
//             CommonUtils.showCustomToastMessageLong("${responseJson["statusMessage"]}", context, 1, 4);
//           }
//         }
//       } else {
//         print("Error: ${addSlotResponse.statusCode}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//     }
//   }
//
//   Future<void> _handleLogin() async {
//     String username = _usernameController.text;
//     String password = _passwordController.text;
//     bool isValid = true;
//     bool hasValidationFailed = false;
//     if (username.isEmpty) {
//       CommonUtils.showCustomToastMessageLong('Please Enter Username', context, 1, 4);
//       isValid = false;
//       hasValidationFailed = true;
//       // Hide the keyboard || password.isEmpty
//       FocusScope.of(context).unfocus();
//     }
//    else if (password.isEmpty) {
//       CommonUtils.showCustomToastMessageLong('Please Enter Password', context, 1, 4);
//       isValid = false;
//       hasValidationFailed = true;
//       // Hide the keyboard || password.isEmpty
//       FocusScope.of(context).unfocus();
//     }
//    else {
//       bool isConnected = await CommonUtils.checkInternetConnectivity();
//       if (isConnected) {
//         print('Connected to the internet');
//         login(username, password);
//       } else {
//         CommonUtils.showCustomToastMessageLong('No Internet Connection', context, 1, 4);
//         FocusScope.of(context).unfocus();
//         print('Not connected to the internet');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return   Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/background.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // App Logo
//                 SizedBox(height: 20.0),
//                 Image.asset(
//                   'assets/logo.png',
//                   width: 100.0,
//                   height: 100.0,
//                 ),
//                 SizedBox(height: 20.0),
//                 // Login Text and Small Image
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SvgPicture.asset(
//                       'assets/agent.svg',
//                       width: 30.0,
//                       height: 30.0,
//                     ),
//                     SizedBox(width: 10.0),
//                     Text(
//                       'Agent Login',
//                       style: TextStyle(
//                         fontSize: 24.0,
//                         fontFamily: 'LibreFranklin',
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFFF44614),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 30.0),
//                 Padding(
//                   padding: EdgeInsets.only(top: 10.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       // Handle the click event for the second text view
//                       print('Second textview clicked');
//                     },
//                     child: Container(
//                       width: 345.0,
//                       height: 40.0,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5.0),
//                         border: Border.all(
//                           color: Color(0xFFF44614),
//                           width: 2,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(left: 10.0, right: 5.0),
//                             child: SvgPicture.asset(
//                               'assets/User_icon.svg',
//                               width: 20.0,
//                             ),
//                           ),
//                           Expanded(
//                             child: Align(
//                               alignment: Alignment.centerLeft,
//                               child: Padding(
//                                 padding: EdgeInsets.only(left: 10.0, top: 6.0),
//                                 child: TextFormField(
//                                   controller: _usernameController,
//                                   keyboardType: TextInputType.name,
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontFamily: 'LibreFranklin',
//                                     color: Color(0xFF042DE3),
//                                     fontWeight: FontWeight.w300,
//                                   ),
//                                   decoration: InputDecoration(
//                                     hintText: ' User Name',
//                                     hintStyle: TextStyle(
//                                       fontSize: 14,
//                                       fontFamily: 'LibreFranklin',
//                                       color: Color(0xFF042DE3),
//                                       fontWeight: FontWeight.w300,
//                                     ),
//                                     border: InputBorder.none,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 10.0),
//                 // Password TextField
//
//                 Padding(
//                   padding: EdgeInsets.only(top: 10.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       // Handle the click event for the second text view
//                       print('Second textview clicked');
//                     },
//                     child: Container(
//                       width: 345.0,
//                       height: 40.0,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5.0),
//                         border: Border.all(
//                           color: Color(0xFFF44614),
//                           width: 2,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(left: 10.0, right: 10.0),
//                             child: SvgPicture.asset(
//                               'assets/password.svg',
//                               width: 15.0,
//                             ),
//                           ),
//                           Expanded(
//                             child: Align(
//                               alignment: Alignment.centerLeft,
//                               child: Padding(
//                                 padding: EdgeInsets.only(left: 10.0, top: 6.0),
//                                 child: TextFormField(
//                                   controller: _passwordController,
//                                   obscureText: _obscureText,
//                                   keyboardType: TextInputType.name,
//                                   // initialValue: 'Full Name',
//                                   style: TextStyle(fontSize: 14, fontFamily: 'LibreFranklin', color: Color(0xFF042DE3), fontWeight: FontWeight.w300),
//
//                                   decoration: InputDecoration(
//                                     hintText: 'Password',
//                                     hintStyle: TextStyle(fontSize: 14, fontFamily: 'LibreFranklin', color: Color(0xFF042DE3), fontWeight: FontWeight.w300),
//                                     alignLabelWithHint: true,
//                                     suffixIcon: GestureDetector(
//                                       onTap: _togglePasswordVisibility,
//                                       child: Icon(
//                                         _obscureText ? Icons.visibility_off : Icons.visibility,
//                                       ),
//                                     ),
//                                     border: InputBorder.none,
//                                     // Remove the underline border
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
//                 // Login Button
//
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _handleLogin,
//                   child: Text('Login'),
//                 ),
//                 SizedBox(height: 16.0),
//                 if (_isLoading) Center(child: CircularProgressIndicator()),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 50.0, // Adjust the top position as needed
//             left: 10.0, // Adjust the left position as needed
//             child: GestureDetector(
//               onTap: () {
//                 // Handle the back button press here
//                 Navigator.pop(context);
//               },
//               child: Container(
//                 width: 40.0,
//                 height: 40.0,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white, // Change the color as needed
//                 ),
//                 child: Icon(
//                   Icons.arrow_back,
//                   color: Color(0xFFF44614), // Change the color as needed
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Set this to false
//
//   void _togglePasswordVisibility() {
//     setState(() {
//       _obscureText = !_obscureText;
//     });
//   }
// }
