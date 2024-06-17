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

class Dashboard_Screen extends StatelessWidget {
  const Dashboard_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TwoCardPageView(),
    );
  }
}

class TwoCardPageView extends StatefulWidget {
  const TwoCardPageView({Key? key}) : super(key: key);

  @override
  _TwoCardPageViewState createState() => _TwoCardPageViewState();
}

class _TwoCardPageViewState extends State<TwoCardPageView> {
  List<Item> _items = [];
  int? userId;
  String marqueeText = '';
  Future<List<BranchList>>? apiData;
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
          print('marquee: ${response['affectedRecords']}');
          for (var i = 0; i < records; i++) {
            marqueeText += '${response['listResult'][i]['text']}  -  ';
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
      body: Column(

        children: [
//MARK: Marquee
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 30,
                  child: FutureBuilder(
                    future: getMarqueeText(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      } else if (snapshot.hasError) {
                        return const SizedBox();
                      } else {
                        return Marquee(
                          text: marqueeText,
                          style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "Calibri",
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFff0176)),
                          velocity: _shouldStartMarquee
                              ? 30
                              : 0, // Control Marquee scrolling with velocity
                        );
                      }
                    },
                  ),
                ),
                // Carousel widget
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  child: FlutterCarousel(
                    options: CarouselOptions(
                      // height: 400.0,
                      showIndicator: true,
                      autoPlay: true,
                      floatingIndicator: false,
                      autoPlayCurve: Curves.linear,
                      // enlargeCenterPage: true,
                      slideIndicator: const CircularSlideIndicator(
                        indicatorBorderColor: CommonStyles.blackColor,
                        currentIndicatorColor: CommonStyles.primaryTextColor,
                      ),
                    ),
                    items: _items.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            // margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            // decoration: const BoxDecoration(color: Colors.grey),
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

                  // PageView.builder(
                  //   controller: _pageController,
                  //   itemCount: _items.length,
                  //   itemBuilder: (context, index) {
                  //     final itemIndex = index % _items.length;
                  //     return SizedBox(
                  //       child: Row(
                  //         children: [
                  //           Expanded(
                  //             child: ItemBuilder(
                  //               items: _items,
                  //               index: itemIndex,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  //   onPageChanged: (int page) {
                  //     setState(() {
                  //       _currentPage = page;
                  //     });
                  //   },
                  // ),
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
                        //height: 60,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border:
                          Border.all(color: CommonStyles.primaryTextColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                        // GestureDetector(
                        //     onTap: () {
                        //       Navigator.of(context, rootNavigator: true).pushNamed("/BookAppointment");
                        //     },
                        //     child:
                        Row(
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
                            // Expanded(
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         'Click Here',
                            //         style: CommonStyles.txSty_16p_f5,
                            //       ),
                            //       Text(
                            //         'To Book an Appointment',
                            //         style: CommonStyles.txSty_20p_fb,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Click Here To',
                                    style: CommonStyles.txSty_16p_f5,
                                  ),
                                  Text(
                                    'Book an Appointment',

                                    /// style: CommonStyles.txSty_20p_fb,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Calibri",
                                      fontWeight: FontWeight.bold,
                                      color: CommonStyles.primaryTextColor,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/book_op_illusion.svg',
                              width: 60.0,
                              height: 55.0,
                              alignment: Alignment.centerRight,
                            ),
                          ],
                        )),
                    // )
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                //MARK: Screens
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed("/Mybookings");
                      },
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 7,
                            // height: MediaQuery.of(context).size.height / 5,
                            padding: const EdgeInsets.all(15),
                            decoration: const BoxDecoration(
                              color: Color(0xFFe656ae),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/my_bookings_icon.svg',
                              color: CommonStyles.whiteColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'My Bookings',
                            style: CommonStyles.txSty_14p_f5,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed("/Products");
                      },
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 7,
                            //height: 60,
                            padding: const EdgeInsets.all(15),
                            decoration: const BoxDecoration(
                              color: Color(0xFFe44561),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/products_icon.svg',
                              color: CommonStyles.whiteColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Products',
                            style: CommonStyles.txSty_14p_f5,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed("/about");
                      },
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 7,
                            // height: 60,
                            padding: const EdgeInsets.all(15),
                            decoration: const BoxDecoration(
                              color: Color(0xFF662d91),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/about_us_icon.svg',
                              color: CommonStyles.whiteColor,
                              // width: 11.0,
                              // height: 11.0,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'About Us',
                            style: CommonStyles.txSty_14p_f5,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed("/ProfileMy");
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            width: MediaQuery.of(context).size.width / 7,
                            //   height: 60,
                            decoration: const BoxDecoration(
                              color: Color(0xFF295f5a),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/my_profile_icon.svg',
                              color: CommonStyles.whiteColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'My Profile',
                            style: CommonStyles.txSty_14p_f5,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                //MARK: Branches
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Branches',
                      style: CommonStyles.txSty_16p_fb,
                    ),
                  ],
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: FutureBuilder(
                    future: apiData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('No Branches Available ',   style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto",
                          ),),
                        );
                      } else {
                        List<BranchList>? data = snapshot.data!;
                        if (data.isNotEmpty) {
                          return Container(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return BranchCard(
                                  branch: data[index],
                                );
                              },
                            ),
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
              ],
            ),
          ),
        ],
      ),

      // Column(
      //   children: [
      //     //MARK: Welcome Text
      //     // Container(
      //     //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      //     //   height: 80,
      //     //   child: Column(
      //     //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     //     mainAxisAlignment: MainAxisAlignment.center,
      //     //     children: [
      //     //       GestureDetector(
      //     //         onTap: () {
      //     //           // Navigator.push(
      //     //           //   context,
      //     //           //   MaterialPageRoute(
      //     //           //       builder: (context) => const AgentDashBoard()),
      //     //           // );
      //     //         },
      //     //         child: const Text(
      //     //           'Hello!',
      //     //           style: CommonStyles.txSty_16w_fb,
      //     //         ),
      //     //       ),
      //     //       Text(
      //     //         userFullName,
      //     //         style: CommonStyles.txSty_18w_fb,
      //     //       ),
      //     //     ],
      //     //   ),
      //     // ),
      //     //MARK: Main Card
      //
      //     SingleChildScrollView(
      //       child: Container(
      //         decoration: const BoxDecoration(
      //           color: CommonStyles.whiteColor,
      //           borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(20),
      //             topRight: Radius.circular(20),
      //           ),
      //         ),
      //
      //         child: Column(
      //           children: [
      //             //MARK: Marquee
      //             Column(
      //               crossAxisAlignment: CrossAxisAlignment.start, // Adjust as needed
      //               children: [
      //                 SizedBox(
      //                   height: 30,
      //                   child: FutureBuilder(
      //                     future: getMarqueeText(),
      //                     builder: (context, snapshot) {
      //                       if (snapshot.connectionState == ConnectionState.waiting) {
      //                         return const SizedBox();
      //                       } else if (snapshot.hasError) {
      //                         return const SizedBox();
      //                       } else {
      //                         return Marquee(
      //                           text: marqueeText,
      //                           style: const TextStyle(fontSize: 16, fontFamily: "Calibri", fontWeight: FontWeight.w600, color: Color(0xFFff0176)),
      //                         );
      //                       }
      //                     },
      //                   ),
      //                 ),
      //                 isDataBinding
      //                     ? Center(
      //                         child: CircularProgressIndicator.adaptive(),
      //                       )
      //                     : SizedBox(
      //                         width: MediaQuery.of(context).size.width,
      //                         height: 180,
      //                         child: PageView.builder(
      //                           controller: _pageController,
      //                           itemCount: _items.length,
      //                           itemBuilder: (context, index) {
      //                             final itemIndex = index % _items.length;
      //                             return SizedBox(
      //                               child: Row(
      //                                 children: [
      //                                   Expanded(
      //                                     child: ItemBuilder(items: _items, index: itemIndex),
      //                                   ),
      //                                 ],
      //                               ),
      //                             );
      //                           },
      //                           onPageChanged: (int page) {
      //                             setState(() {
      //                               _currentPage = page;
      //                             });
      //                           },
      //                         ),
      //                       ),
      //               ],
      //             ),
      //
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: <Widget>[
      //                 for (int i = 0; i < _items.length; i++)
      //                   Container(
      //                     margin: const EdgeInsets.all(2),
      //                     width: 10,
      //                     height: 10,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(10),
      //                       border: Border.all(color: CommonStyles.primaryTextColor, width: 1.5),
      //                       color: _currentPage == i ? Colors.grey.withOpacity(0.9) : Colors.transparent,
      //                     ),
      //                   )
      //               ],
      //             ),
      //             const SizedBox(height: 8.0),
      //
      //             Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 15.0),
      //               child: Column(
      //                 children: [
      //                   //MARK: Book Appointment
      //                   IntrinsicHeight(
      //                     child: GestureDetector(
      //                       onTap: () {
      //                         Navigator.of(context, rootNavigator: true).pushNamed("/BookAppointment");
      //                       },
      //                       child: Container(
      //                           width: double.infinity,
      //                           height: MediaQuery.of(context).size.height / 11,
      //                           //height: 60,
      //                           padding: const EdgeInsets.all(5),
      //                           decoration: BoxDecoration(
      //                             border: Border.all(color: CommonStyles.primaryTextColor),
      //                             borderRadius: BorderRadius.circular(10),
      //                           ),
      //                           child:
      //                               // GestureDetector(
      //                               //     onTap: () {
      //                               //       Navigator.of(context, rootNavigator: true).pushNamed("/BookAppointment");
      //                               //     },
      //                               //     child:
      //                               Row(
      //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                             children: [
      //                               SizedBox(
      //                                 width: 2,
      //                               ),
      //                               Container(
      //                                 padding: const EdgeInsets.all(15),
      //                                 decoration: const BoxDecoration(shape: BoxShape.circle, color: CommonStyles.primaryTextColor),
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
      //                               // Expanded(
      //                               //   child: Column(
      //                               //     crossAxisAlignment: CrossAxisAlignment.start,
      //                               //     children: [
      //                               //       Text(
      //                               //         'Click Here',
      //                               //         style: CommonStyles.txSty_16p_f5,
      //                               //       ),
      //                               //       Text(
      //                               //         'To Book an Appointment',
      //                               //         style: CommonStyles.txSty_20p_fb,
      //                               //       ),
      //                               //     ],
      //                               //   ),
      //                               // ),
      //                               SizedBox(
      //                                 width: MediaQuery.of(context).size.width / 2,
      //                                 child: const Column(
      //                                   crossAxisAlignment: CrossAxisAlignment.start,
      //                                   mainAxisAlignment: MainAxisAlignment.center,
      //                                   children: [
      //                                     Text(
      //                                       'Click Here To',
      //                                       style: CommonStyles.txSty_16p_f5,
      //                                     ),
      //                                     Text(
      //                                       'Book an Appointment',
      //
      //                                       /// style: CommonStyles.txSty_20p_fb,
      //                                       style: TextStyle(
      //                                         fontSize: 14,
      //                                         fontFamily: "Calibri",
      //                                         fontWeight: FontWeight.bold,
      //                                         color: CommonStyles.primaryTextColor,
      //                                         letterSpacing: 2,
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                               const SizedBox(
      //                                 width: 10,
      //                               ),
      //                               SvgPicture.asset(
      //                                 'assets/book_op_illusion.svg',
      //                                 width: 60.0,
      //                                 height: 55.0,
      //                                 alignment: Alignment.centerRight,
      //                               ),
      //                             ],
      //                           )),
      //                       // )
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     height: 10,
      //                   ),
      //                   //MARK: Screens
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       GestureDetector(
      //                         onTap: () {
      //                           Navigator.of(context, rootNavigator: true).pushNamed("/Mybookings");
      //                         },
      //                         child: Column(
      //                           children: [
      //                             Container(
      //                               width: MediaQuery.of(context).size.width / 7,
      //                               // height: MediaQuery.of(context).size.height / 5,
      //                               padding: const EdgeInsets.all(15),
      //                               decoration: const BoxDecoration(
      //                                 color: Color(0xFFe656ae),
      //                                 shape: BoxShape.circle,
      //                               ),
      //                               child: SvgPicture.asset(
      //                                 'assets/my_bookings_icon.svg',
      //                                 color: CommonStyles.whiteColor,
      //                               ),
      //                             ),
      //                             const SizedBox(height: 5),
      //                             const Text(
      //                               'My Bookings',
      //                               style: CommonStyles.txSty_14p_f5,
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                       GestureDetector(
      //                         onTap: () {
      //                           Navigator.of(context, rootNavigator: true).pushNamed("/Products");
      //                         },
      //                         child: Column(
      //                           children: [
      //                             Container(
      //                               width: MediaQuery.of(context).size.width / 7,
      //                               //height: 60,
      //                               padding: const EdgeInsets.all(15),
      //                               decoration: const BoxDecoration(
      //                                 color: Color(0xFFe44561),
      //                                 shape: BoxShape.circle,
      //                               ),
      //                               child: SvgPicture.asset(
      //                                 'assets/products_icon.svg',
      //                                 color: CommonStyles.whiteColor,
      //                               ),
      //                             ),
      //                             const SizedBox(height: 5),
      //                             const Text(
      //                               'Products',
      //                               style: CommonStyles.txSty_14p_f5,
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                       GestureDetector(
      //                         onTap: () {
      //                           Navigator.of(context, rootNavigator: true).pushNamed("/about");
      //                         },
      //                         child: Column(
      //                           children: [
      //                             Container(
      //                               width: MediaQuery.of(context).size.width / 7,
      //                               // height: 60,
      //                               padding: const EdgeInsets.all(15),
      //                               decoration: const BoxDecoration(
      //                                 color: Color(0xFF662d91),
      //                                 shape: BoxShape.circle,
      //                               ),
      //                               child: SvgPicture.asset(
      //                                 'assets/about_us_icon.svg',
      //                                 color: CommonStyles.whiteColor,
      //                                 // width: 11.0,
      //                                 // height: 11.0,
      //                               ),
      //                             ),
      //                             const SizedBox(height: 5),
      //                             const Text(
      //                               'About Us',
      //                               style: CommonStyles.txSty_14p_f5,
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                       GestureDetector(
      //                         onTap: () {
      //                           Navigator.of(context, rootNavigator: true).pushNamed("/ProfileMy");
      //                         },
      //                         child: Column(
      //                           children: [
      //                             Container(
      //                               padding: const EdgeInsets.all(15),
      //                               width: MediaQuery.of(context).size.width / 7,
      //                               //   height: 60,
      //                               decoration: const BoxDecoration(
      //                                 color: Color(0xFF295f5a),
      //                                 shape: BoxShape.circle,
      //                               ),
      //                               child: SvgPicture.asset(
      //                                 'assets/my_profile_icon.svg',
      //                                 color: CommonStyles.whiteColor,
      //                               ),
      //                             ),
      //                             const SizedBox(height: 5),
      //                             const Text(
      //                               'My Profile',
      //                               style: CommonStyles.txSty_14p_f5,
      //                             ),
      //                           ],
      //                         ),
      //                       )
      //                     ],
      //                   ),
      //                   const SizedBox(height: 10),
      //                   //MARK: Branches
      //                   const Row(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         'Branches',
      //                         style: CommonStyles.txSty_16p_fb,
      //                       ),
      //                     ],
      //                   ),
      //
      //                   SizedBox(
      //                     height: MediaQuery.of(context).size.height / 4,
      //                     child: FutureBuilder(
      //                       future: apiData,
      //                       builder: (context, snapshot) {
      //                         if (snapshot.connectionState == ConnectionState.waiting) {
      //                           return const Center(child: CircularProgressIndicator.adaptive());
      //                         } else if (snapshot.hasError) {
      //                           return Center(
      //                             child: Text(snapshot.error.toString()),
      //                           );
      //                         } else {
      //                           List<BranchList>? data = snapshot.data!;
      //                           return Container(
      //                             child: ListView.builder(
      //                               scrollDirection: Axis.horizontal,
      //                               itemCount: data.length,
      //                               itemBuilder: (context, index) {
      //                                 return BranchCard(
      //                                   branch: data[index],
      //                                 );
      //                               },
      //                             ),
      //                           );
      //                         }
      //                       },
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Future<List<BranchList>> getBranchsData() async {
    var apiUrl = baseUrl+getbranchesall;

    try {
      final jsonResponse = await http.get(
        Uri.parse(apiUrl),
      );

      if (jsonResponse.statusCode == 200) {
        Map<String, dynamic> response = jsonDecode(jsonResponse.body);
        List<dynamic> branchesData = response['listResult'];
        List<BranchList> result =
        branchesData.map((e) => BranchList.fromJson(e)).toList();

        if (result.isNotEmpty) {
          print('result: ${result[0].name}');
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
  final BranchList branch;

  const BranchCard({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        // width: 170,
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: Colors.grey,
          color: CommonStyles.branchBg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 8.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
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
            // Expanded(
            //   child: ClipRRect(
            //     borderRadius: const BorderRadius.only(
            //       topLeft: Radius.circular(10),
            //       topRight: Radius.circular(10),
            //     ),
            //     child: Image.network(
            //       branch.imageName,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            // Expanded(
            //   child: Container(
            //     padding: const EdgeInsets.all(5),
            //     decoration: const BoxDecoration(
            //       borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(10),
            //         topRight: Radius.circular(10),
            //       ),
            //       color: Colors.greenAccent,
            //     ),
            //     child: Image.network(
            //       // 'https://via.placeholder.com/600/92c952',
            //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH7vDN07mCqaSv-VvdFX3VYd2Ic9uFyha4kA&s',
            //       fit: BoxFit.fill,
            //     ),
            //   ),
            // ),
            // Expanded(
            //   child: Container(
            //     padding: const EdgeInsets.all(10),
            //     decoration: const BoxDecoration(
            //       borderRadius: BorderRadius.only(
            //         bottomLeft: Radius.circular(10),
            //         bottomRight: Radius.circular(10),
            //       ),
            //       color: CommonStyles.branchBg,
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.stretch,
            //       children: [
            //         Text(
            //           branch.name,
            //           style: CommonStyles.txSty_16p_fb,
            //         ),
            //         Text(branch.address, style: CommonStyles.txSty_12b_f5),
            //       ],
            //     ),
            //   ),
            // ),
            Container(
              // height: MediaQuery.of(context).size.height,
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
                  Text(
                    branch.name,
                    style: CommonStyles.txSty_16p_fb,
                  ),
                  Text(branch.address,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: CommonStyles.txSty_12b_f5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemBuilder extends StatelessWidget {
  const ItemBuilder({
    Key? key,
    required this.items,
    required this.index,
  }) : super(key: key);

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
