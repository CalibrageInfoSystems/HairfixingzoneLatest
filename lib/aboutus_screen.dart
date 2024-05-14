import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hairfixingzone/Common/common_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CommonUtils.dart';
import 'CustomerLoginScreen.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // banner
                Container(
                  padding: const EdgeInsets.only(
                      bottom: 10, top: 5, left: 0, right: 0),
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/top_image.png',
                    ),
                  ),
                ),
                // space
                const SizedBox(
                  height: 5,
                ),
                // about us content
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to Hair Fixing Zone, your premier destination for cutting-edge Hair Replacement solutions in Bangalore. Established in 2016, Hair Fixing Zone has emerged as a beacon of hope for individuals grappling with hair loss, Baldness, Hair thinning, or seeking to enhance their natural beauty. With four branches strategically located across Bangalore, we strive to provide convenient access to our specialized services, ensuring that every client receives the personalized care and attention they deserve.',
                          // style: TextStyle(
                          //     wordSpacing: 3.0,
                          //     letterSpacing: 1.5,
                          //     color: Color(0xFF0f75bc),
                          //     fontSize: 14),
                          // textAlign: TextAlign.justify,

                          style: CommonStyles.txSty_16blu_f5,
                        ),
                        SizedBox(height: 15),
                        Text('Our Journey',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF662d91),
                            )),
                        SizedBox(height: 5),
                        Text(
                          'At Hair Fixing Zone, Our journey began with a simple yet profound mission: to empower individuals to embrace their unique beauty with confidence. Recognizing the transformation power of hair, we embarked on a quest to offer innovation solutions that go beyond conventional norms. Over the years, we have honed our expertise, staying at the forefront of industry advancements to deliver unparalleled results to our estmeed clientele',
                          // style: TextStyle(
                          //   wordSpacing: 3.0,
                          //   letterSpacing: 1.5,
                          //   color: Color(0xFF0f75bc),
                          //   fontSize: 14,
                          // ),
                          // textAlign: TextAlign.justify,
                          style: CommonStyles.txSty_16blu_f5,
                        ),
                      ]),
                )
              ],
            ),
          ),
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

  AppBar _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFf3e3ff),
        title: const Text(
          'About Us',
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
}
