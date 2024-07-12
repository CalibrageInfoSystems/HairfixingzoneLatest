import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Common/common_styles.dart';
import 'CommonUtils.dart';
import 'CustomerLoginScreen.dart';
import 'FavouritesScreen.dart';
import 'ProfileMy.dart';
import 'aboutus_screen.dart';
import 'contactus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class NewScreen extends StatelessWidget {
  final String userName;
  final String email;

  const NewScreen({
    Key? key,
    required this.userName,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xffffffff),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: CommonUtils.primaryTextColor, // Adjust the color as needed
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: CommonStyles.primaryTextColor,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : "H",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  radius: 25,
                ),
                title: Text(userName, style: CommonStyles.txSty_20black_fb),
                subtitle: Text(email, style: CommonStyles.txSty_20black_fb),
                onTap: () {
                  // Add your edit profile navigation logic here
                },
              ),
              Divider(),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/Profile_new.svg',
                  width: 25,
                  height: 25,
                  color: Color(0xFF662e91), // Adjust color as needed
                ),
                title: Text('Profile', style: CommonStyles.txSty_20black_fb),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16), // Add trailing icon here
                onTap: () {
                  profile(context); // Execute your action here
                },
              ),
              Divider(),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/about_us.svg',
                  width: 25,
                  height: 25,
                  color:Color(0xFF662e91), // Adjust color as needed
                ),
                title: Text('About Us', style: CommonStyles.txSty_20black_fb),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16), // Add trailing icon here
                onTap: () {
                  AboutUs(context);
                },
              ),
              Divider(),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/fav_star.svg',
                  width: 25,
                  height: 25,
                  color:Color(0xFF662e91), // Adjust color as needed
                ),
                title: Text('Favourites', style: CommonStyles.txSty_20black_fb),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16), // Add trailing icon here
                onTap: () {
                  Favourite(context);
                }
              ),
              Divider(),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/headset.svg',
                  width: 25,
                  height: 25,
                  color: Color(0xFF662e91), // Adjust color as needed
                ),
                title: Text('Contact Us', style: CommonStyles.txSty_20black_fb),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16), // Add trailing icon here
                onTap: () {
                  contact_us(context); // Execute your action here
                },
              ),
              Divider(),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/logout_new.svg',
                  width: 25,
                  height: 25,
                  color: Color(0xFF662e91), // Adjust color as needed
                ),
                title: Text('Logout', style: CommonStyles.txSty_20black_fb),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16), // Add trailing icon here
                onTap: () {
                  logOutDialog(context); // Execute your action here
                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  void logOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are You Sure You Want to Logout?'),
          actions: [
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    color: CommonUtils.primaryTextColor,
                  ),
                  side: const BorderSide(
                    color: CommonUtils.primaryTextColor,
                  ),
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                child: const Text(
                  'No',
                  style: TextStyle(
                    fontSize: 16,
                    color: CommonUtils.primaryTextColor,
                    fontFamily: 'Calibri',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10), // Add spacing between buttons
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirmLogout(context);
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    color: CommonUtils.primaryTextColor,
                  ),
                  side: const BorderSide(
                    color: CommonUtils.primaryTextColor,
                  ),
                  backgroundColor: CommonUtils.primaryTextColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Calibri',
                  ),
                ),
              ),
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

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const CustomerLoginScreen()),
          (route) => false,
    );
  }

  Future<bool> onBackPressed(BuildContext context) {
    // Navigate back when the back button is pressed
    Navigator.pop(context);
    // Return false to indicate that we handled the back button press
    return Future.value(false);
  }

  void contact_us(BuildContext context) {
    // Implement your contact us logic here, like navigating to a contact screen
    print('Navigating to Contact Us screen');
    // Example navigation
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => contactus()),
    );
  }

  void AboutUs(BuildContext context) {
    print('Navigating to About Us screen');
    // Example navigation
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AboutUsScreen()),
    );
  }

  void profile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ProfileMy()),
    );
  }

  void Favourite(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FavouritesScreen()),
    );
  }
}
