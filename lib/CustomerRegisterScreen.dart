import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hairfixingzone/CommonUtils.dart';

import 'Common/custom_button.dart';
import 'Common/custome_form_field.dart';
import 'ForgotPasswordscreen.dart';
import 'HomeScreen.dart';

class CustomerRegisterScreen extends StatefulWidget {
  const CustomerRegisterScreen({super.key});

  @override
  State<CustomerRegisterScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<CustomerRegisterScreen> {
  bool isTextFieldFocused = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController Fullname = new TextEditingController();
  TextEditingController DateofBirth = new TextEditingController();
  TextEditingController Gender = new TextEditingController();
  TextEditingController Mobilenumber = new TextEditingController();
  TextEditingController AlernateMobilenum = new TextEditingController();
  TextEditingController Email = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController Password = new TextEditingController();
  TextEditingController ConfrimPassword = new TextEditingController();

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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: const BoxDecoration(),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.height / 3.5,
                      child: Image.asset('assets/hfz_logo.png'),
                    ),
                    Text(
                      'Customer Registration',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: "Calibri",
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: Color(0xFF662d91),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 2.5, // Adjust the height here
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            CustomeFormField(
                              label: 'Full Name',
                              validator: validatefullname,
                              controller: Fullname,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomeFormField(
                              label: 'Date of Birth',
                              validator: validatedob,
                              controller: DateofBirth,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomeFormField(
                              label: 'Gender',
                              validator: validateGender,
                              controller: Gender,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomeFormField(
                              label: 'Mobile Number',
                              validator: validateMobilenum,
                              controller: Mobilenumber,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomeFormField(
                              label: 'Alternate Mobile Number',
                              validator: validateAlterMobilenum,
                              controller: AlernateMobilenum,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomeFormField(
                              label: 'Email',
                              validator: validateEmail,
                              controller: Email,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomeFormField(
                              label: 'User Name',
                              validator: validateusername,
                              controller: username,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomeFormField(
                              label: 'Password',
                              controller: Password,
                              validator: validatePassword,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomeFormField(
                              label: 'Confirm Password',
                              validator: validateconfirmpassword,
                              controller: ConfrimPassword,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              child: GestureDetector(
                                onTap: () {
                                  validating();
                                },
                                child: CustomButton(
                                  buttonText: 'Register',
                                  color: CommonUtils.primaryTextColor,
                                  onPressed: loginUser,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an Account?',
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

  String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Gender';
    }

    return null;
  }

  String? validatedob(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Date of Birth';
    }

    return null;
  }

  String? validatefullname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Full Name';
    }

    return null;
  }

  String? validateMobilenum(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Mobile Number';
    }

    return null;
  }

  String? validateAlterMobilenum(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Alternate Mobile Number';
    }

    return null;
  }

  String? validateusername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter User Name';
    }

    return null;
  }

  String? validateconfirmpassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Confirm Password';
    }
    if (value.length < 4) {
      return 'Password must be 4 characters or more';
    }
    if (value.length > 8) {
      return 'Password must be 8 characters or less';
    }
    return null;
  }

  void loginUser() {
    if (_formKey.currentState!.validate()) {
      print('login: Login success!');
    }
  }

  void validating() {
  //   if (_formKey.currentState!.validate()) {
  //
  //     String? fullname = Fullname.text;
  //     String? dob = DateofBirth.text;
  //     String? dob = Gender.text;
  //     String? dob = Mobilenumber.text;
  //     String? dob = AlernateMobilenum.text;
  //     String? dob = DateofBirth.text;
  //
  //
  //     // Print the username and password
  //     print('Username: $email');
  //     print('Password: $password');
  //     setState(() {
  //       _isLoading = true; //Enable loading before getQuestions
  //     });
  //     final String apiUrl = baseUrl + ValidateUser;
  //
  //     // Prepare the request body
  //     Map<String, String> requestBody = {
  //       'userName':email,
  //       'password': password,
  //       "deviceTokens":"",
  //     };
  //
  //     // Make the POST request
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       body: requestBody,
  //     );
  //
  //     // Check if the request was successful
  //     if (response.statusCode == 200) {
  //       // Parse the JSON response
  //       Map<String, dynamic> data = json.decode(response.body);
  //
  //       // Extract the necessary information
  //       bool isSuccess = data['isSuccess'];
  //       String statusMessage = data['statusMessage'];
  //
  //       // Print the result
  //       print('Is Success: $isSuccess');
  //       print('Status Message: $statusMessage');
  //
  //       // Handle the data accordingly
  //       if (isSuccess) {
  //         // If the user is valid, you can extract more data from 'listResult'
  //
  //         if ( data['listResult'] != null) {
  //           setState(() {
  //             _isLoading = false;
  //
  //           });
  //           List<dynamic> listResult = data['listResult'];
  //           Map<String, dynamic> user = listResult.first;
  //           print('User ID: ${user['id']}');
  //           print('Full Name: ${user['fullName']}');
  //           print('Role ID: ${user['roleID']}');
  //           await saveUserDataToSharedPreferences(user);
  //           // Extract other user information as needed
  //           if (user['roleID'] == 2) {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => HomeScreen()),
  //             );
  //           } else {
  //             // Show toast for invalid user
  //             FocusScope.of(context).unfocus();
  //             CommonUtils.showCustomToastMessageLong("Invalid User", context, 1, 4);
  //             // showToast('Invalid user');
  //           }
  //         }
  //
  //       else{
  //         FocusScope.of(context).unfocus();
  //         CommonUtils.showCustomToastMessageLong('Invalid User ', context, 1, 4);
  //       }
  //
  //     } else {
  //       FocusScope.of(context).unfocus();
  //       CommonUtils.showCustomToastMessageLong("${data["statusMessage"]}", context, 1, 4);
  //       // Handle the case where the user is not valid
  //       List<dynamic> validationErrors = data['validationErrors'];
  //       if (validationErrors.isNotEmpty) {
  //         // Print or handle validation errors if any
  //       }
  //     }
  //   }
  //   else {
  //     setState(() {
  //       _isLoading = false;
  //
  //     });
  //     // Handle any error cases here
  //     print('Failed to connect to the API. Status code: ${response.statusCode}');
  //   }
  // }
    }
}
