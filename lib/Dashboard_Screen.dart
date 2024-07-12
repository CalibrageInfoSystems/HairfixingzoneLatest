import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:url_launcher/url_launcher.dart';

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
      body:
      // SingleChildScrollView(
      //
      //   child:
        Container(
          height: MediaQuery.of(context).size.height,
         // color: Colors.white, // Set the background color to white
decoration: BoxDecoration(
  color: Colors.white
),
        child: Column(
          children: [
            //MARK: Marquee
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                FutureBuilder(
                  future: getMarqueeText(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    } else if (snapshot.hasError) {
                      return const SizedBox();
                    } else {
                      if (marqueeText != null) {
                        return SizedBox(
                          height: 30,
                          child: Marquee(
                            text: marqueeText!,
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Calibri",
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFff0176)),
                            velocity: _shouldStartMarquee
                                ? 30
                                : 0, // Control Marquee scrolling with velocity
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }
                  },
                ),
                //MARK: Carousel widget
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  child: FlutterCarousel(
                    options: CarouselOptions(
                      showIndicator: true,
                      autoPlay: true,
                      floatingIndicator: false,
                      autoPlayCurve: Curves.linear,
                      slideIndicator: const CircularSlideIndicator(
                        indicatorBorderColor: CommonStyles.blackColor,
                        currentIndicatorColor: CommonStyles.primaryTextColor,
                        indicatorRadius: 2,
                      ),
                    ),
                    items: _items.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item.imageName,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                        child: CircularProgressIndicator
                                            .adaptive());
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),

                // Carousel indicator
                // CarouselIndicator(
                //   currentPage: _currentPage,
                //   itemCount: _items.length,
                //   onPageChanged: (int page) {
                //     setState(() {
                //       _currentPage = page;
                //     });
                //   },
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     for (int i = 0; i < _items.length; i++)
                //       GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             _currentPage = i;
                //           });
                //         },
                //         child: Container(
                //           margin: const EdgeInsets.all(2),
                //           width: 10,
                //           height: 10,
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10),
                //             border: Border.all(
                //                 color: CommonStyles.primaryTextColor,
                //                 width: 1.5),
                //             color: _currentPage == i
                //                 ? Colors.grey.withOpacity(0.9)
                //                 : Colors.transparent,
                //           ),
                //         ),
                //       ),
                //   ],
                // ),
              ],
            ),

            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  //MARK: Book Appointment
                  IntrinsicHeight(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed("/BookAppointment");
                      },
                      child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 11,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: CommonStyles.primaryTextColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 2,
                              ),
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: CommonStyles.primaryTextColor),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/noun-appointment-date-2417776.svg',
                                    width: 30.0,
                                    height: 30.0,
                                    color: CommonStyles.whiteColor,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //MARK: WORK
                                    const Text(
                                      'Click Here To',
                                      style: CommonStyles.txSty_16p_f5,
                                    ),
                                    Text(
                                      'Book an Appointment',

                                      /// style: CommonStyles.txSty_20p_fb,
                                      // style: TextStyle(
                                      //   fontSize: 14,
                                      //   fontFamily: "Calibri",
                                      //   fontWeight: FontWeight.bold,
                                      //   color: CommonStyles.primaryTextColor,
                                      //   letterSpacing: 2,
                                      // ),
                                      style: CommonStyles.txSty_16p_fb.copyWith(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: SvgPicture.asset(
                                  'assets/book_op_illusion.svg',
                                  width: 60.0,
                                  height: 55.0,
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                            ],
                          )),
                      // )
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //MARK: Screens
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Branches',
                        style: CommonStyles.txSty_16p_fb,
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.white, // Set the background color to white
                 child:
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3,

                    child:    FutureBuilder(
                      future: apiData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              'No Branches Available ',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Roboto",
                              ),
                            ),
                          );
                        } else {
                          List<Model_branch>? data = snapshot.data!;
                          if (data.isNotEmpty) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return BranchCard(
                                  branch: data[index],
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: Text(
                                'No Branches Available',
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
                  )],
              ),
            ),
          ],
        ),
      ),
  //  )
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