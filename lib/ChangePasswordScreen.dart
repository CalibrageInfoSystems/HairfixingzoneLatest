import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hairfixingzone/Common/custom_button.dart';
import 'package:hairfixingzone/Common/custome_form_field.dart';
import 'package:hairfixingzone/CommonUtils.dart';
import 'package:hairfixingzone/CustomerLoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmNewController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmNewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.height / 5,
                  child: Image.asset('assets/hfz_logo.png'),
                ),
                const SizedBox(
                  height: 120,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomeFormField(
                        label: 'Current Password',
                        validator: validateCurrentPassword,
                        controller: _currentController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomeFormField(
                        label: 'New Password',
                        validator: validateNewPassword,
                        controller: _newController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomeFormField(
                        label: 'Confirm New Password',
                        validator: validateConfirmNewPassword,
                        controller: _confirmNewController,
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      //MARK: Update Button
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              buttonText: 'Update Password',
                              color: CommonUtils.primaryTextColor,
                              onPressed: changePassword,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changePassword() {
    if (_formKey.currentState!.validate()) {
      print('xxx: login success');
    }
    // if we got success response we have to navigate to next screen
    // Navigator.of(context).push(
    //                 MaterialPageRoute(
    //                   builder: (context) => const ChangePasswordScreen(),
    //                 ),
    //               );
  }

  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Current Password';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter New Password';
    }
    return null;
  }

  String? validateConfirmNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Confirm Password';
    }
    if (_newController.text != _confirmNewController.text) {
      return 'Confirm Password must be same as new password';
    }
    return null;
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFf3e3ff),
        title: const Text(
          'Change Password',
          style: TextStyle(color: Color(0xFF0f75bc), fontSize: 16.0),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/sign-out-alt.svg', // Path to your SVG asset
              color: const Color(0xFF662e91),
              width: 24, // Adjust width as needed
              height: 24, // Adjust height as needed
            ),
            onPressed: () {
              logOutDialog(context);
              // Add logout functionality here
            },
          ),
        ],
        // centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: CommonUtils.primaryTextColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ));
  }

  void logOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to Logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirmLogout(context);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> onConfirmLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.remove('userId'); // Remove userId from SharedPreferences
    prefs.remove('userRoleId'); // Remove roleId from SharedPreferences
    CommonUtils.showCustomToastMessageLong("Logout Successful", context, 0, 3);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const CustomerLoginScreen()),
      (route) => false,
    );
  }
}
