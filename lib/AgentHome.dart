import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hairfixingzone/Common/common_styles.dart';
import 'package:hairfixingzone/CommonUtils.dart';
import 'package:hairfixingzone/CustomerLoginScreen.dart';
import 'package:hairfixingzone/MyAppointments.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'AddConsulationscreen.dart';
import 'AgentDashBoard.dart';
import 'AgentLogin.dart';
import 'ViewConsultation.dart';

class AgentHome extends StatefulWidget {
  final int userId;

  const AgentHome({super.key, required this.userId});

  @override
  State<AgentHome> createState() => _AgentHomeState();
}

class _AgentHomeState extends State<AgentHome> {
  String userFullName = '';
  @override
  void initState() {
    super.initState();
    checkLoginuserdata();
    print('_____Agent Home_____');
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return Future.value(false);
        } else {
          bool confirmClose = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Exit'),
                content: const Text('Are You Sure You Want to Close The App?'),
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
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
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
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
          if (confirmClose == true) {
            SystemNavigator.pop();
          }
          return Future.value(false);
        }
      },
      child: Scaffold(
        appBar: CommonStyles.agentAppbar(
          context: context,
          title: buildTitle(_currentIndex, context),
          userName:
              userFullName.isNotEmpty ? userFullName[0].toUpperCase() : "A",
          onTap: () {
            logOutDialog(context);
          },
        ),
        body: _buildScreens(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          backgroundColor: const Color(0xffffffff),
          onTap: (index) => setState(() {
            _currentIndex = index;
          }),
          selectedItemColor: Colors.black,

          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/home.svg',
                width: 24,
                height: 24,
                color: Colors.black.withOpacity(0.6),
              ),
              activeIcon: SvgPicture.asset(
                'assets/home.svg',
                width: 24,
                height: 24,
                color: CommonUtils.primaryTextColor,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/invite-alt.svg',
                width: 24,
                height: 24,
                color: Colors.black.withOpacity(0.6),
              ),
              activeIcon: SvgPicture.asset(
                'assets/invite-alt.svg',
                width: 24,
                height: 24,
                color: CommonUtils.primaryTextColor,
              ),
              label: 'Add Consultation',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/apps.svg',
                width: 24,
                height: 24,
                color: Colors.black.withOpacity(0.6),
              ),
              activeIcon: SvgPicture.asset(
                'assets/apps.svg',
                width: 24,
                height: 24,
                color: CommonUtils.primaryTextColor,
              ),
              label: 'View Consultation',
            ),
          ],
          selectedLabelStyle: CommonStyles.txSty_16b_fb,
          // unselectedLabelStyle: TextStyle(
          //   fontSize: 14,
          //   color: Colors.grey, // Customize the color as needed
          // ),
        ),
        /* 
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
                    : Colors.black,
              ),
              title: const Text(
                'Home',
              ),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: SvgPicture.asset(
                'assets/calendar-day.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 1
                    ? CommonUtils.primaryTextColor
                    : Colors.black,
              ),
              title: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add',
                  ),
                  Text(
                    'Consultation',
                  ),
                ],
              ),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: SvgPicture.asset(
                'assets/calendar-lines.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 2
                    ? CommonUtils.primaryTextColor
                    : Colors.black,
              ),
              title: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('View'),
                  Text('Consultation'),
                ],
              ),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      */
      ),
    );
  }

  Widget _buildScreens(int index) {
    switch (index) {
      case 0:
        return AgentDashBoard(
          agentid: widget.userId,
        );

      case 1:
        return AddConsulationscreen(
          agentId: widget.userId,
        );

      case 2:
        return ViewConsultation(
          agentId: widget.userId,
        );

      default:
        return AgentDashBoard(
          agentid: widget.userId,
        );
    }
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
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10), // Add spacing between buttons
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirmLogout();
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
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
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
    CommonUtils.showCustomToastMessageLong(
        "Logout Successfully", context, 0, 3);

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
        return 'Add Consultation';
      case 2:
        return 'View Consultation';

      default:
        return '';
    }
  }

  void checkLoginuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userFullName = prefs.getString('userFullName') ?? '';
      print('userFullName: $userFullName');
    });
  }

  String buildTitle(int currentIndex, BuildContext context) {
    switch (currentIndex) {
      case 0:
        return '';
      case 1:
        return 'Add Consultation';
      case 2:
        return 'View Consultation';
      default:
        return 'default';
    }
  }
}
