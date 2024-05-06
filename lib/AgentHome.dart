import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hairfixingzone/CommonUtils.dart';
import 'package:hairfixingzone/CustomerLoginScreen.dart';
import 'package:hairfixingzone/MyAppointments.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'AgentDashBoard.dart';
import 'AgentLogin.dart';

class AgentHome extends StatefulWidget {
  const AgentHome({super.key});

  @override
  State<AgentHome> createState() => _AgentHomeState();
}

class _AgentHomeState extends State<AgentHome> {
  @override
  void initState() {
    super.initState();
    print('_____Agent Home_____');
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool confirmClose = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Exit'),
              content: const Text('Are you sure you want to close the app?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );

        if (confirmClose == true) {
          SystemNavigator.pop();
        }

        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFf3e3ff),
          automaticallyImplyLeading: false,
          title: _currentIndex == 0
              ? SizedBox(
            width: 85,
            height: 40,
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Image.asset(
                'assets/hfz_logo.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          )
              : _currentIndex == 1 || _currentIndex == 2 || _currentIndex == 3
              ? Text(
            _getAppBarTitle(_currentIndex),
            style: CommonUtils.header_Styles,
          )
              : null,
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/sign-out-alt.svg',
                color: const Color(0xFF662e91),
                width: 24,
                height: 24,
              ),
              onPressed: () {
                logOutDialog();
              },
            ),
          ],
        ),
        body: _buildScreens(_currentIndex),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          backgroundColor: const Color(0xFFf3e3ff),
          showElevation: true,
          itemCornerRadius: 24,
          curve: Curves.easeIn,
          onItemSelected: (index) => setState(() {
            setState(() {
              _currentIndex = index;
            });
          }),
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: SvgPicture.asset(
                'assets/objects-column.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 0
                    ? CommonUtils.primaryTextColor
                    : Colors.grey,
              ),
              title: const Text(
                'Screen1',
              ),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: SvgPicture.asset(
                'assets/invite-alt.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 1
                    ? CommonUtils.primaryTextColor
                    : Colors.grey,
              ),
              title: const Text(
                'Screen2',
              ),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: SvgPicture.asset(
                'assets/invite-alt.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 2
                    ? CommonUtils.primaryTextColor
                    : Colors.grey,
              ),
              title: const Text('Screen3'),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: SvgPicture.asset(
                'assets/bin-bottles.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 3
                    ? CommonUtils.primaryTextColor
                    : Colors.grey,
              ),
              title: const Text('Screen4'),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreens(int index) {
    switch (index) {
      case 0:
        return const AgentDashBoard();

      case 1:
        return const MyAppointments();

      case 2:
        return const MyAppointments();

      case 3:
        return const MyAppointments();

      default:
        return const AgentDashBoard();
    }
  }

  void logOutDialog() {
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
                onConfirmLogout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> onConfirmLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.remove('userId');
    prefs.remove('userRoleId');
    CommonUtils.showCustomToastMessageLong("Logout Successful", context, 0, 3);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AgentLogin()),
          (route) => false,
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return '';
      case 1:
        return 'Test1';
      case 2:
        return 'Test2';
      case 3:
        return 'Test3';
      default:
        return 'default';
    }
  }
}
