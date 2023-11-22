
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'BranchModel.dart';
import 'CommonUtils.dart';
import 'appointmentlist.dart';
import 'api_config.dart';


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
 initState()   {
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
        _getbranchData(widget.userId);
      } else { CommonUtils.showCustomToastMessageLong('No Internet Connection', context, 1, 4);
      print('Not connected to the internet');  // Not connected to the internet
      }
    });




  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Column(
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
                              style: TextStyle(
                                color: Color(0xFFFB4110),
                                fontFamily: 'Calibri',
                                fontSize: 20
                              ),
                            ),
                            TextSpan(
                              text: 'Hair Fixing Zone',
                              style: TextStyle(
                                color: Color(0xFF163CF1),
                              fontFamily: 'Calibri',
                                fontSize: 20
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
            _isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: brancheslist.length,
                itemBuilder: (context, index) {
                  BranchModel branch = brancheslist[index];

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    child: IntrinsicHeight(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(42.5),
                          bottomLeft: Radius.circular(42.5),
                        ),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder:
                                (context)=>appointmentlist(userId:widget.userId, branchid:branch.id,branchname:branch.name ,filepath:branch.filePath,phonenumber:branch.mobileNumber,branchaddress:branch.address) ),);
                          },
                          child: Card(
                            shadowColor: Colors.transparent,
                            surfaceTintColor:Colors.transparent ,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(29.0),
                                bottomLeft: Radius.circular(29.0),
                              ),
                              //surfaceTintColor : Colors.red,

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
                                  // borderRadius: BorderRadius.only(
                                  //   topRight: Radius.circular(30.0),
                                  //   bottomLeft: Radius.circular(30.0),
                                  //
                                  // ),

                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 15.0),
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
                                          child: Image.network(
                                            imagesflierepo+
                                            branch.filePath,
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
                                                      print('Appointment Clicked ');

                                                      // Handle button press, navigate to a new screen
                                                      Navigator.of(context).push(MaterialPageRoute(builder:
                                                          (context)=>appointmentlist(userId:widget.userId, branchid:branch.id,branchname:branch.name ,filepath:branch.filePath,phonenumber:branch.mobileNumber,branchaddress:branch.address) ),);
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
                                          ],
                                        ),
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
                        )

                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );

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

  Future<void> _getbranchData(int userId) async {

    String apiUrl = baseUrl+GetBranchByUserId+'$userId';

    // Make the HTTP GET request
    final response = await http.get(Uri.parse(apiUrl));
    try {
      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response body
        final data = json.decode(response.body);
        print('Failed to fetch data:  $data');

        List<BranchModel> branchList = [];
        for (var item in data['ListResult']) {
          branchList.add(BranchModel(
            id: item['Id'],
            name: item['Name'],
            filePath: item['FilePath'],
            address: item['Address'],
            startTime: item['StartTime'],
            closeTime: item['CloseTime'],
            room: item['Room'],
            mobileNumber: item['MobileNumber'],
            isActive: item['IsActive'],
          ));
        }

        // Update the state with the fetched data
        setState(() {
          brancheslist = branchList;
        });
      }
      else {
        // Handle error if the API request was not successful
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any exception that occurred during the API call
      print('Error: $error');
    }
  }

}











