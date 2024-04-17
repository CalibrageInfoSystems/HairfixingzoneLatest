import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hairfixingzone/HomeScreen.dart';
import 'package:hairfixingzone/services/local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Branches_screen.dart';
import 'CommonUtils.dart';
import 'api_config.dart';
// import 'package:hairfixingservice/services/local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserLoginScreen> {
  bool _isLoading = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  String notificationMsg = "Waiting for notifications";
  String firebaseToken = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  Future<void> login(String username, String password) async {
    // Define the API endpoint
  //  final String apiUrl = 'http://182.18.157.215/SaloonApp/API/ValidateUserData';
    final String apiUrl = baseUrl + ValidateUser;

    // Prepare the request body
    Map<String, String> requestBody = {
      'userName':_usernameController.text,
      'password': _passwordController.text,
      "deviceTokens":"",
    };

    // Make the POST request
    final response = await http.post(
      Uri.parse(apiUrl),
      body: requestBody,
    );

    // Check if the request was successful
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

        if ( data['listResult'] != null) {
          List<dynamic> listResult = data['listResult'];
          Map<String, dynamic> user = listResult.first;
          print('User ID: ${user['id']}');
          print('Full Name: ${user['fullName']}');
          print('Role ID: ${user['roleID']}');
          await saveUserDataToSharedPreferences(user);
          // Extract other user information as needed
          if (user['roleID'] == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            // Show toast for invalid user
            CommonUtils.showCustomToastMessageLong("Invalid user", context, 1, 4);
           // showToast('Invalid user');
          }
        }
        else{
       //   FocusScope.of(context).unfocus();
          CommonUtils.showCustomToastMessageLong('Invalid user ', context, 1, 4);
        }
      } else {
        CommonUtils.showCustomToastMessageLong("${data["statusMessage"]}", context, 1, 4);
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


  // Future<bool> login(String username, String password) async {
  //   final String apiUrl = baseUrl + ValidateUserData;
  //
  //   final Map<String, dynamic> requestObject = {
  //     "userName": username,
  //     "password": password,
  //   };
  //
  //   print('requestObject == ${jsonEncode(requestObject)}');
  //
  //   try {
  //     final http.Response response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(requestObject),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = jsonDecode(response.body);
  //
  //       if (responseData["isSuccess"]) {
  //         final dynamic userData = responseData["listResult"];
  //
  //         if (userData != null) {
  //           // print("UserId ${int.parse(userData['id'])}");
  //           // print("Roleid ${int.parse(userData['roleID'])}");
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //           prefs.setBool('isLoggedIn', true);
  //           prefs.setInt("id", int.parse(userData['id']));
  //           prefs.setInt("roleId", int.parse(userData['roleID']));
  //           prefs.setString("fullName", userData['fullName']);
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => HomeScreen()),
  //           );
  //           return true; // Indicate successful login
  //         } else {
  //           print("ListResult is null");
  //           return false; // Indicate failed login
  //         }
  //       } else {
  //         print("API returned an error: ${responseData["EndUserMessage"]}");
  //         return false; // Indicate failed login
  //       }
  //     } else {
  //       print("Error: ${response.statusCode}");
  //       return false; // Indicate failed login
  //     }
  //   } catch (e) {
  //     print("Exception: $e");
  //     return false; // Indicate failed login
  //   }
  // }


  Future<void> _handleLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    bool isValid = true;
    bool hasValidationFailed = false;

    if (password.isEmpty) {
      CommonUtils.showCustomToastMessageLong('Please Enter Password', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
      // Hide the keyboard || password.isEmpty
      FocusScope.of(context).unfocus();
    }
    if (username.isEmpty) {
      CommonUtils.showCustomToastMessageLong('Please Enter Username', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
      // Hide the keyboard || password.isEmpty
      FocusScope.of(context).unfocus();
    } else {
      bool isConnected = await CommonUtils.checkInternetConnectivity();
      if (isConnected) {
        print('Connected to the internet');
        login(username, password);
      } else {
        CommonUtils.showCustomToastMessageLong('No Internet Connection', context, 1, 4);
        FocusScope.of(context).unfocus();
        print('Not connected to the internet');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child:  Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Logo
                SizedBox(height: 20.0),
                Image.asset(
                  'assets/logo.png',
                  width: 100.0,
                  height: 100.0,
                ),
                SizedBox(height: 20.0),
                // Login Text and Small Image
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/agent.svg',
                      width: 30.0,
                      height: 30.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      'Customer Login',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'Calibri',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF44614),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      // Handle the click event for the second text view
                      print('Second textview clicked');
                    },
                    child: Container(
                      width: 345.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Color(0xFFF44614),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 5.0),
                            child: SvgPicture.asset(
                              'assets/User_icon.svg',
                              width: 20.0,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.0, top: 6.0),
                                child: TextFormField(
                                  controller: _usernameController,
                                  keyboardType: TextInputType.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Calibri',
                                    color: Color(0xFF042DE3),
                                    fontWeight: FontWeight.w300,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: ' User Name',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Calibri',
                                      color: Color(0xFF042DE3),
                                      fontWeight: FontWeight.w300,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.0),
                // Password TextField

                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      // Handle the click event for the second text view
                      print('Second textview clicked');
                    },
                    child: Container(
                      width: 345.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Color(0xFFF44614),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: SvgPicture.asset(
                              'assets/password.svg',
                              width: 15.0,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.0, top: 6.0),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscureText,
                                  keyboardType: TextInputType.name,
                                  // initialValue: 'Full Name',
                                  style: TextStyle(fontSize: 14, fontFamily: 'Calibri', color: Color(0xFF042DE3), fontWeight: FontWeight.w300),

                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: TextStyle(fontSize: 14, fontFamily: 'Calibri', color: Color(0xFF042DE3), fontWeight: FontWeight.w300),
                                    alignLabelWithHint: true,
                                    suffixIcon: GestureDetector(
                                      onTap: _togglePasswordVisibility,
                                      child: Icon(
                                        _obscureText ? Icons.visibility_off : Icons.visibility,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    // Remove the underline border
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Login Button

                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: Text('Login'),
                ),
                SizedBox(height: 16.0),
                if (_isLoading) CircularProgressIndicator(),
              ],
            ),
          ),
          Positioned(
            top: 50.0, // Adjust the top position as needed
            left: 10.0, // Adjust the left position as needed
            child: GestureDetector(
              onTap: () {
                print('Back button tapped');
                Navigator.pop(context);
              },
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // Change the color as needed
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xFFF44614), // Change the color as needed
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  // Set this to false

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> saveUserDataToSharedPreferences(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('isLoggedIn', true);
    // Save user data using unique keys
    await prefs.setInt('userId', userData['id']);
    await prefs.setString('userFullName', userData['firstName']);
    await prefs.setInt('userRoleId', userData['roleID']);
    await prefs.setString('email', userData['email']);
    await prefs.setString('contactNumber', userData['contactNumber']);
    await prefs.setString('gender', userData['gender']);
    // Save other user data as needed
  }
}
