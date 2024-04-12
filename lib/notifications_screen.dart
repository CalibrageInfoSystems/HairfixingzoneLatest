import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'CommonUtils.dart';
import 'Notifications.dart';
import 'api_config.dart';

class notifications_screen extends StatefulWidget {
  int userId;
  String formattedDate;

  notifications_screen({required this.userId, required this.formattedDate});
  @override
  _notifications_screenState createState() => _notifications_screenState();
}
class _notifications_screenState extends State<notifications_screen> {
  bool _isLoading = false;


  String notificationMsg = "Waiting for notifications";
  String firebaseToken = "";
  List<Notifications> appointments = [];
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('User ID: ${widget.userId}');

    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        print('Connected to the internet');
        fetchAppointments(widget.userId,widget.formattedDate);
      } else { CommonUtils.showCustomToastMessageLong('Not connected to the internet', context, 1, 4);
      print('Not connected to the internet');  // Not connected to the internet
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set this to false

      appBar: AppBar(
        backgroundColor: const Color(0xFFF44614),
        centerTitle: true,
        title: Container(
          width: 85,
          height: 50,
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),

        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: isLoading ? Center(
          child: CircularProgressIndicator(),)
            : appointments.isNotEmpty
            ? ListView.builder(
          shrinkWrap: true,
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
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
                )
            )
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
                )
            );

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
                      )
                  ),
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

                                Padding(
                                  padding: EdgeInsets.only(top:5.0,
                                      bottom: 4.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Name : ',
                                          style: TextStyle(
                                              color: Color(
                                                  0xFFF44614),fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Calibri'),
                                        ),
                                        TextSpan(
                                          text: appointment.customerName,
                                          style: TextStyle(
                                              color: Color(
                                                  0xFF042DE3),fontSize: 12,
                                              fontFamily: 'Calibri'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 4.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Branch Name : ',
                                          style: TextStyle(
                                              color: Color(
                                                  0xFFF44614),fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Calibri'),
                                        ),
                                        TextSpan(
                                          text: appointment.name,
                                          style: TextStyle(
                                              color: Color(
                                                  0xFF042DE3),fontSize: 12,
                                              fontFamily: 'Calibri'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 4.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Gender : ',
                                          style: TextStyle(
                                              color: Color(
                                                  0xFFF44614),fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Calibri'),
                                        ),
                                        TextSpan(
                                          text: appointment.gender,
                                          style: TextStyle(
                                              color: Color(
                                                  0xFF042DE3),fontSize: 12,

                                              fontFamily: 'Calibri'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 4.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Purpose : ',
                                          style: TextStyle(
                                              color: Color(
                                                  0xFFF44614),fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Calibri'),
                                        ),
                                        TextSpan(
                                          text: appointment.purposeOfVisit,
                                          style: TextStyle(
                                              color: Color(
                                                  0xFF042DE3),fontSize: 12,

                                              fontFamily: 'Calibri'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 4.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons
                                                .email_outlined,
                                            size: 16,
                                            color: Color(
                                                0xFFF44614),
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' : ',
                                          style: TextStyle(
                                              color: Color(
                                                  0xFFF44614),
                                              fontSize: 12,

                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Calibri'),
                                        ),
                                        TextSpan(
                                          text: appointment.email,
                                          style: TextStyle(
                                              color: Color(
                                                  0xFF042DE3),fontSize: 12,

                                              fontFamily: 'Calibri'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 4.0),

                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.lock_clock,
                                            color: Color(
                                                0xFFF44614),
                                            size: 16,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' : ',
                                          style: TextStyle(
                                              color: Color(
                                                  0xFFF44614),
                                              fontSize: 12,

                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Calibri'),
                                        ),

                                        TextSpan(

                                          text: DateFormat('dd-MM-yyyy').format(DateTime.parse(appointment.date)),
                                          //  text: appointment.date,
                                          style: TextStyle(
                                              color: Color(
                                                0xFF042DE3,
                                              ),
                                              fontSize: 12,
                                              fontFamily: 'Calibri'),
                                        ),
                                        TextSpan(
                                          text: " "+ appointment.slotDuration,
                                          style: TextStyle(
                                              color: Color(
                                                0xFF042DE3,
                                              ),
                                              fontSize: 12,

                                              fontFamily: 'Calibri'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 5.0,left: 5.0,right: 5.0,top: 5.0),
                              child:GestureDetector(
                                onTap: () {
                                  String phoneNumber = appointment.phoneNumber;
                                  launch("tel:$phoneNumber");
                                },
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 8.0, top: 2.0), // Add desired left and top padding
                                          child: Icon(
                                            Icons.phone,
                                            color: Color(0xFFF44614),
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: ': ',
                                        style: TextStyle(
                                          color: Color(0xFFF44614),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Calibri',
                                        ),
                                      ),
                                      TextSpan(
                                        text: appointment.phoneNumber,
                                        style: TextStyle(
                                          color: Color(0xFF042DE3),
                                          fontFamily: 'Calibri',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            if (appointment.statusTypeId == 5)
                              Visibility(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Container(
                                        width: 75,
                                        height: 75,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 2.0,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Positioned(
                                              top: 12,
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.green ,
                                                size: 33,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 15,
                                              child: Text(
                                                'Accepted',
                                                style: TextStyle(
                                                    color: Colors.green ,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Calibri'
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
                            if (appointment.statusTypeId == 6)
                              Visibility(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Container(
                                        width: 75,
                                        height: 75,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color:  Colors.red,
                                            width: 2.0,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Positioned(
                                              top: 12,
                                              child: Icon(
                                                Icons.close,
                                                color:Colors.red,
                                                size: 33,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 15,
                                              child: Text(
                                                'Rejected',
                                                style: TextStyle(
                                                    color:  Colors.red,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Calibri'
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

                            if (!appointment.isAccepted) SizedBox(height: 8),
                            if (!appointment.isRejected)
                              if(!appointment.isAccepted)
                                if (appointment.statusTypeId == 4)

                                  if (!appointment.isAccepted)
                                    ElevatedButton(
                                      //  onPressed: () {
                                      onPressed: isPastDate(widget.formattedDate, appointment.slotDuration) ? null : () {

                                        acceptAppointment(index);

                                        Notifications data = Notifications(
                                          id: appointment.id,
                                          branchId: appointment.branchId,
                                          name: appointment.name,
                                          date: appointment.date,
                                          slotTime: appointment.slotTime,
                                          customerName: appointment.customerName,
                                          phoneNumber: appointment.phoneNumber,
                                          email: appointment.email,
                                          genderTypeId: appointment.genderTypeId,
                                          gender: appointment.gender,
                                          statusTypeId: appointment.statusTypeId,
                                          status: appointment.status,
                                          purposeOfVisit: appointment.purposeOfVisit,
                                          purposeOfVisitId : appointment.purposeOfVisitId,
                                          isActive: appointment.isActive,
                                          slotDuration: appointment.slotDuration, address: appointment.address,
                                        );

                                        print('Button 1 pressed for ${appointment.customerName}');
                                        postAppointment(data, 5);
                                        Get_ApprovedDeclinedSlots(data, 5);
                                        print('accpteedbuttonisclicked');
                                      },
                                      child: Text('Accept'),
                                      style: ButtonStyle(
                                        foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                            if (states.contains(MaterialState.disabled)) {
                                              return Colors.grey; // Set the text color to gray when disabled
                                            }
                                            return Colors.green; // Use the default text color for enabled state
                                          },
                                        ),
                                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                            if (states.contains(MaterialState.disabled)) {
                                              return Colors.grey.withOpacity(0.5); // Set the background color to gray with opacity when disabled
                                            }
                                            return Colors.white; // Use the default background color for enabled state
                                          },
                                        ),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                            side: BorderSide(color: Colors.green, width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                            // ElevatedButton(
                            //   onPressed: () { acceptAppointment(index);
                            //
                            //   Appointment data = Appointment(id: appointment.id, branchId: appointment.branchId, name: appointment.name
                            //       , date: appointment.date, slotTime: appointment.slotTime, customerName: appointment.customerName, phoneNumber: appointment.phoneNumber, email: appointment.email,
                            //       genderTypeId: appointment.genderTypeId, gender: appointment.gender, statusTypeId: appointment.statusTypeId, status: appointment.status, comment: appointment.comment, isActive: appointment.isActive, SlotDuration: '');
                            //   print('Button 1 pressed for ${appointment.customerName}');
                            //   postAppointment(data,5);
                            //   print('accpteedbuttonisclicked');},
                            //   child: Text('Accept'),
                            //   style: TextButton.styleFrom(
                            //     primary: Colors.green,
                            //     backgroundColor: Colors.white,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(25.0),
                            //       side: BorderSide(color: Colors.green, width: 2.0),
                            //     ),
                            //   ),
                            // ),

                            if (!appointment.isRejected) SizedBox(height: 2),
                            if (!appointment.isAccepted)
                              if(!appointment.isRejected)
                                if (appointment.statusTypeId == 4)
                                  ElevatedButton(
                                    //  onPressed: () {
                                    onPressed: isPastDate(widget.formattedDate,appointment.slotDuration  ) ? null : () {
                                      // Handle reject button action
                                      rejectAppointment(index);

                                      Notifications data = Notifications(
                                        id: appointment.id,
                                        branchId: appointment.branchId,
                                        name: appointment.name,
                                        date: appointment.date,
                                        slotTime: appointment.slotTime,
                                        customerName: appointment.customerName,
                                        phoneNumber: appointment.phoneNumber,
                                        email: appointment.email,
                                        genderTypeId: appointment.genderTypeId,
                                        gender: appointment.gender,
                                        statusTypeId: appointment.statusTypeId,
                                        status: appointment.status,
                                        purposeOfVisit: appointment.purposeOfVisit,
                                        purposeOfVisitId : appointment.purposeOfVisitId,
                                        isActive: appointment.isActive,
                                        slotDuration: appointment.slotDuration, address: appointment.address,
                                      );

                                      print('Button 1 pressed for ${appointment.customerName}');
                                      postAppointment(data, 6);
                                      print('rejectedbuttonisclciked');
                                    },
                                    child: Text('Reject'),
                                    style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.disabled)) {
                                            return Colors.grey; // Set the text color to gray when disabled
                                          }
                                          return Color(0xFFF44614); // Use the default text color for enabled state
                                        },
                                      ),
                                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.disabled)) {
                                            return Colors.grey.withOpacity(0.5); // Set the background color to gray with opacity when disabled
                                          }
                                          return Colors.white; // Use the default background color for enabled state
                                        },
                                      ),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                          side: BorderSide(color: Color(0xFFF44614), width: 2.0),
                                        ),
                                      ),
                                    ),
                                  ),


                            if (appointment.isAccepted || appointment.isRejected )
                              Visibility(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Container(
                                        width: 75,
                                        height: 75,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: appointment.isAccepted ? Colors.green : Colors.red,
                                            width: 2.0,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Positioned(
                                              top: 12,
                                              child: Icon(
                                                appointment.isAccepted ? Icons.check : Icons.close,
                                                color: appointment.isAccepted ? Colors.green : Colors.red,
                                                size: 33,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 15,
                                              child: Text(
                                                appointment.isAccepted ? 'Accepted' : 'Rejected',
                                                style: TextStyle(
                                                  color: appointment.isAccepted ? Colors.green : Colors.red,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Calibri',
                                                ),
                                              ),
                                            ),
                                          ],
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
          },
        )
            : Center(
          child: Text(
            'No Slots Available',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFFFB4110),
              fontWeight: FontWeight.bold,
              fontFamily: 'Calibri',
            ),
          ),
        ),

      ),
    );
  }

  void fetchAppointments(int userId, String? formattedDate) async {

    appointments.clear();
    final url =  Uri.parse(baseUrl+Getnotificatons+'$userId/null/$formattedDate');
    print('url==842===$url');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['listResult'] != null) {
          final List<dynamic> appointmentsData = responseData['listResult'];
          setState(() {
            appointments = appointmentsData
                .map((appointment) => Notifications.fromJson(appointment))
                .toList();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          //  textFieldController.text = 'No Slots Available';
          print('No Slots Available');
        }
      } else {
        throw Exception('Failed to fetch appointments');
      }
    } catch (error) {
      throw Exception('Failed to connect to the API');
    }
  }

  Future<void> Get_ApprovedDeclinedSlots(Notifications data, int i) async {
    final url =  Uri.parse(baseUrl+GetApprovedDeclinedSlots);
    print('url==>55555: $url');

    final request = {

      "Id": data.id,
      "StatusTypeId": 5,
      "BranchName":data.name,
      "Date": data.date,
      "SlotTime": data.slotTime,
      "CustomerName": data.customerName,
      "PhoneNumber": data.phoneNumber,
      "Email":data.email,
      "Address": data.address,
      "SlotDuration": data.slotDuration

    };
    print('Get_ApprovedSlotsmail: $request');
    try {
      // Send the POST request
      final response = await http.post(
        url,
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json', // Set the content type header
        },
      );

      // Check the response status code
      if (response.statusCode == 204) {
        print('Request sent successfully');

      } else {

        print('Failed to send the request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void acceptAppointment(int index) {
    setState(() {
      appointments[index].isAccepted = true;
    });
  }

  void rejectAppointment(int index) {
    setState(() {
      appointments[index].isRejected = true;
    });
  }


  Future<void> postAppointment(Notifications data, int i) async {
    final url =  Uri.parse(baseUrl+postApiAppointment);
    print('url==>890: $url');
    // final url = Uri.parse('http://182.18.157.215/SaloonApp/API/api/Appointment');
    DateTime now = DateTime.now();

    // Using toString() method
    String dateTimeString = now.toString();
    print('DateTime as String: $dateTimeString');

    // Create the request object
    final request = {

      "Id": data.id,
      "BranchId": data.branchId,
      "Date": data.date,
      "SlotTime": data.slotTime,
      "CustomerName":data.customerName,
      "PhoneNumber": data.phoneNumber,
      "Email": data.email,
      "GenderTypeId": data.genderTypeId,
      "StatusTypeId": i,
      "PurposeOfVisitId": data.purposeOfVisitId,
      "PurposeOfVisit": data.purposeOfVisit,
      "IsActive": true,
      "CreatedDate": dateTimeString,
      "UpdatedDate": dateTimeString,
      "UpdatedByUserId": widget.userId
    };
    print('Accept Or reject object: $request');
    try {
      // Send the POST request
      final response = await http.post(
        url,
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json', // Set the content type header
        },
      );

      // Check the response status code
      if (response.statusCode == 200) {
        print('Request sent successfully');

        // showCustomToastMessageLong(
        //     'Request sent successfully', context, 0, 2);
        //    Navigator.pop(context);
      } else {
        //showCustomToastMessageLong(
        // 'Failed to send the request', context, 1, 2);
        print('Failed to send the request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
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
}


