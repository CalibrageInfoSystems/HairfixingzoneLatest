import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hairfixingzone/slotbookingscreen.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'BranchModel.dart';
import 'Commonutils.dart';
import 'MyAppointment_Model.dart';
import 'api_config.dart';

class MyAppointments extends StatefulWidget {
  const MyAppointments({super.key});

  @override
  MyAppointments_screenState createState() => MyAppointments_screenState();
}

class MyAppointments_screenState extends State<MyAppointments> {
  String accessToken = '';
  String empolyeid = '';
  String todate = "";
  final TextEditingController _commentstexteditcontroller =
  TextEditingController();
  double rating_star = 0.0;
  int? userId;
  List<BranchModel> brancheslist = [];

  bool isLoading = true;
  List<MyAppointment_Model> MyAppointmentList = [];
  List<UserFeedback> userfeedbacklist = [];
  late Future<List<MyAppointment_Model>> apiData;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        print('The Internet Is Connected');
        checkLoginuserdata();
        // fetchMyAppointments(userId);
        getbranchedata();
      } else {
        print('The Internet Is not  Connected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        refreshTheScreen();
      },
      child: Scaffold(
        appBar: _appBar(),
        body: FutureBuilder(
          future: apiData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'No appointments found!',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Roboto",
                  ),
                ),
              );
            } else {
              if (snapshot.hasData) {
                List<MyAppointment_Model> data = snapshot.data!;
                return _appointments(data);
              } else {
                return const Center(
                  child: Text(
                    'No appointmens available',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto",
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Color _getStatusBorderColor(String status) {
    switch (status) {
    // Orange border for 'Pending' status
      case 'Accepted':
        return Colors.green.shade600;
      case 'Declined':
        return Colors.red;
      case 'Submited':
        return Colors.lightBlueAccent;
    // Add more cases for other statuses if needed
      default:
        return Colors.orange; // Red border for other statuses
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green.shade600;
      case 'Rejected':
        return Colors.red;

      default:
        return Colors.red;
    }
  }

  void checkLoginuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    print('userId: : $userId');
    apiData = fetchMyAppointments(userId);
  }

  Future<List<MyAppointment_Model>> fetchMyAppointments(int? userId) async {
    final url = Uri.parse(
        'http://182.18.157.215/SaloonApp/API/api/Appointment/GetAppointmentByUserid');

    try {
      final request = {
        "userid": userId,
        "branchId": null,
        "fromdate": null,
        "toDate": null
      };
      print('GetAppointmentByUserid: ${json.encode(request)}');

      final jsonResponse = await http.post(
        url,
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (jsonResponse.statusCode == 200) {
        final response = json.decode(jsonResponse.body);

        if (response['listResult'] != null) {
          List<dynamic> listResult = response['listResult'];
          List<MyAppointment_Model> result = listResult
              .map((item) => MyAppointment_Model.fromJson(item))
              .toList();
          return result;
        } else {
          throw Exception('No appointments found!');
        }
      } else {
        print('Request failed with status: ${jsonResponse.statusCode}');
        throw Exception(
            'Request failed with status: ${jsonResponse.statusCode}');
      }
    } catch (error) {
      print('catch: $error');
      rethrow;
    }
  }

  void ShowAlertdialog(MyAppointment_Model appointments, int index) {
    print('indexof listview$index');
    _commentstexteditcontroller.clear();
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              title: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,

                  //     height: MediaQuery.of(context).size.height,
                  //   color: Colors.white,
                  padding: const EdgeInsets.only(
                      top: 15.0, left: 15.0, right: 15.0, bottom: 20.0),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFd7defa),
                        Color(0xFFfee7e1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Feedback',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFFf15f22),
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
                          color: Color(0xFFf15f22),
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
                            itemPadding:
                            const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                rating_star = rating;
                                print('rating_star$rating_star');
                              });
                            },
                          )),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 0, top: 10.0, right: 0),
                        child: GestureDetector(
                          onTap: () async {},
                          child: Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xFFf15f22), width: 1.5),
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
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 0.0, right: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.grey,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Calibri'),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                validaterating(appointments, index);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFFf15f22),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Calibri'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Padding(
                      //       padding: EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0),
                      //       child: Container(
                      //         width: MediaQuery.of(context).size.width / 3.80,
                      //         decoration: BoxDecoration(
                      //           color: Color(0xFFf15f22),
                      //           borderRadius: BorderRadius.circular(6.0),
                      //         ),
                      //         child: ElevatedButton(
                      //           onPressed: () {
                      //             validaterating(appointments, index);
                      //           },
                      //           child: Text(
                      //             'Submit',
                      //             style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Calibri'),
                      //           ),
                      //           style: ElevatedButton.styleFrom(
                      //             foregroundColor: Colors.transparent,
                      //             elevation: 0,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(4.0),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 10,
                      //     ),
                      //     Padding(
                      //       padding: EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0),
                      //       child: Container(
                      //         width: MediaQuery.of(context).size.width / 3.80,
                      //         decoration: BoxDecoration(
                      //           color: Color(0xFFf15f22),
                      //           borderRadius: BorderRadius.circular(6.0),
                      //         ),
                      //         child: ElevatedButton(
                      //           onPressed: () {
                      //
                      //          Navigator.of(context).pop();
                      //           },
                      //           child: Text(
                      //             'Cancel',
                      //             style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Calibri'),
                      //           ),
                      //           style: ElevatedButton.styleFrom(
                      //             foregroundColor: Colors.transparent,
                      //             elevation: 0,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(4.0),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
              // actions: [
              //   ElevatedButton(
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //     child: Text(
              //       'Ok',
              //       style: TextStyle(color: Colors.white, fontFamily: 'Calibri'), // Set text color to white
              //     ),
              //     style: ElevatedButton.styleFrom(
              //       foregroundColor: Color(0xFFf15f22), // Change to your desired background color
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(5), // Set border radius
              //       ),
              //     ),
              //   ),
              // ],
            );
          },
        );
      },
    );
  }

  Future<void> validaterating(
      MyAppointment_Model appointmens, int index) async {
    print('indexinvalidating$index');
    bool isValid = true;
    bool hasValidationFailed = false;
    int myInt = rating_star.toInt();
    print('changedintoint$myInt');
    if (rating_star <= 0.0) {
      FocusScope.of(context).unfocus();
      CommonUtils.showCustomToastMessageLong(
          'Please Give Rating', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }

    if (isValid && _commentstexteditcontroller.text.trim().isEmpty) {
      FocusScope.of(context).unfocus();
      CommonUtils.showCustomToastMessageLong(
          'Please Enter Comments', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }
    if (isValid) {
      final url = Uri.parse(baseUrl + postApiAppointment);
      print('url==>890: $url');
      DateTime now = DateTime.now();
      String dateTimeString = now.toString();
      print('DateTime as String: $dateTimeString');

      //  for (MyAppointment_Model appointment in appointmens) {
      // Create the request object for each appointment
      final request = {
        "Id": appointmens.id,
        "BranchId": appointmens.branchId,
        "Date": appointmens.date,
        "SlotTime": appointmens.slotTime,
        "CustomerName": appointmens.customerName,
        "PhoneNumber":
        appointmens.contactNumber, // Changed from appointments.phoneNumber
        "Email": appointmens.email,
        "GenderTypeId": appointmens.genderTypeId,
        "StatusTypeId": 11,
        "PurposeOfVisitId": appointmens.purposeOfVisitId,
        "PurposeOfVisit": appointmens.purposeOfVisit,
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
          fetchMyAppointments(userId);
          CommonUtils.showCustomToastMessageLong(
              'Feedback Successfully Submited', context, 0, 4);

          if (index >= 0.0 && index < userfeedbacklist.length) {
            // Ensure index is within the valid range
            userfeedbacklist[index].ratingstar = rating_star;
            userfeedbacklist[index].comments =
                _commentstexteditcontroller.text.toString();

            print(
                'rating_starapi${userfeedbacklist[index].ratingstar}  comments${userfeedbacklist[index].comments}');

            Navigator.pop(context);
          } else {
            print('Invalid index: $index');
          }
          // _printAppointments();
          // userfeedbacklist[index].ratingstar = rating_star;
          // userfeedbacklist[index].comments = _commentstexteditcontroller.text.toString();

          Navigator.pop(context);
        } else {
          print(
              'Failed to send the request. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error while sending : $e');
      }
      //  }
    }
  }

  void conformation(MyAppointment_Model appointments, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to Cancel?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                CancelAppointment(appointments, index);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> CancelAppointment(
      MyAppointment_Model appointmens, int index) async {
    final url = Uri.parse(baseUrl + postApiAppointment);
    print('url==>890: $url');
    DateTime now = DateTime.now();
    String dateTimeString = now.toString();
    print('DateTime as String: $dateTimeString');

    //  for (MyAppointment_Model appointment in appointmens) {
    // Create the request object for each appointment
    final request = {
      "Id": appointmens.id,
      "BranchId": appointmens.branchId,
      "Date": appointmens.date,
      "SlotTime": appointmens.slotTime,
      "CustomerName": appointmens.customerName,
      "PhoneNumber":
      appointmens.contactNumber, // Changed from appointments.phoneNumber
      "Email": appointmens.email,
      "GenderTypeId": appointmens.genderTypeId,
      "StatusTypeId": 6,
      "PurposeOfVisitId": appointmens.purposeOfVisitId,
      "PurposeOfVisit": appointmens.purposeOfVisit,
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
        Map<String, dynamic> data = json.decode(response.body);

        // Extract the necessary information
        bool isSuccess = data['isSuccess'];
        if (isSuccess == true) {
          print('Request sent successfully');
          fetchMyAppointments(userId);
          CommonUtils.showCustomToastMessageLong(
              'Cancelled  Successfully ', context, 0, 4);
;
       //   Navigator.pop(context);
          // Success case
          // Handle success scenario here
        } else {
          // Failure case
          // Handle failure scenario here
          CommonUtils.showCustomToastMessageLong(
              'The request should not be canceled within 30 minutes before slot',
              context,
              0,
              2);
        }
      } else {
        //showCustomToastMessageLong(
        // 'Failed to send the request', context, 1, 2);
        print(
            'Failed to send the request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while sending : $e');
    }
    //  }
  }

  void showBranchesDialog(BuildContext context, MyAppointment_Model appointment_model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Branch'),
          content: SizedBox(
              width: double.maxFinite,
              height: 400, // Adjust the height as needed
              child: brancheslist.isEmpty // Check if brancheslist is empty
                  ? Center(child: CircularProgressIndicator()) // Show a loading indicator if brancheslist is empty
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: brancheslist.length,
                itemBuilder: (context, index) {
                  BranchModel branch = brancheslist[index];

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
                    child: IntrinsicHeight(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15.0),
                          bottomLeft: Radius.circular(15.0),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  slotbookingscreen(
                                  branchId: branch.id, branchname: branch.name,  branchlocation: branch.address,
                                  filepath: branch.imageName != null ?  branch.imageName! : 'assets/top_image.png', MobileNumber: branch.mobileNumber,
                                  appointmentId: appointment_model.id, // Provide the appointmentId value
                                  screenFrom: "ReSchedule",
                                ) ,
                              ),
                            );
                            Navigator.of(context).pop();
                            //
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(builder: (context) => feedback_Screen()),
                            // );

                          },
                          child: Card(
                            shadowColor: Colors.transparent,
                            surfaceTintColor: Colors.transparent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFEE7E1), // Start color
                                      Color(0xFFD7DEFA),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: Container(
                                        width: 80,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: Color(0xFF9FA1EE),
                                            width: 3.0,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(7.0),
                                          child: branch.imageName != null
                                              ? Image.network(
                                            branch.imageName!,
                                            width: 80,
                                            height: 50,
                                            fit: BoxFit.fill,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;

                                              return const Center(child: CircularProgressIndicator.adaptive());
                                            },
                                          )
                                              : Image.asset(
                                            'assets/top_image.png', // Provide the path to your default image asset
                                            width: 110,
                                            height: 65,
                                            fit: BoxFit.fill,
                                          ),

                                        ),
                                      ),
                                    ),


                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 15.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 15.0),
                                              child: Text(
                                                branch.name,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xFFFB4110),
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Calibri',
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 4.0),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(right: 10.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Image.asset(
                                                          'assets/location_icon.png',
                                                          width: 20,
                                                          height: 18,
                                                        ),
                                                        SizedBox(width: 4.0),
                                                        Expanded(
                                                          child: Text(
                                                            branch.address,
                                                            style: TextStyle(
                                                              fontFamily: 'Calibri',
                                                              fontSize: 12,
                                                              color: Color(0xFF000000),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(flex: 3),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                height: 26,
                                                margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Color(0xFF8d97e2),
                                                  ),
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // Handle button press
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Colors.transparent,
                                                    onPrimary: Color(0xFF8d97e2),
                                                    elevation: 0,
                                                    shadowColor: Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print('booknowbuttonisclciked');
                                                      print(branch.id);
                                                      print(branch.name);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>  slotbookingscreen(
                                                            branchId: branch.id, branchname: branch.name,  branchlocation: branch.address,
                                                            filepath: branch.imageName != null ?  branch.imageName! : 'assets/top_image.png', MobileNumber: branch.mobileNumber, appointmentId: appointment_model.id, // Provide the appointmentId value
                                                            screenFrom: "ReSchedule",) ,
                                                        ),
                                                      );

                                                      Navigator.of(context).pop();
                                                    },


                                                    // Handle button press, navigate to a new screen

                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/datepicker_icon.svg',
                                                          width: 15.0,
                                                          height: 15.0,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          'Book Now',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Color(0xFF8d97e2),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );

                },
              )
          ),
        );
      },
    );
  }
  Future<void> getbranchedata() async {
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

  bool isPastDate(String selectedDate, String time) {
    final now = DateTime.now();
    // DateTime currentTime = DateTime.now();
    //  print('currentTime: $currentTime');
    //   int hours = currentTime.hour;
    //  print('current hours: $hours');
    // Format the time using a specific pattern with AM/PM
    String formattedTime = DateFormat('hh:mm a').format(now);

    final selectedDateTime = DateTime.parse(selectedDate);
    final currentDate = DateTime(now.year, now.month, now.day);

    // Agent login chey

    bool isBeforeTime = false; // Assume initial value as true
    bool isBeforeDate = selectedDateTime.isBefore(currentDate);
    // Parse the desired time for comparison
    DateTime desiredTime = DateFormat('hh:mm a').parse(time);
    // Parse the current time for comparison
    DateTime currentTime = DateFormat('hh:mm a').parse(formattedTime);

    if (selectedDateTime == currentDate) {
      int comparison = currentTime.compareTo(desiredTime);
      print('comparison$comparison');
      // Print the comparison result
      if (comparison < 0) {
        isBeforeTime = false;
        print('The current time is earlier than 10:15 AM.');
      } else if (comparison > 0) {
        isBeforeTime = true;
      } else {
        isBeforeTime = true;
      }

      //  isBeforeTime = hours >= time;
    }

    print('isBeforeTime: $isBeforeTime');
    print('isBeforeDate: $isBeforeDate');
    return isBeforeTime || isBeforeDate;
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFf15f22),
      title: const Text(
        'My Appointments',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _appointments(List<MyAppointment_Model> data) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 10,
        right: 10,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          MyAppointment_Model appointmentModel = data[index];
          final borderColor = _getStatusBorderColor(appointmentModel.status);
          final isEvenItem = index % 2 == 0;
          DateTime dateObj = DateTime.parse(appointmentModel.date);
          String formattedDate = DateFormat('dd MMMM, yyyy').format(dateObj);
          String review;
          if (appointmentModel.review != null) {
            review = appointmentModel.review!;
          } else {
            review = '';
          }
          double ratingffromapi;
          if (appointmentModel.rating != null) {
            ratingffromapi = appointmentModel.rating!;
          } else {
            ratingffromapi = 0.0;
          }
          BoxDecoration boxDecoration;
          if (appointmentModel.statusTypeId == 4) {
            boxDecoration = isEvenItem
                ? BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFfee7e1),
                    Color(0xFFd7defa),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ))
                : BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFd7defa),
                    Color(0xFFfee7e1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ));

            return GestureDetector(
              onTap: () {
                print('CardView clicked!');
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ),
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                      )),
                  child: Container(
                    padding: const EdgeInsets.only(
                        bottom: 10, top: 5, left: 0, right: 0),
                    decoration: boxDecoration,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListTile(
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   'Branch Name',
                                //   style: TextStyle(color: Color(0xFFF44614), fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                // ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  //   height: MediaQuery.of(context).size.height,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    appointmentModel.branch,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 7,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    'Slot Time',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                  // Icon(
                                                  //   Icons.lock_clock,
                                                  //   size: 16,
                                                  //   color: Color(0xFFF44614),
                                                  // ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    ' : ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 12,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    appointmentModel
                                                        .slotDuration,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF042DE3),
                                                        fontSize: 12,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    'Purpose ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 10,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    appointmentModel
                                                        .purposeOfVisit,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF042DE3),
                                                        fontSize: 12,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //Spacer(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Text(
                                            'Date',
                                            style: TextStyle(
                                                color: Color(0xFFF44614),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Calibri'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 0,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Text(
                                            ': ',
                                            style: TextStyle(
                                                color: Color(0xFFF44614),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Calibri'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          child: Text(
                                            formattedDate,
                                            style: const TextStyle(
                                                color: Color(0xFF042DE3),
                                                fontSize: 12,
                                                fontFamily: 'Calibri'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Text(
                                            'Status',
                                            style: TextStyle(
                                                color: Color(0xFFF44614),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Calibri'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 0,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Text(
                                            ': ',
                                            style: TextStyle(
                                                color: Color(0xFFF44614),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Calibri'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          child: Text(
                                            appointmentModel.status,
                                            style: const TextStyle(
                                                color: Color(0xFF042DE3),
                                                fontSize: 12,
                                                fontFamily: 'Calibri'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
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
          } else if (appointmentModel.statusTypeId == 5) {
            // Customize UI for statusTypeId 2
            boxDecoration = isEvenItem
                ? BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFfee7e1),
                    Color(0xFFd7defa),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ))
                : BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFd7defa),
                    Color(0xFFfee7e1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ));

            return GestureDetector(
              onTap: () {
                print('CardView clicked!');
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ),
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                      )),
                  child: Container(
                    padding: const EdgeInsets.only(
                        bottom: 10, top: 5, left: 0, right: 0),
                    decoration: boxDecoration,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListTile(
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   'Branch Name',
                                //   style: TextStyle(color: Color(0xFFF44614), fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                // ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  //   height: MediaQuery.of(context).size.height,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    appointmentModel.branch,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 7,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    'Slot Time',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                  // Icon(
                                                  //   Icons.lock_clock,
                                                  //   size: 16,
                                                  //   color: Color(0xFFF44614),
                                                  // ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    ' : ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 12,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    appointmentModel
                                                        .slotDuration,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF042DE3),
                                                        fontSize: 12,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    'Purpose ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 10,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    appointmentModel
                                                        .purposeOfVisit,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF042DE3),
                                                        fontSize: 12,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    'Date',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 10,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    formattedDate,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF042DE3),
                                                        fontSize: 12,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    'Status',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 10,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    appointmentModel.status,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF042DE3),
                                                        fontSize: 12,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //Spacer(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width:
                                130, // Ensure buttons take up the full width of the container
                                child: ElevatedButton(
                                  onPressed: isPastDate(appointmentModel.date,
                                      appointmentModel.slotDuration)
                                      ? null // Disable the button if slotDuration is before the current time
                                      : () {
                                    getbranchedata();
                                    showBranchesDialog(context,
                                        appointmentModel); // Call the function to show branches dialog
                                    print('Reschedule');
                                  },
                                  style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return Colors
                                              .grey; // Set the text color to gray when disabled
                                        }
                                        return Colors
                                            .green; // Use the default text color for enabled state
                                      },
                                    ),
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return Colors.grey.withOpacity(
                                              0.5); // Set the background color to gray with opacity when disabled
                                        }
                                        return Colors
                                            .white; // Use the default background color for enabled state
                                      },
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(25.0),
                                        side: const BorderSide(
                                            color: Colors.green, width: 2.0),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/rescheduling.svg',
                                        width: 24,
                                        height: 24,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text('Reschedule'),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width:
                                130, // Ensure buttons take up the full width of the container
                                child: ElevatedButton(
                                  onPressed: isPastDate(appointmentModel.date,
                                      appointmentModel.slotDuration)
                                      ? null // Disable the button if slotDuration is before the current time
                                      : () {
                                    conformation(appointmentModel, index);
                                    print('rejectedbuttonisclciked');
                                    print('Reschedule');
                                  },
                                  style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return Colors
                                              .grey; // Set the text color to gray when disabled
                                        }
                                        return const Color(
                                            0xFFF44614); // Use the default text color for enabled state
                                      },
                                    ),
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return Colors.grey.withOpacity(
                                              0.5); // Set the background color to gray with opacity when disabled
                                        }
                                        return Colors
                                            .white; // Use the default background color for enabled state
                                      },
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(25.0),
                                        side: const BorderSide(
                                            color: Color(0xFFF44614),
                                            width: 2.0),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/close.svg',
                                        width: 24,
                                        height: 24,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text('Cancel'),
                                    ],
                                  ),
                                ),
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
          } else if (appointmentModel.statusTypeId == 6) {
            boxDecoration = isEvenItem
                ? BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFfee7e1),
                    Color(0xFFd7defa),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ))
                : BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFd7defa),
                    Color(0xFFfee7e1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ));

            return GestureDetector(
              onTap: () {
                print('CardView clicked!');
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ),
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                      )),
                  child: Container(
                    padding: const EdgeInsets.only(
                        bottom: 10, top: 5, left: 0, right: 0),
                    decoration: boxDecoration,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListTile(
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   'Branch Name',
                                //   style: TextStyle(color: Color(0xFFF44614), fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                // ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  //   height: MediaQuery.of(context).size.height,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    appointmentModel.branch,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 7,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    'Slot Time',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                  // Icon(
                                                  //   Icons.lock_clock,
                                                  //   size: 16,
                                                  //   color: Color(0xFFF44614),
                                                  // ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    ' : ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 12,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    appointmentModel
                                                        .slotDuration,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF042DE3),
                                                        fontSize: 12,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    'Purpose ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 10,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    appointmentModel
                                                        .purposeOfVisit,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF042DE3),
                                                        fontSize: 12,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //Spacer(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Text(
                                            'Date',
                                            style: TextStyle(
                                                color: Color(0xFFF44614),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Calibri'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 0,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Text(
                                            ': ',
                                            style: TextStyle(
                                                color: Color(0xFFF44614),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Calibri'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          child: Text(
                                            formattedDate,
                                            style: const TextStyle(
                                                color: Color(0xFF042DE3),
                                                fontSize: 12,
                                                fontFamily: 'Calibri'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Text(
                                            'Status',
                                            style: TextStyle(
                                                color: Color(0xFFF44614),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Calibri'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 0,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Text(
                                            ': ',
                                            style: TextStyle(
                                                color: Color(0xFFF44614),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Calibri'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          child: Text(
                                            appointmentModel.status,
                                            style: const TextStyle(
                                                color: Color(0xFF042DE3),
                                                fontSize: 12,
                                                fontFamily: 'Calibri'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
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
          } else if (appointmentModel.statusTypeId == 18) {
            // Customize UI for statusTypeId 2
            boxDecoration = isEvenItem
                ? BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFfee7e1),
                    Color(0xFFd7defa),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ))
                : BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFd7defa),
                    Color(0xFFfee7e1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ));

            return GestureDetector(
              onTap: () {
                print('CardView clicked!');
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ),
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                      )),
                  child: Container(
                    padding: const EdgeInsets.only(
                        bottom: 10, top: 5, left: 0, right: 0),
                    decoration: boxDecoration,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListTile(
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   'Branch Name',
                                //   style: TextStyle(color: Color(0xFFF44614), fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                // ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  //   height: MediaQuery.of(context).size.height,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    appointmentModel.branch,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 7,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    'Slot Time',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                  // Icon(
                                                  //   Icons.lock_clock,
                                                  //   size: 16,
                                                  //   color: Color(0xFFF44614),
                                                  // ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    ' : ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 12,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    appointmentModel
                                                        .slotDuration,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF042DE3),
                                                        fontSize: 12,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    'Purpose ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 10,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    appointmentModel
                                                        .purposeOfVisit,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF042DE3),
                                                        fontSize: 12,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    'Date',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 10,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    formattedDate,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF042DE3),
                                                        fontSize: 12,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    'Status',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFFF44614),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 10,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text(
                                                    appointmentModel.status,
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xFF042DE3),
                                                        fontSize: 12,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //Spacer(),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width:
                                130, // Ensure buttons take up the full width of the container
                                child: ElevatedButton(
                                  onPressed: appointmentModel.statusTypeId ==
                                      18 // Provide a valid condition here
                                      ? () {
                                    ShowAlertdialog(appointmentModel,
                                        index); // Call the function to show branches dialog
                                    //  conformation(appointment_model, index);
                                    // Handle reject button action
                                    print('Rate Us');
                                  }
                                      : null,
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(25.0),
                                        side: const BorderSide(
                                            color: Colors.green, width: 2.0),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return Colors.grey.withOpacity(
                                              0.5); // Set the background color to gray with opacity when disabled
                                        }
                                        return Colors
                                            .white; // Use the default background color for enabled state
                                      },
                                    ),
                                    foregroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return Colors
                                              .grey; // Set the text color to gray when disabled
                                        }
                                        return Colors
                                            .green; // Use the default text color for enabled state
                                      },
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/rate.svg', // Replace 'your_image.svg' with the path to your SVG image asset
                                        width: 24, // Adjust width as needed
                                        height: 24, // Adjust height as needed
                                      ),
                                      const SizedBox(
                                          width:
                                          5), // Add some space between the image and text
                                      const Text('Rate Us'),
                                    ],
                                  ),
                                ),
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
          } else {
            boxDecoration = isEvenItem
                ? BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFfee7e1),
                    Color(0xFFd7defa),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ))
                : BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFd7defa),
                    Color(0xFFfee7e1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ));

            return GestureDetector(
              onTap: () {
                print('CardView clicked!');
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ),
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                      )),
                  child: Container(
                    padding: const EdgeInsets.only(
                        bottom: 10, top: 5, left: 0, right: 0),
                    decoration: boxDecoration,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListTile(
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width:
                                      MediaQuery.of(context).size.width / 2,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0, 0),
                                                      child: Text(
                                                        appointmentModel.branch,
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFFF44614),
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontFamily:
                                                            'Calibri'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Expanded(
                                                flex: 7,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.fromLTRB(
                                                          0, 0, 0, 0),
                                                      child: Text(
                                                        'Slot Time',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFF44614),
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontFamily:
                                                            'Calibri'),
                                                      ),
                                                      // Icon(
                                                      //   Icons.lock_clock,
                                                      //   size: 16,
                                                      //   color: Color(0xFFF44614),
                                                      // ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Expanded(
                                                flex: 0,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.fromLTRB(
                                                          0, 0, 0, 0),
                                                      child: Text(
                                                        ' : ',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFF44614),
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontFamily:
                                                            'Calibri'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 12,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0, 0),
                                                      child: Text(
                                                        appointmentModel
                                                            .slotDuration,
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF042DE3),
                                                            fontSize: 12,
                                                            fontFamily:
                                                            'Calibri'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Expanded(
                                                flex: 6,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.fromLTRB(
                                                          0, 0, 0, 0),
                                                      child: Text(
                                                        'Purpose ',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFF44614),
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontFamily:
                                                            'Calibri'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Expanded(
                                                flex: 0,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.fromLTRB(
                                                          0, 0, 0, 0),
                                                      child: Text(
                                                        ': ',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFF44614),
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontFamily:
                                                            'Calibri'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 10,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0, 0),
                                                      child: Text(
                                                        appointmentModel
                                                            .purposeOfVisit,
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF042DE3),
                                                            fontSize: 12,
                                                            fontFamily:
                                                            'Calibri'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.25,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: Text(
                                                'Date',
                                                style: TextStyle(
                                                    color: Color(0xFFF44614),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Calibri'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 0,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: Text(
                                                ': ',
                                                style: TextStyle(
                                                    color: Color(0xFFF44614),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Calibri'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: Text(
                                                formattedDate,
                                                style: const TextStyle(
                                                    color: Color(0xFF042DE3),
                                                    fontSize: 12,
                                                    fontFamily: 'Calibri'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: Text(
                                                'Status',
                                                style: TextStyle(
                                                    color: Color(0xFFF44614),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Calibri'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 0,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: Text(
                                                ': ',
                                                style: TextStyle(
                                                    color: Color(0xFFF44614),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Calibri'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: Text(
                                                appointmentModel.status,
                                                style: const TextStyle(
                                                    color: Color(0xFF042DE3),
                                                    fontSize: 12,
                                                    fontFamily: 'Calibri'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(
                              flex: 6,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Rating',
                                      style: TextStyle(
                                        color: Color(0xFFF44614),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Calibri',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text(
                                      ': ',
                                      style: TextStyle(
                                          color: Color(0xFFF44614),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Calibri'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RatingBar.builder(
                                    //     initialRating: ratingffromapi,
                                      initialRating: ratingffromapi,
                                      minRating: 0,
                                      itemSize: 15.0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 1.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {})
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(
                              flex: 6,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left:
                                    15.0), // Add left padding to the Feedback text
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Feedback',
                                      style: TextStyle(
                                        color: Color(0xFFF44614),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Calibri',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    ': ',
                                    style: TextStyle(
                                      color: Color(0xFFF44614),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Calibri',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text(
                                      review,
                                      style: const TextStyle(
                                        color: Color(0xFF042DE3),
                                        fontSize: 12,
                                        fontFamily: 'Calibri',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void refreshTheScreen() {
    CommonUtils.checkInternetConnectivity().then(
          (isConnected) {
        if (isConnected) {
          print('The Internet Is Connected');

          try {
            // reload the data
            checkLoginuserdata();
            setState(() {});
          } catch (error) {
            print('catch: $error');
            rethrow;
          }
        } else {
          CommonUtils.showCustomToastMessageLong(
              'Please check your internet  connection', context, 1, 4);
          print('The Internet Is not  Connected');
        }
      },
    );
  }
}

class UserFeedback {
  double? ratingstar;
  String comments;

  UserFeedback({required this.ratingstar, required this.comments});
}
