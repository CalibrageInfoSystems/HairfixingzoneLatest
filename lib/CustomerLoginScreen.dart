import 'package:flutter/material.dart';
import 'package:hairfixingzone/CommonUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Common/custom_button.dart';
import 'Common/custome_form_field.dart';
import 'CustomerRegisterScreen.dart';
import 'ForgotPasswordscreen.dart';
import 'HomeScreen.dart';
import 'api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<CustomerLoginScreen> {
  bool isTextFieldFocused = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonUtils.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: CommonUtils.primaryTextColor ,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // No shadow
      ),

      body:
      SingleChildScrollView(child:
      Column(
        mainAxisSize: MainAxisSize.max,
        children: [


          Container(
            height: MediaQuery.of(context).size.height / 2.2,
            decoration: const BoxDecoration(

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

    SizedBox(
    height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 2, // Adjust the height here
    child: SingleChildScrollView(
    physics: AlwaysScrollableScrollPhysics(),
    child: Form(
         key: _formKey,child: Container(
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
                    CustomeFormField(label: 'Email/User Name', validator: validateEmail,controller: _emailController,),
                    SizedBox(
                      height: 10,
                    ),
                    CustomeFormField(
                      label: 'Password',
                      validator: validatePassword,
                      controller: _passwordController, // Pass the password controller
                    ),
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
                            style: CommonUtils.Mediumtext_o_14,
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
                            child:

           CustomButton(
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

                        Text('New User?', style: CommonUtils.Mediumtext_14),
                        SizedBox(width: 8.0),
                        GestureDetector(
                          onTap: () {
                            // Handle the click event for the "Click here!" text
                            print('Click here! clicked');
                            // Add your custom logic or navigation code here
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CustomerRegisterScreen(),
                              ),
                            );
                          },
                          child: Text('Register Here!', style: CommonUtils.Mediumtext_o_14),
                        )
                      ],
                    ),
                  ],
                ),



              ],
            ),
          ),
         ) ))],
      )),

    );
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Password';
    }
    // if (value.length < 4) {
    //   return 'Password must be 4 characters or more';
    // }
    // if (value.length > 8) {
    //   return 'Password must be 8 characters or less';
    // }
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

  Future<void> loginUser() async {
    if (_formKey.currentState!.validate()) {
      print('login: Login success!');
      String? email = _emailController.text;
      String? password = _passwordController.text;

      // Print the username and password
      print('Username: $email');
      print('Password: $password');
      setState(() {
        _isLoading = true; //Enable loading before getQuestions
      });
      final String apiUrl = baseUrl + ValidateUser;

      // Prepare the request body
      Map<String, String> requestBody = {
        'userName':email,
        'password': password,
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
            setState(() {
              _isLoading = false;

            });
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
              FocusScope.of(context).unfocus();
              CommonUtils.showCustomToastMessageLong("Invalid User", context, 1, 3, toastPosition: MediaQuery.of(context).size.height / 2);
              // showToast('Invalid user');
            }
          }
          else{
            FocusScope.of(context).unfocus();
            CommonUtils.showCustomToastMessageLong('Invalid User ',context, 1, 3, toastPosition: MediaQuery.of(context).size.height / 2);
          }

        } else {
          FocusScope.of(context).unfocus();
          CommonUtils.showCustomToastMessageLong("${data["statusMessage"]}", context, 1, 3, toastPosition: MediaQuery.of(context).size.height / 2);
          // Handle the case where the user is not valid
          List<dynamic> validationErrors = data['validationErrors'];
          if (validationErrors.isNotEmpty) {
            // Print or handle validation errors if any
          }
        }
      }
      else {
        setState(() {
          _isLoading = false;

        });
        // Handle any error cases here
        print('Failed to connect to the API. Status code: ${response.statusCode}');
      }
    }
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