import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import 'package:hairfixingzone/LatestAppointment.dart';
import 'package:hairfixingzone/NewScreen.dart';
import 'package:hairfixingzone/slotbookingscreen.dart';
import 'dart:async';

//
// import 'package:hairfixingservice/slotbookingscreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'Booking_Screen.dart';
import 'BranchModel.dart';
import 'Branches_screen.dart';
import 'Common/common_styles.dart';
import 'Dashboard_Screen.dart';
import 'MyAppointments.dart';
import 'MyProducts.dart';
import 'Profile.dart';
import 'api_config.dart';
import 'CommonUtils.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// class _HomeScreenState extends State<HomeScreen> {
//   late int _currentIndex;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  String userFullName = '';
  String email = '';
  String phonenumber = '';
  String Gender = '';
  int? userId;


  List<LastAppointment> appointments = [];

  final TextEditingController _commentstexteditcontroller =
      TextEditingController();
  double ratingStar = 0.0;
  double qualityRating = 0.0;

  @override
  void initState() {
    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        print('Connected to the internet');

        checkLoginuserdata();
        // Call API immediately when screen loads
        //  fetchData();
        //();
      } else {
        CommonUtils.showCustomToastMessageLong(
            'Please Check Your Internet Connection', context, 1, 4);
        print('Not connected to the internet'); // Not connected to the internet
      }
    });
    super.initState();
    _currentIndex = widget.initialIndex;
  }
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
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
                  content:
                      const Text('Are You Sure You Want to Close The App?'),
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
          backgroundColor: CommonStyles.whiteColor,
          appBar: CommonStyles.customerAppbar(
            context: context,
            title:buildTitle(_currentIndex, context),
            userName:
                userFullName.isNotEmpty ? userFullName[0].toUpperCase() : "H",
            userFullName: userFullName,
            email: email,
          ),

          //   body: SliderScreen(),
          body: _buildScreens(_currentIndex, context,userFullName),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            backgroundColor: const Color(0xffffffff),
            onTap: (index) => setState(() {
              _currentIndex = index;
              
            }),
      selectedItemColor:  Color(0xFF11528f),

              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/home_new.svg',
                    width: 20,
                    height: 20,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/home_new.svg',
                    width: 20,
                    height: 20,
                    color:  Color(0xFF11528f),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/invite-alt.svg',
                    width: 20,
                    height: 20,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/invite-alt.svg',
                    width: 20,
                    height: 20,
                    color: Color(0xFF11528f),
                  ),
                  label: 'Appointments',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/apps-add.svg',
                    width: 20,
                    height: 20,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/apps-add.svg',
                    width: 20,
                    height: 20,
                    color: Color(0xFF11528f),
                  ),
                  label: 'Menu',
                ),
              ],
              selectedLabelStyle: CommonStyles.txSty_16p_f5,
              // unselectedLabelStyle: TextStyle(
              //   fontSize: 14,
              //   color: Colors.grey, // Customize the color as needed
              // ),
            ),


        ));
  }

  void checkLoginuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userFullName = prefs.getString('userFullName') ?? '';
      print('userFullName: $userFullName');
      email = prefs.getString('email') ?? '';
      phonenumber = prefs.getString('contactNumber') ?? '';
      Gender = prefs.getString('gender') ?? '';
      userId = prefs.getInt('userId');
      print('userId:$userId');
     // getLatestAppointmentByUserId(userId);
      print('userFullName: $userFullName');
      print('gender:$Gender');

    });
  }




  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print('isLoggedIn: $isLoggedIn');
    if (isLoggedIn) {
      int? userId = prefs.getInt('userId'); // Retrieve the user ID

      if (userId != null) {
        // Use the user ID as needed
        print('User ID: $userId');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Branches_screen(userId: userId)));
      } else {
        // Handle the case where the user ID is not available
        print('User ID not found in SharedPreferences');
      }
    } else {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => agentloginscreen()),
      // );
    }
  }

  Widget buildTitle(int currentIndex, BuildContext context) {
    switch (currentIndex) {
      case 0:
        return Text.rich(
          TextSpan(

          ),
        );

      case 1:
        return Text(
          'Appointments',
          style:CommonStyles.txSty_22b_f5
        );

      case 2:
        return Text(
          'Profile',
            style:CommonStyles.txSty_22b_f5
        );



      default:
        return Text(
          'default',
            style:CommonStyles.txSty_22b_f5
        );
    }
  }
}


Widget _buildScreens(int index, BuildContext context, String userFullName) {
  switch (index) {
    case 0:
      return CustomerDashBoard(toNavigate: (Branch value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Bookingscreen(
              branchId: value.branchId,
              branchname: value.branchname,
              branchaddress: value.branchaddress,
              phonenumber: value.phonenumber,
              branchImage: value.branchImage,
              latitude: value.latitude,
              longitude: value.longitude, LocationUrl: value.LocationUrl,
            ),
          ),
        );
      });

    case 1:
      // Return the messages screen widget
      return const MyAppointments();

    case 2:
      
      // Return the settings screen widget
      return  NewScreen(userName: userFullName);
    case 3:
      // Return the settings screen widget
      return Profile();

    default:
      return Profile();
  }
}


//
class BannerImages {
  final int id;
  final String imageName;

  BannerImages({
    required this.imageName,
    required this.id,
  });

  factory BannerImages.fromJson(Map<String, dynamic> json) {
    return BannerImages(
      imageName: json['imageName'] ?? '',
      id: json['id'] ?? 0,
    );
  }
}
