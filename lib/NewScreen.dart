import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hairfixingzone/EditProfile.dart';
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

class NewScreen extends StatefulWidget {
  final String userName;
  final String email;

  const NewScreen({
    Key? key,
    required this.userName,
    required this.email,
  }) : super(key: key);

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  DateTime? createdDate;

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
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfile(createdDate: '$createdDate'),
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: CommonStyles.primaryTextColor,
                  radius: 25,
                  child: Text(
                    widget.userName.isNotEmpty
                        ? widget.userName[0].toUpperCase()
                        : "H",
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                title:
                    Text(widget.userName, style: CommonStyles.txSty_20black_fb),
                subtitle: const Text('Edit profile',
                    style: CommonStyles.txSty_16black_f5),
              ),
              const Divider(),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/Profile_new.svg',
                  width: 25,
                  height: 25,
                  color: const Color(0xFF662e91), // Adjust color as needed
                ),
                title:
                    const Text('Profile', style: CommonStyles.txSty_20black_fb),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: Colors.grey, size: 16), // Add trailing icon here
                onTap: () {
                  profile(context); // Execute your action here
                },
              ),
              const Divider(),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/about_us.svg',
                  width: 25,
                  height: 25,
                  color: const Color(0xFF662e91), // Adjust color as needed
                ),
                title: const Text('About Us',
                    style: CommonStyles.txSty_20black_fb),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: Colors.grey, size: 16), // Add trailing icon here
                onTap: () {
                  AboutUs(context);
                },
              ),
              const Divider(),
              ListTile(
                  leading: SvgPicture.asset(
                    'assets/fav_star.svg',
                    width: 25,
                    height: 25,
                    color: const Color(0xFF662e91), // Adjust color as needed
                  ),
                  title: const Text('Favourites',
                      style: CommonStyles.txSty_20black_fb),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Colors.grey, size: 16), // Add trailing icon here
                  onTap: () {
                    Favourite(context);
                  }),
              const Divider(),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/headset.svg',
                  width: 25,
                  height: 25,
                  color: const Color(0xFF662e91), // Adjust color as needed
                ),
                title: const Text('Contact Us',
                    style: CommonStyles.txSty_20black_fb),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: Colors.grey, size: 16), // Add trailing icon here
                onTap: () {
                  contact_us(context); // Execute your action here
                },
              ),
              const Divider(),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/logout_new.svg',
                  width: 25,
                  height: 25,
                  color: const Color(0xFF662e91), // Adjust color as needed
                ),
                title:
                    const Text('Logout', style: CommonStyles.txSty_20black_fb),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: Colors.grey, size: 16), // Add trailing icon here
                onTap: () {
                  logOutDialog(context); // Execute your action here
                },
              ),
              const Divider(),
              const SizedBox(height: 50),
              referBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget referBox() {
    return Container(
      height: 150,
      margin: const EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: CommonStyles.primaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Refer & earn \$100',
                        style: CommonStyles.txSty_20black_fb),
                    const Text(
                        'Get \$100 when your friend completes their first booking',
                        style: CommonStyles.txSty_16black_f5),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CommonStyles.primaryTextColor,
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // shape: const StadiumBorder(),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Refer now',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: const Center(
                child: Icon(Icons.home),
              ),
            ),
          ),
        ],
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
      MaterialPageRoute(builder: (context) => const AboutUsScreen()),
    );
  }

  void profile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ProfileMy()),
    );
  }

  void Favourite(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const FavouritesScreen()),
    );
  }
}
