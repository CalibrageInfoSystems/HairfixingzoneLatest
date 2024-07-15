import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hairfixingzone/BranchesModel.dart';
import 'package:hairfixingzone/Common/common_styles.dart';
import 'package:hairfixingzone/aboutus_screen.dart';
import 'package:hairfixingzone/api_config.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'BranchModel.dart';
import 'CommonUtils.dart';
import 'HomeScreen.dart';
import 'Model_Branch.dart';

class Dashboard_Screen extends StatelessWidget {
  const Dashboard_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TwoCardPageView(),
    );
  }
}

class TwoCardPageView extends StatefulWidget {
  const TwoCardPageView({super.key});

  @override
  _TwoCardPageViewState createState() => _TwoCardPageViewState();
}

class _TwoCardPageViewState extends State<TwoCardPageView> {
  List<Item> _items = [];
  int? userId;
  String? marqueeText;
  Future<List<Model_branch>>? apiData;
  String userFullName = '';
  String email = '';
  String phonenumber = '';
  bool isDataBinding = false;

//  String gender ='';
  String Gender = '';
  final bool _shouldStartMarquee =
  true; // Variable to control Marquee scrolling

  // final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    checkLoginuserdata();
    _fetchItems();
    apiData = getBranchsData();
    getMarqueeText();
  }

  void _fetchItems() async {
    final response = await http.get(Uri.parse(baseUrl + getbanner));
    setState(() {
      isDataBinding = true;
    });
    if (response.statusCode == 200) {
      setState(() {
        _items = (json.decode(response.body)['listResult'] as List)
            .map((item) => Item.fromJson(item))
            .toList();
        isDataBinding = false;
      });
    } else {
      isDataBinding = false;
      throw Exception('Failed to load items');
    }
  }

  Future<void> getMarqueeText() async {
    final apiUrl = Uri.parse(baseUrl + getcontent);

    try {
      final jsonResponse = await http.get(apiUrl);

      if (jsonResponse.statusCode == 200) {
        final response = json.decode(jsonResponse.body);

        if (response['isSuccess']) {
          int records = response['affectedRecords'];
          for (var i = 0; i < records; i++) {
            marqueeText = response['listResult'][i]['text'] != null
                ? '${response['listResult'][i]['text']}  -  '
                : null;
            // marqueeText += response['listResult'][i]['text'];
          }
        } else {
          print('api failed');
          throw Exception('api failed');
        }
      } else {
        throw Exception(
            'Request failed with status: ${jsonResponse.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: CommonStyles.primaryTextColor,
      body: SliderScreen(),
//       // SingleChildScrollView(
//       //
//       //   child:
//         Container(
//           height: MediaQuery.of(context).size.height,
//          // color: Colors.white, // Set the background color to white
// decoration: BoxDecoration(
//   color: Colors.white
// ),
//         child: Column(
//           children: [
//             //MARK: Marquee
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 FutureBuilder(
//                   future: getMarqueeText(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const SizedBox();
//                     } else if (snapshot.hasError) {
//                       return const SizedBox();
//                     } else {
//                       if (marqueeText != null) {
//                         return SizedBox(
//                           height: 30,
//                           child: Marquee(
//                             text: marqueeText!,
//                             style: const TextStyle(
//                                 fontSize: 16,
//                                 fontFamily: "Calibri",
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFFff0176)),
//                             velocity: _shouldStartMarquee
//                                 ? 30
//                                 : 0, // Control Marquee scrolling with velocity
//                           ),
//                         );
//                       } else {
//                         return const SizedBox();
//                       }
//                     }
//                   },
//                 ),
//                 //MARK: Carousel widget
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   height: 180,
//                   child: FlutterCarousel(
//                     options: CarouselOptions(
//                       showIndicator: true,
//                       autoPlay: true,
//                       floatingIndicator: false,
//                       autoPlayCurve: Curves.linear,
//                       slideIndicator: const CircularSlideIndicator(
//                         indicatorBorderColor: CommonStyles.blackColor,
//                         currentIndicatorColor: CommonStyles.primaryTextColor,
//                         indicatorRadius: 2,
//                       ),
//                     ),
//                     items: _items.map((item) {
//                       return Builder(
//                         builder: (BuildContext context) {
//                           return SizedBox(
//                             width: MediaQuery.of(context).size.width,
//                             child: Card(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               elevation: 4,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Image.network(
//                                   item.imageName,
//                                   height: 100,
//                                   fit: BoxFit.cover,
//                                   loadingBuilder:
//                                       (context, child, loadingProgress) {
//                                     if (loadingProgress == null) return child;
//                                     return const Center(
//                                         child: CircularProgressIndicator
//                                             .adaptive());
//                                   },
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     }).toList(),
//                   ),
//                 ),
//
//                 // Carousel indicator
//                 // CarouselIndicator(
//                 //   currentPage: _currentPage,
//                 //   itemCount: _items.length,
//                 //   onPageChanged: (int page) {
//                 //     setState(() {
//                 //       _currentPage = page;
//                 //     });
//                 //   },
//                 // ),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.center,
//                 //   children: <Widget>[
//                 //     for (int i = 0; i < _items.length; i++)
//                 //       GestureDetector(
//                 //         onTap: () {
//                 //           setState(() {
//                 //             _currentPage = i;
//                 //           });
//                 //         },
//                 //         child: Container(
//                 //           margin: const EdgeInsets.all(2),
//                 //           width: 10,
//                 //           height: 10,
//                 //           decoration: BoxDecoration(
//                 //             borderRadius: BorderRadius.circular(10),
//                 //             border: Border.all(
//                 //                 color: CommonStyles.primaryTextColor,
//                 //                 width: 1.5),
//                 //             color: _currentPage == i
//                 //                 ? Colors.grey.withOpacity(0.9)
//                 //                 : Colors.transparent,
//                 //           ),
//                 //         ),
//                 //       ),
//                 //   ],
//                 // ),
//               ],
//             ),
//
//             const SizedBox(height: 20.0),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15.0),
//               child: Column(
//                 children: [
//                   //MARK: Book Appointment
//                   IntrinsicHeight(
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.of(context, rootNavigator: true)
//                             .pushNamed("/BookAppointment");
//                       },
//                       child: Container(
//                           width: double.infinity,
//                           height: MediaQuery.of(context).size.height / 11,
//                           padding: const EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: CommonStyles.primaryTextColor),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const SizedBox(
//                                 width: 2,
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.all(15),
//                                 decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: CommonStyles.primaryTextColor),
//                                 child: Center(
//                                   child: SvgPicture.asset(
//                                     'assets/noun-appointment-date-2417776.svg',
//                                     width: 30.0,
//                                     height: 30.0,
//                                     color: CommonStyles.whiteColor,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     //MARK: WORK
//                                     const Text(
//                                       'Click Here To',
//                                       style: CommonStyles.txSty_16p_f5,
//                                     ),
//                                     Text(
//                                       'Book an Appointment',
//
//                                       /// style: CommonStyles.txSty_20p_fb,
//                                       // style: TextStyle(
//                                       //   fontSize: 14,
//                                       //   fontFamily: "Calibri",
//                                       //   fontWeight: FontWeight.bold,
//                                       //   color: CommonStyles.primaryTextColor,
//                                       //   letterSpacing: 2,
//                                       // ),
//                                       style: CommonStyles.txSty_16p_fb.copyWith(
//                                         fontSize: 20,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(30),
//                                 child: SvgPicture.asset(
//                                   'assets/book_op_illusion.svg',
//                                   width: 60.0,
//                                   height: 55.0,
//                                   alignment: Alignment.centerRight,
//                                 ),
//                               ),
//                             ],
//                           )),
//                       // )
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   //MARK: Screens
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: 5,
//                       ),
//                       Text(
//                         'Branches',
//                         style: CommonStyles.txSty_16p_fb,
//                       ),
//                     ],
//                   ),
//                   Container(
//                     color: Colors.white, // Set the background color to white
//                  child:
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height / 3,
//
//                     child:    FutureBuilder(
//                       future: apiData,
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const Center(
//                               child: CircularProgressIndicator.adaptive());
//                         } else if (snapshot.hasError) {
//                           return const Center(
//                             child: Text(
//                               'No Branches Available ',
//                               style: TextStyle(
//                                 fontSize: 12.0,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: "Roboto",
//                               ),
//                             ),
//                           );
//                         } else {
//                           List<Model_branch>? data = snapshot.data!;
//                           if (data.isNotEmpty) {
//                             return ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: data.length,
//                               itemBuilder: (context, index) {
//                                 return BranchCard(
//                                   branch: data[index],
//                                 );
//                               },
//                             );
//                           } else {
//                             return const Center(
//                               child: Text(
//                                 'No Branches Available',
//                                 style: TextStyle(
//                                   fontSize: 12.0,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: "Roboto",
//                                 ),
//                               ),
//                             );
//                           }
//                         }
//                       },
//                     ),
//                   ),
//                   )],
//               ),
//             ),
//           ],
//         ),
//       ),
//   //  )
    );
  }

  Future<List<Model_branch>> getBranchsData() async {
    //var apiUrl = baseUrl + getbranchesall;
    var apiUrl = '$baseUrl${getbrancheselectedcity}null';
    print('result: $apiUrl');
    try {
      final jsonResponse = await http.get(
        Uri.parse(apiUrl),
      );

      if (jsonResponse.statusCode == 200) {
        Map<String, dynamic> response = jsonDecode(jsonResponse.body);
        List<dynamic> branchesData = response['listResult'];
        List<Model_branch> result =
        branchesData.map((e) => Model_branch.fromJson(e)).toList();

        if (result.isNotEmpty) {
          print('result: ${result[0].branchName}');
          print('result: ${result[0].address}');
          print('result: ${result[0].imageName}');
        } else {
          result = [];
          print('No Data');
        }
        return result;
      } else {
        throw Exception('api failed');
      }
    } catch (e) {
      print('errorin$e');
      rethrow;
    }
  }

  void checkLoginuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userFullName = prefs.getString('userFullName') ?? '';
      email = prefs.getString('email') ?? '';
      phonenumber = prefs.getString('contactNumber') ?? '';
      Gender = prefs.getString('gender') ?? '';
      userId = prefs.getInt('userId');
      // _fullnameController1.text = userFullName;
      // _emailController3.text = email;
      // _phonenumberController2.text = phonenumber;
      // gender = selectedGender;
      print('userId:$userId');
      print('userFullName:$userFullName');
      print('gender:$Gender');
      // if (gender == 1) {
      //   Gender = 'Female';
      // } else if (gender == 2) {
      //   Gender = 'Male';
      // } else if (gender == 3) {
      //   Gender = 'Other';
      // }
    });
  }
}

// class SliderScreen extends StatefulWidget {
//   @override
//   _SliderScreenState createState() => _SliderScreenState();
// }
//
// class _SliderScreenState extends State<SliderScreen> {
//   List<BannerImages> imageList = [];
//
//   List<BranchModel> brancheslist = [];
//   final CarouselController carouselController = CarouselController();
//   int currentIndex = 0;
//   bool isLoading = true;
//   bool isDataBinding = false;
//   bool apiAllowed = true;
//   late Timer _timer;
//   @override
//   initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitDown,
//       DeviceOrientation.portraitUp,
//     ]);
//
//     CommonUtils.checkInternetConnectivity().then((isConnected) {
//       if (isConnected) {
//         print('Connected to the internet');
//         fetchData();
//         // Call API immediately when screen loads
//         //  fetchData();
//         //fetchimagesslider();
//         fetchImages();
//       } else {
//         CommonUtils.showCustomToastMessageLong('No Internet Connection', context, 1, 4);
//         print('Not connected to the internet'); // Not connected to the internet
//       }
//     });
//   }
//
//   void fetchData() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     // Add a timeout of 8 seconds using Future.delayed
//     Future.delayed(Duration(seconds: 15), () {
//       if (isLoading) {
//         setState(() {
//           isLoading = false;
//           brancheslist.clear(); // Clear the list if timeout occurs
//         });
//       }
//     });
//
//     await _getData(); // Call your API method
//   }
//
//   void fetchimagesslider() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     // Add a timeout of 8 seconds using Future.delayed
//     Future.delayed(Duration(seconds: 15), () {
//       if (isLoading) {
//         setState(() {
//           isLoading = false;
//           imageList.clear(); // Clear the list if timeout occurs
//         });
//       }
//     });
//
//     await fetchImages(); // Call your API method
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//   // Future<void> _getDataWithinFiveSeconds() async {
//   //   // Start a timer to measure the elapsed time
//   //   Timer(Duration(seconds: 5), () {
//   //     if (!isLoading) {
//   //       print('API call within 5 seconds!');
//   //       // Make the API call here
//   //       _getData();
//   //       fetchImages();
//   //     } else {
//   //       print('API call after 5seconds');
//   //     }
//   //   });
//   // }
//
// //   Future<void> _getData() async {
// //     final url =  Uri.parse(baseUrl+getbranches);
// //     print('url==>135: $url');
// // //  final url = Uri.parse('http://182.18.157.215/SaloonApp/API/api/Banner/null');
// //
// //
// //     final response = await http.get(url);
// //
// //     try {
// //       // Check if the request was successful
// //       if (response.statusCode == 200) {
// //         // Parse the response body
// //         final data = json.decode(response.body);
// //         print('Failed to fetch data:  $data');
// //
// //         List<BranchModel> branchList = [];
// //         for (var item in data['ListResult']) {
// //           branchList.add(BranchModel(
// //             id: item['Id'],
// //             name: item['Name'],
// //             filePath: item['FilePath'],
// //             address: item['Address'],
// //             startTime: item['StartTime'],
// //             closeTime: item['CloseTime'],
// //             room: item['Room'],
// //             mobileNumber: item['MobileNumber'],
// //             isActive: item['IsActive'],
// //           ));
// //         }
// //
// //         // Update the state with the fetched data
// //         setState(() {
// //           brancheslist = branchList;
// //         });
// //       }
// //       else {
// //         // Handle error if the API request was not successful
// //         print('Request failed with status: ${response.statusCode}');
// //       }
// //     } catch (error) {
// //       // Handle any exception that occurred during the API call
// //       print('Error: $error');
// //     }
// //   }
// //   Future<void> _getData() async {
// //     setState(() {
// //       isLoading = true; // Set isLoading to true before making the API call
// //     });
// //
// //     final url = Uri.parse(baseUrl + getbranches);
// //     print('url==>135: $url');
// //
// //     final response = await http.get(url);
// //
// //     try {
// //       // Check if the request was successful
// //       if (response.statusCode == 200) {
// //         // Parse the response body
// //         final data = json.decode(response.body);
// //         print('Failed to fetch data:  $data');
// //
// //         List<BranchModel> branchList = [];
// //         for (var item in data['ListResult']) {
// //           branchList.add(BranchModel(
// //             id: item['Id'],
// //             name: item['Name'],
// //             filePath: item['FilePath'],
// //             address: item['Address'],
// //             startTime: item['StartTime'],
// //             closeTime: item['CloseTime'],
// //             room: item['Room'],
// //             mobileNumber: item['MobileNumber'],
// //             isActive: item['IsActive'],
// //           ));
// //         }
// //
// //         // Update the state with the fetched data
// //         setState(() {
// //           brancheslist = branchList;
// //           isLoading = false; // Set isLoading to false after data is fetched
// //         });
// //       } else {
// //         // Handle error if the API request was not successful
// //         print('Request failed with status: ${response.statusCode}');
// //         setState(() {
// //           isLoading = false; // Set isLoading to false if request fails
// //         });
// //       }
// //     } catch (error) {
// //       // Handle any exception that occurred during the API call
// //       print('Error data is not getting from the api: $error');
// //       setState(() {
// //         isLoading = false; // Set isLoading to false if error occurs
// //       });
// //     }
// //   }
//
//   // Future<void> _getData() async {
//   //   final url = Uri.parse(baseUrl + getbranches);
//   //   print('branchesapi:$url');
//   //   try {
//   //     final response = await http.get(url);
//   //
//   //     if (response.statusCode == 200) {
//   //       final data = json.decode(response.body);
//   //
//   //       List<BranchModel> branchList = [];
//   //       for (var item in data['ListResult']) {
//   //         branchList.add(BranchModel(
//   //           id: item['Id'],
//   //           name: item['Name'],
//   //           filePath: item['FilePath'],
//   //           address: item['Address'],
//   //           startTime: item['StartTime'],
//   //           closeTime: item['CloseTime'],
//   //           room: item['Room'],
//   //           mobileNumber: item['MobileNumber'],
//   //           isActive: item['IsActive'],
//   //         ));
//   //       }
//   //
//   //       setState(() {
//   //         brancheslist = branchList;
//   //         isLoading = false;
//   //       });
//   //     } else {
//   //       print('Request failed with status: ${response.statusCode}');
//   //       setState(() {
//   //         isLoading = false;
//   //       });
//   //     }
//   //   } catch (error) {
//   //     print('Error fetching data: $error');
//   //     setState(() {
//   //       isLoading = false;
//   //     });
//   //   }
//   // }
//
//   Future<void> _getData() async {
//     setState(() {
//       isLoading = true; // Set isLoading to true before making the API call
//     });
//
//     final url = Uri.parse(baseUrl + getbranches);
//     print('url==>135: $url');
//
//     bool success = false;
//     int retries = 0;
//     const maxRetries = 1;
//
//     while (!success && retries < maxRetries) {
//       try {
//         final response = await http.get(url);
//
//         // Check if the request was successful
//         if (response.statusCode == 200) {
//           // Parse the response body
//           final data = json.decode(response.body);
//           print('Failed to fetch data:  $data');
//
//           List<BranchModel> branchList = [];
//
//           for (var item in data['listResult']) {
//             branchList.add(BranchModel(
//               id: item['id'],
//               name: item['name'],
//               imageName: item['imageName'],
//               address: item['address'],
//               startTime: item['startTime'],
//               closeTime: item['closeTime'],
//               room: item['room'],
//               mobileNumber: item['mobileNumber'],
//               isActive: item['isActive'],
//             ));
//           }
//
//
//           // Update the state with the fetched data
//           setState(() {
//             brancheslist = branchList;
//             isLoading = false; // Set isLoading to false after data is fetched
//           });
//
//           success = true;
//         } else {
//           // Handle error if the API request was not successful
//           print('Request failed with status: ${response.statusCode}');
//           setState(() {
//             isLoading = false; // Set isLoading to false if request fails
//           });
//         }
//       } catch (error) {
//         // Handle any exception that occurred during the API call
//         print('Error data is not getting from the api: $error');
//         setState(() {
//           isLoading = false; // Set isLoading to false if error occurs
//         });
//       }
//
//       retries++;
//     }
//
//     if (!success) {
//       // Handle the case where all retries failed
//       print('All retries failed. Unable to fetch data from the API.');
//     }
//   }
//
// //   Future<void> fetchImages() async {
// //     final url = Uri.parse(baseUrl + getBanners);
// //     print('url==>127: $url');
// // //  final url = Uri.parse('http://182.18.157.215/SaloonApp/API/api/Banner/null');
// //
// //     try {
// //       final response = await http.get(url);
// //
// //       if (response.statusCode == 200) {
// //         final jsonData = json.decode(response.body);
// //
// //         List<BannerImages> bannerImages = [];
// //         for (var item in jsonData['ListResult']) {
// //           bannerImages.add(BannerImages(FilePath: item['FilePath'], Id: item['Id']));
// //         }
// //
// //         setState(() {
// //           imageList = bannerImages;
// //         });
// //       } else {
// //         // Handle error if the API request was not successful
// //         print('Request failed with status: ${response.statusCode}');
// //       }
// //     } catch (error) {
// //       // Handle any exception that occurred during the API call
// //       print('Error: $error');
// //     }
// //   }
//   Future<void> fetchImages() async {
//     setState(() {
//       isDataBinding = true; // Set the flag to true when data fetching starts
//
//       isLoading = true; // Set isLoading to true before making the API call
//     });
//     final url = Uri.parse(baseUrl + getBanners);
//     print('url==>127: $url');
//
//
//     try {
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//
//         List<BannerImages> bannerImages = [];
//         for (var item in jsonData['listResult']) {
//           bannerImages.add(BannerImages(
//               imageName: item['imageName'] ?? '', id: item['id'] ?? 0));
//         }
//         // for (var item in jsonData['ListResult']) {
//         //   bannerImages.add(BannerImages(FilePath: item['FilePath'], Id: item['Id']));
//         // }
//
//         setState(() {
//           imageList = bannerImages;
//           isDataBinding = false;
//
//           isLoading = false; // Set isLoading to false after completing the API call
//         });
//       } else {
//         // Handle error if the API request was not successful
//         print('Request failed with status: ${response.statusCode}');
//         setState(() {
//           isDataBinding = false;
//
//           isLoading = false; // Set isLoading to false if request fails
//         });
//       }
//     } catch (error) {
//       // Handle any exception that occurred during the API call
//       print('Error images are not from the api: $error');
//       setState(() {
//         isDataBinding = false;
//         isLoading = false; // Set isLoading to false if error occurs
//       });
//     }
//   }
//
//   void retryDataFetching() {
//     // setState(() {
//     //   isLoading = true; // Set isLoading to true to show loading indicator
//     // });
//     // _getData(); // Call your API method to fetch data
//     // fetchImages(); // Call your API method to fetch images
//     CommonUtils.checkInternetConnectivity().then((isConnected) {
//       if (isConnected) {
//         print('Connected to the internet');
//         //fetchImages();
//         // _getData();
//         fetchData();
//         fetchimagesslider();
//       } else {
//         CommonUtils.showCustomToastMessageLong('No Internet Connection', context, 1, 4);
//         print('Not connected to the internet'); // Not connected to the internet
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 0.0),
//           child: Padding(
//             padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
//             child: RichText(
//               text: TextSpan(
//                 style: DefaultTextStyle.of(context).style,
//                 children: [
//                   TextSpan(
//                     text: 'Welcome to ',
//                     style: TextStyle(
//                       fontFamily: 'Calibri',
//                       fontSize: 20,
//                       color: Color(0xFFFB4110),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   TextSpan(
//                     text: 'Hair Fixing Zone',
//                     style: TextStyle(
//                       fontFamily: 'Calibri',
//                       fontSize: 20,
//                       color: Color(0xFF163CF1),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10.0),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       Align(
//                         alignment: Alignment.topCenter,
//                         child: isDataBinding
//                             ? Center(
//                           child: CircularProgressIndicator.adaptive(),
//                         )
//                             : imageList.isEmpty
//                             ? Center(
//                           // child: CircularProgressIndicator.adaptive(),
//                           child: Icon(
//                             Icons.signal_cellular_connected_no_internet_0_bar_sharp,
//                             color: Colors.red,
//                           ),
//                         )
//                             : CarouselSlider(
//                           items: imageList
//                               .map((item) => Image.network(
//                             item.imageName,
//                             fit: BoxFit.fitWidth,
//                             width: MediaQuery.of(context).size.width,
//                           ))
//                               .toList(),
//                           carouselController: carouselController,
//                           options: CarouselOptions(
//                             scrollPhysics: const BouncingScrollPhysics(),
//                             autoPlay: true,
//                             aspectRatio: 23 / 9,
//                             viewportFraction: 1,
//                             onPageChanged: (index, reason) {
//                               setState(() {
//                                 currentIndex = index;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//
//                       // Align(
//                       //   alignment: Alignment.topCenter,
//                       //   child: Padding(
//                       //     padding: EdgeInsets.only(top: 110.0),
//                       //     child: Row(
//                       //       mainAxisAlignment: MainAxisAlignment.center,
//                       //       children: imageList.asMap().entries.map((entry) {
//                       //         final index = entry.key;
//                       //         return buildIndicator(index);
//                       //       }).toList(),
//                       //     ),
//                       //   ),
//                       // ),working code has been hide because it is intialize static padding
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         //  padding: EdgeInsets.all(20.0),
//
//                         height: MediaQuery.of(context).size.height,
//                         child: Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Padding(
//                             padding: EdgeInsets.only(bottom: 25.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: imageList.asMap().entries.map((entry) {
//                                 final index = entry.key;
//                                 return buildIndicator(index);
//                               }).toList(),
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
//                   child: Align(
//                     alignment: Alignment.topCenter,
//                     child: Text(
//                       'Branches',
//                       textAlign: TextAlign.left,
//                       style: TextStyle(
//                         fontFamily: 'Calibri',
//                         fontSize: 20,
//                         color: Color(0xFF163CF1),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (isLoading)
//                   Text('Please Wait Loading Slow Internet Connection !')
//                 else if (brancheslist.isEmpty && imageList.isEmpty)
//                   Container(
//                     padding: EdgeInsets.all(15.0),
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text('Failed to fetch data. Please check your internet connection.!'),
//                           SizedBox(height: 20),
//                           ElevatedButton(
//                             onPressed: retryDataFetching,
//                             child: Text('Retry'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 Expanded(
//                     flex: 3,
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: isLoading ? 5 : brancheslist.length, // Display a fixed number of shimmer items when loading
//                       itemBuilder: (context, index) {
//                         if (isLoading) {
//                           // Return shimmer effect if isLoading is true
//                           return Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
//                             child: Shimmer.fromColors(
//                               baseColor: Colors.grey.shade300,
//                               highlightColor: Colors.grey.shade100,
//                               child: Container(
//                                 height: 150, // Adjust height as needed
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(15.0),
//                                 ),
//                                 // child: Shimmer.fromColors(
//                                 //   baseColor: Colors.grey.shade300,
//                                 //   highlightColor: Colors.grey.shade100,
//                                 //   child: ClipRRect(
//                                 //     borderRadius: BorderRadius.circular(7.0),
//                                 //     child: Image.network(
//                                 //       imagesflierepo,
//                                 //       width: 110,
//                                 //       height: 65,
//                                 //       fit: BoxFit.fill,
//                                 //       // loadingBuilder: (context, child, loadingProgress) {
//                                 //       //   if (loadingProgress == null) return child;
//                                 //       //
//                                 //       //   return const Center(child: CircularProgressIndicator.adaptive());
//                                 //       //   // You can use LinearProgressIndicator or CircularProgressIndicator instead
//                                 //       // },
//                                 //     ),
//                                 //   ),
//                                 // ),
//                               ),
//                             ),
//                           );
//                         } else {
//                           // Return actual data when isLoading is false
//                           BranchModel branch = brancheslist[index];
//                           return Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
//                             child: IntrinsicHeight(
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.only(
//                                   topRight: Radius.circular(42.5),
//                                   bottomLeft: Radius.circular(42.5),
//                                 ),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     // Navigator.push(
//                                     //   context,
//                                     //   MaterialPageRoute(builder: (context) => slotbookingscreen(branchId: branch.id, branchname: branch.name, branchlocation: branch.address, filepath: branch.filePath, MobileNumber: branch.mobileNumber)),
//                                     // );
//                                   },
//                                   child: Card(
//                                     shadowColor: Colors.transparent,
//                                     surfaceTintColor: Colors.transparent,
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.only(
//                                         topRight: Radius.circular(29.0),
//                                         bottomLeft: Radius.circular(29.0),
//                                       ),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           gradient: LinearGradient(
//                                             colors: [
//                                               Color(0xFFFEE7E1), // Start color
//                                               Color(0xFFD7DEFA),
//                                             ],
//                                             begin: Alignment.centerLeft,
//                                             end: Alignment.centerRight,
//                                           ),
//                                         ),
//                                         child: Row(
//                                           crossAxisAlignment: CrossAxisAlignment.center,
//                                           children: [
//                                             Padding(
//                                               padding: EdgeInsets.only(left: 15.0),
//                                               child: Container(
//                                                 width: 110,
//                                                 height: 65,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius: BorderRadius.circular(10.0),
//                                                   border: Border.all(
//                                                     color: Color(0xFF9FA1EE),
//                                                     width: 3.0,
//                                                   ),
//                                                 ),
//                                                 child: ClipRRect(
//                                                   borderRadius: BorderRadius.circular(7.0),
//                                                   child: Image.network(
//                                                     branch.imageName!,
//                                                     width: 110,
//                                                     height: 65,
//                                                     fit: BoxFit.fill,
//                                                     loadingBuilder: (context, child, loadingProgress) {
//                                                       if (loadingProgress == null) return child;
//
//                                                       return const Center(child: CircularProgressIndicator.adaptive());
//                                                       // You can use LinearProgressIndicator or CircularProgressIndicator instead
//                                                     },
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             // Padding(
//                                             //   padding: EdgeInsets.only(left: 15.0),
//                                             //   child: Container(
//                                             //     width: 110,
//                                             //     height: 65,
//                                             //     decoration: BoxDecoration(
//                                             //       borderRadius: BorderRadius.circular(10.0),
//                                             //       border: Border.all(
//                                             //         color: Color(0xFF9FA1EE),
//                                             //         width: 3.0,
//                                             //       ),
//                                             //     ),
//                                             //     child: ClipRRect(
//                                             //       borderRadius: BorderRadius.circular(7.0),
//                                             //       child: isLoading
//                                             //           ? Shimmer.fromColors(
//                                             //               baseColor: Colors.grey.shade300,
//                                             //               highlightColor: Colors.white,
//                                             //               child: Container(
//                                             //                 width: 110,
//                                             //                 height: 65,
//                                             //                 decoration: BoxDecoration(
//                                             //                   color: Colors.white,
//                                             //                   borderRadius: BorderRadius.circular(7.0),
//                                             //                 ),
//                                             //               ),
//                                             //             )
//                                             //           : Image.network(
//                                             //               imagesflierepo + branch.filePath,
//                                             //               width: 110,
//                                             //               height: 65,
//                                             //               fit: BoxFit.fill,
//                                             //             ),
//                                             //     ),
//                                             //   ),
//                                             // ),
//
//                                             Expanded(
//                                               child: Padding(
//                                                 padding: EdgeInsets.only(left: 15.0),
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Padding(
//                                                       padding: EdgeInsets.only(top: 15.0),
//                                                       child: Text(
//                                                         branch.name,
//                                                         style: TextStyle(
//                                                           fontSize: 18,
//                                                           color: Color(0xFFFB4110),
//                                                           fontWeight: FontWeight.bold,
//                                                           fontFamily: 'Calibri',
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     SizedBox(height: 4.0),
//                                                     Expanded(
//                                                       child: Padding(
//                                                         padding: EdgeInsets.only(right: 10.0),
//                                                         child: Column(
//                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                           children: [
//                                                             Row(
//                                                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                                               children: [
//                                                                 Image.asset(
//                                                                   'assets/location_icon.png',
//                                                                   width: 20,
//                                                                   height: 18,
//                                                                 ),
//                                                                 SizedBox(width: 4.0),
//                                                                 Expanded(
//                                                                   child: Text(
//                                                                     branch.address,
//                                                                     style: TextStyle(
//                                                                       fontFamily: 'Calibri',
//                                                                       fontSize: 12,
//                                                                       color: Color(0xFF000000),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                             Spacer(flex: 3),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Align(
//                                                       alignment: Alignment.bottomRight,
//                                                       child: Container(
//                                                         height: 26,
//                                                         margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
//                                                         decoration: BoxDecoration(
//                                                           color: Colors.white,
//                                                           border: Border.all(
//                                                             color: Color(0xFF8d97e2),
//                                                           ),
//                                                           borderRadius: BorderRadius.circular(10.0),
//                                                         ),
//                                                         child: ElevatedButton(
//                                                           onPressed: () {
//                                                             // Handle button press
//                                                           },
//                                                           style: ElevatedButton.styleFrom(
//                                                             foregroundColor: Color(0xFF8d97e2), backgroundColor: Colors.transparent,
//                                                             elevation: 0,
//                                                             shadowColor: Colors.transparent,
//                                                             shape: RoundedRectangleBorder(
//                                                               borderRadius: BorderRadius.circular(10.0),
//                                                             ),
//                                                           ),
//                                                           child: GestureDetector(
//                                                             onTap: () {
//                                                               print('booknowbuttonisclciked');
//                                                               print(branch.id);
//                                                               print(branch.name);
//                                                               Navigator.push(
//                                                                 context,
//                                                                 MaterialPageRoute(
//                                                                   builder: (context) => Bookingscreen(
//                                                                     branchId: branch.id!,
//                                                                     branchname: branch.name!,
//                                                                     branchaddress: branch.address!,
//                                                                     phonenumber: branch.mobileNumber!,
//                                                                     branchImage: branch.imageName!,
//                                                                     latitude: branch.latitude,
//                                                                     longitude: branch.longitude,
//                                                                   ),
//                                                                 ),
//                                                               );
//                                                               // Handle button press, navigate to a new screen
//                                                               // Navigator.push(
//                                                               //   context,
//                                                               //   MaterialPageRoute(
//                                                               //       builder: (context) => slotbookingscreen(branchId: branch.id, branchname: branch.name, branchlocation: branch.address, filepath: branch.filePath, MobileNumber: branch.mobileNumber)),
//                                                               // );
//                                                             },
//                                                             child: Row(
//                                                               mainAxisSize: MainAxisSize.min,
//                                                               children: [
//                                                                 SvgPicture.asset(
//                                                                   'assets/datepicker_icon.svg',
//                                                                   width: 15.0,
//                                                                   height: 15.0,
//                                                                 ),
//                                                                 SizedBox(width: 5),
//                                                                 Text(
//                                                                   'Book Now',
//                                                                   style: TextStyle(
//                                                                     fontSize: 13,
//                                                                     color: Color(0xFF8d97e2),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                     )
//
//                   // ListView.builder(
//                   //   shrinkWrap: true,
//                   //   itemCount: brancheslist.length,
//                   //   itemBuilder: (context, index) {
//                   //     BranchModel branch = brancheslist[index]; // Get the branch at the current index
//                   //
//                   //     return Padding(
//                   //         padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
//                   //         child: IntrinsicHeight(
//                   //           child: ClipRRect(
//                   //               borderRadius: BorderRadius.only(
//                   //                 topRight: Radius.circular(42.5),
//                   //                 bottomLeft: Radius.circular(42.5),
//                   //               ),
//                   //               child: GestureDetector(
//                   //                 onTap: () {
//                   //                   Navigator.push(
//                   //                     context,
//                   //                     MaterialPageRoute(builder: (context) => slotbookingscreen(branchId: branch.id, branchname: branch.name, branchlocation: branch.address, filepath: branch.filePath, MobileNumber: branch.mobileNumber)),
//                   //                   );
//                   //                 },
//                   //                 child: Card(
//                   //                   shadowColor: Colors.transparent,
//                   //                   surfaceTintColor: Colors.transparent,
//                   //                   child: ClipRRect(
//                   //                     borderRadius: BorderRadius.only(
//                   //                       topRight: Radius.circular(29.0),
//                   //                       bottomLeft: Radius.circular(29.0),
//                   //                     ),
//                   //                     //surfaceTintColor : Colors.red,
//                   //
//                   //                     child: Container(
//                   //                       decoration: BoxDecoration(
//                   //                         gradient: LinearGradient(
//                   //                           colors: [
//                   //                             Color(0xFFFEE7E1), // Start color
//                   //                             Color(0xFFD7DEFA),
//                   //                           ],
//                   //                           begin: Alignment.centerLeft,
//                   //                           end: Alignment.centerRight,
//                   //                         ),
//                   //                         // borderRadius: BorderRadius.only(
//                   //                         //   topRight: Radius.circular(30.0),
//                   //                         //   bottomLeft: Radius.circular(30.0),
//                   //                         //
//                   //                         // ),
//                   //                       ),
//                   //                       child: Row(
//                   //                         crossAxisAlignment: CrossAxisAlignment.center,
//                   //                         children: [
//                   //                           Padding(
//                   //                             padding: EdgeInsets.only(left: 15.0),
//                   //                             child: Container(
//                   //                               width: 110,
//                   //                               height: 65,
//                   //                               decoration: BoxDecoration(
//                   //                                 borderRadius: BorderRadius.circular(10.0),
//                   //                                 border: Border.all(
//                   //                                   color: Color(0xFF9FA1EE),
//                   //                                   width: 3.0,
//                   //                                 ),
//                   //                               ),
//                   //                               child: ClipRRect(
//                   //                                 borderRadius: BorderRadius.circular(7.0),
//                   //                                 child: Image.network(
//                   //                                   imagesflierepo + branch.filePath,
//                   //                                   width: 110,
//                   //                                   height: 65,
//                   //                                   fit: BoxFit.fill,
//                   //                                 ),
//                   //                               ),
//                   //                             ),
//                   //                           ),
//                   //                           Expanded(
//                   //                             child: Padding(
//                   //                               padding: EdgeInsets.only(left: 15.0),
//                   //                               child: Column(
//                   //                                 mainAxisAlignment: MainAxisAlignment.start,
//                   //                                 crossAxisAlignment: CrossAxisAlignment.start,
//                   //                                 children: [
//                   //                                   Padding(
//                   //                                     padding: EdgeInsets.only(top: 15.0),
//                   //                                     child: Text(
//                   //                                       branch.name,
//                   //                                       style: TextStyle(
//                   //                                         fontSize: 18,
//                   //                                         color: Color(0xFFFB4110),
//                   //                                         fontWeight: FontWeight.bold,
//                   //                                         fontFamily: 'Calibri',
//                   //                                       ),
//                   //                                     ),
//                   //                                   ),
//                   //                                   SizedBox(height: 4.0),
//                   //                                   Expanded(
//                   //                                     child: Padding(
//                   //                                       padding: EdgeInsets.only(right: 10.0),
//                   //                                       child: Column(
//                   //                                         crossAxisAlignment: CrossAxisAlignment.start,
//                   //                                         children: [
//                   //                                           Row(
//                   //                                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   //                                             children: [
//                   //                                               Image.asset(
//                   //                                                 'assets/location_icon.png',
//                   //                                                 width: 20,
//                   //                                                 height: 18,
//                   //                                               ),
//                   //                                               SizedBox(width: 4.0),
//                   //                                               Expanded(
//                   //                                                 child: Text(
//                   //                                                   branch.address,
//                   //                                                   style: TextStyle(
//                   //                                                     fontFamily: 'Calibri',
//                   //                                                     fontSize: 12,
//                   //                                                     color: Color(0xFF000000),
//                   //                                                   ),
//                   //                                                 ),
//                   //                                               ),
//                   //                                             ],
//                   //                                           ),
//                   //                                           Spacer(flex: 3),
//                   //                                         ],
//                   //                                       ),
//                   //                                     ),
//                   //                                   ),
//                   //                                   Align(
//                   //                                     alignment: Alignment.bottomRight,
//                   //                                     child: Container(
//                   //                                       height: 26,
//                   //                                       margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
//                   //                                       decoration: BoxDecoration(
//                   //                                         color: Colors.white,
//                   //                                         border: Border.all(
//                   //                                           color: Color(0xFF8d97e2),
//                   //                                         ),
//                   //                                         borderRadius: BorderRadius.circular(10.0),
//                   //                                       ),
//                   //                                       child: ElevatedButton(
//                   //                                         onPressed: () {
//                   //                                           // Handle button press
//                   //                                         },
//                   //                                         style: ElevatedButton.styleFrom(
//                   //                                           primary: Colors.transparent,
//                   //                                           onPrimary: Color(0xFF8d97e2),
//                   //                                           elevation: 0,
//                   //                                           shadowColor: Colors.transparent,
//                   //                                           shape: RoundedRectangleBorder(
//                   //                                             borderRadius: BorderRadius.circular(10.0),
//                   //                                           ),
//                   //                                         ),
//                   //                                         child: GestureDetector(
//                   //                                           onTap: () {
//                   //                                             print('booknowbuttonisclciked');
//                   //                                             print(branch.id);
//                   //                                             print(branch.name);
//                   //                                             // Handle button press, navigate to a new screen
//                   //                                             Navigator.push(
//                   //                                               context,
//                   //                                               MaterialPageRoute(
//                   //                                                   builder: (context) => slotbookingscreen(branchId: branch.id, branchname: branch.name, branchlocation: branch.address, filepath: branch.filePath, MobileNumber: branch.mobileNumber)),
//                   //                                             );
//                   //                                           },
//                   //                                           child: Row(
//                   //                                             mainAxisSize: MainAxisSize.min,
//                   //                                             children: [
//                   //                                               SvgPicture.asset(
//                   //                                                 'assets/datepicker_icon.svg',
//                   //                                                 width: 15.0,
//                   //                                                 height: 15.0,
//                   //                                               ),
//                   //                                               SizedBox(width: 5),
//                   //                                               Text(
//                   //                                                 'Book Now',
//                   //                                                 style: TextStyle(
//                   //                                                   fontSize: 13,
//                   //                                                   color: Color(0xFF8d97e2),
//                   //                                                 ),
//                   //                                               ),
//                   //                                             ],
//                   //                                           ),
//                   //                                         ),
//                   //                                       ),
//                   //                                     ),
//                   //                                   ),
//                   //                                 ],
//                   //                               ),
//                   //                             ),
//                   //                           ),
//                   //                         ],
//                   //                       ),
//                   //                     ),
//                   //                   ),
//                   //                 ),
//                   //               )),
//                   //         ));
//                   //   },
//                   // ),
//                 ),
//
//                 // width: 300.0,
//                 Padding(
//                   padding: EdgeInsets.only(bottom: 10.0),
//                   child: Container(
//                     margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
//                     decoration: BoxDecoration(
//                       color: Color(0xFFFFFFFF),
//                       border: Border.all(
//                         color: Color(0xFFFB4110),
//                       ),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: TextButton(
//                       onPressed: () async {
//                         const url = 'https://www.hairfixingzone.com/';
//                         try {
//                           if (await canLaunch(url)) {
//                             await launch(url);
//                           } else {
//                             throw 'Could not launch $url';
//                           }
//                         } catch (e) {
//                           print('Error launching URL: $e');
//                         }
//                       },
//                       style: ButtonStyle(
//                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                         ),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             'assets/web_icon.png',
//                             width: 20,
//                             height: 20,
//                           ),
//                           SizedBox(width: 5),
//                           Text(
//                             'Click Here for Website',
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Color(0xFFFB4110),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget buildIndicator(int index) {
//     return Container(
//       width: 8,
//       height: 8,
//       margin: EdgeInsets.symmetric(horizontal: 4),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: index == currentIndex ? Colors.orange : Colors.grey,
//       ),
//     );
//   }
// }
//

class BranchCard extends StatelessWidget {
  final Model_branch branch;

  const BranchCard({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, // Set the background color to white
      child:
      Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CommonStyles.branchBg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.grey,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.network(
                    branch.imageName,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: CommonStyles.branchBg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            branch.branchName,
                            style: CommonStyles.txSty_16p_fb.copyWith(
                              fontSize: 22,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            openMap(branch); // Call the openMap method
                          },
                          child: SvgPicture.asset(
                            'assets/map_marker.svg',
                            width: 20,
                            height: 20,
                            color: CommonStyles.statusGreenText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Expanded(
                      child: Text(
                        branch.address,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: CommonStyles.txSty_12b_f5.copyWith(
                          fontSize: 16,
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
    )) ;
  }

  Future<void> openMap(Model_branch branchnames) async {
    // Replace with your logic to open the map, for example:
    final url =
        'https://www.google.com/maps/search/?api=1&query=${branchnames.latitude},${branchnames.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ItemBuilder extends StatelessWidget {
  const ItemBuilder({
    super.key,
    required this.items,
    required this.index,
  });

  final List<Item> items;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      height: 180,
      width: 150,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            items[index].imageName,
            height: 100,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return const Center(child: CircularProgressIndicator.adaptive());
            },
          ),
        ),
      ),
    );
  }
}

class Item {
  final String name;
  final Color color;
  final String imageName;

  Item(this.name, this.color, this.imageName);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['name'] as String,
      Colors.blue, // Default color
      json['imageName'] as String? ??
          '', // Add null check and provide a default value
    );
  }
}
// return GestureDetector(
// onTap: () {
// // Add your onTap functionality here
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => Bookingscreen(
// branchId: branchnames.id!,
// branchname: branchnames.branchName!,
// branchaddress: branchnames.address!,
// phonenumber: branchnames.mobileNumber!,
// branchImage: branchnames.imageName!,
// latitude: branchnames.latitude,
// longitude: branchnames.longitude,
// ),
// ),
// );
// },
// child: Card(
// elevation: 2,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10),
// ),
// child: Container(
// height: MediaQuery.of(context).size.height,
// width: MediaQuery.of(context).size.width / 2,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10),
// color: CommonStyles.branchBg,
// ),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: [
// Expanded(
// child: Container(
// clipBehavior: Clip.antiAlias,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10),
// // color: Colors.grey,
// ),
// child: ClipRRect(
// borderRadius: const BorderRadius.only(
// topLeft: Radius.circular(10),
// topRight: Radius.circular(10),
// ),
// child: Image.network(
// branch.imageName,
// fit: BoxFit.cover,
// ),
// ),
// ),
// ),
// Expanded(
// child: Container(
// padding: const EdgeInsets.all(10),
// decoration: const BoxDecoration(
// borderRadius: BorderRadius.only(
// bottomLeft: Radius.circular(10),
// bottomRight: Radius.circular(10),
// ),
// color: CommonStyles.branchBg,
// ),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: [
// Row(
// children: [
// Expanded(
// child: Text(
// branch.branchName,
// style: CommonStyles.txSty_16p_fb.copyWith(
// fontSize: 22,
// ),
// ),
// ),
// GestureDetector(
// onTap: () {
// openMap(branch); // Call the openMap method
// },
// child: SvgPicture.asset(
// 'assets/map_marker.svg',
// width: 20,
// height: 20,
// color: CommonStyles.statusGreenText,
// ),
// ),
// ],
// ),
// const SizedBox(
// height: 5.0,
// ),
// Expanded(
// child: Text(
// branch.address,
// maxLines: 3,
// overflow: TextOverflow.ellipsis,
// style: CommonStyles.txSty_12b_f5.copyWith(
// fontSize: 16,
// ),
// ),
// ),
// ],
// ),
// ),
// ),
// ],
// ),
// ),
// ),
// )
// ;