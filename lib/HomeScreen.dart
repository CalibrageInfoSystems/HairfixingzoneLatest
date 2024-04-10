import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hairfixingzone/UserSelectionScreen.dart';
import 'package:hairfixingzone/feedback.dart';
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
import 'BranchModel.dart';
import 'Branches_screen.dart';
import 'MyAppointments.dart';
import 'agentloginscreen.dart';
import 'api_config.dart';
import 'CommonUtils.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ExpandedTileController _expandedTileController;
  @override
  void initState() {
    // TODO: implement initState
    _expandedTileController = ExpandedTileController(isExpanded: false);

    super.initState();
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
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF44614), // Orange color

          centerTitle: true,
          // actions: [
          //   Align(
          //     alignment: Alignment.bottomRight,
          //     child: Container(
          //       //width: 115,
          //       height: 35,
          //       margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         border: Border.all(
          //             color: Color(0xFF8d97e2),
          //             width: 3
          //         ),
          //         borderRadius: BorderRadius.circular(10.0),
          //       ),
          //       child: ElevatedButton(
          //         onPressed: () {
          //           checkLoginStatus();
          //
          //
          //           // Handle button press
          //         },
          //         style: ElevatedButton.styleFrom(
          //           primary: Colors.transparent,
          //           onPrimary: Color(0xFF8d97e2),
          //           elevation: 0,
          //           shadowColor: Colors.transparent,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10.0),
          //           ),
          //         ),
          //         child: Row(
          //           mainAxisSize: MainAxisSize.min,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             Image.asset(
          //               'assets/agent_icon.png',
          //               width: 20,
          //               height: 20,
          //             ),
          //             SizedBox(width: 5),
          //             Text(
          //               'AGENT',
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.bold,
          //                 color: Color(0xFF042de3),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   )
          // ],

          title: Container(
            width: 85, // Adjust the width as needed
            height: 50, // Adjust the height as needed
            child: FractionallySizedBox(
              widthFactor: 1, // Adjust the width factor as needed (0.8 = 80% of available width)
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    // Remove the DecorationImage with AssetImage
                    ),
                child: Icon(Icons.place),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ExpandedTile(
                  controller: _expandedTileController,
                  theme: const ExpandedTileThemeData(
                    headerColor: Colors.transparent,
                    headerPadding: EdgeInsets.all(0),
                    headerSplashColor: Colors.transparent,
                    contentBackgroundColor: Colors.transparent,
                    // contentPadding: EdgeInsets.all(15),
                    // contentRadius: 12.0,
                  ),
                  leading: const Icon(
                    Icons.person,
                    color: Colors.black,
                    size: 22,
                  ),
                  title: const Text(
                    ' User Profile',
                    // style: TextStyle(),
                  ),
                  content: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            padding: const EdgeInsets.all(10), // Adjust padding as needed
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              CupertinoIcons.profile_circled,
                              size: 20, // Reduce the size of the icon
                              color: Colors.blue,
                            ),
                          ),
                          title: Text(
                            'Full Name',
                            // style: CommonUtils.txSty_14B_Fb,
                          ),
                          // subtitle: const Text(
                          //   'SlpCode',
                          //   style: CommonUtils.Mediumtext_12,
                          // ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            padding: const EdgeInsets.all(10), // Set padding to zero
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.email_outlined,
                              size: 20,
                              color: Colors.orange,
                            ),
                          ),
                          title: Text(
                            'Email',
                            //   style: CommonUtils.txSty_14B_Fb,
                          ),
                          // subtitle: const Text(
                          //   'Email',
                          //   style: CommonUtils.Mediumtext_12,
                          // ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.call,
                                size: 20,
                                color: Colors.red,
                              )),
                          title: Text(
                            '1234567890',
                            //    style: CommonUtils.txSty_14B_Fb
                          ),
                          // subtitle: const Text(
                          //   'Phone Number',
                          //   style: CommonUtils.Mediumtext_12,
                          // ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.male,
                                size: 20,
                                color: Colors.green,
                              )),
                          title: Text(
                            'Gender',
                            //style: CommonUtils.txSty_14B_Fb
                          ),
                          // subtitle: const Text(
                          //   'Company Name',
                          //   style: CommonUtils.Mediumtext_12,
                          // ),
                        ),
                        // if (reporingManagerName != null)
                        //   ListTile(
                        //     contentPadding: EdgeInsets.zero,
                        //     leading: Container(
                        //         padding: const EdgeInsets.all(10),
                        //         decoration: BoxDecoration(
                        //           color: const Color(0xFFe78337).withOpacity(0.2),
                        //           // color: const Color.fromARGB(
                        //           //     255, 178, 236, 180),
                        //           borderRadius: BorderRadius.circular(20),
                        //         ),
                        //         child: const Icon(
                        //           Icons.manage_accounts_rounded,
                        //           size: 20,
                        //           color: Color(0xFFe78337),
                        //         )),
                        //     title: Text('$reporingManagerName', style: CommonUtils.txSty_14B_Fb),
                        //     subtitle: const Text(
                        //       'Reporing Manager Name',
                        //       style: CommonUtils.Mediumtext_12,
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.place),
                title: Text(
                  'My Appointments',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'hind_semibold',
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyAppointments()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text(
                  'Feedback',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'hind_semibold',
                  ),
                ),
                onTap: () {
                  // Handle the onTap action for Logout
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => feedback_Screen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout), // Change the icon as needed
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'hind_semibold',
                  ),
                ),
                onTap: () {
                  // Handle the onTap action for Logout
                  logOutDialog();
                },
              ),
              // Add more ListTiles or other widgets as needed
            ],
          ),
        ),
        body: SliderScreen(),
      ),
    ));
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
      MaterialPageRoute(builder: (context) =>  UserSelectionScreen()),
          (route) => false,
    );
  }


// void checkLoginStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  //   print('isLoggedIn: $isLoggedIn');
  //   if (isLoggedIn) {
  //     int? userId = prefs.getInt('id'); // Retrieve the user ID
  //
  //     if (userId != null) {
  //       // Use the user ID as needed
  //       print('User ID: $userId');
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => Branches_screen(userId: userId)));
  //     } else {
  //       // Handle the case where the user ID is not available
  //       print('User ID not found in SharedPreferences');
  //     }
  //   } else {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => agentloginscreen()),
  //     );
  //   }
  // }
}

// class BannerImages {
//   final String imageName;
//   final int id;
//
//   BannerImages({required this.imageName, required this.id});
// }
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

class SliderScreen extends StatefulWidget {
  @override
  _SliderScreenState createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  List<BannerImages> imageList = [];

  List<BranchModel> brancheslist = [];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  bool isLoading = true;
  bool isDataBinding = false;
  bool apiAllowed = true;
  late Timer _timer;
  @override
  initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        print('Connected to the internet');
        fetchData();
        // Call API immediately when screen loads
        //  fetchData();
        //fetchimagesslider();
        fetchImages();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showBottomSheet(context);
        });
      } else {
        CommonUtils.showCustomToastMessageLong('No Internet Connection', context, 1, 4);
        print('Not connected to the internet'); // Not connected to the internet
      }
    });
  }

  void fetchData() async {
    setState(() {

      isLoading = true;
    });

    // Add a timeout of 8 seconds using Future.delayed
    Future.delayed(Duration(seconds: 15), () {
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
    Future.delayed(Duration(seconds: 15), () {
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
    _timer?.cancel();
    super.dispose();
  }
  // Future<void> _getDataWithinFiveSeconds() async {
  //   // Start a timer to measure the elapsed time
  //   Timer(Duration(seconds: 5), () {
  //     if (!isLoading) {
  //       print('API call within 5 seconds!');
  //       // Make the API call here
  //       _getData();
  //       fetchImages();
  //     } else {
  //       print('API call after 5seconds');
  //     }
  //   });
  // }

//   Future<void> _getData() async {
//     final url =  Uri.parse(baseUrl+getbranches);
//     print('url==>135: $url');
// //  final url = Uri.parse('http://182.18.157.215/SaloonApp/API/api/Banner/null');
//
//
//     final response = await http.get(url);
//
//     try {
//       // Check if the request was successful
//       if (response.statusCode == 200) {
//         // Parse the response body
//         final data = json.decode(response.body);
//         print('Failed to fetch data:  $data');
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
//         // Update the state with the fetched data
//         setState(() {
//           brancheslist = branchList;
//         });
//       }
//       else {
//         // Handle error if the API request was not successful
//         print('Request failed with status: ${response.statusCode}');
//       }
//     } catch (error) {
//       // Handle any exception that occurred during the API call
//       print('Error: $error');
//     }
//   }
//   Future<void> _getData() async {
//     setState(() {
//       isLoading = true; // Set isLoading to true before making the API call
//     });
//
//     final url = Uri.parse(baseUrl + getbranches);
//     print('url==>135: $url');
//
//     final response = await http.get(url);
//
//     try {
//       // Check if the request was successful
//       if (response.statusCode == 200) {
//         // Parse the response body
//         final data = json.decode(response.body);
//         print('Failed to fetch data:  $data');
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
//         // Update the state with the fetched data
//         setState(() {
//           brancheslist = branchList;
//           isLoading = false; // Set isLoading to false after data is fetched
//         });
//       } else {
//         // Handle error if the API request was not successful
//         print('Request failed with status: ${response.statusCode}');
//         setState(() {
//           isLoading = false; // Set isLoading to false if request fails
//         });
//       }
//     } catch (error) {
//       // Handle any exception that occurred during the API call
//       print('Error data is not getting from the api: $error');
//       setState(() {
//         isLoading = false; // Set isLoading to false if error occurs
//       });
//     }
//   }

  // Future<void> _getData() async {
  //   final url = Uri.parse(baseUrl + getbranches);
  //   print('branchesapi:$url');
  //   try {
  //     final response = await http.get(url);
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //
  //       List<BranchModel> branchList = [];
  //       for (var item in data['ListResult']) {
  //         branchList.add(BranchModel(
  //           id: item['Id'],
  //           name: item['Name'],
  //           filePath: item['FilePath'],
  //           address: item['Address'],
  //           startTime: item['StartTime'],
  //           closeTime: item['CloseTime'],
  //           room: item['Room'],
  //           mobileNumber: item['MobileNumber'],
  //           isActive: item['IsActive'],
  //         ));
  //       }
  //
  //       setState(() {
  //         brancheslist = branchList;
  //         isLoading = false;
  //       });
  //     } else {
  //       print('Request failed with status: ${response.statusCode}');
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } catch (error) {
  //     print('Error fetching data: $error');
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

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
              filePath: item['filePath'],
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

//   Future<void> fetchImages() async {
//     final url = Uri.parse(baseUrl + getBanners);
//     print('url==>127: $url');
// //  final url = Uri.parse('http://182.18.157.215/SaloonApp/API/api/Banner/null');
//
//     try {
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//
//         List<BannerImages> bannerImages = [];
//         for (var item in jsonData['ListResult']) {
//           bannerImages.add(BannerImages(FilePath: item['FilePath'], Id: item['Id']));
//         }
//
//         setState(() {
//           imageList = bannerImages;
//         });
//       } else {
//         // Handle error if the API request was not successful
//         print('Request failed with status: ${response.statusCode}');
//       }
//     } catch (error) {
//       // Handle any exception that occurred during the API call
//       print('Error: $error');
//     }
//   }

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: 'Welcome to ',
                    style: TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 20,
                      color: Color(0xFFFB4110),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Hair Fixing Zone',
                    style: TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 20,
                      color: Color(0xFF163CF1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: isDataBinding
                            ? Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : imageList.isEmpty
                                ? Center(
                                    // child: CircularProgressIndicator.adaptive(),
                                    child: Icon(
                                      Icons.signal_cellular_connected_no_internet_0_bar_sharp,
                                      color: Colors.red,
                                    ),
                                  )
                                : CarouselSlider(
                                    items: imageList
                                        .map((item) => Image.network(
                                              item.imageName,
                                              fit: BoxFit.fitWidth,
                                              width: MediaQuery.of(context).size.width,
                                            ))
                                        .toList(),
                                    carouselController: carouselController,
                                    options: CarouselOptions(
                                      scrollPhysics: const BouncingScrollPhysics(),
                                      autoPlay: true,
                                      aspectRatio: 23 / 9,
                                      viewportFraction: 1,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          currentIndex = index;
                                        });
                                      },
                                    ),
                                  ),
                      ),

                      // Align(
                      //   alignment: Alignment.topCenter,
                      //   child: Padding(
                      //     padding: EdgeInsets.only(top: 110.0),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: imageList.asMap().entries.map((entry) {
                      //         final index = entry.key;
                      //         return buildIndicator(index);
                      //       }).toList(),
                      //     ),
                      //   ),
                      // ),working code has been hide because it is intialize static padding
                      Container(
                        width: MediaQuery.of(context).size.width,
                        //  padding: EdgeInsets.all(20.0),

                        height: MediaQuery.of(context).size.height,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: imageList.asMap().entries.map((entry) {
                                final index = entry.key;
                                return buildIndicator(index);
                              }).toList(),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Branches',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Calibri',
                        fontSize: 20,
                        color: Color(0xFF163CF1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  Text('Please Wait Loading Slow Internet Connection !')
                else if (brancheslist.isEmpty && imageList.isEmpty)
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Failed to fetch data. Please check your internet connection.!'),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: retryDataFetching,
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                    flex: 3,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: isLoading ? 5 : brancheslist.length, // Display a fixed number of shimmer items when loading
                      itemBuilder: (context, index) {
                        if (isLoading) {
                          // Return shimmer effect if isLoading is true
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 150, // Adjust height as needed
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                // child: Shimmer.fromColors(
                                //   baseColor: Colors.grey.shade300,
                                //   highlightColor: Colors.grey.shade100,
                                //   child: ClipRRect(
                                //     borderRadius: BorderRadius.circular(7.0),
                                //     child: Image.network(
                                //       imagesflierepo,
                                //       width: 110,
                                //       height: 65,
                                //       fit: BoxFit.fill,
                                //       // loadingBuilder: (context, child, loadingProgress) {
                                //       //   if (loadingProgress == null) return child;
                                //       //
                                //       //   return const Center(child: CircularProgressIndicator.adaptive());
                                //       //   // You can use LinearProgressIndicator or CircularProgressIndicator instead
                                //       // },
                                //     ),
                                //   ),
                                // ),
                              ),
                            ),
                          );
                        } else {
                          // Return actual data when isLoading is false
                          BranchModel branch = brancheslist[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
                            child: IntrinsicHeight(
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(42.5),
                                  bottomLeft: Radius.circular(42.5),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => slotbookingscreen(branchId: branch.id, branchname: branch.name, branchlocation: branch.address, filepath: branch.filePath, MobileNumber: branch.mobileNumber)),
                                    );
                                  },
                                  child: Card(
                                    shadowColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(29.0),
                                        bottomLeft: Radius.circular(29.0),
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
                                                    imagesflierepo + branch.filePath,
                                                    width: 110,
                                                    height: 65,
                                                    fit: BoxFit.fill,
                                                    loadingBuilder: (context, child, loadingProgress) {
                                                      if (loadingProgress == null) return child;

                                                      return const Center(child: CircularProgressIndicator.adaptive());
                                                      // You can use LinearProgressIndicator or CircularProgressIndicator instead
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Padding(
                                            //   padding: EdgeInsets.only(left: 15.0),
                                            //   child: Container(
                                            //     width: 110,
                                            //     height: 65,
                                            //     decoration: BoxDecoration(
                                            //       borderRadius: BorderRadius.circular(10.0),
                                            //       border: Border.all(
                                            //         color: Color(0xFF9FA1EE),
                                            //         width: 3.0,
                                            //       ),
                                            //     ),
                                            //     child: ClipRRect(
                                            //       borderRadius: BorderRadius.circular(7.0),
                                            //       child: isLoading
                                            //           ? Shimmer.fromColors(
                                            //               baseColor: Colors.grey.shade300,
                                            //               highlightColor: Colors.white,
                                            //               child: Container(
                                            //                 width: 110,
                                            //                 height: 65,
                                            //                 decoration: BoxDecoration(
                                            //                   color: Colors.white,
                                            //                   borderRadius: BorderRadius.circular(7.0),
                                            //                 ),
                                            //               ),
                                            //             )
                                            //           : Image.network(
                                            //               imagesflierepo + branch.filePath,
                                            //               width: 110,
                                            //               height: 65,
                                            //               fit: BoxFit.fill,
                                            //             ),
                                            //     ),
                                            //   ),
                                            // ),

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
                                                              // Handle button press, navigate to a new screen
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => slotbookingscreen(branchId: branch.id, branchname: branch.name, branchlocation: branch.address, filepath: branch.filePath, MobileNumber: branch.mobileNumber)),
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
                        }
                      },
                    )

                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   itemCount: brancheslist.length,
                    //   itemBuilder: (context, index) {
                    //     BranchModel branch = brancheslist[index]; // Get the branch at the current index
                    //
                    //     return Padding(
                    //         padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
                    //         child: IntrinsicHeight(
                    //           child: ClipRRect(
                    //               borderRadius: BorderRadius.only(
                    //                 topRight: Radius.circular(42.5),
                    //                 bottomLeft: Radius.circular(42.5),
                    //               ),
                    //               child: GestureDetector(
                    //                 onTap: () {
                    //                   Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(builder: (context) => slotbookingscreen(branchId: branch.id, branchname: branch.name, branchlocation: branch.address, filepath: branch.filePath, MobileNumber: branch.mobileNumber)),
                    //                   );
                    //                 },
                    //                 child: Card(
                    //                   shadowColor: Colors.transparent,
                    //                   surfaceTintColor: Colors.transparent,
                    //                   child: ClipRRect(
                    //                     borderRadius: BorderRadius.only(
                    //                       topRight: Radius.circular(29.0),
                    //                       bottomLeft: Radius.circular(29.0),
                    //                     ),
                    //                     //surfaceTintColor : Colors.red,
                    //
                    //                     child: Container(
                    //                       decoration: BoxDecoration(
                    //                         gradient: LinearGradient(
                    //                           colors: [
                    //                             Color(0xFFFEE7E1), // Start color
                    //                             Color(0xFFD7DEFA),
                    //                           ],
                    //                           begin: Alignment.centerLeft,
                    //                           end: Alignment.centerRight,
                    //                         ),
                    //                         // borderRadius: BorderRadius.only(
                    //                         //   topRight: Radius.circular(30.0),
                    //                         //   bottomLeft: Radius.circular(30.0),
                    //                         //
                    //                         // ),
                    //                       ),
                    //                       child: Row(
                    //                         crossAxisAlignment: CrossAxisAlignment.center,
                    //                         children: [
                    //                           Padding(
                    //                             padding: EdgeInsets.only(left: 15.0),
                    //                             child: Container(
                    //                               width: 110,
                    //                               height: 65,
                    //                               decoration: BoxDecoration(
                    //                                 borderRadius: BorderRadius.circular(10.0),
                    //                                 border: Border.all(
                    //                                   color: Color(0xFF9FA1EE),
                    //                                   width: 3.0,
                    //                                 ),
                    //                               ),
                    //                               child: ClipRRect(
                    //                                 borderRadius: BorderRadius.circular(7.0),
                    //                                 child: Image.network(
                    //                                   imagesflierepo + branch.filePath,
                    //                                   width: 110,
                    //                                   height: 65,
                    //                                   fit: BoxFit.fill,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                           Expanded(
                    //                             child: Padding(
                    //                               padding: EdgeInsets.only(left: 15.0),
                    //                               child: Column(
                    //                                 mainAxisAlignment: MainAxisAlignment.start,
                    //                                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                                 children: [
                    //                                   Padding(
                    //                                     padding: EdgeInsets.only(top: 15.0),
                    //                                     child: Text(
                    //                                       branch.name,
                    //                                       style: TextStyle(
                    //                                         fontSize: 18,
                    //                                         color: Color(0xFFFB4110),
                    //                                         fontWeight: FontWeight.bold,
                    //                                         fontFamily: 'Calibri',
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                   SizedBox(height: 4.0),
                    //                                   Expanded(
                    //                                     child: Padding(
                    //                                       padding: EdgeInsets.only(right: 10.0),
                    //                                       child: Column(
                    //                                         crossAxisAlignment: CrossAxisAlignment.start,
                    //                                         children: [
                    //                                           Row(
                    //                                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //                                             children: [
                    //                                               Image.asset(
                    //                                                 'assets/location_icon.png',
                    //                                                 width: 20,
                    //                                                 height: 18,
                    //                                               ),
                    //                                               SizedBox(width: 4.0),
                    //                                               Expanded(
                    //                                                 child: Text(
                    //                                                   branch.address,
                    //                                                   style: TextStyle(
                    //                                                     fontFamily: 'Calibri',
                    //                                                     fontSize: 12,
                    //                                                     color: Color(0xFF000000),
                    //                                                   ),
                    //                                                 ),
                    //                                               ),
                    //                                             ],
                    //                                           ),
                    //                                           Spacer(flex: 3),
                    //                                         ],
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                   Align(
                    //                                     alignment: Alignment.bottomRight,
                    //                                     child: Container(
                    //                                       height: 26,
                    //                                       margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                    //                                       decoration: BoxDecoration(
                    //                                         color: Colors.white,
                    //                                         border: Border.all(
                    //                                           color: Color(0xFF8d97e2),
                    //                                         ),
                    //                                         borderRadius: BorderRadius.circular(10.0),
                    //                                       ),
                    //                                       child: ElevatedButton(
                    //                                         onPressed: () {
                    //                                           // Handle button press
                    //                                         },
                    //                                         style: ElevatedButton.styleFrom(
                    //                                           primary: Colors.transparent,
                    //                                           onPrimary: Color(0xFF8d97e2),
                    //                                           elevation: 0,
                    //                                           shadowColor: Colors.transparent,
                    //                                           shape: RoundedRectangleBorder(
                    //                                             borderRadius: BorderRadius.circular(10.0),
                    //                                           ),
                    //                                         ),
                    //                                         child: GestureDetector(
                    //                                           onTap: () {
                    //                                             print('booknowbuttonisclciked');
                    //                                             print(branch.id);
                    //                                             print(branch.name);
                    //                                             // Handle button press, navigate to a new screen
                    //                                             Navigator.push(
                    //                                               context,
                    //                                               MaterialPageRoute(
                    //                                                   builder: (context) => slotbookingscreen(branchId: branch.id, branchname: branch.name, branchlocation: branch.address, filepath: branch.filePath, MobileNumber: branch.mobileNumber)),
                    //                                             );
                    //                                           },
                    //                                           child: Row(
                    //                                             mainAxisSize: MainAxisSize.min,
                    //                                             children: [
                    //                                               SvgPicture.asset(
                    //                                                 'assets/datepicker_icon.svg',
                    //                                                 width: 15.0,
                    //                                                 height: 15.0,
                    //                                               ),
                    //                                               SizedBox(width: 5),
                    //                                               Text(
                    //                                                 'Book Now',
                    //                                                 style: TextStyle(
                    //                                                   fontSize: 13,
                    //                                                   color: Color(0xFF8d97e2),
                    //                                                 ),
                    //                                               ),
                    //                                             ],
                    //                                           ),
                    //                                         ),
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               )),
                    //         ));
                    //   },
                    // ),
                    ),

                // width: 300.0,
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      border: Border.all(
                        color: Color(0xFFFB4110),
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        const url = 'https://www.hairfixingzone.com/';
                        try {
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        } catch (e) {
                          print('Error launching URL: $e');
                        }
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/web_icon.png',
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Click Here for Website',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFFB4110),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildIndicator(int index) {
    return Container(
      width: 8,
      height: 8,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == currentIndex ? Colors.orange : Colors.grey,
      ),
    );
  }
  TextEditingController _commentstexteditcontroller = TextEditingController();
  double rating_star = 0.0;

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,

            /// height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(
              top: 15.0,
              left: 15.0,
              right: 15.0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
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
                        validaterating();
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
        );
      },
    );
  }

  Future<void> validaterating() async {
    bool isValid = true;
    bool hasValidationFailed = false;
    if (rating_star != null && rating_star <= 0.0) {
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
    }
  }
}
