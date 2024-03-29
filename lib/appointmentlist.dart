import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'Appointment.dart';
import 'CommonUtils.dart';
import 'api_config.dart';

class appointmentlist extends StatefulWidget {
  final int userId;
  final int branchid;
  final String branchname;
  final String filepath;
  final String phonenumber;
  final String branchaddress;
  appointmentlist({required this.userId, required this.branchid, required this.branchname, required this.filepath, required this.phonenumber, required this.branchaddress}) {}
  @override
  _appointmentlist createState() => _appointmentlist();
}

class _appointmentlist extends State<appointmentlist> {
  DateTime? _selectedDate;
  TextEditingController _dateController = TextEditingController();
  List<Appointment> appointments = [];
  Color backgroundColor = Colors.white;
  Color textColor = Colors.black;
  late String selecteddate;
  int selectedButtonIndex = 1;
  TextEditingController textFieldController = TextEditingController();
  bool isLoading = true;
  bool isButtonEnabled = false; // Set this value based on your condition
  bool datediff = false; // Set this value based on your condition
  bool timediff = false;
  bool isBeforeTime = false;
  bool isBeforeDate = true;
  @override
  void initState() {
    super.initState();
    _dateController.text = 'Select date';
    print('User ID: ${widget.userId}');
    print('User branchid: ${widget.branchid}');
    print('User branchname: ${widget.branchname}');
    print('User filepath: ${widget.filepath}');
    _dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    selecteddate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    print('selecteddate $selecteddate');
    // Calling fetchAppointments with nullable parameters as null
    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        print('Connected to the internet');
        fetchAppointments(widget.userId, widget.branchid, status: null, date: selecteddate);
      } else {
        CommonUtils.showCustomToastMessageLong('Not connected to the internet', context, 1, 4);
        print('Not connected to the internet'); // Not connected to the internet
      }
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final desiredWidth = screenWidth;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Color(0xFFFB4110),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop(); // Navigate back to the previous screen
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2)),
                Image.asset(
                  'assets/logo.png',
                  width: 100,
                  height: 180,
                ),
              ],
            )),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'), // Replace with your background image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              child: Container(
                margin: EdgeInsets.all(16.0),
                height: 120,
                width: desiredWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(28.0),
                    bottomLeft: Radius.circular(28.0),
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 8.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFD7DEFA),
                      spreadRadius: -15.0,
                      blurRadius: 20.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        imagesflierepo + widget.filepath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Container(
                        child: Opacity(
                          opacity: 0.7,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFEE7E1),
                                  Color(0xFFD7DEFA),
                                ],
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(top: 25),
                              margin: EdgeInsets.all(16.0),
                              height: 120,
                              width: screenWidth,
                              child: Text(
                                widget.branchname,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Calibri',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 150,
              left: 16,
              right: 16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      _openDatePicker();
                    },
                    child: Container(
                      width: desiredWidth,
                      height: 40.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF163CF1), width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: AbsorbPointer(
                        child: SizedBox(
                          child: TextFormField(
                            controller: _dateController,
                            style: TextStyle(fontSize: 14, color: Color(0xFFFB4110), fontWeight: FontWeight.w300, fontFamily: 'Calibri'),
                            decoration: InputDecoration(
                              hintText: 'Select date',
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'assets/datepicker_icon.svg',
                                  width: 20.0,
                                ),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 200,
              left: 8,
              right: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      isLoading = true;
                      fetchAppointments(widget.userId, widget.branchid, status: null, date: selecteddate);
                      setState(() {
                        selectedButtonIndex = 1;
                      });
                    },
                    child: Text(
                      'All',
                      style: TextStyle(color: selectedButtonIndex == 1 ? Colors.white : Color(0xFFF44614), fontWeight: FontWeight.bold, fontFamily: 'Calibri', fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: selectedButtonIndex == 1 ? Color(0xFFF44614) : Colors.white,
                      onPrimary: Color(0xFFF44614),
                      side: BorderSide(color: Color(0xFFF44614), width: 2.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      isLoading = true;
                      fetchAppointments(widget.userId, widget.branchid, status: 4, date: selecteddate);
                      setState(() {
                        selectedButtonIndex = 2;
                      });
                    },
                    child: Text(
                      'Requested',
                      style: TextStyle(color: selectedButtonIndex == 2 ? Colors.white : Color(0xFFF44614), fontWeight: FontWeight.bold, fontFamily: 'Calibri', fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: selectedButtonIndex == 2 ? Color(0xFFF44614) : Colors.white,
                      onPrimary: Color(0xFFF44614),
                      side: BorderSide(color: Color(0xFFF44614), width: 2.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      isLoading = true;
                      fetchAppointments(widget.userId, widget.branchid, status: 5, date: selecteddate);
                      setState(() {
                        selectedButtonIndex = 3;
                      });
                    },
                    child: Text(
                      'Accepted',
                      style: TextStyle(color: selectedButtonIndex == 3 ? Colors.white : Color(0xFFF44614), fontWeight: FontWeight.bold, fontFamily: 'Calibri', fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: selectedButtonIndex == 3 ? Color(0xFFF44614) : Colors.white,
                      onPrimary: Color(0xFFF44614),
                      side: BorderSide(color: Color(0xFFF44614), width: 2.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      isLoading = true;
                      fetchAppointments(widget.userId, widget.branchid, status: 6, date: selecteddate);
                      setState(() {
                        selectedButtonIndex = 4;
                      });
                    },
                    child: Text(
                      'Rejected',
                      style: TextStyle(color: selectedButtonIndex == 4 ? Colors.white : Color(0xFFF44614), fontWeight: FontWeight.bold, fontFamily: 'Calibri', fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: selectedButtonIndex == 4 ? Color(0xFFF44614) : Colors.white,
                      onPrimary: Color(0xFFF44614),
                      side: BorderSide(color: Color(0xFFF44614), width: 2.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 250,
              bottom: 10,
              left: 10,
              right: 10,
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
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
                                                Padding(
                                                  padding: EdgeInsets.only(top: 5.0, bottom: 4.0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Name : ',
                                                          style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                                        ),
                                                        TextSpan(
                                                          text: appointment.customerName,
                                                          style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(bottom: 4.0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Gender : ',
                                                          style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                                        ),
                                                        TextSpan(
                                                          text: appointment.gender,
                                                          style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(bottom: 4.0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Purpose : ',
                                                          style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                                        ),
                                                        TextSpan(
                                                          text: appointment.purposeofvisit,
                                                          style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(bottom: 4.0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        WidgetSpan(
                                                          child: Icon(
                                                            Icons.email_outlined,
                                                            size: 16,
                                                            color: Color(0xFFF44614),
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: ' : ',
                                                          style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                                        ),
                                                        TextSpan(
                                                          text: appointment.email,
                                                          style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(bottom: 4.0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        WidgetSpan(
                                                          child: Icon(
                                                            Icons.lock_clock,
                                                            color: Color(0xFFF44614),
                                                            size: 16,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: ' : ',
                                                          style: TextStyle(color: Color(0xFFF44614), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                                        ),
                                                        TextSpan(
                                                          text: appointment.SlotDuration,
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
                                              padding: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0, top: 5.0),
                                              child: GestureDetector(
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
                                                                color: Colors.green,
                                                                size: 33,
                                                              ),
                                                            ),
                                                            Positioned(
                                                              bottom: 15,
                                                              child: Text(
                                                                'Accepted',
                                                                style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
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
                                                            color: Colors.red,
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
                                                                color: Colors.red,
                                                                size: 33,
                                                              ),
                                                            ),
                                                            Positioned(
                                                              bottom: 15,
                                                              child: Text(
                                                                'Rejected',
                                                                style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
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
                                              if (!appointment.isAccepted)
                                                if (appointment.statusTypeId == 4)
                                                  if (!appointment.isAccepted)
                                                    ElevatedButton(
                                                      onPressed: isPastDate(selecteddate, appointment.SlotDuration)
                                                          ? null
                                                          : () {
                                                              acceptAppointment(index);

                                                              Appointment data = Appointment(
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
                                                                purposevisitid: appointment.purposevisitid,
                                                                purposeofvisit: appointment.purposeofvisit,
                                                                isActive: appointment.isActive,
                                                                SlotDuration: appointment.SlotDuration,
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
                                            if (!appointment.isRejected) SizedBox(height: 2),
                                            if (!appointment.isAccepted)
                                              if (!appointment.isRejected)
                                                if (appointment.statusTypeId == 4)
                                                  ElevatedButton(
                                                    onPressed: isPastDate(selecteddate, appointment.SlotDuration)
                                                        ? null
                                                        : () {
                                                            // Handle reject button action
                                                            rejectAppointment(index);

                                                            Appointment data = Appointment(
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
                                                              purposevisitid: appointment.purposevisitid,
                                                              purposeofvisit: appointment.purposeofvisit,
                                                              isActive: appointment.isActive,
                                                              SlotDuration: appointment.SlotDuration,
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
                                            if (appointment.isAccepted || appointment.isRejected)
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
          ],
        ),
      ),
    );
  }

  Future<void> _openDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
      selectableDayPredicate: (DateTime date) {
        // Enable all dates (including past dates)
        return true;
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate!);
        selecteddate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
        DateTime currentDate = DateTime.now();
        // Splitting into date and time components
        String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
        //   String formattedTime = DateFormat('HH:mm:ss').format(currentDate);

        print('currentDate: $formattedDate');
        //   print('Time: $formattedTime');
        //  DateTime selectedDate = _selectedDate!;// The date you want to compare with the current date
        //   print('currentDate date $currentDate');
        print('Selected date $selecteddate');
        DateTime selectedDateTime = DateTime.parse(selecteddate);
        DateTime currentDateTime = DateTime.parse(formattedDate);
        print('currentDatetime: $currentDateTime');
        //   print('Time: $formattedTime');
        //  DateTime selectedDate = _selectedDate!;// The date you want to compare with the current date
        //   print('currentDate date $currentDate');
        print('Selected date time$selectedDateTime');
        if (selectedDateTime.isAfter(currentDateTime)) {
          // The selected date is after the current date
          print('Selected date is in the future');
        } else if (selectedDateTime == currentDateTime) {
          // The selected date is before the current date
          print('Selected date is in the past');
        } else {
          // The selected date is the same as the current date
          print('Selected date is the same as the current date');
        }
        DateTime currentTime = DateTime.now();
        print('currentTime: $currentTime');
        int hours = currentTime.hour;
        int minutes = currentTime.minute;
        int seconds = currentTime.second;

        print('Hours: $hours');
        print('Minutes: $minutes');
        print('Seconds: $seconds');
        selectedButtonIndex = 1;
        fetchAppointments(widget.userId, widget.branchid, status: null, date: selecteddate);
      });
    }
  }

  // Future<void> fetchAppointments() async {
  //   final url = Uri.parse('http://182.18.157.215/SaloonApp/API/GetAppointment/1/1/null/null');
  //   final response = await http.get(url);
  //
  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     final List<dynamic> appointmentsData = jsonData['ListResult'];
  //
  //     setState(() {
  //       appointments = appointmentsData.map((data) => Appointment.fromJson(data)).toList();
  //     });
  //   } else {
  //     throw Exception('Failed to load appointments');
  //   }
  // }

  void acceptAppointment(int index) {
    setState(() {
      appointments[index].isAccepted = true;
    });
  }

  void rejectAppointment(int index) {
    // Perform the reject action here
    setState(() {
      appointments[index].isRejected = true;
    });
    // Add your logic to handle the reject action for the appointment at the given index
  }

  Future<void> postAppointment(Appointment data, int i) async {
    final url = Uri.parse(baseUrl + postApiAppointment);
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
      "CustomerName": data.customerName,
      "PhoneNumber": data.phoneNumber,
      "Email": data.email,
      "GenderTypeId": data.genderTypeId,
      "StatusTypeId": i,
      "PurposeOfVisitId": data.purposevisitid,
      "PurposeOfVisit": data.purposeofvisit,
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

  void fetchAppointments(int userId, int branchid, {required status, required date}) async {
    appointments.clear();
    final url = Uri.parse(baseUrl + GetAppointment + '$userId/$branchid/$status/$date');
    print('url==842===$url');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['ListResult'] != null) {
          final List<dynamic> appointmentsData = responseData['ListResult'];
          setState(() {
            appointments = appointmentsData.map((appointment) => Appointment.fromJson(appointment)).toList();
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

  Future<void> Get_ApprovedDeclinedSlots(Appointment data, int i) async {
    final url = Uri.parse(baseUrl + GetApprovedDeclinedSlots);
    print('url==>55555: $url');

    final request = {
      "Id": data.id,
      "StatusTypeId": 5,
      "BranchName": widget.branchname,
      "Date": data.date,
      "SlotTime": data.slotTime,
      "CustomerName": data.customerName,
      "PhoneNumber": widget.phonenumber,
      "Email": data.email,
      "Address": widget.branchaddress,
      "SlotDuration": data.SlotDuration
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
}
