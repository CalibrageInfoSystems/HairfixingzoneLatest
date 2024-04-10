import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        fetchMyAppointments();
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
          body:
              // isLoading
              //     ? Center(child: CircularProgressIndicator())
              //     : leaveData.isEmpty
              //         ? Center(child: Text('No Leaves Applied!'))
              //         :
              Positioned(
                  top: 10,
                  bottom: 10,
                  left: 10,
                  right: 10,
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
                      final isEvenItem = index % 2 == 0;
                      final boxDecoration = isEvenItem
                          ? BoxDecoration(
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
                              padding: EdgeInsets.only(bottom: 10, top: 5, left: 5, right: 10),
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
                                                      flex: 3,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                            child: Text(
                                                              'Name ',
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
                                                              ' : ',
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
                                                              '${appointment_model.customerName}',
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
                                                      flex: 4,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                            child: Icon(
                                                              Icons.email_outlined,
                                                              size: 16,
                                                              color: Color(0xFFF44614),
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
                                                              '${appointment_model.email}',
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
                                                      flex: 4,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                            child: Icon(
                                                              Icons.lock_clock,
                                                              size: 16,
                                                              color: Color(0xFFF44614),
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
                                              ],
                                            ),
                                          ),

                                          // Padding(
                                          //   padding: EdgeInsets.only(top: 5.0, bottom: 4.0),
                                          //   child: RichText(
                                          //     text: TextSpan(
                                          //       children: [
                                          //         TextSpan(
                                          //           text: 'Name : ',
                                          //           style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                          //         ),
                                          //         TextSpan(
                                          //           text: 'customerName',
                                          //           style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),

                                          // Padding(
                                          //   padding: EdgeInsets.only(bottom: 4.0),
                                          //   child: RichText(
                                          //     text: TextSpan(
                                          //       children: [
                                          //         WidgetSpan(
                                          //           child: Icon(
                                          //             Icons.email_outlined,
                                          //             size: 16,
                                          //             color: Color(0xFFF44614),
                                          //           ),
                                          //         ),
                                          //         TextSpan(
                                          //           text: ' : ',
                                          //           style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                          //         ),
                                          //         TextSpan(
                                          //           text: 'email',
                                          //           style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),

                                          // Padding(
                                          //   padding: EdgeInsets.only(bottom: 4.0),
                                          //   child: RichText(
                                          //     text: TextSpan(
                                          //       children: [
                                          //         WidgetSpan(
                                          //           child: Icon(
                                          //             Icons.lock_clock,
                                          //             color: Color(0xFFF44614),
                                          //             size: 16,
                                          //           ),
                                          //         ),
                                          //         TextSpan(
                                          //           text: ' : ',
                                          //           style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                          //         ),
                                          //         TextSpan(
                                          //           text: 'SlotDuration',
                                          //           style: TextStyle(
                                          //               color: Color(
                                          //                 0xFF042DE3,
                                          //               ),
                                          //               fontSize: 12,
                                          //               fontFamily: 'Calibri'),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
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
                                              flex: 9,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                    child: Text(
                                                      'Purposeofvisit ',
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
                                                      ' : ',
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
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 9,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                    child: Text(
                                                      'Status ',
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
                                                      ' : ',
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
                                                      '${appointment_model.status}',
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
                                              flex: 9,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                    child: Icon(
                                                      Icons.phone,
                                                      size: 14,
                                                      color: Color(0xFFF44614),
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
                                                      ' : ',
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
                                                      '${appointment_model.contactNumber}',
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
                                              flex: 9,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                    child: Text(
                                                      'Gender ',
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
                                                      ' : ',
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
                                                      '${appointment_model.gender}',
                                                      style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),

                                        // Padding(
                                        //   padding: EdgeInsets.only(bottom: 4.0),
                                        //   child: RichText(
                                        //     text: TextSpan(
                                        //       children: [
                                        //         TextSpan(
                                        //           text: 'Gender : ',
                                        //           style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                        //         ),
                                        //         TextSpan(
                                        //           text: 'gender',
                                        //           style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                        // Row(
                                        //   children: [
                                        //     Expanded(
                                        //       flex: 10,
                                        //       child: Column(
                                        //         crossAxisAlignment: CrossAxisAlignment.end,
                                        //         children: [
                                        //           Padding(
                                        //             padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                        //             child: Icon(
                                        //               Icons.phone,
                                        //               size: 16,
                                        //               color: Color(0xFFF44614),
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //     Expanded(
                                        //       flex: 0,
                                        //       child: Column(
                                        //         crossAxisAlignment: CrossAxisAlignment.center,
                                        //         children: [
                                        //           Padding(
                                        //             padding: EdgeInsets.fromLTRB(0, 10, 5, 0),
                                        //             child: Text(
                                        //               ' : ',
                                        //               style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //     Expanded(
                                        //       flex: 14,
                                        //       child: Column(
                                        //         crossAxisAlignment: CrossAxisAlignment.start,
                                        //         children: [
                                        //           Padding(
                                        //             padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        //             child: Text(
                                        //               '6846847844',
                                        //               style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     )
                                        //   ],
                                        // ),
                                        // Padding(
                                        //   padding: EdgeInsets.only(bottom: 4.0),
                                        //   child: RichText(
                                        //     text: TextSpan(
                                        //       children: [
                                        //         TextSpan(
                                        //           text: 'Purpose : ',
                                        //           style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                        //         ),
                                        //         TextSpan(
                                        //           text: 'purposeofvisit',
                                        //           style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                        // Row(
                                        //   children: [
                                        //     Expanded(
                                        //       flex: 10,
                                        //       child: Column(
                                        //         crossAxisAlignment: CrossAxisAlignment.end,
                                        //         children: [
                                        //           Padding(
                                        //             padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                        //             child: Icon(
                                        //               Icons.phone,
                                        //               size: 16,
                                        //               color: Color(0xFFF44614),
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //     Expanded(
                                        //       flex: 0,
                                        //       child: Column(
                                        //         crossAxisAlignment: CrossAxisAlignment.center,
                                        //         children: [
                                        //           Padding(
                                        //             padding: EdgeInsets.fromLTRB(0, 10, 5, 0),
                                        //             child: Text(
                                        //               ' : ',
                                        //               style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //     Expanded(
                                        //       flex: 14,
                                        //       child: Column(
                                        //         crossAxisAlignment: CrossAxisAlignment.start,
                                        //         children: [
                                        //           Padding(
                                        //             padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        //             child: Text(
                                        //               '6846847844',
                                        //               style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     )
                                        //   ],
                                        // ),
                                        // Padding(
                                        //   padding: EdgeInsets.only(bottom: 4.0),
                                        //   child: RichText(
                                        //     text: TextSpan(
                                        //       children: [
                                        //         TextSpan(
                                        //           text: 'Status :',
                                        //           style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                        //         ),
                                        //         TextSpan(
                                        //           text: ' Accepted',
                                        //           style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
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
      case 'Rejected':
        return Colors.red;
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

  void fetchMyAppointments() async {
    // setState(() {
    // //  isLoading = true; // Set isLoading to true before making the API request
    // });

    String url = 'http://182.18.157.215/SaloonApp/API/api/Appointment/GetAppointmentByUserid/1';
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
          // isLoading = false; // Set isLoading to false after data is fetched
        });
      } else {
        // Handle error if the API request was not successful
        print('Request failed with status: ${response.statusCode}');
        setState(() {
          // isLoading = false; // Set isLoading to false if request fails
        });
      }
    } catch (error) {
      // Handle any exception that occurred during the API call
      print('Error data is not getting from the api: $error');
      setState(() {
        //  isLoading = false; // Set isLoading to false if error occurs
      });
    }
  }
}
