import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hairfixingzone/Branches_screen.dart';
import 'package:hairfixingzone/CommonUtils.dart';

import 'package:hairfixingzone/services/local_notifications.dart';
import 'package:hairfixingzone/startingscreen.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AgentBranchesModel.dart';
import 'AgentHome.dart';
import 'Common/common_styles.dart';
import 'Common/custom_button.dart';
import 'Common/custome_form_field.dart';
import 'CustomerRegisterScreen.dart';
import 'ForgotPasswordscreen.dart';
import 'HomeScreen.dart';
import 'api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgentLogin extends StatefulWidget {
  const AgentLogin({super.key});

  @override
  State<AgentLogin> createState() => _AgentLoginState();
}

class _AgentLoginState extends State<AgentLogin> {
  bool isTextFieldFocused = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _emailError = false;
  bool _passwordError = false;
  String? invalidCredentials;
  String? _emailErrorMsg;
  String? _passwordErrorMsg;
  bool showPassword = true;
  bool validateUserEmail = false;
  bool validateUserPassword = false;
  String firebaseToken = "";

  String notificationMsg = "Waiting for notifications";
  @override
  void initState() {
    super.initState();

    // LocalNotificationService.initialize();

    // Terminated State
    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if (event != null) {
        setState(() {
          notificationMsg = "${event.notification!.title} ${event.notification!.body} I am coming from terminated state";
        });
      }
    });

    // Foregrand State
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.showNotificationOnForeground(context, event);
      setState(() {
        notificationMsg = "${event.notification!.title} ${event.notification!.body} I am coming from foreground";
      });
    });

    // background State
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      setState(() {
        notificationMsg = "${event.notification!.title} ${event.notification!.body} I am coming from background";
      });
    });
    // Get Firebase Token
    FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        firebaseToken = token ?? "";
        print('firebaseToken==>61===>   $firebaseToken');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => startingscreen(),
              ));
          return true;
        },
        child: Scaffold(
          backgroundColor: CommonUtils.primaryColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: CommonUtils.primaryTextColor,
              ),
              onPressed: () {
                Navigator.of(
                  context,
                ).pop();

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => startingscreen(),
                //     ));
              },
            ),
            backgroundColor: Colors.transparent,
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
                        const Text('Agent Login',
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomeFormField(
                                  label: 'Email/User Name',
                                  errorText: _emailError ? _emailErrorMsg : null,
                                  onChanged: (_) {
                                    setState(() {
                                      _emailError = false;
                                    });
                                  },
                                  validator: validateEmail,
                                  controller: _emailController,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomeFormField(
                                  label: 'Password',
                                  errorText: _passwordError ? _passwordErrorMsg : null,
                                  onChanged: (_) {
                                    setState(() {
                                      _passwordError = false;
                                    });
                                  },
                                  validator: validatePassword,
                                  controller: _passwordController,
                                  obscureText: showPassword,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                    child: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     GestureDetector(
                                //       onTap: () {
                                //         Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   const ForgotPasswordscreen()),
                                //         );
                                //       },
                                //       child: const Text(
                                //         'Forgot Password?',
                                //         style: CommonUtils.Mediumtext_o_14,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        buttonText: 'Login',
                                        color: CommonUtils.primaryTextColor,
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            if (validateUserEmail && validateUserPassword) {
                                              _handleLogin();
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),

                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     const Text('New User?',
                                //         style: CommonUtils.Mediumtext_14),
                                //     const SizedBox(width: 8.0),
                                //     GestureDetector(
                                //       onTap: () {

                                //         print('Click here! clicked');

                                //         Navigator.of(context).push(
                                //           MaterialPageRoute(
                                //             builder: (context) =>
                                //                 const CustomerRegisterScreen(),
                                //           ),
                                //         );
                                //       },
                                //       child: const Text(
                                //         'Register Here!',
                                //         style: TextStyle(
                                //           fontSize: 20,
                                //           fontFamily: "Calibri",
                                //           fontWeight: FontWeight.w700,
                                //           color: Color(0xFF0f75bc),
                                //         ),
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
        ));
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _emailError = true;
        _emailErrorMsg = 'Email is required';
      });
      return null;
    }

    if (invalidCredentials != null) {
      setState(() {
        invalidCredentials = null;
      });
      return null;
    }
    validateUserEmail = true;
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _passwordError = true;
        _passwordErrorMsg = 'Password is required';
      });
      return null;
    }

    if (invalidCredentials != null) {
      setState(() {
        invalidCredentials = null;
      });
      return null;
    }

    validateUserPassword = true;
    return null;
  }

  String? endUserMessageFromApi(int code, String endUserMessage) {
    if (code == 10) {
      setState(() {
        _emailError = true;
        _emailErrorMsg = endUserMessage;
        _passwordError = true;
        _passwordErrorMsg = endUserMessage;

        validateUserEmail = false;
        validateUserPassword = false;
      });
    }

    return null;
  }

  Future<void> _handleLogin() async {
    String username = _emailController.text;
    String password = _passwordController.text;
    bool isValid = true;
    bool hasValidationFailed = false;
    if (username.isEmpty) {
      CommonUtils.showCustomToastMessageLong('Please Enter Username', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
      // Hide the keyboard || password.isEmpty
      FocusScope.of(context).unfocus();
    } else if (password.isEmpty) {
      CommonUtils.showCustomToastMessageLong('Please Enter Password', context, 1, 4);
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

  Future<void> login(String usename, String password) async {
    final String apiUrl = baseUrl + ValidateUser;
    final String addSlotUrl = baseUrl + AddAgentSlotInformation;
    // setState(() {
    //   _isLoading = true; //Enable loading before getQuestions
    // });
    List<int> userIds = [];
    List<int> branchIds = [];
    int agentId;

    final Map<String, dynamic> requestObject = {
      "UserName": usename,
      "Password": password,
      "deviceTokens": [firebaseToken],
    };
    CommonStyles.progressBar(context);
    print('requestObject==${jsonEncode(requestObject)}');

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestObject),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["isSuccess"]) {
          List<dynamic>? listResult = responseData["listResult"];

          Map<String, dynamic> user = listResult![0];
          print('User ID: ${user['id']}');
          print('Full Name: ${user['firstName']}');
          print('Role ID: ${user['roleID']}');

          await saveUserDataToSharedPreferences(user);
          LoadingProgress.stop(context);
          if (listResult != null && listResult.isNotEmpty && listResult[0]['roleID'] == 3) {
            agentId = listResult[0]["id"];

            final Map<String, dynamic> agentSlotsDetailsMap = {
              "AgentSlotsdetails": [],
            };

            for (var item in listResult) {
              userIds.add(item["id"]);
              branchIds.add(item["branchId"]);
            }

            for (int i = 0; i < userIds.length; i++) {
              final Map<String, dynamic> agentSlotDetail = {
                "id": null,
                "userId": userIds[i],
                "branchId": branchIds[i],
                "devicetoken": firebaseToken,
              };

              print('agentSlotDetail==$agentSlotDetail');
              print("Slot information added for User ID: ${userIds[i]}, Branch ID: ${branchIds[i]}");

              agentSlotsDetailsMap["AgentSlotsdetails"].add(agentSlotDetail);
            }

            // Send the agentSlotsDetailsMap as the body of the request
            await addAgentSlotInformation(agentSlotsDetailsMap, agentId);
          } else {
            // setState(() {
            //   _isLoading = false;

            // });
            LoadingProgress.stop(context);
            FocusScope.of(context).unfocus();
            CommonUtils.showCustomToastMessageLong('Invalid user ', context, 1, 4);
            LoadingProgress.stop(context);
            print("ListResult is null");
          }
        } else {
          // setState(() {
          //   _isLoading = false;

          // });
          LoadingProgress.stop(context);
          FocusScope.of(context).unfocus();
          CommonUtils.showCustomToastMessageLong(responseData["statusMessage"], context, 1, 4);
          print("API returned an error: ${responseData["statusMessage"]}");
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> addAgentSlotInformation(Map<String, dynamic> agentSlotsDetailsMap, int agentId) async {
    //  final String baseUrl = "http://182.18.157.215/SaloonApp/API/";
    final String addSlotUrl = "${baseUrl}AddAgentSlotInformation";

    try {
      final http.Response addSlotResponse = await http.post(
        Uri.parse(addSlotUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(agentSlotsDetailsMap),
      );
      print('requestObject==483${jsonEncode(agentSlotsDetailsMap)}');
      if (addSlotResponse.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(addSlotResponse.body);

        if (responseJson["isSuccess"]) {
          // setState(() {
          //   _isLoading = false;

          // });
          print("Agent slots information added successfully.");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);
          int userId = agentId; // Replace with the actual user ID
          print('userId==$userId');
          prefs.setInt('userId', userId); // Save the user ID

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AgentHome(userId: agentId),
              ));
        } else {
          print("Error: ${responseJson["statusMessage"]}");
          // setState(() {
          //   _isLoading = false;

          // });
          if (responseJson["statusMessage"] == "This token is already used") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('isLoggedIn', true);
            int userId = agentId; // Replace with the actual user ID
            print('userId==$userId');
            prefs.setInt('userId', userId);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgentHome(userId: agentId),
                ));
          } else {
            // setState(() {
            //   _isLoading = false;

            // });
            CommonUtils.showCustomToastMessageLong("${responseJson["statusMessage"]}", context, 1, 4);
          }
        }
      } else {
        print("Error: ${addSlotResponse.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> saveUserDataToSharedPreferences(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('userId', userData['id']);
    prefs.setBool('isLoggedIn', true);
    await prefs.setString('userFullName', userData['firstName']);
    await prefs.setInt('userRoleId', userData['roleID']);
    await prefs.setString('email', userData['email']);
    await prefs.setString('contactNumber', userData['contactNumber']);
    await prefs.setString('gender', userData['gender']);
  }

  static void progressBar(BuildContext context) {
    LoadingProgress.start(
      context,
      widget: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.withOpacity(0.6),
        ),
        width: MediaQuery.of(context).size.width / 4,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 13),
        child: const AspectRatio(
          aspectRatio: 1,
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }

  // static Future<void> saveAgentData(List<AgentBranchesModel> branches) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final List<String> branchesJsonList =
  //   branches.map((branch) => json.encode(branch.toJson())).toList();
  //   await prefs.setStringList(agentKey, branchesJsonList);
  // }
}
