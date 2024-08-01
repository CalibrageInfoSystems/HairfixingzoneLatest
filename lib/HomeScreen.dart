import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
  const HomeScreen({super.key});

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
              selectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w500,fontSize: 16,color: Color(0xFF11528f)),
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
      getLatestAppointmentByUserId(userId);
      print('userFullName: $userFullName');
      print('gender:$Gender');

    });
  }

  Future<void> getLatestAppointmentByUserId(int? userId) async {
    //  final response = await http.get('http://182.18.157.215/SaloonApp/API/api/Role/GetLatestAppointmentByUserId/1');
    final Uri url = Uri.parse(
        'http://182.18.157.215/SaloonApp/API/api/Role/GetLatestAppointmentByUserId/$userId');
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
        print('xxx: here');
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _showBottomSheet(context, appointments);
        });
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   _showBottomSheet(context, appointments);
        // });
      }
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  void _showBottomSheet(
      BuildContext context, List<LastAppointment> appointments) {
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
                    fontSize: 20,
                    color: CommonUtils.primaryTextColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Outfit',

                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Service Rating',
                      style: TextStyle(
                        fontSize: 16,
                        color: CommonUtils.primaryTextColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    const SizedBox(width: 10),
                    RatingBar.builder(
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
                          ratingStar = rating;
                          print('ratingStar $ratingStar');
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Quality Rating',
                      style: TextStyle(
                        fontSize: 16,
                        color: CommonUtils.primaryTextColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    const SizedBox(width: 10),
                    RatingBar.builder(
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
                          qualityRating = rating;
                          print('Qul_rating_star $qualityRating');
                        });
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0, top: 10.0, right: 0),
                  child: GestureDetector(
                    onTap: () async {},
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: CommonUtils.primaryTextColor, width: 1.5),
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _commentstexteditcontroller,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                        maxLines: null,
                        maxLength: 250,
                        // Set maxLines to null for multiline input
                        decoration: const InputDecoration(
                          hintText: 'Comment',
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
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
                const SizedBox(
                  height: 10,
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
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            fontFamily: 'Outfit',
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
                                borderRadius: BorderRadius.circular(5.0),
                                color: CommonUtils.primaryTextColor,
                              ),
                              child: const Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
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
    if (isValid && ratingStar <= 0.0) {
      CommonUtils.showCustomToastMessageLong(
          'Please Rate Your Experience', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
      FocusScope.of(context).unfocus();
    }

    if (isValid && qualityRating <= 0.0) {
      FocusScope.of(context).unfocus();
      CommonUtils.showCustomToastMessageLong(
          'Please Rate Your Experience with Quality', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }


    if (isValid) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? storedEmployeeId = sharedPreferences.getString("employeeId");
      print('employidinfeedback$storedEmployeeId');
      String comments = _commentstexteditcontroller.text.toString();
      int myInt = ratingStar.toInt();
      print('changedintoint$myInt');
      addUpdatefeedback(appointments);
    }
  }

  Future<void> addUpdatefeedback(List<LastAppointment> appointments) async {
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
        "PhoneNumber":
            appointment.contactNumber, // Changed from appointments.phoneNumber
        "Email": appointment.email,
        "GenderTypeId": appointment.genderTypeId,
        "StatusTypeId": 17,
        "PurposeOfVisitId": appointment.purposeOfVisitId,
        "PurposeOfVisit": appointment.purposeOfVisit,
        "IsActive": true,
        "CreatedDate": dateTimeString,
        "UpdatedDate": dateTimeString,
        "UpdatedByUserId": null,
        "rating": ratingStar,
        "review": _commentstexteditcontroller.text.toString(),
        "reviewSubmittedDate": dateTimeString,
        "timeofslot": null,
        "customerId": userId,
        "paymentTypeId": null,
        "qualityRating": qualityRating,
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
          CommonUtils.showCustomToastMessageLong(
              'Feedback Successfully Submitted', context, 0, 4);
          print('Request sent successfully');
          Navigator.pop(context);
        } else {
          print(
              'Failed to send the request. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
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
          style: GoogleFonts.outfit(fontWeight: FontWeight.w500,fontSize: 22,color: Colors.black),
        );

      case 2:
        return Text(
          'Profile',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w500,fontSize: 22,color: Colors.black),
        );



      default:
        return Text(
          'default',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w500,fontSize: 22,color: Colors.black),
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
              longitude: value.longitude,
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
