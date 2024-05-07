import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hairfixingzone/Common/common_styles.dart';
import 'package:hairfixingzone/Profile.dart';
import 'package:hairfixingzone/UserSelectionScreen.dart';
import 'package:hairfixingzone/feedback.dart';
import 'package:hairfixingzone/slotbookingscreen.dart';

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'Appointment.dart';
import 'BranchModel.dart';
import 'Branches_screen.dart';
import 'CustomerLoginScreen.dart';
import 'Dashboard_Screen.dart';
import 'LatestAppointment.dart';
import 'MyAppointments.dart';
import 'MyProducts.dart';
import 'aboutus_screen.dart';
import 'agentloginscreen.dart';
import 'api_config.dart';
import 'CommonUtils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late ExpandedTileController _expandedTileController;

  String userFullName = '';
  String email = '';
  String phonenumber = '';

//  String gender ='';
  String Gender = '';
  List<BannerImages> imageList = [];

  List<BranchModel> brancheslist = [];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  bool isLoading = true;
  bool isDataBinding = false;
  bool apiAllowed = true;
  late Timer _timer;
  List<LastAppointment> appointments = [];
  int? userId;

  // String userFullName = '';
  // String email = '';
  // String phonenumber = '';
  // int gender = 0;
  // String Gender = '';
  @override
  void initState() {
    // TODO: implement initState
    _expandedTileController = ExpandedTileController(isExpanded: false);

    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        print('Connected to the internet');
        fetchData();
        checkLoginuserdata();
        // Call API immediately when screen loads
        //  fetchData();
        //fetchimagesslider();
        fetchImages();
      } else {
        CommonUtils.showCustomToastMessageLong('No Internet Connection', context, 1, 4);
        print('Not connected to the internet'); // Not connected to the internet
      }
    });
    super.initState();
  }

  void checkLoginuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userFullName = prefs.getString('userFullName') ?? '';
      email = prefs.getString('email') ?? '';
      phonenumber = prefs.getString('contactNumber') ?? '';
      Gender = prefs.getString('gender') ?? '';
      userId = prefs.getInt('userId');
      // _fullnameController1.text = userFullName;
      // _emailController3.text = email;
      // _phonenumberController2.text = phonenumber;
      // gender = selectedGender;
      print('userId:$userId');
      GetLatestAppointmentByUserId(userId);
      print('userFullName:$userFullName');
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
        bool confirmClose = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Exit'),
              content: const Text('Are you sure you want to close the app?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), // Close the dialog and return false
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // Close the dialog and return true
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );

        // Close the app if user confirms
        if (confirmClose == true) {
          // Close the app
          SystemNavigator.pop();
        }

        // Return false to prevent default back button behavior
        return Future.value(false);
      },
      // child: MaterialApp(
      //   debugShowCheckedModeBanner: false,
      child: Scaffold(
        appBar: _currentIndex == 0
            ? CommonStyles.homeAppBar(onPressed: () => logOutDialog(),)
            : CommonStyles.remainingAppBars(
                context,
                title: _getAppBarTitle(_currentIndex),
                onPressed: () {
                  logOutDialog();
                },
              ),

        // AppBar(
        //   backgroundColor: const Color(0xFFf3e3ff),
        //   automaticallyImplyLeading: false,
        //   title: _currentIndex == 0
        //       ? Container(
        //           width: 85,
        //           height: 40,
        //           child: FractionallySizedBox(
        //             widthFactor: 1,
        //             child: Image.asset(
        //               'assets/hfz_logo.png',
        //               fit: BoxFit.fitWidth,
        //             ),
        //           ),
        //         )
        //       : _currentIndex == 1 || _currentIndex == 2 || _currentIndex == 3
        //           ? Text(
        //               _getAppBarTitle(_currentIndex),
        //               style: CommonUtils.header_Styles,
        //             )
        //           : null,
        //   actions: [
        //     IconButton(
        //       icon: SvgPicture.asset(
        //         'assets/sign-out-alt.svg',
        //         color: Color(0xFF662e91),
        //         width: 24,
        //         height: 24,
        //       ),
        //       onPressed: () {
        //         logOutDialog();
        //         // Add logout functionality here
        //       },
        //     ),
        //   ],
        // ),

        body: _buildScreens(_currentIndex),

        // Column(
        //   children: [
        //
        //     Expanded(
        //       child: Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 10.0),
        //         child: Column(
        //           children: [
        //             Expanded(
        //               child: Stack(
        //                 children: [
        //                   Align(
        //                     alignment: Alignment.topCenter,
        //                     child: isDataBinding
        //                         ? Center(
        //                             child: CircularProgressIndicator.adaptive(),
        //                           )
        //                         : imageList.isEmpty
        //                             ? Center(
        //                                 // child: CircularProgressIndicator.adaptive(),
        //                                 child: Icon(
        //                                   Icons.signal_cellular_connected_no_internet_0_bar_sharp,
        //                                   color: Colors.red,
        //                                 ),
        //                               )
        //                             : CarouselSlider(
        //                                 items: imageList
        //                                     .map((item) => Image.network(
        //                                           item.imageName,
        //                                           fit: BoxFit.fitWidth,
        //                                           width: MediaQuery.of(context).size.width,
        //                                         ))
        //                                     .toList(),
        //                                 carouselController: carouselController,
        //                                 options: CarouselOptions(
        //                                   scrollPhysics: const BouncingScrollPhysics(),
        //                                   autoPlay: true,
        //                                   aspectRatio: 23 / 9,
        //                                   viewportFraction: 1,
        //                                   onPageChanged: (index, reason) {
        //                                     setState(() {
        //                                       currentIndex = index;
        //                                     });
        //                                   },
        //                                 ),
        //                               ),
        //                   ),
        //
        //                   Container(
        //                     width: MediaQuery.of(context).size.width,
        //                     //  padding: EdgeInsets.all(20.0),
        //
        //                     height: MediaQuery.of(context).size.height,
        //                     child: Align(
        //                       alignment: Alignment.bottomCenter,
        //                       child: Padding(
        //                         padding: EdgeInsets.only(bottom: 25.0),
        //                         child: Row(
        //                           mainAxisAlignment: MainAxisAlignment.center,
        //                           children: imageList.asMap().entries.map((entry) {
        //                             final index = entry.key;
        //                             return buildIndicator(index);
        //                           }).toList(),
        //                         ),
        //                       ),
        //                     ),
        //                   )
        //                 ],
        //               ),
        //             ),
        //             // Padding(
        //             //   padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        //             //   child: Align(
        //             //     alignment: Alignment.topCenter,
        //             //     child: Text(
        //             //       'Branches',
        //             //       textAlign: TextAlign.left,
        //             //       style: TextStyle(
        //             //         fontFamily: 'Calibri',
        //             //         fontSize: 20,
        //             //         color: Color(0xFF163CF1),
        //             //         fontWeight: FontWeight.bold,
        //             //       ),
        //             //     ),
        //             //   ),
        //             // ),
        //             // if (isLoading)
        //             //   Text('Please Wait Loading Slow Internet Connection !')
        //             // else if (brancheslist.isEmpty && imageList.isEmpty)
        //             //   Container(
        //             //     padding: EdgeInsets.all(15.0),
        //             //     child: Center(
        //             //       child: Column(
        //             //         mainAxisAlignment: MainAxisAlignment.center,
        //             //         children: [
        //             //           Text('Failed to fetch data. Please check your internet connection.!'),
        //             //           SizedBox(height: 20),
        //             //           ElevatedButton(
        //             //             onPressed: retryDataFetching,
        //             //             child: Text('Retry'),
        //             //           ),
        //             //         ],
        //             //       ),
        //             //     ),
        //             //   ),
        //             // // if (brancheslist == null || brancheslist.isEmpty)
        //             // //   Container(
        //             // //     padding: EdgeInsets.all(15.0),
        //             // //     child: Center(
        //             // //       child: Column(
        //             // //         mainAxisAlignment: MainAxisAlignment.center,
        //             // //         children: [
        //             // //           SizedBox(height: 100),
        //             // //           Center(
        //             // //             child: Text('No found.'),
        //             // //           ),
        //             // //         ],
        //             // //       ),
        //             // //     ),
        //             // //   ),
        //             // Expanded(
        //             //     flex: 3,
        //             //     child: ListView.builder(
        //             //       shrinkWrap: true,
        //             //       itemCount: isLoading ? 5 : brancheslist.length, // Display a fixed number of shimmer items when loading
        //             //       itemBuilder: (context, index) {
        //             //         if (isLoading) {
        //             //           // Return shimmer effect if isLoading is true
        //             //           return Padding(
        //             //             padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
        //             //             child: Shimmer.fromColors(
        //             //               baseColor: Colors.grey.shade300,
        //             //               highlightColor: Colors.grey.shade100,
        //             //               child: Container(
        //             //                 height: 150, // Adjust height as needed
        //             //                 decoration: BoxDecoration(
        //             //                   color: Colors.white,
        //             //                   borderRadius: BorderRadius.circular(15.0),
        //             //                 ),
        //             //               ),
        //             //             ),
        //             //           );
        //             //         } else {
        //             //           // Return actual data when isLoading is false
        //             //           BranchModel branch = brancheslist[index];
        //             //           return Padding(
        //             //             padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
        //             //             child: IntrinsicHeight(
        //             //               child: ClipRRect(
        //             //                 borderRadius: BorderRadius.only(
        //             //                   topRight: Radius.circular(15.0),
        //             //                   bottomLeft: Radius.circular(15.0),
        //             //                 ),
        //             //                 child: GestureDetector(
        //             //                   onTap: () {
        //             //                     Navigator.push(
        //             //                       context,
        //             //                       MaterialPageRoute(
        //             //                         builder: (context) => slotbookingscreen(
        //             //                           branchId: branch.id,
        //             //                           branchname: branch.name,
        //             //                           branchlocation: branch.address,
        //             //                           filepath: branch.imageName != null ? branch.imageName! : 'assets/top_image.png',
        //             //                           MobileNumber: branch.mobileNumber,
        //             //                           appointmentId: 0,
        //             //                           // Provide the appointmentId value
        //             //                           screenFrom: "Schedule",
        //             //                         ),
        //             //                       ),
        //             //                     );
        //             //                     //
        //             //                     // Navigator.of(context).push(
        //             //                     //   MaterialPageRoute(builder: (context) => feedback_Screen()),
        //             //                     // );
        //             //                   },
        //             //                   child: Card(
        //             //                     shadowColor: Colors.transparent,
        //             //                     surfaceTintColor: Colors.transparent,
        //             //                     child: ClipRRect(
        //             //                       borderRadius: BorderRadius.only(
        //             //                         topRight: Radius.circular(15.0),
        //             //                         bottomLeft: Radius.circular(15.0),
        //             //                       ),
        //             //                       child: Container(
        //             //                         decoration: BoxDecoration(
        //             //                           gradient: LinearGradient(
        //             //                             colors: [
        //             //                               Color(0xFFFEE7E1), // Start color
        //             //                               Color(0xFFD7DEFA),
        //             //                             ],
        //             //                             begin: Alignment.centerLeft,
        //             //                             end: Alignment.centerRight,
        //             //                           ),
        //             //                         ),
        //             //                         child: Row(
        //             //                           crossAxisAlignment: CrossAxisAlignment.center,
        //             //                           children: [
        //             //                             Padding(
        //             //                               padding: EdgeInsets.only(left: 15.0),
        //             //                               child: Container(
        //             //                                 width: 110,
        //             //                                 height: 65,
        //             //                                 decoration: BoxDecoration(
        //             //                                   borderRadius: BorderRadius.circular(10.0),
        //             //                                   border: Border.all(
        //             //                                     color: Color(0xFF9FA1EE),
        //             //                                     width: 3.0,
        //             //                                   ),
        //             //                                 ),
        //             //                                 child: ClipRRect(
        //             //                                   borderRadius: BorderRadius.circular(7.0),
        //             //                                   child: branch.imageName != null
        //             //                                       ? Image.network(
        //             //                                           branch.imageName!,
        //             //                                           width: 110,
        //             //                                           height: 65,
        //             //                                           fit: BoxFit.fill,
        //             //                                           loadingBuilder: (context, child, loadingProgress) {
        //             //                                             if (loadingProgress == null) return child;
        //             //
        //             //                                             return const Center(child: CircularProgressIndicator.adaptive());
        //             //                                           },
        //             //                                         )
        //             //                                       : Image.asset(
        //             //                                           'assets/top_image.png', // Provide the path to your default image asset
        //             //                                           width: 110,
        //             //                                           height: 65,
        //             //                                           fit: BoxFit.fill,
        //             //                                         ),
        //             //                                 ),
        //             //                               ),
        //             //                             ),
        //             //                             // Padding(
        //             //                             //   padding: EdgeInsets.only(left: 15.0),
        //             //                             //   child: Container(
        //             //                             //     width: 110,
        //             //                             //     height: 65,
        //             //                             //     decoration: BoxDecoration(
        //             //                             //       borderRadius: BorderRadius.circular(10.0),
        //             //                             //       border: Border.all(
        //             //                             //         color: Color(0xFF9FA1EE),
        //             //                             //         width: 3.0,
        //             //                             //       ),
        //             //                             //     ),
        //             //                             //     child: ClipRRect(
        //             //                             //       borderRadius: BorderRadius.circular(7.0),
        //             //                             //       child: isLoading
        //             //                             //           ? Shimmer.fromColors(
        //             //                             //               baseColor: Colors.grey.shade300,
        //             //                             //               highlightColor: Colors.white,
        //             //                             //               child: Container(
        //             //                             //                 width: 110,
        //             //                             //                 height: 65,
        //             //                             //                 decoration: BoxDecoration(
        //             //                             //                   color: Colors.white,
        //             //                             //                   borderRadius: BorderRadius.circular(7.0),
        //             //                             //                 ),
        //             //                             //               ),
        //             //                             //             )
        //             //                             //           : Image.network(
        //             //                             //               imagesflierepo + branch.filePath,
        //             //                             //               width: 110,
        //             //                             //               height: 65,
        //             //                             //               fit: BoxFit.fill,
        //             //                             //             ),
        //             //                             //     ),
        //             //                             //   ),
        //             //                             // ),
        //             //
        //             //                             Expanded(
        //             //                               child: Padding(
        //             //                                 padding: EdgeInsets.only(left: 15.0),
        //             //                                 child: Column(
        //             //                                   mainAxisAlignment: MainAxisAlignment.start,
        //             //                                   crossAxisAlignment: CrossAxisAlignment.start,
        //             //                                   children: [
        //             //                                     Padding(
        //             //                                       padding: EdgeInsets.only(top: 15.0),
        //             //                                       child: Text(
        //             //                                         branch.name,
        //             //                                         style: TextStyle(
        //             //                                           fontSize: 18,
        //             //                                           color: Color(0xFFFB4110),
        //             //                                           fontWeight: FontWeight.bold,
        //             //                                           fontFamily: 'Calibri',
        //             //                                         ),
        //             //                                       ),
        //             //                                     ),
        //             //                                     SizedBox(height: 4.0),
        //             //                                     Expanded(
        //             //                                       child: Padding(
        //             //                                         padding: EdgeInsets.only(right: 10.0),
        //             //                                         child: Column(
        //             //                                           crossAxisAlignment: CrossAxisAlignment.start,
        //             //                                           children: [
        //             //                                             Row(
        //             //                                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             //                                               children: [
        //             //                                                 Image.asset(
        //             //                                                   'assets/location_icon.png',
        //             //                                                   width: 20,
        //             //                                                   height: 18,
        //             //                                                 ),
        //             //                                                 SizedBox(width: 4.0),
        //             //                                                 Expanded(
        //             //                                                   child: Text(
        //             //                                                     branch.address,
        //             //                                                     style: TextStyle(
        //             //                                                       fontFamily: 'Calibri',
        //             //                                                       fontSize: 12,
        //             //                                                       color: Color(0xFF000000),
        //             //                                                     ),
        //             //                                                   ),
        //             //                                                 ),
        //             //                                               ],
        //             //                                             ),
        //             //                                             Spacer(flex: 3),
        //             //                                           ],
        //             //                                         ),
        //             //                                       ),
        //             //                                     ),
        //             //                                     Align(
        //             //                                       alignment: Alignment.bottomRight,
        //             //                                       child: Container(
        //             //                                         height: 26,
        //             //                                         margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
        //             //                                         decoration: BoxDecoration(
        //             //                                           color: Colors.white,
        //             //                                           border: Border.all(
        //             //                                             color: Color(0xFF8d97e2),
        //             //                                           ),
        //             //                                           borderRadius: BorderRadius.circular(10.0),
        //             //                                         ),
        //             //                                         child: ElevatedButton(
        //             //                                           onPressed: () {
        //             //                                             // Handle button press
        //             //                                           },
        //             //                                           style: ElevatedButton.styleFrom(
        //             //                                             primary: Colors.transparent,
        //             //                                             onPrimary: Color(0xFF8d97e2),
        //             //                                             elevation: 0,
        //             //                                             shadowColor: Colors.transparent,
        //             //                                             shape: RoundedRectangleBorder(
        //             //                                               borderRadius: BorderRadius.circular(10.0),
        //             //                                             ),
        //             //                                           ),
        //             //                                           child: GestureDetector(
        //             //                                             onTap: () {
        //             //                                               print('booknowbuttonisclciked');
        //             //                                               print(branch.id);
        //             //                                               print(branch.name);
        //             //                                               Navigator.push(
        //             //                                                 context,
        //             //                                                 MaterialPageRoute(
        //             //                                                   builder: (context) => slotbookingscreen(
        //             //                                                     branchId: branch.id,
        //             //                                                     branchname: branch.name,
        //             //                                                     branchlocation: branch.address,
        //             //                                                     filepath:
        //             //                                                         branch.imageName != null ? branch.imageName! : 'assets/top_image.png',
        //             //                                                     MobileNumber: branch.mobileNumber,
        //             //                                                     appointmentId: 0,
        //             //                                                     // Provide the appointmentId value
        //             //                                                     screenFrom: "Schedule",
        //             //                                                   ),
        //             //                                                 ),
        //             //                                               );
        //             //                                             },
        //             //
        //             //                                             // Handle button press, navigate to a new screen
        //             //
        //             //                                             child: Row(
        //             //                                               mainAxisSize: MainAxisSize.min,
        //             //                                               children: [
        //             //                                                 SvgPicture.asset(
        //             //                                                   'assets/datepicker_icon.svg',
        //             //                                                   width: 15.0,
        //             //                                                   height: 15.0,
        //             //                                                 ),
        //             //                                                 SizedBox(width: 5),
        //             //                                                 Text(
        //             //                                                   'Book Now',
        //             //                                                   style: TextStyle(
        //             //                                                     fontSize: 13,
        //             //                                                     color: Color(0xFF8d97e2),
        //             //                                                   ),
        //             //                                                 ),
        //             //                                               ],
        //             //                                             ),
        //             //                                           ),
        //             //                                         ),
        //             //                                       ),
        //             //                                     ),
        //             //                                   ],
        //             //                                 ),
        //             //                               ),
        //             //                             ),
        //             //                           ],
        //             //                         ),
        //             //                       ),
        //             //                     ),
        //             //                   ),
        //             //                 ),
        //             //               ),
        //             //             ),
        //             //           );
        //             //         }
        //             //       },
        //             //     )),
        //             //
        //             // // width: 300.0,
        //             // Padding(
        //             //   padding: EdgeInsets.only(bottom: 10.0),
        //             //   child: Container(
        //             //     margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        //             //     decoration: BoxDecoration(
        //             //       color: Color(0xFFFFFFFF),
        //             //       border: Border.all(
        //             //         color: Color(0xFFFB4110),
        //             //       ),
        //             //       borderRadius: BorderRadius.circular(10.0),
        //             //     ),
        //             //     child: TextButton(
        //             //       onPressed: () async {
        //             //         const url = 'https://www.hairfixingzone.com/';
        //             //         try {
        //             //           if (await canLaunch(url)) {
        //             //             await launch(url);
        //             //           } else {
        //             //             throw 'Could not launch $url';
        //             //           }
        //             //         } catch (e) {
        //             //           print('Error launching URL: $e');
        //             //         }
        //             //       },
        //             //       style: ButtonStyle(
        //             //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //             //           RoundedRectangleBorder(
        //             //             borderRadius: BorderRadius.circular(10.0),
        //             //           ),
        //             //         ),
        //             //       ),
        //             //       child: Row(
        //             //         crossAxisAlignment: CrossAxisAlignment.center,
        //             //         mainAxisAlignment: MainAxisAlignment.center,
        //             //         children: [
        //             //           Image.asset(
        //             //             'assets/web_icon.png',
        //             //             width: 20,
        //             //             height: 20,
        //             //           ),
        //             //           SizedBox(width: 5),
        //             //           Text(
        //             //             'Click Here for Website',
        //             //             style: TextStyle(
        //             //               fontSize: 18,
        //             //               color: Color(0xFFFB4110),
        //             //             ),
        //             //           ),
        //             //         ],
        //             //       ),
        //             //     ),
        //             //   ),
        //             // )
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
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
                color: _currentIndex == 0 ? CommonUtils.primaryTextColor : Colors.grey,
              ),
              title: const Text(
                'Home',
              ),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: SvgPicture.asset(
                'assets/invite-alt.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 1 ? CommonUtils.primaryTextColor : Colors.grey, // Change color based
              ),
              title: const Text(
                'Bookings',
              ),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: SvgPicture.asset(
                'assets/invite-alt.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 2 ? CommonUtils.primaryTextColor : Colors.grey, // Change color based on selection
              ),
              title: const Text('My Profile'),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: SvgPicture.asset(
                'assets/bin-bottles.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 3 ? CommonUtils.primaryTextColor : Colors.grey, // Change color based on selection
              ),
              title: const Text('Products'),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return '';
      case 1:
        return 'My Bookings';
      case 2:
        return 'My Profile';
      case 3:
        return 'My Products';

      default:
        return 'Home';
    }
  }

  Future<void> onConfirmLogout() async {
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

  void fetchData() async {
    setState(() {
      isLoading = true;
    });

    // Add a timeout of 8 seconds using Future.delayed
    Future.delayed(const Duration(seconds: 15), () {
      if (isLoading) {
        setState(() {
          isLoading = false;
          brancheslist.clear(); // Clear the list if timeout occurs
        });
      }
    });

    await _getData(); // Call your API method
  }

  void fetchimagesslider() async {
    setState(() {
      isLoading = true;
    });

    // Add a timeout of 8 seconds using Future.delayed
    Future.delayed(const Duration(seconds: 15), () {
      if (isLoading) {
        setState(() {
          isLoading = false;
          imageList.clear(); // Clear the list if timeout occurs
        });
      }
    });

    await fetchImages(); // Call your API method
  }

  @override
  void dispose() {
    //  _timer?.cancel();
    super.dispose();
  }

  Future<void> _getData() async {
    setState(() {
      isLoading = true; // Set isLoading to true before making the API call
    });

    final url = Uri.parse(baseUrl + getbranches);
    print('url==>135: $url');

    bool success = false;
    int retries = 0;
    const maxRetries = 1;

    while (!success && retries < maxRetries) {
      try {
        final response = await http.get(url);

        // Check if the request was successful
        if (response.statusCode == 200) {
          // Parse the response body
          final data = json.decode(response.body);

          List<BranchModel> branchList = [];
          for (var item in data['listResult']) {
            branchList.add(BranchModel(
              id: item['id'],
              name: item['name'],
              imageName: item['imageName'],
              address: item['address'],
              startTime: item['startTime'],
              closeTime: item['closeTime'],
              room: item['room'],
              mobileNumber: item['mobileNumber'],
              isActive: item['isActive'],
            ));
          }

          // Update the state with the fetched data
          setState(() {
            brancheslist = branchList;
            isLoading = false; // Set isLoading to false after data is fetched
          });

          success = true;
        } else {
          // Handle error if the API request was not successful
          print('Request failed with status: ${response.statusCode}');
          setState(() {
            isLoading = false; // Set isLoading to false if request fails
          });
        }
      } catch (error) {
        // Handle any exception that occurred during the API call
        print('Error data is not getting from the api: $error');
        setState(() {
          isLoading = false; // Set isLoading to false if error occurs
        });
      }

      retries++;
    }

    if (!success) {
      // Handle the case where all retries failed
      print('All retries failed. Unable to fetch data from the API.');
    }
  }

  Future<void> fetchImages() async {
    setState(() {
      isDataBinding = true; // Set the flag to true when data fetching starts

      isLoading = true; // Set isLoading to true before making the API call
    });

    final url = Uri.parse(baseUrl + getBanners);
    print('url==>127: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        List<BannerImages> bannerImages = [];
        for (var item in jsonData['listResult']) {
          bannerImages.add(BannerImages(imageName: item['imageName'] ?? '', id: item['id'] ?? 0));
        }

        setState(() {
          imageList = bannerImages;
          isDataBinding = false;

          isLoading = false; // Set isLoading to false after completing the API call
        });
      } else {
        // Handle error if the API request was not successful
        print('Request failed with status: ${response.statusCode}');
        setState(() {
          isDataBinding = false;

          isLoading = false; // Set isLoading to false if request fails
        });
      }
    } catch (error) {
      // Handle any exception that occurred during the API call
      print('Error images are not from the api: $error');
      setState(() {
        isDataBinding = false;
        isLoading = false; // Set isLoading to false if error occurs
      });
    }
  }

  void retryDataFetching() {
    // setState(() {
    //   isLoading = true; // Set isLoading to true to show loading indicator
    // });
    // _getData(); // Call your API method to fetch data
    // fetchImages(); // Call your API method to fetch images
    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        print('Connected to the internet');
        //fetchImages();
        // _getData();
        fetchData();
        fetchimagesslider();
      } else {
        CommonUtils.showCustomToastMessageLong('No Internet Connection', context, 1, 4);
        print('Not connected to the internet'); // Not connected to the internet
      }
    });
  }

  Future<void> GetLatestAppointmentByUserId(int? userId) async {
    //  final response = await http.get('http://182.18.157.215/SaloonApp/API/api/Role/GetLatestAppointmentByUserId/1');
    final Uri url = Uri.parse('http://182.18.157.215/SaloonApp/API/api/Role/GetLatestAppointmentByUserId/$userId');
    print('url==>1086: $url');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<LastAppointment> loadedAppointments = [];

      for (var item in jsonData) {
        loadedAppointments.add(LastAppointment.fromJson(item));
      }

      setState(() {
        appointments = loadedAppointments;
        print('Appointment ID: ${appointments.length}');
      });

      // Print each appointment in the logs
      for (var appointment in appointments) {
        print('Appointment ID: ${appointment.id}');
        print('Branch: ${appointment.branch}');
        print('Date: ${appointment.date}');
        print('Customer Name: ${appointment.customerName}');
        print('Slot Time: ${appointment.slotTime}');
        print('Contact Number: ${appointment.contactNumber}');
        print('Email: ${appointment.email}');
        print('Gender: ${appointment.gender}');
        print('Status: ${appointment.status}');
        print('Purpose of Visit: ${appointment.purposeOfVisit}');
        print('Slot Duration: ${appointment.slotDuration}');
        print('Appointment Time: ${appointment.appointmentTime}');
        print('');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showBottomSheet(context, appointments);
        });
      }
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Widget buildIndicator(int index) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == currentIndex ? Colors.orange : Colors.grey,
      ),
    );
  }

  final TextEditingController _commentstexteditcontroller = TextEditingController();
  double rating_star = 0.0;

  void _showBottomSheet(BuildContext context, List<LastAppointment> appointments) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please Rate Your Recent Experience With Us',
                  style: TextStyle(
                    fontSize: 24,
                    color: CommonUtils.primaryTextColor,
                    fontFamily: 'Calibri',
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                const Text(
                  'Rating',
                  style: TextStyle(
                    fontSize: 16,
                    color: CommonUtils.primaryTextColor,
                    fontFamily: 'Calibri',
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: CommonUtils.primaryTextColor,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          rating_star = rating;
                          print('rating_star$rating_star');
                        });
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 0, top: 10.0, right: 0),
                  child: GestureDetector(
                    onTap: () async {},
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: CommonUtils.primaryTextColor, width: 1.5),
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _commentstexteditcontroller,
                        style: const TextStyle(
                          fontFamily: 'Calibri',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                        maxLines: null,
                        maxLength: 256,
                        // Set maxLines to null for multiline input
                        decoration: const InputDecoration(
                          hintText: 'Comments',
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Calibri',
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
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
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            fontFamily: 'Calibri',
                            fontSize: 14,
                            color: CommonUtils.primaryTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              validaterating(appointments);
                            },
                            child: Container(
                              // width: desiredWidth * 0.9,
                              height: 40.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: CommonUtils.primaryTextColor,
                              ),
                              child: const Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontFamily: 'Calibri',
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> validaterating(List<LastAppointment> appointments) async {
    bool isValid = true;
    bool hasValidationFailed = false;
    if (rating_star <= 0.0) {
      CommonUtils.showCustomToastMessageLong('Please Give Rating', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
      FocusScope.of(context).unfocus();
    }

    if (isValid && _commentstexteditcontroller.text.trim().isEmpty) {
      CommonUtils.showCustomToastMessageLong('Please Enter Comments', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
      FocusScope.of(context).unfocus();
    }
    if (isValid) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String? storedEmployeeId = sharedPreferences.getString("employeeId");
      print('employidinfeedback$storedEmployeeId');
      String comments = _commentstexteditcontroller.text.toString();
      int myInt = rating_star.toInt();
      print('changedintoint$myInt');
      AddUpdatefeedback(appointments);
    }
  }

  // Future<void> AddUpdatefeedback(List<LastAppointment> appointments) async {}

  Future<void> AddUpdatefeedback(List<LastAppointment> appointments) async {
    final url = Uri.parse(baseUrl + postApiAppointment);
    print('url==>890: $url');
    DateTime now = DateTime.now();
    String dateTimeString = now.toString();
    print('DateTime as String: $dateTimeString');

    for (LastAppointment appointment in appointments) {
      // Create the request object for each appointment
      final request = {
        "Id": appointment.id,
        "BranchId": appointment.branchId,
        "Date": appointment.date,
        "SlotTime": appointment.slotTime,
        "CustomerName": appointment.customerName,
        "PhoneNumber": appointment.contactNumber, // Changed from appointments.phoneNumber
        "Email": appointment.email,
        "GenderTypeId": appointment.genderTypeId,
        "StatusTypeId": 11,
        "PurposeOfVisitId": appointment.purposeOfVisitId,
        "PurposeOfVisit": appointment.purposeOfVisit,
        "IsActive": true,
        "CreatedDate": dateTimeString,
        "UpdatedDate": dateTimeString,
        "UpdatedByUserId": null,
        "rating": rating_star,
        "review": _commentstexteditcontroller.text.toString(),
        "reviewSubmittedDate": dateTimeString,
        "timeofslot": null,
        "customerId": userId
      };
      print('AddUpdatefeedback object: : ${json.encode(request)}');

      try {
        // Send the POST request for each appointment
        final response = await http.post(
          url,
          body: json.encode(request),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          print('Request sent successfully');
          Navigator.pop(context);
        } else {
          print('Failed to send the request. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Widget _buildScreens(int index) {
    switch (index) {
      case 0:
        return const Dashboard_Screen();

      case 1:
        // Return the messages screen widget
        return const MyAppointments();

      case 2:
        // Return the settings screen widget
        return Profile();
      case 3:
        // Return the settings screen widget
        return const MyProducts();

      default:
        return const Dashboard_Screen();
    }
  }
}

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
