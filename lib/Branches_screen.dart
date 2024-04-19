import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'BranchModel.dart';
import 'CommonUtils.dart';
import 'UserSelectionScreen.dart';
import 'ViewConsultations.dart';
import 'appointmentlist.dart';
import 'api_config.dart';
import 'consultation_creation_screen.dart';
// import 'consultation_creation_screen.dart';

class Branches_screen extends StatefulWidget {
  final int userId;

  Branches_screen({required this.userId});
  @override
  _BranchesscreenState createState() => _BranchesscreenState();
}

class _BranchesscreenState extends State<Branches_screen> {
  List<BranchModel> brancheslist = [];
  bool _isLoading = false;
  @override
  initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
// Print the userId
    print('User ID: ${widget.userId}');

    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        print('Connected to the internet');
        // _getBranchData(widget.userId);
        fetchData();
      } else {
        CommonUtils.showCustomToastMessageLong('No Internet Connection', context, 1, 4);
        print('Not connected to the internet'); // Not connected to the internet
      }
    });
  }

  void retryDataFetching() {
    // setState(() {
    //   isLoading = true; // Set isLoading to true to show loading indicator
    // });
    // _getData(); // Call your API method to fetch data
    // fetchImages(); // Call your API method to fetch images
    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        fetchData();
        print('Connected to the internet');
        // _getBranchData(widget.userId);
      } else {
        CommonUtils.showCustomToastMessageLong('No Internet Connection', context, 1, 4);
        print('Not connected to the internet'); // Not connected to the internet
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final desiredWidth = screenWidth;
    return WillPopScope(
        onWillPop: () async {
          // Show a confirmation dialog
          bool confirmClose = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirm Exit'),
                content: Text('Are you sure you want to close the app?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false), // Close the dialog and return false
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true), // Close the dialog and return true
                    child: Text('Yes'),
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
          return false;
        },
        child: Scaffold(
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
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    logOutDialog();
                    // Add logout functionality here
                  },
                ),
              ],
            ),
            body:
            // SingleChildScrollView(
            //   child:
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Calibri',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decorationColor: Colors.transparent,
                                  decoration: TextDecoration.none,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Welcome to ',
                                    style: TextStyle(color: Color(0xFFFB4110), fontFamily: 'Calibri', fontSize: 20),
                                  ),
                                  TextSpan(
                                    text: 'Hair Fixing Zone',
                                    style: TextStyle(color: Color(0xFF163CF1), fontFamily: 'Calibri', fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // _isLoading
                  //     ? Center(
                  //   child: CircularProgressIndicator(),
                  // )
                  // :.

                  Center(
                    child: Column(
                      children: [
                        if (_isLoading)
                          Container(
                            child: Align(
                              alignment: Alignment.center,
                              child: Center(
                                child: Column(
                                  children: [
                                    Text('Please Wait Loading Slow Internet Connection !'),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else if (brancheslist.isEmpty)
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Failed to fetch data. Please Check Your Internet Connection.!'),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: retryDataFetching,
                                    child: Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _isLoading ? 5 : brancheslist.length,
                      itemBuilder: (context, index) {
                        if (_isLoading) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      width: 110,
                                      height: 65,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: Color(0xFF9FA1EE),
                                          width: 3.0,
                                        ),
                                      ),
                                      child: Image.asset(
                                        'assets/background.png', // Replace with your placeholder image path
                                        width: 110,
                                        height: 65,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )),
                            ),
                          );
                        } else {
                          BranchModel branch = brancheslist[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                            child: IntrinsicHeight(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.0),
                                    bottomLeft: Radius.circular(15.0),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigator.of(context).push(
                                      //   MaterialPageRoute(
                                      //       builder: (context) => appointmentlist(
                                      //           userId: widget.userId,
                                      //           branchid: branch.id,
                                      //           branchname: branch.name,
                                      //           filepath: branch.imageName != null ? imagesflierepo + branch.imageName! : 'assets/top_image.png',
                                      //           phonenumber: branch.mobileNumber,
                                      //           branchaddress: branch.address)),
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
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 15.0,top:10.0),
                                                    child: Container(
                                                      width: 110,
                                                      height: 65,
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
                                                          width: 110,
                                                          height: 65,
                                                          fit: BoxFit.fill,
                                                          loadingBuilder: (context, child, loadingProgress) {
                                                            if (loadingProgress == null) return child;

                                                            return const Center(child: CircularProgressIndicator.adaptive());
                                                          },
                                                        )
                                                            : Image.asset(
                                                          'assets/top_image.png',
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
                                                          Padding(
                                                            padding: EdgeInsets.only(right: 10.0),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10.0),
                                              Container(
                                                height: 26,
                                                margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                                                // decoration: BoxDecoration(
                                                //   color: Colors.white,
                                                //   border: Border.all(
                                                //     color: Color(0xFF8d97e2),
                                                //   ),
                                                //   borderRadius: BorderRadius.circular(10.0),
                                                // ),
                                                child:
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Container(
                                                      height: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: Color(0xFF8d97e2),
                                                        ),
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),// Ensure the button takes the full height of the parent container
                                                      child: Align(
                                                        alignment: Alignment.bottomRight,
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
                                                              print('Check Appointment Clicked ');

                                                              // Handle button press, navigate to a new screen
                                                              Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                  builder: (context) => appointmentlist(
                                                                    userId: widget.userId,
                                                                    branchid: branch.id,
                                                                    branchname: branch.name,
                                                                    filepath: branch.imageName != null ? branch.imageName! : 'assets/top_image.png',
                                                                    phonenumber: branch.mobileNumber,
                                                                    branchaddress: branch.address,
                                                                  ),
                                                                ),
                                                              );
                                                            },
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
                                                                  'Check Appointment',
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: Color(0xFF8d97e2),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10), // Add some spacing between the buttons
                                                    Container(
                                                      height: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: Color(0xFF8d97e2),
                                                        ),
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),// Ensure the button takes the full height of the parent container
                                                      child: Align(
                                                        alignment: Alignment.bottomRight,
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
                                                              print('See Appointment Clicked ');
                                                              Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                  builder: (context) => ViewConsultations(
                                                                    branchid: widget.userId,
                                                                    // branchid: branch.id,
                                                                  ),
                                                                ),
                                                              );
                                                              // Handle button press for "See Appointment"
                                                            },
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Icon(
                                                                  Icons.calendar_today,
                                                                  size: 15.0,
                                                                  color: Color(0xFF8d97e2),
                                                                ),
                                                                SizedBox(width: 5),
                                                                Text(
                                                                  'View Consultations',
                                                                  style: TextStyle(
                                                                    fontSize: 12,
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


                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    // child: Card(
                                    //   shadowColor: Colors.grey,
                                    //   elevation: 10,
                                    //   child: Container(
                                    //     decoration: BoxDecoration(
                                    //       gradient: LinearGradient(
                                    //         colors: [
                                    //           Color(0xFFFEE7E1), // Start color
                                    //           Color(0xFFD7DEFA)
                                    //         ],
                                    //         begin: Alignment.centerLeft,
                                    //         end: Alignment.centerRight,
                                    //       ),
                                    //       borderRadius: BorderRadius.only(
                                    //         topRight: Radius.circular(30.0),
                                    //         bottomLeft: Radius.circular(30.0),
                                    //       ),
                                    //     ),
                                    //     child: Row(
                                    //       crossAxisAlignment: CrossAxisAlignment.center,
                                    //       children: [
                                    //         Padding(
                                    //           padding: EdgeInsets.only(left: 15.0),
                                    //           child: Container(
                                    //             width: 110,
                                    //             height: 65,
                                    //             decoration: BoxDecoration(
                                    //               borderRadius: BorderRadius.circular(10.0),
                                    //               border: Border.all(
                                    //                 color: Color(0xFF9FA1EE),
                                    //                 width: 3.0,
                                    //               ),
                                    //             ),
                                    //             child: ClipRRect(
                                    //               borderRadius: BorderRadius.circular(7.0),
                                    //               child: Image.network(
                                    //                 branch.filePath,
                                    //                 width: 110,
                                    //                 height: 65,
                                    //                 fit: BoxFit.fill,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         Expanded(
                                    //           child: Padding(
                                    //             padding: EdgeInsets.only(left: 15.0),
                                    //             child: Column(
                                    //               mainAxisAlignment: MainAxisAlignment.start,
                                    //               crossAxisAlignment: CrossAxisAlignment.start,
                                    //               children: [
                                    //                 Padding(
                                    //                   padding: EdgeInsets.only(top: 15.0),
                                    //                   child: Text(
                                    //                     branch.name,
                                    //                     style: TextStyle(
                                    //                       fontSize: 18,
                                    //                       color: Color(0xFFFB4110),
                                    //                       fontWeight: FontWeight.bold,
                                    //                       fontFamily: 'Calibri',
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //                 SizedBox(height: 4.0),
                                    //                 Expanded(
                                    //                   child: Padding(
                                    //                     padding: EdgeInsets.only(right: 10.0),
                                    //                     child: Column(
                                    //                       crossAxisAlignment: CrossAxisAlignment.start,
                                    //                       children: [
                                    //                         Row(
                                    //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                           children: [
                                    //                             Image.asset(
                                    //                               'assets/location_icon.png',
                                    //                               width: 20,
                                    //                               height: 18,
                                    //                             ),
                                    //                             SizedBox(width: 4.0),
                                    //                             Expanded(
                                    //                               child: Text(
                                    //                                 branch.address,
                                    //                                 style: TextStyle(
                                    //                                   fontFamily: 'Calibri',
                                    //                                   fontSize: 12,
                                    //                                   color: Color(0xFF000000),
                                    //                                 ),
                                    //                               ),
                                    //                             ),
                                    //                           ],
                                    //                         ),
                                    //                         Spacer(
                                    //                           flex: 3,
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //                 Align(
                                    //                   alignment: Alignment.bottomRight,
                                    //                   child: Container(
                                    //                     height: 26,
                                    //                     margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                                    //                     decoration: BoxDecoration(
                                    //                       color: Colors.white,
                                    //                       border: Border.all(
                                    //                         color: Color(0xFF8d97e2),
                                    //                       ),
                                    //                       borderRadius: BorderRadius.circular(10.0),
                                    //                     ),
                                    //                     child: ElevatedButton(
                                    //                       onPressed: () {
                                    //                         Navigator.of(context).push(MaterialPageRoute(builder:
                                    //                             (context)=>appointmentlist(userId:widget.userId, branchid:branch.id,branchname:branch.name ,filepath:branch.filePath) ),);
                                    //                         // Handle button press
                                    //                         //  _handleButtonPress();
                                    //                       },
                                    //                       style: ElevatedButton.styleFrom(
                                    //                         primary: Colors.transparent,
                                    //                         onPrimary: Color(0xFF8d97e2),
                                    //                         elevation: 0,
                                    //                         shadowColor: Colors.transparent,
                                    //                         shape: RoundedRectangleBorder(
                                    //                           borderRadius: BorderRadius.circular(10.0),
                                    //                         ),
                                    //                       ),
                                    //                       child: GestureDetector(
                                    //                         onTap: () {
                                    //                           // Handle button press, navigate to a new screen
                                    //                           // Navigator.push(
                                    //                           //   context,
                                    //                           //   MaterialPageRoute(builder: (context) => appointmentlist(userId:widget.userId, branchid:branch.id,branchname:branch.name   )),
                                    //                           // );
                                    //                         },
                                    //                         child: Row(
                                    //                           mainAxisSize: MainAxisSize.min,
                                    //                           children: [
                                    //                             SvgPicture.asset(
                                    //                               'assets/datepicker_icon.svg',
                                    //                               width: 15.0,
                                    //                               height: 15.0,
                                    //                             ),
                                    //                             SizedBox(width: 5),
                                    //                             Text(
                                    //                               'Check Appointment',
                                    //                               style: TextStyle(
                                    //                                   fontSize: 12,
                                    //                                   color: Color(0xFF8d97e2),
                                    //                                   fontWeight: FontWeight.bold,
                                    //                                   fontFamily: 'Calibri'
                                    //                               ),
                                    //                             ),
                                    //                           ],
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                  )),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ConsulationCreationScreen(userid: widget.userId)),
                          );
                        },
                        child: Container(
                          width: desiredWidth * 0.9,
                          height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Color(0xFFFB4110),
                          ),
                          child: Center(
                            child: Text(
                              'Add Consultation',
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
                ],
              ),
              //   ),
            )));
  }

  void _handleButtonPress() {
    setState(() {
      _isLoading = true;
    });

    // Perform your operations here

    // After the operations are completed, update the state to hide the progress indicator
    setState(() {
      _isLoading = false;
    });
  }

  void fetchData() async {
    setState(() {
      _isLoading = true;
    });

    // Add a timeout of 8 seconds using Future.delayed
    Future.delayed(Duration(seconds: 15), () {
      if (_isLoading) {
        setState(() {
          _isLoading = false;
          brancheslist.clear(); // Clear the list if timeout occurs
        });
      }
    });

    await _getBranchData(widget.userId); // Call your API method
  }

  Future<void> _getBranchData(int userId) async {
    // setState(() {
    //   _isLoading = true; // Set isLoading to true before making the API call
    // });

    String apiUrl = baseUrl + GetBranchByUserId + '$userId';
    // const maxRetries = 1; // Set maximum number of retries
    // int retries = 0;

    //while (retries < maxRetries) {
    try {
      // Make the HTTP GET request with a timeout of 30 seconds
      final response = await http.get(Uri.parse(apiUrl));
      print('apiUrl: $apiUrl');
      if (response.statusCode == 200) {
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

        setState(() {
          brancheslist = branchList;
          _isLoading = false;
        });
        return; // Exit the function after successful response
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    // retries++;
    // await Future.delayed(Duration(seconds: 2 * retries)); // Exponential backoff
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

  Future<void> onConfirmLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.remove('userId'); // Remove userId from SharedPreferences
    prefs.remove('userRoleId'); // Remove roleId from SharedPreferences
    CommonUtils.showCustomToastMessageLong("Logout Successful", context, 0, 3);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => UserSelectionScreen()),
          (route) => false,
    );
  }

// Handle the case where all retries failed
// print('All retries failed. Unable to fetch data from the API.');
//  setState(() {
//    _isLoading = false;
//  });
}

// Future<void> _getBranchData(int userId) async {
//   setState(() {
//     _isLoading = true; // Set isLoading to true before making the API call
//   });
//
//   String apiUrl = baseUrl + GetBranchByUserId + '$userId';
//   const maxRetries = 1; // Set maximum number of retries
//   int retries = 0;
//
//   while (retries < maxRetries) {
//     try {
//       // Make the HTTP GET request with a timeout of 30 seconds
//       final response = await http.get(Uri.parse(apiUrl)).timeout(Duration(seconds: 30));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         List<BranchModel> branchList = [];
//         for (var item in data['ListResult']) {
//           branchList.add(BranchModel(
//             id: item['Id'],
//             name: item['Name'],
//             filePath: item['FilePath'],
//             address: item['Address'],
//             startTime: item['StartTime'],
//             closeTime: item['CloseTime'],
//             room: item['Room'],
//             mobileNumber: item['MobileNumber'],
//             isActive: item['IsActive'],
//           ));
//         }
//
//         setState(() {
//           brancheslist = branchList;
//           _isLoading = false;
//         });
//         return; // Exit the function after successful response
//       } else {
//         print('Request failed with status: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error: $error');
//     }
//
//     retries++;
//     await Future.delayed(Duration(seconds: 2 * retries)); // Exponential backoff
//   }
//
//   // Handle the case where all retries failed
//   print('All retries failed. Unable to fetch data from the API.');
//   setState(() {
//     _isLoading = false;
//   });
// }
