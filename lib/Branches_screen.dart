import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'Agentappointmentlist.dart';
import 'BranchModel.dart';
import 'Common/common_styles.dart';
import 'CommonUtils.dart';
import 'UserSelectionScreen.dart';
import 'ViewConsultations.dart';
import 'appointmentlist.dart';
import 'api_config.dart';
import 'consultation_creation_screen.dart';
// import 'consultation_creation_screen.dart';

class Branches_screen extends StatefulWidget {
  final int userId;

  const Branches_screen({super.key, required this.userId});

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
        CommonUtils.showCustomToastMessageLong('Please Check Your Internet Connection', context, 1, 4);
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

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFf3e3ff),
          title: const Text(
            'Select Branch',
            style: TextStyle(color: Color(0xFF0f75bc), fontSize: 16.0, fontFamily: "Calibri", fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: CommonUtils.primaryTextColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: brancheslist.length,
            itemBuilder: (context, index) {
              BranchModel branchnames = brancheslist[index];
              String? imageUrl = branchnames.imageName;
              if (imageUrl == null || imageUrl.isEmpty) {
                imageUrl = 'assets/top_image.png';
              }
              return BranchTemplate(branchnames: branchnames, imageUrl: imageUrl, userId: widget.userId);
            },
          )

              //   ListView.builder(
              //     itemCount: brancheslist.length,
              //     // shrinkWrap: true,
              //     // physics: const PageScrollPhysics(),
              //     itemBuilder: (context, index) {
              //       BranchModel branchnames = brancheslist[index];
              //       String? imageUrl = branchnames.imageName;
              //       if (imageUrl == null || imageUrl.isEmpty) {
              //         imageUrl = 'assets/top_image.png';
              //       }
              //       return BranchTemplate(
              //           branchnames: branchnames, imageUrl: imageUrl, userId: widget.userId);
              //     },
              //   ),
              // ),
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

  void fetchData() async {
    setState(() {
      _isLoading = true;
    });

    // Add a timeout of 8 seconds using Future.delayed
    Future.delayed(const Duration(seconds: 15), () {
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

    String apiUrl = '$baseUrl$GetBranchByUserId$userId/null';
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
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirmLogout();
              },
              child: const Text('Yes'),
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

class BranchTemplate extends StatelessWidget {
  final BranchModel branchnames;
  final String imageUrl;
  final int userId;
  const BranchTemplate({super.key, required this.branchnames, required this.imageUrl, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Agentappointmentlist(
                  userId: userId,
                  branchid: branchnames.id!,
                  branchname: branchnames.name,
                  filepath: branchnames.imageName != null ? branchnames.imageName! : 'assets/top_image.png',
                  phonenumber: branchnames.mobileNumber,
                  branchaddress: branchnames.address,
                ),
              ),
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width,
            // decoration: BoxDecoration(
            //   border: Border.all(color: Color(0xFF662e91), width: 1.0),
            //   borderRadius: BorderRadius.circular(10.0),
            // ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              // borderRadius: BorderRadius.circular(30), //border corner radius
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF960efd).withOpacity(0.2), //color of shadow
                  spreadRadius: 2, //spread radius
                  blurRadius: 4, // blur radius
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  // width: MediaQuery.of(context).size.width / 4,
                  child: Image.network(
                    imageUrl.isNotEmpty ? imageUrl : 'https://example.com/placeholder-image.jpg',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height / 4 / 2,
                    width: MediaQuery.of(context).size.width / 3.2,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/hairfixing_logo.png', // Path to your PNG placeholder image
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height / 4 / 2,
                        width: MediaQuery.of(context).size.width / 3.2,
                      );
                    },
                  ),
                ),
                Container(
                  // height: MediaQuery.of(context).size.height / 4 / 2,

                  width: MediaQuery.of(context).size.width / 2.2,
                  padding: EdgeInsets.only(top: 7),
                  // width: MediaQuery.of(context).size.width / 4,
                  child: Column(
                    //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${branchnames.name}',
                        style: TextStyle(
                          color: Color(0xFF0f75bc),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('${branchnames.address}', maxLines: 2, overflow: TextOverflow.ellipsis, style: CommonStyles.txSty_12b_f5),
                    ],
                  ),
                )
              ],
            ),
          )
          // Container(
          //   height: MediaQuery.of(context).size.height / 8,
          //   width: MediaQuery.of(context).size.width,
          //   // decoration: BoxDecoration(
          //   //   border: Border.all(color: Color(0xFF662e91), width: 1.0),
          //   //   borderRadius: BorderRadius.circular(10.0),
          //   // ),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(10.0),
          //     // borderRadius: BorderRadius.circular(30), //border corner radius
          //     boxShadow: [
          //       BoxShadow(
          //         color:
          //         const Color(0xFF960efd).withOpacity(0.2), //color of shadow
          //         spreadRadius: 2, //spread radius
          //         blurRadius: 4, // blur radius
          //         offset: const Offset(0, 2), // changes position of shadow
          //       ),
          //     ],
          //   ),
          //   child: Row(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(left: 15.0, top: 0.0),
          //         child: SizedBox(
          //           width: MediaQuery.of(context).size.width / 3,
          //           height: 65,
          //           // decoration: BoxDecoration(
          //           //   borderRadius: BorderRadius.circular(10.0),
          //           //   border: Border.all(
          //           //     color: Color(0xFF9FA1EE),
          //           //     width: 3.0,
          //           //   ),
          //           // ),
          //           child: ClipRRect(
          //             borderRadius: BorderRadius.circular(8.0),
          //             child: Image.network(
          //               imageUrl.isNotEmpty
          //                   ? imageUrl
          //                   : 'https://example.com/placeholder-image.jpg',
          //               fit: BoxFit.cover,
          //               height: MediaQuery.of(context).size.height / 4 / 2,
          //               width: MediaQuery.of(context).size.width / 3.2,
          //               errorBuilder: (context, error, stackTrace) {
          //                 return Image.asset(
          //                   'assets/hairfixing_logo.png', // Path to your PNG placeholder image
          //                   fit: BoxFit.cover,
          //                   height: MediaQuery.of(context).size.height / 4 / 2,
          //                   width: MediaQuery.of(context).size.width / 3.2,
          //                 );
          //               },
          //             ),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(
          //         width: 5,
          //       ),
          //       Padding(
          //           padding: const EdgeInsets.only(left: 5.0, top: 10.0),
          //           child: SizedBox(
          //             width: MediaQuery.of(context).size.width / 2.5,
          //             //    padding: EdgeInsets.only(top: 7),
          //             // width: MediaQuery.of(context).size.width / 4,
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   branchnames.name,
          //                   style: const TextStyle(
          //                     color: Color(0xFF0f75bc),
          //                     fontSize: 14.0,
          //                     fontWeight: FontWeight.w600,
          //                   ),
          //                 ),
          //                 const SizedBox(
          //                   height: 5,
          //                 ),
          //                 Text(
          //                   branchnames.address,
          //                   style: const TextStyle(
          //                       color: Colors.black,
          //                       fontSize: 12.0,
          //                       fontWeight: FontWeight.w600),
          //                   maxLines: 3,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               ],
          //             ),
          //           ))
          //     ],
          //   ),
          // ),
          ),
    );
  }
}
