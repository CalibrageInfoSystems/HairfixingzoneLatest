import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
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
import 'agentloginscreen.dart';
import 'api_config.dart';
import 'CommonUtils.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  String userFullName = '';
  String email = '';
  String phonenumber = '';
  String Gender = '';
  int? userId;
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
      // _fullnameController1.text = userFullName;
      // _emailController3.text = email;
      // _phonenumberController2.text = phonenumber;
      // gender = selectedGender;
      print('userId:$userId');
    //  GetLatestAppointmentByUserId(userId);
      print('userFullName: $userFullName');
      print('gender:$Gender');
      // if (gender == 1) {
      //   Gender = 'Female';
      // } else if (gender == 2) {
      //   Gender = 'Male';
      // } else if (gender == 3) {
      //   Gender = 'Other';
      // }
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
                          fontFamily: 'Calibri',
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
                          fontFamily: 'Calibri',
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
      //MARK: AppBar000000000000000000000000000000000000

      child:Scaffold(
        appBar: CommonStyles.homeAppBar(
            context: context,
            userName: userFullName.isNotEmpty ? userFullName[0].toUpperCase() : "H",userFullName: userFullName,email :email
        ),

     //   body: SliderScreen(),
   body: _buildScreens(_currentIndex),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          backgroundColor: const Color(0xffffffff),
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
              title:  Text(
                'Home',style: CommonStyles.txSty_14b_f5,
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
                    : Colors.black, // Change color based
              ),
              title: const Text(
                'Bookings',style: CommonStyles.txSty_14b_f5,
              ),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: SvgPicture.asset(
                'assets/bin-bottles.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 2
                    ? CommonUtils.primaryTextColor
                    : Colors.black, // Change color based on selection
              ),
              title: const Text('Products',style: CommonStyles.txSty_14b_f5,),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: SvgPicture.asset(
                'assets/my_profile_icon.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 3
                    ? CommonUtils.primaryTextColor
                    : Colors.black, // Change color based on selection
              ),
              title: const Text('My Profile',style: CommonStyles.txSty_14b_f5,),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: const Color(0xFFF44614), // Orange color
    //
    //       actions: [
    //         Align(
    //           alignment: Alignment.bottomRight,
    //           child: Container(
    //             width: 115,
    //             height: 35,
    //             margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               border: Border.all(
    //                 color: Color(0xFF8d97e2),
    //                 width: 3,
    //               ),
    //               borderRadius: BorderRadius.circular(10.0),
    //             ),
    //             child: InkWell(
    //               onTap: () {
    //                 checkLoginStatus();
    //                 // Handle button press
    //               },
    //               child: Container(
    //                 padding: EdgeInsets.symmetric(horizontal: 10), // Adjust padding as needed
    //                 child: Row(
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: [
    //                     Image.asset(
    //                       'assets/agent_icon.png',
    //                       width: 20,
    //                       height: 20,
    //                     ),
    //                     SizedBox(width: 5),
    //                     Text(
    //                       'AGENT',
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         color: Color(0xFF042de3),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //
    //
    //       title: Container(
    //         width: 85, // Adjust the width as needed
    //         height: 50, // Adjust the height as needed
    //         child: FractionallySizedBox(
    //           widthFactor: 1, // Adjust the width factor as needed (0.8 = 80% of available width)
    //           child: Image.asset(
    //             'assets/logo.png',
    //             fit: BoxFit.fitHeight,
    //           ),
    //         ),
    //       ),
    //     ),
    //
    //   ),
    // );
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => Branches_screen(userId: userId)));
      } else {
        // Handle the case where the user ID is not available
        print('User ID not found in SharedPreferences');
      }
    }
    else {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => agentloginscreen()),
      // );
    }
  }
}

// class BannerImages {
//   final String FilePath;
//   final int Id;
//
//   BannerImages({required this.FilePath, required this.Id});
// }



// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _currentIndex = 0;
//   late ExpandedTileController _expandedTileController;
//
//   String userFullName = '';
//   String email = '';
//   String phonenumber = '';
//
// //  String gender ='';
//   String Gender = '';
//   List<BannerImages> imageList = [];
//
//   List<BranchModel> brancheslist = [];
//   final CarouselController carouselController = CarouselController();
//   int currentIndex = 0;
//   bool isLoading = true;
//   bool isDataBinding = false;
//   bool apiAllowed = true;
//   late Timer _timer;
//   List<LastAppointment> appointments = [];
//   int? userId;
//
//   // String userFullName = '';
//   // String email = '';
//   // String phonenumber = '';
//   // int gender = 0;
//   // String Gender = '';
//   @override
//   void initState() {
//     _expandedTileController = ExpandedTileController(isExpanded: false);
//
//     CommonUtils.checkInternetConnectivity().then((isConnected) {
//       if (isConnected) {
//         print('Connected to the internet');
//         fetchData();
//         checkLoginuserdata();
//         // Call API immediately when screen loads
//         //  fetchData();
//         //();
//         fetchImages();
//       } else {
//         CommonUtils.showCustomToastMessageLong(
//             'Please Check Your Internet Connection', context, 1, 4);
//         print('Not connected to the internet'); // Not connected to the internet
//       }
//     });
//     super.initState();
//   }
//
//   void checkLoginuserdata() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     setState(() {
//       userFullName = prefs.getString('userFullName') ?? '';
//       print('userFullName: $userFullName');
//       email = prefs.getString('email') ?? '';
//       phonenumber = prefs.getString('contactNumber') ?? '';
//       Gender = prefs.getString('gender') ?? '';
//       userId = prefs.getInt('userId');
//       // _fullnameController1.text = userFullName;
//       // _emailController3.text = email;
//       // _phonenumberController2.text = phonenumber;
//       // gender = selectedGender;
//       print('userId:$userId');
//       GetLatestAppointmentByUserId(userId);
//       print('userFullName: $userFullName');
//       print('gender:$Gender');
//       // if (gender == 1) {
//       //   Gender = 'Female';
//       // } else if (gender == 2) {
//       //   Gender = 'Male';
//       // } else if (gender == 3) {
//       //   Gender = 'Other';
//       // }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Show a confirmation dialog
//         if (_currentIndex != 0) {
//           setState(() {
//             _currentIndex = 0;
//           });
//           return Future.value(false);
//         } else {
//           bool confirmClose = await showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: const Text('Confirm Exit'),
//                 content: const Text('Are You Sure You Want to Close The App?'),
//                 actions: [
//                   Container(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         textStyle: const TextStyle(
//                           color: CommonUtils.primaryTextColor,
//                         ),
//                         side: const BorderSide(
//                           color: CommonUtils.primaryTextColor,
//                         ),
//                         backgroundColor: Colors.white,
//                         shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(5),
//                           ),
//                         ),
//                       ),
//                       child: const Text(
//                         'No',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: CommonUtils.primaryTextColor,
//                           fontFamily: 'Calibri',
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Container(
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.of(context).pop(true),
//                       style: ElevatedButton.styleFrom(
//                         textStyle: const TextStyle(
//                           color: CommonUtils.primaryTextColor,
//                         ),
//                         side: const BorderSide(
//                           color: CommonUtils.primaryTextColor,
//                         ),
//                         backgroundColor: CommonUtils.primaryTextColor,
//                         shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(5),
//                           ),
//                         ),
//                       ),
//                       child: const Text(
//                         'Yes',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.white,
//                           fontFamily: 'Calibri',
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//           if (confirmClose == true) {
//             SystemNavigator.pop();
//           }
//           return Future.value(false);
//         }
//       },
//       //MARK: AppBar000000000000000000000000000000000000
//
//       child:Scaffold(
//       appBar: CommonStyles.homeAppBar(
// context: context,
//       userName: userFullName.isNotEmpty ? userFullName[0].toUpperCase() : "H",userFullName: userFullName,email :email
//     ),
//
//         /* appBar: _currentIndex == 0
//             ? CommonStyles.homeAppBar(
//                 onSelected: (value) {
//                   print('value: $value');
//                   switch (value) {
//                     case 'profile':
//                       print('Profile');
//                       setState(() {
//                         _currentIndex = 3;
//                       });
//                       break;
//                     case 'favorites':
//                       print('Favorites');
//                       break;
//                     case 'about':
//                       print('About');
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const AboutUsScreen()),
//                       );
//                       break;
//                     case 'logout':
//                       logOutDialog();
//                       break;
//                     default:
//                       print('default');
//                       break;
//                   }
//                 }, // logOutDialog()
//                 userName: userFullName.isNotEmpty
//                     ? userFullName[0].toLowerCase()
//                     : "H",
//               )
//             : CommonStyles.remainingAppBars(
//                 context,
//                 title: _getAppBarTitle(_currentIndex),
//                 onPressed: () {
//                   logOutDialog();
//                 },
//               ),
//         */
//         body:
//         _buildScreens(_currentIndex),
//         bottomNavigationBar: BottomNavyBar(
//           selectedIndex: _currentIndex,
//           backgroundColor: const Color(0xffffffff),
//           showElevation: true,
//           itemCornerRadius: 24,
//           curve: Curves.easeIn,
//           onItemSelected: (index) => setState(() {
//             setState(() {
//               _currentIndex = index;
//             });
//           }),
//           items: <BottomNavyBarItem>[
//             BottomNavyBarItem(
//               icon: SvgPicture.asset(
//                 'assets/objects-column.svg',
//                 width: 24,
//                 height: 24,
//                 color: _currentIndex == 0
//                     ? CommonUtils.primaryTextColor
//                     : Colors.black,
//               ),
//               title:  Text(
//                 'Home',style: CommonStyles.txSty_14b_f5,
//               ),
//               activeColor: Colors.blue,
//               textAlign: TextAlign.center,
//             ),
//             BottomNavyBarItem(
//               icon: SvgPicture.asset(
//                 'assets/invite-alt.svg',
//                 width: 24,
//                 height: 24,
//                 color: _currentIndex == 1
//                     ? CommonUtils.primaryTextColor
//                     : Colors.black, // Change color based
//               ),
//               title: const Text(
//                 'Bookings',style: CommonStyles.txSty_14b_f5,
//               ),
//               activeColor: Colors.blue,
//               textAlign: TextAlign.center,
//             ),
//             BottomNavyBarItem(
//               icon: SvgPicture.asset(
//                 'assets/bin-bottles.svg',
//                 width: 24,
//                 height: 24,
//                 color: _currentIndex == 2
//                     ? CommonUtils.primaryTextColor
//                     : Colors.black, // Change color based on selection
//               ),
//               title: const Text('Products',style: CommonStyles.txSty_14b_f5,),
//               activeColor: Colors.blue,
//               textAlign: TextAlign.center,
//             ),
//             BottomNavyBarItem(
//               icon: SvgPicture.asset(
//                 'assets/my_profile_icon.svg',
//                 width: 24,
//                 height: 24,
//                 color: _currentIndex == 3
//                     ? CommonUtils.primaryTextColor
//                     : Colors.black, // Change color based on selection
//               ),
//               title: const Text('My Profile',style: CommonStyles.txSty_14b_f5,),
//               activeColor: Colors.blue,
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void logOutDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: const Text('Are You Sure You Want to Logout?'),
//           actions: [
//             Container(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   textStyle: const TextStyle(
//                     color: CommonUtils.primaryTextColor,
//                   ),
//                   side: const BorderSide(
//                     color: CommonUtils.primaryTextColor,
//                   ),
//                   backgroundColor: Colors.white,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(5),
//                     ),
//                   ),
//                 ),
//                 child: const Text(
//                   'No',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: CommonUtils.primaryTextColor,
//                     fontFamily: 'Calibri',
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 10), // Add spacing between buttons
//             Container(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   onConfirmLogout();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   textStyle: const TextStyle(
//                     color: CommonUtils.primaryTextColor,
//                   ),
//                   side: const BorderSide(
//                     color: CommonUtils.primaryTextColor,
//                   ),
//                   backgroundColor: CommonUtils.primaryTextColor,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(5),
//                     ),
//                   ),
//                 ),
//                 child: const Text(
//                   'Yes',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.white,
//                     fontFamily: 'Calibri',
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   String _getAppBarTitle(int index) {
//     switch (index) {
//       case 0:
//         return '';
//       case 1:
//         return 'My Bookings';
//       case 2:
//         return 'My Products';
//       case 3:
//         return 'My Profile';
//
//       default:
//         return 'Home';
//     }
//   }
//
//   Future<void> onConfirmLogout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('isLoggedIn', false);
//     prefs.remove('userId'); // Remove userId from SharedPreferences
//     prefs.remove('userRoleId'); // Remove roleId from SharedPreferences
//     CommonUtils.showCustomToastMessageLong(
//         "Logout Successfully", context, 0, 3);
//
//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (context) => const CustomerLoginScreen()),
//           (route) => false,
//     );
//   }
//
//   void fetchData() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     // Add a timeout of 8 seconds using Future.delayed
//     Future.delayed(const Duration(seconds: 15), () {
//       if (isLoading) {
//         setState(() {
//           isLoading = false;
//           brancheslist.clear(); // Clear the list if timeout occurs
//         });
//       }
//     });
//
//     await _getData(); // Call your API method
//   }
//
//   void fetchimagesslider() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     // Add a timeout of 8 seconds using Future.delayed
//     Future.delayed(const Duration(seconds: 15), () {
//       if (isLoading) {
//         setState(() {
//           isLoading = false;
//           imageList.clear(); // Clear the list if timeout occurs
//         });
//       }
//     });
//
//     await fetchImages(); // Call your API method
//   }
//
//   @override
//   void dispose() {
//     //  _timer?.cancel();
//     super.dispose();
//   }
//
//   Future<void> _getData() async {
//     setState(() {
//       isLoading = true; // Set isLoading to true before making the API call
//     });
//
//     final url = Uri.parse(baseUrl + getbranches);
//     print('url==>135: $url');
//
//     bool success = false;
//     int retries = 0;
//     const maxRetries = 1;
//
//     while (!success && retries < maxRetries) {
//       try {
//         final response = await http.get(url);
//
//         // Check if the request was successful
//         if (response.statusCode == 200) {
//           // Parse the response body
//           final data = json.decode(response.body);
//
//           List<BranchModel> branchList = [];
//           for (var item in data['listResult']) {
//             branchList.add(BranchModel(
//               id: item['id'],
//               name: item['name'],
//               imageName: item['imageName'],
//               address: item['address'],
//               startTime: item['startTime'],
//               closeTime: item['closeTime'],
//               room: item['room'],
//               mobileNumber: item['mobileNumber'],
//               isActive: item['isActive'],
//             ));
//           }

//           // Update the state with the fetched data
//           setState(() {
//             brancheslist = branchList;
//             isLoading = false; // Set isLoading to false after data is fetched
//           });
//
//           success = true;
//         } else {
//           // Handle error if the API request was not successful
//           print('Request failed with status: ${response.statusCode}');
//           setState(() {
//             isLoading = false; // Set isLoading to false if request fails
//           });
//         }
//       } catch (error) {
//         // Handle any exception that occurred during the API call
//         print('Error data is not getting from the api: $error');
//         setState(() {
//           isLoading = false; // Set isLoading to false if error occurs
//         });
//       }
//
//       retries++;
//     }
//
//     if (!success) {
//       // Handle the case where all retries failed
//       print('All retries failed. Unable to fetch data from the API.');
//     }
//   }
//
//   Future<void> fetchImages() async {
//     setState(() {
//       isDataBinding = true; // Set the flag to true when data fetching starts
//
//       isLoading = true; // Set isLoading to true before making the API call
//     });
//
//     final url = Uri.parse(baseUrl + getBanners);
//     print('url==>127: $url');
//
//     try {
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//
//         List<BannerImages> bannerImages = [];
//         for (var item in jsonData['listResult']) {
//           bannerImages.add(BannerImages(
//               imageName: item['imageName'] ?? '', id: item['id'] ?? 0));
//         }
//
//         setState(() {
//           imageList = bannerImages;
//           isDataBinding = false;
//
//           isLoading =
//           false; // Set isLoading to false after completing the API call
//         });
//       } else {
//         // Handle error if the API request was not successful
//         print('Request failed with status: ${response.statusCode}');
//         setState(() {
//           isDataBinding = false;
//
//           isLoading = false; // Set isLoading to false if request fails
//         });
//       }
//     } catch (error) {
//       // Handle any exception that occurred during the API call
//       print('Error images are not from the api: $error');
//       setState(() {
//         isDataBinding = false;
//         isLoading = false; // Set isLoading to false if error occurs
//       });
//     }
//   }
//
//   void retryDataFetching() {
//     // setState(() {
//     //   isLoading = true; // Set isLoading to true to show loading indicator
//     // });
//     // _getData(); // Call your API method to fetch data
//     // fetchImages(); // Call your API method to fetch images
//     CommonUtils.checkInternetConnectivity().then((isConnected) {
//       if (isConnected) {
//         print('Connected to the internet');
//         //fetchImages();
//         // _getData();
//         fetchData();
//         fetchimagesslider();
//       } else {
//         CommonUtils.showCustomToastMessageLong(
//             'Please Check Your Internet Connection', context, 1, 4);
//         print('Not connected to the internet'); // Not connected to the internet
//       }
//     });
//   }
//
//   Future<void> GetLatestAppointmentByUserId(int? userId) async {
//     //  final response = await http.get('http://182.18.157.215/SaloonApp/API/api/Role/GetLatestAppointmentByUserId/1');
//     final Uri url = Uri.parse(
//         'http://182.18.157.215/SaloonApp/API/api/Role/GetLatestAppointmentByUserId/$userId');
//     print('url==>1086: $url');
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final List<dynamic> jsonData = jsonDecode(response.body);
//       List<LastAppointment> loadedAppointments = [];
//
//       for (var item in jsonData) {
//         loadedAppointments.add(LastAppointment.fromJson(item));
//       }
//
//       setState(() {
//         appointments = loadedAppointments;
//         print('Appointment ID: ${appointments.length}');
//       });
//
//       // Print each appointment in the logs
//       for (var appointment in appointments) {
//         print('Appointment ID: ${appointment.id}');
//         print('Branch: ${appointment.branch}');
//         print('Date: ${appointment.date}');
//         print('Customer Name: ${appointment.customerName}');
//         print('Slot Time: ${appointment.slotTime}');
//         print('Contact Number: ${appointment.contactNumber}');
//         print('Email: ${appointment.email}');
//         print('Gender: ${appointment.gender}');
//         print('Status: ${appointment.status}');
//         print('Purpose of Visit: ${appointment.purposeOfVisit}');
//         print('Slot Duration: ${appointment.slotDuration}');
//         print('Appointment Time: ${appointment.appointmentTime}');
//         print('');
//         SchedulerBinding.instance.addPostFrameCallback((_) {
//           _showBottomSheet(context, appointments);
//         });
//         // WidgetsBinding.instance.addPostFrameCallback((_) {
//         //   _showBottomSheet(context, appointments);
//         // });
//       }
//     } else {
//       throw Exception('Failed to load appointments');
//     }
//   }
//
//   Widget buildIndicator(int index) {
//     return Container(
//       width: 8,
//       height: 8,
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: index == currentIndex ? Colors.orange : Colors.grey,
//       ),
//     );
//   }
//
//   final TextEditingController _commentstexteditcontroller =
//   TextEditingController();
//   double rating_star = 0.0;
//
//   void _showBottomSheet(
//       BuildContext context, List<LastAppointment> appointments) {
//     showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Please Rate Your Recent Experience With Us',
//                   style: TextStyle(
//                     fontSize: 24,
//                     color: CommonUtils.primaryTextColor,
//                     fontFamily: 'Calibri',
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15.0,
//                 ),
//                 const Text(
//                   'Rating',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: CommonUtils.primaryTextColor,
//                     fontFamily: 'Calibri',
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15.0,
//                 ),
//                 SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     child: RatingBar.builder(
//                       initialRating: 0,
//                       minRating: 0,
//                       direction: Axis.horizontal,
//                       allowHalfRating: true,
//                       itemCount: 5,
//                       itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
//                       itemBuilder: (context, _) => const Icon(
//                         Icons.star,
//                         color: CommonUtils.primaryTextColor,
//                       ),
//                       onRatingUpdate: (rating) {
//                         setState(() {
//                           rating_star = rating;
//                           print('rating_star$rating_star');
//                         });
//                       },
//                     )),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 0, top: 10.0, right: 0),
//                   child: GestureDetector(
//                     onTap: () async {},
//                     child: Container(
//                       height: 80,
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: CommonUtils.primaryTextColor, width: 1.5),
//                         borderRadius: BorderRadius.circular(5.0),
//                         color: Colors.white,
//                       ),
//                       child: TextFormField(
//                         controller: _commentstexteditcontroller,
//                         style: const TextStyle(
//                           fontFamily: 'Calibri',
//                           fontSize: 14,
//                           fontWeight: FontWeight.w300,
//                         ),
//                         maxLines: null,
//                         maxLength: 250,
//                         // Set maxLines to null for multiline input
//                         decoration: const InputDecoration(
//                           hintText: 'Comment',
//                           hintStyle: TextStyle(
//                             color: Colors.black54,
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'Calibri',
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 16.0,
//                             vertical: 12.0,
//                           ),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           textStyle: const TextStyle(
//                             color: CommonUtils.primaryTextColor,
//                           ),
//                           side: const BorderSide(
//                             color: CommonUtils.primaryTextColor,
//                           ),
//                           backgroundColor: Colors.white,
//                           shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(10),
//                             ),
//                           ),
//                         ),
//                         child: const Text(
//                           'Close',
//                           style: TextStyle(
//                             fontFamily: 'Calibri',
//                             fontSize: 14,
//                             color: CommonUtils.primaryTextColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Expanded(
//                       child: SizedBox(
//                         child: Center(
//                           child: GestureDetector(
//                             onTap: () {
//                               validaterating(appointments);
//                             },
//                             child: Container(
//                               // width: desiredWidth * 0.9,
//                               height: 40.0,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15.0),
//                                 color: CommonUtils.primaryTextColor,
//                               ),
//                               child: const Center(
//                                 child: Text(
//                                   'Submit',
//                                   style: TextStyle(
//                                     fontFamily: 'Calibri',
//                                     fontSize: 14,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> validaterating(List<LastAppointment> appointments) async {
//     bool isValid = true;
//     bool hasValidationFailed = false;
//     if (isValid && rating_star <= 0.0) {
//       CommonUtils.showCustomToastMessageLong(
//           'Please Rate Your Experience', context, 1, 4);
//       isValid = false;
//       hasValidationFailed = true;
//       FocusScope.of(context).unfocus();
//     }
//
//     // if (isValid && _commentstexteditcontroller.text.trim().isEmpty) {
//     //   CommonUtils.showCustomToastMessageLong('Please Enter Comment', context, 1, 4);
//     //   isValid = false;
//     //   hasValidationFailed = true;
//     //   FocusScope.of(context).unfocus();
//     // }
//     if (isValid) {
//       SharedPreferences sharedPreferences =
//       await SharedPreferences.getInstance();
//       String? storedEmployeeId = sharedPreferences.getString("employeeId");
//       print('employidinfeedback$storedEmployeeId');
//       String comments = _commentstexteditcontroller.text.toString();
//       int myInt = rating_star.toInt();
//       print('changedintoint$myInt');
//       AddUpdatefeedback(appointments);
//     }
//   }
//
//   // Future<void> AddUpdatefeedback(List<LastAppointment> appointments) async {}
//
//   Future<void> AddUpdatefeedback(List<LastAppointment> appointments) async {
//     final url = Uri.parse(baseUrl + postApiAppointment);
//     print('url==>890: $url');
//     DateTime now = DateTime.now();
//     String dateTimeString = now.toString();
//     print('DateTime as String: $dateTimeString');
//
//     for (LastAppointment appointment in appointments) {
//       // Create the request object for each appointment
//       final request = {
//         "Id": appointment.id,
//         "BranchId": appointment.branchId,
//         "Date": appointment.date,
//         "SlotTime": appointment.slotTime,
//         "CustomerName": appointment.customerName,
//         "PhoneNumber":
//         appointment.contactNumber, // Changed from appointments.phoneNumber
//         "Email": appointment.email,
//         "GenderTypeId": appointment.genderTypeId,
//         "StatusTypeId": 17,
//         "PurposeOfVisitId": appointment.purposeOfVisitId,
//         "PurposeOfVisit": appointment.purposeOfVisit,
//         "IsActive": true,
//         "CreatedDate": dateTimeString,
//         "UpdatedDate": dateTimeString,
//         "UpdatedByUserId": null,
//         "rating": rating_star,
//         "review": _commentstexteditcontroller.text.toString(),
//         "reviewSubmittedDate": dateTimeString,
//         "timeofslot": null,
//         "customerId": userId,
//         "paymentTypeId": null
//       };
//       print('AddUpdatefeedback object: : ${json.encode(request)}');
//
//       try {
//         // Send the POST request for each appointment
//         final response = await http.post(
//           url,
//           body: json.encode(request),
//           headers: {
//             'Content-Type': 'application/json',
//           },
//         );
//
//         if (response.statusCode == 200) {
//           CommonUtils.showCustomToastMessageLong(
//               'Feedback Successfully Submitted', context, 0, 4);
//           print('Request sent successfully');
//           Navigator.pop(context);
//         } else {
//           print(
//               'Failed to send the request. Status code: ${response.statusCode}');
//         }
//       } catch (e) {
//         print('Error: $e');
//       }
//     }
//   }
//
  Widget _buildScreens(int index) {
    switch (index) {
      case 0:
        return const Dashboard_Screen();

      case 1:
      // Return the messages screen widget
        return  MyAppointments();

      case 2:
      // Return the settings screen widget
        return  MyProducts();
      case 3:
      // Return the settings screen widget
        return  Profile();

      default:
        return  Dashboard_Screen();
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
