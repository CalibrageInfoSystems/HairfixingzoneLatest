import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// import 'package:hrms/api%20config.dart';
// import 'package:hrms/home_screen.dart';
// import 'package:hrms/personal_details.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Commonutils.dart';
import 'MyAppointment_Model.dart';

// import 'Model Class/EmployeeLeave.dart';
// import 'SharedPreferencesHelper.dart';

class MyAppointments extends StatefulWidget {
  @override
  MyAppointments_screenState createState() => MyAppointments_screenState();
}

class MyAppointments_screenState extends State<MyAppointments> {
  String accessToken = '';
  String empolyeid = '';
  String todate = "";
  TextEditingController _commentstexteditcontroller = TextEditingController();
  double rating_star = 0.0;
  int? userId;
  // List<Map<String, dynamic>> leaveData = [];

  bool isLoading = true;
  List<MyAppointment_Model> MyAppointmentList = [];

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
        
      } else {
        print('The Internet Is not  Connected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textscale = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(
        onWillPop: () async {
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(builder: (context) => home_screen()),
          // ); // Navigate to the previous screen
          return true; // Prevent default back navigation behavior
        },
        child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Color(0xFFf15f22),
              title: Text(
                'My Appointments',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(builder: (context) => home_screen()),
                  // );
                  // Implement your logic to navigate back
                },
              )),
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : MyAppointmentList.isEmpty
              ? Center(child: Text('No Appointments Booked!'))
              : Container(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 10,
                right: 10,
              ),
              child:
              // isLoading
              //     ? Center(
              //   child: CircularProgressIndicator(),
              // )
              //     : appointments.isNotEmpty
              //     ?
              ListView.builder(
                shrinkWrap: true,
                itemCount: MyAppointmentList.length,
                itemBuilder: (context, index) {
                  MyAppointment_Model appointment_model = MyAppointmentList[index];
                  final borderColor = _getStatusBorderColor(appointment_model.status);
                  final isEvenItem = index % 2 == 0;
                  final boxDecoration = isEvenItem
                      ? BoxDecoration(
                      border: Border.all(color: borderColor, width: 1.5),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFfee7e1),
                          Color(0xFFd7defa),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                      ))
                      : BoxDecoration(
                      border: Border.all(color: borderColor, width: 1.5),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFd7defa),
                          Color(0xFFfee7e1),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                      ));

                  return GestureDetector(
                    onTap: () {
                      print('CardView clicked!');
                      if (appointment_model.statusTypeId == 5) {
                        ShowAlertdialog(appointment_model);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(42.5),
                        bottomLeft: Radius.circular(42.5),
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                            )),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10, top: 5, left: 0, right: 0),
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
                                      Container(
                                        width: MediaQuery.of(context).size.width / 2,
                                        //   height: MediaQuery.of(context).size.height,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: Text(
                                                          '${appointment_model.branch}',
                                                          style: TextStyle(color: Color(0xFFF44614), fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),


                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 7,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: Text(
                                                          'Slot Time',
                                                          style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
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
                                                Expanded(
                                                  flex: 0,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: Text(
                                                          ' : ',
                                                          style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 12,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: Text(
                                                          '${appointment_model.slotDuration}',
                                                          style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 6,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: Text(
                                                          'Status',
                                                          style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 0,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: Text(
                                                          ': ',
                                                          style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 10,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: Text(
                                                          '${appointment_model.status}',
                                                          style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
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
                              Container(
                                width: MediaQuery.of(context).size.width / 2.25,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                child: Text(
                                                  'Feedback',
                                                  style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 0,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                child: Text(
                                                  ': ',
                                                  style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 9,
                                          /* child: GestureDetector(
                                                      onTap: () {
                                                        ShowAlertdialog();
                                                      },*/
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                child: Text(
                                                  'Recived',
                                                  style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                                ),
                                              ),
                                            ],
                                          ),
                                          //  )
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                child: Text(
                                                  'Purpose of Visit',
                                                  style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 0,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                child: Text(
                                                  ': ',
                                                  style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 9,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                child: Text(
                                                  '${appointment_model.purposeOfVisit}',
                                                  style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),


                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            //     : Center(
            //   child: Text(
            //     'No Slots Available',
            //     style: TextStyle(
            //       fontSize: 18,
            //       color: Color(0xFFFB4110),
            //       fontWeight: FontWeight.bold,
            //       fontFamily: 'Calibri',
            //     ),
            //   ),
            // ),
          ),
        ));
  }

  Color _getStatusBorderColor(String status) {
    switch (status) {
    // Orange border for 'Pending' status
      case 'Accepted':
        return Colors.green.shade600;
      case 'Declined':
        return Colors.red;
      case 'Submited':
        return Colors.transparent;
    // Add more cases for other statuses if needed
      default:
        return Colors.red; // Red border for other statuses
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
    userId = prefs.getInt('userId'); // Retrieve the user ID
    print('userId: : $userId');
    fetchMyAppointments(userId);
  }
  void fetchMyAppointments(int? userId) async {
    setState(() {
      isLoading = true; // Set isLoading to true before making the API request
    });

    String url = 'http://182.18.157.215/SaloonApp/API/api/Appointment/GetAppointmentByUserid/$userId';
    print('GetAppointmentByUserid: : $url');
    try {
      final response = await http.get(Uri.parse(url));

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response body
        final data = json.decode(response.body);

        List<MyAppointment_Model> myAppointmentsList = [];
        for (var item in data['listResult']) {
          myAppointmentsList.add(MyAppointment_Model(
            id: item['id'],
            branchId: item['branchId'],
            branch: item['branch'],
            date: item['date'],
            slotTime: item['slotTime'],
            customerName: item['customerName'],
            contactNumber: item['contactNumber'],
            email: item['email'],
            genderTypeId: item['genderTypeId'],
            gender: item['gender'],
            statusTypeId: item['statusTypeId'],
            status: item['status'],
            purposeOfVisitId: item['purposeOfVisitId'],
            purposeOfVisit: item['purposeOfVisit'],
            isActive: item['isActive'],
            slotDuration: item['slotDuration'],
          ));
        }

        // Update the state with the fetched data
        setState(() {
          MyAppointmentList = myAppointmentsList;
          isLoading = false; // Set isLoading to false after data is fetched
        });
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
  }

  void ShowAlertdialog(MyAppointment_Model appointment_model) {
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
                  padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 20.0),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
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
                      Text(
                        'Feedback',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFFf15f22),
                          fontFamily: 'Calibri',
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        'Rating',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFf15f22),
                          fontFamily: 'Calibri',
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: RatingBar.builder(
                            initialRating: 0,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => Icon(
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
                        padding: EdgeInsets.only(left: 0, top: 10.0, right: 0),
                        child: GestureDetector(
                          onTap: () async {},
                          child: Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFf15f22), width: 1.5),
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              controller: _commentstexteditcontroller,
                              style: TextStyle(
                                fontFamily: 'Calibri',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                              maxLines: null,
                              maxLength: 256,
                              // Set maxLines to null for multiline input
                              decoration: InputDecoration(
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
                        padding: EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFf15f22),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              //   validaterating();
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Calibri'),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                          ),
                        ),
                      ),
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
              //       primary: Color(0xFFf15f22), // Change to your desired background color
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
}
