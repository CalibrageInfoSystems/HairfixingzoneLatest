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

import 'Booking_Screen.dart';
import 'BranchModel.dart';
import 'CommonUtils.dart';
import 'HomeScreen.dart';
import 'Model_Branch.dart';

class Branch {
  final int branchId;
  final String branchname;
  final String branchaddress;
  final String phonenumber;
  final String branchImage;
  final double? latitude;
  final double? longitude;

  Branch({
    required this.branchId,
    required this.branchname,
    required this.branchaddress,
    required this.phonenumber,
    required this.branchImage,
    required this.latitude,
    required this.longitude,
  });
}

class CustomerDashBoard extends StatefulWidget {
  final void Function()? bookNowButtonPressed;
  final Function(Branch data) toNavigate;
  const CustomerDashBoard(
      {super.key, this.bookNowButtonPressed, required this.toNavigate});

  @override
  State<CustomerDashBoard> createState() => _CustomerDashBoardState();
}

class _CustomerDashBoardState extends State<CustomerDashBoard> {
  String? marqueeText;

  List<BannerImages> imageList = [];

  List<BranchModel> brancheslist = [];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  bool isLoading = true;
  bool isDataBinding = false;
  bool apiAllowed = true;
  late Timer _timer;
  final bool _shouldStartMarquee = true;
  List<Item> _items = [];

  String userFullName = '';

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
        getMarqueeText();
        fetchCarouselData();
        fetchData();
        fetchLoginUserInfo();

        //fetchimagesslider();
        fetchImages();
      } else {
        CommonUtils.showCustomToastMessageLong(
            'No Internet Connection', context, 1, 4);
        print('Not connected to the internet');
      }
    });
  }

  void fetchLoginUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userFullName = prefs.getString('userFullName') ?? '';
    });
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

  void fetchData() async {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 15), () {
      if (isLoading) {
        setState(() {
          isLoading = false;
          brancheslist.clear();
        });
      }
    });

    await _getData();
  }

  void fetchimagesslider() async {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 15), () {
      if (isLoading) {
        setState(() {
          isLoading = false;
          imageList.clear();
        });
      }
    });

    await fetchImages();
  }

  void fetchCarouselData() async {
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _getData() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(baseUrl + getbranches);
    print('url==>135: $url');

    bool success = false;
    int retries = 0;
    const maxRetries = 1;

    while (!success && retries < maxRetries) {
      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          print('Failed to fetch data:  $data');

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
            isLoading = false;
          });

          success = true;
        } else {
          print('Request failed with status: ${response.statusCode}');
          setState(() {
            isLoading = false;
          });
        }
      } catch (error) {
        print('Error data is not getting from the api: $error');
        setState(() {
          isLoading = false;
        });
      }

      retries++;
    }

    if (!success) {
      print('All retries failed. Unable to fetch data from the API.');
    }
  }

  Future<void> fetchImages() async {
    setState(() {
      isDataBinding = true;

      isLoading = true;
    });
    final url = Uri.parse(baseUrl + getBanners);
    print('url==>127: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        List<BannerImages> bannerImages = [];
        for (var item in jsonData['listResult']) {
          bannerImages.add(BannerImages(
              imageName: item['imageName'] ?? '', id: item['id'] ?? 0));
        }

        setState(() {
          imageList = bannerImages;
          isDataBinding = false;

          isLoading = false;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        setState(() {
          isDataBinding = false;

          isLoading = false;
        });
      }
    } catch (error) {
      print('Error images are not from the api: $error');
      setState(() {
        isDataBinding = false;
        isLoading = false;
      });
    }
  }

  void retryDataFetching() {
    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        print('Connected to the internet');
        //fetchImages();

        fetchData();
        fetchimagesslider();
      } else {
        CommonUtils.showCustomToastMessageLong(
            'No Internet Connection', context, 1, 4);
        print('Not connected to the internet');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonStyles.whiteColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Hey, ',
                      style: CommonStyles.txSty_20b_fb.copyWith(fontSize: 24),
                    ),
                    Text(
                      userFullName,
                      style: CommonStyles.txSty_20b_fb.copyWith(fontSize: 24),
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: const [
                      TextSpan(
                        text: 'Welcome to ',
                        style: TextStyle(
                          fontFamily: 'Calibri',
                          fontSize: 20,
                          color:  Color(0xFF662e91),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Hair Fixing Zone',
                        style: TextStyle(
                          fontFamily: 'Calibri',
                          fontSize: 20,
                          color: Color(0xFF0f75bc),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                //MARK: Carousel view
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  child: FlutterCarousel(
                    options: CarouselOptions(
                      floatingIndicator: false,
                      height: 180,
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      slideIndicator: const CircularSlideIndicator(
                        indicatorBorderColor: CommonStyles.blackColor,
                        currentIndicatorColor: CommonStyles.primaryTextColor,
                        indicatorRadius: 2, // Decrease the size of the indicator
                      ),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
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
                const SizedBox(height: 10),
                /* 
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: isDataBinding
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : imageList.isEmpty
                                ? const Center(
                                    
                                    child: Icon(
                                      Icons
                                          .signal_cellular_connected_no_internet_0_bar_sharp,
                                      color: Colors.red,
                                    ),
                                  )
                                : CarouselSlider(
                                    items: imageList
                                        .map((item) => Image.network(
                                              item.imageName,
                                              fit: BoxFit.fitWidth,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ))
                                        .toList(),
                                    carouselController: carouselController,
                                    options: CarouselOptions(
                                      scrollPhysics:
                                          const BouncingScrollPhysics(),
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        
            
                        height: MediaQuery.of(context).size.height,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
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
             */
                //MARK: Marquee Text
                FutureBuilder(
                  future: getMarqueeText(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    } else if (snapshot.hasError) {
                      return const SizedBox();
                    } else {
                      if (marqueeText != null) {
                        return Container(
                          height: 60,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                'assets/wave_background.png',
                              ),
                            ),
                          ),
                          child: Marquee(
                            text: marqueeText!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "Calibri",
                              fontWeight: FontWeight.w600,
                              color: CommonStyles.whiteColor,
                            ),
                            velocity: _shouldStartMarquee ? 30 : 0,
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }
                  },
                ),

                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                  const Text('Please Wait Loading Slow Internet Connection !')
                else if (brancheslist.isEmpty && imageList.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                'Failed to fetch data. Please check your internet connection.!'),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: retryDataFetching,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: isLoading ? 5 : brancheslist.length,
                        itemBuilder: (context, index) {
                          if (isLoading) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 5.0),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            BranchModel branch = brancheslist[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 5.0),
                              child: IntrinsicHeight(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(42.5),
                                    bottomLeft: Radius.circular(42.5),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Card(
                                      shadowColor: Colors.transparent,
                                      surfaceTintColor: Colors.transparent,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(29.0),
                                          bottomLeft: Radius.circular(29.0),
                                        ),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFFEE7E1),
                                                Color(0xFFD7DEFA),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Container(
                                                  width: 110,
                                                  height: 65,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xFF9FA1EE),
                                                      width: 3.0,
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7.0),
                                                    child: Image.network(
                                                      branch.imageName!,
                                                      width: 110,
                                                      height: 65,
                                                      fit: BoxFit.fill,
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;

                                                        return const Center(
                                                            child:
                                                                CircularProgressIndicator
                                                                    .adaptive());
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 15.0),
                                                        child: Text(
                                                          branch.name,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            color:CommonStyles.primaryTextColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Calibri',
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 4.0),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Image.asset(
                                                                    'assets/location_icon.png',
                                                                    width: 20,
                                                                    height: 18,
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          4.0),
                                                                  Expanded(
                                                                    child: Text(
                                                                      branch
                                                                          .address,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontFamily:
                                                                            'Calibri',
                                                                        fontSize:
                                                                            12,
                                                                        color: Color(
                                                                            0xFF000000),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const Spacer(
                                                                  flex: 3),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Container(
                                                          height: 26,
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 10.0,
                                                                  right: 10.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                              color: const Color(
                                                                  0xFF8d97e2),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          child: ElevatedButton(
                                                            onPressed: () {},
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  const Color(
                                                                      0xFF8d97e2),
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              elevation: 0,
                                                              shadowColor: Colors
                                                                  .transparent,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                            ),
                                                            child:
                                                                GestureDetector(
                                                              onTap:
                                                                  // widget
                                                                  //     .bookNowButtonPressed
                                                                  () {
                                                                Branch
                                                                    branchData =
                                                                    Branch(
                                                                  branchId:
                                                                      branch
                                                                          .id!,
                                                                  branchname:
                                                                      branch
                                                                          .name,
                                                                  branchaddress:
                                                                      branch
                                                                          .address,
                                                                  phonenumber:
                                                                      branch
                                                                          .mobileNumber,
                                                                  branchImage:
                                                                      branch
                                                                          .imageName!,
                                                                  latitude: branch
                                                                      .latitude,
                                                                  longitude: branch
                                                                      .longitude,
                                                                );

                                                                widget.toNavigate(
                                                                    branchData);

                                                                /*   Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Bookingscreen(
                                                                      branchId:
                                                                          branch
                                                                              .id!,
                                                                      branchname:
                                                                          branch
                                                                              .name,
                                                                      branchaddress:
                                                                          branch
                                                                              .address,
                                                                      phonenumber:
                                                                          branch
                                                                              .mobileNumber,
                                                                      branchImage:
                                                                          branch
                                                                              .imageName!,
                                                                      latitude:
                                                                          branch
                                                                              .latitude,
                                                                      longitude:
                                                                          branch
                                                                              .longitude,
                                                                    ),
                                                                  ),
                                                                );
                                                               */
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    'assets/datepicker_icon.svg',
                                                                    width: 15.0,
                                                                    height:
                                                                        15.0,
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 5),
                                                                  const Text(
                                                                    'Book Now',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Color(
                                                                          0xFF8d97e2),
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
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIndicator(int index) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == currentIndex ? Colors.orange : Colors.grey,
      ),
    );
  }
}

class BranchCard extends StatelessWidget {
  final Model_branch branch;

  const BranchCard({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Card(
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
                                openMap(branch);
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
        ));
  }

  Future<void> openMap(Model_branch branchnames) async {
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
      Colors.blue,
      json['imageName'] as String? ?? '',
    );
  }
}
