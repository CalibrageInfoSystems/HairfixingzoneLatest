import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hairfixingzone/BranchModel.dart';

import 'package:hairfixingzone/Common/common_styles.dart';
import 'package:hairfixingzone/aboutus_screen.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';

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
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  String marqueeText = '';
  Future<List<BranchModel>>? apiData;
  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentPage);
    _fetchItems();
    _startAutoScroll();
    apiData = getBranchsData();
    getMarqueeText();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _fetchItems() async {
    final response = await http.get(Uri.parse(
        'http://182.18.157.215/SaloonApp/API/GetBranchById/null/true'));

    if (response.statusCode == 200) {
      setState(() {
        _items = (json.decode(response.body)['listResult'] as List)
            .map((item) => Item.fromJson(item))
            .toList();
      });
    } else {
      throw Exception('Failed to load items');
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_currentPage < _items.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  Future<void> getMarqueeText() async {
    final apiUrl = Uri.parse('http://182.18.157.215/SaloonApp/API/GetContent');

    try {
      final jsonResponse = await http.get(apiUrl);

      if (jsonResponse.statusCode == 200) {
        final response = json.decode(jsonResponse.body);

        if (response['isSuccess']) {
          int records = response['affectedRecords'];
          for (var i = 0; i < records; i++) {
            marqueeText =
            '${marqueeText + response['listResult'][i]['text']}  ';
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
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final itemIndex = index % _items.length;
                return SizedBox(
                  child: Row(
                    children: [
                      Expanded(
                        child: ItemBuilder(items: _items, index: itemIndex),
                      ),
                    ],
                  ),
                );
              },
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < _items.length; i++)
                Container(
                  margin: const EdgeInsets.all(2),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 1.5),
                    color: _currentPage == i
                        ? Colors.grey.withOpacity(0.9)
                        : Colors.transparent,
                  ),
                )
            ],
          ),
          const SizedBox(height: 5),
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
                    //'The quick brown fox jumps over the lazy dog', //MARK: Marquee
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    scrollAxis: Axis.horizontal, //scroll direction
                    crossAxisAlignment: CrossAxisAlignment.start,
                    blankSpace: 20.0,
                    velocity: 50.0, //speed
                    pauseAfterRound: const Duration(seconds: 1),
                    startPadding: 10.0,
                    numberOfRounds: null,
                    accelerationDuration: const Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: const Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                //MARK: Book Appointment
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: CommonStyles.primaryTextColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.home),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Click Here'),
                            Text('To Book an Appointment'),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.home),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //MARK: Screens
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 85,
                          height: 85,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 240, 124, 230),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.home),
                        ),
                        const SizedBox(height: 5),
                        const Text('My Bookings'),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 85,
                          height: 85,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 228, 67, 67),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.home),
                        ),
                        const SizedBox(height: 5),
                        const Text('Products'),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 85,
                          height: 85,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 115, 26, 199),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.home),
                        ),
                        const SizedBox(height: 5),
                        const Text('About Us'),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 85,
                          height: 85,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 3, 104, 65),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.home),
                        ),
                        const SizedBox(height: 5),
                        const Text('My Profile'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                //MARK: Branches
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Branches'),
                  ],
                ),

                const SizedBox(height: 5),

                SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: FutureBuilder(
                    future: apiData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else {
                        List<BranchModel>? data = snapshot.data!;
                        return Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 140,
                                height: 170,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Image.network(data[index].imageName!),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 140,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(data[index].name),
                                            Text(
                                              data[index].address,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _customheightCard({
    required String imageUrl,
    required String item,
    required String item_1,
    required Color color,
    required Color color_1,
    required Color textcolor,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        //  height: MediaQuery.of(context).size.height * (4 / 9) - 250 / 2,
        height: MediaQuery.of(context).size.height / 3.3,
        // height: height,
        width: MediaQuery.of(context).size.width / 2,
        child: Card(
          color: color,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 8,
          child: Padding(
            padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 0),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color_1,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SvgPicture.asset(
                    "assets/$imageUrl",
                    width: 30.0,
                    height: 30.0,
                    color: const Color(0xFF414141),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w700,
                        color: textcolor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 14,
                            color: textcolor,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w600),
                        children: const [
                          // TextSpan(
                          //   text: 'All Incoming and\n',
                          // ),
                          // WidgetSpan(
                          //   child: SizedBox(height: 25),
                          // ),
                          // TextSpan(
                          //   text: 'Outgoing Transactions\n',
                          // ),
                          // WidgetSpan(
                          //   child: SizedBox(height: 25),
                          // ),
                          // TextSpan(
                          //   text: 'Record',
                          // ),
                          TextSpan(
                              text:
                              'All Incoming and Outgoing Transactions record',
                              style: TextStyle(height: 2))
                        ],
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _customwidthCard({
    required String imageUrl,
    required String item,
    required Color color,
    required String item1,
    required VoidCallback? onTap,
    required Color color_1,
    required Color textcolor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        //  height: MediaQuery.of(context).size.width * (3.8 / 9) - 110 / 2,
        width: MediaQuery.of(context).size.width / 2.25,
        //  height: 275 / 2,
        height: MediaQuery.of(context).size.height / 6,
        child: Card(
          color: color,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 8,
          child: Padding(
            padding:
            const EdgeInsets.only(left: 10, right: 15, top: 7, bottom: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color_1,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SvgPicture.asset(
                    "assets/$imageUrl",
                    width: 20.0,
                    height: 22.0,
                    color: const Color(0xFF414141),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      item,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w700,
                          color: textcolor),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 8.0,
                // ),
                Text(
                  item1,
                  style: const TextStyle(
                      fontSize: 12,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF414141)),
                ),
                // Expanded(
                //   child: Align(
                //     alignment: Alignment.topLeft,
                //     child: Text(
                //       item1,
                //       style: TextStyle(
                //           fontSize: 12,
                //           fontFamily: "Roboto",
                //           fontWeight: FontWeight.w500,
                //           color: Color(0xFF414141)),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _customcontainerCard({
    //  required String imageUrl,
    required String item,
    required String item1,
    required Color color,
    required VoidCallback? onTap,
    required Color color_1,
    required Color textcolor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        //height: 260 / 2,
        height: MediaQuery.of(context).size.height / 6,
        width: MediaQuery.of(context).size.width / 2,
        child: Card(
          color: color,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 8,
          child: Padding(
            padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // SizedBox(height: 8),
                // Container(
                //   margin: const EdgeInsets.only(bottom: 6),
                //   padding: const EdgeInsets.all(6),
                //   decoration: BoxDecoration(
                //     color: color_1,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: SvgPicture.asset(
                //     "assets/$imageUrl",
                //     width: 20.0,
                //     height: 22.0,
                //     color: const Color(0xFF414141),
                //   ),
                // ),
                const SizedBox(height: 8),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      item,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w700,
                          color: textcolor),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  item1,
                  style: const TextStyle(
                      fontSize: 12,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF414141)),
                ),
                // Expanded(
                //   child: Align(
                //     alignment: Alignment.topLeft,
                //     child: Text(
                //       item1,
                //       style: TextStyle(
                //           fontSize: 12,
                //           fontFamily: "Roboto",
                //           fontWeight: FontWeight.w500,
                //           color: Color(0xFF414141)),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _customcontainernewCard({
    required String imageUrl,
    required String item,
    required String item1,
    required Color color,
    required VoidCallback? onTap,
    required Color color_1,
    required Color textcolor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 10,
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: color,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 8,
          child: Padding(
            padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color_1,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset(
                    "assets/$imageUrl",
                    width: 20.0,
                    height: 22.0,
                    color: const Color(0xFF414141),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start, // Adjusted to center
                    mainAxisAlignment:
                    MainAxisAlignment.center, // Added to center
                    children: [
                      Text(
                        item,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w700,
                            color: textcolor),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        item1,
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF414141)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<BranchModel>> getBranchsData() async {
    const apiUrl =
        'http://182.18.157.215/SaloonApp/API/GetBranchById/null/true';

    try {
      final jsonResponse = await http.get(
        Uri.parse(apiUrl),
      );

      if (jsonResponse.statusCode == 200) {
        Map<String, dynamic> response = jsonDecode(jsonResponse.body);
        List<dynamic> branchesData = response['listResult'];
        List<BranchModel> result =
        branchesData.map((e) => BranchModel.fromJson(e)).toList();
        print('result: ${result[0].name}');
        print('result: ${result[0].address}');
        print('result: ${result[0].imageName}');
        return result;
      } else {
        throw Exception('api failed');
      }
    } catch (e) {
      rethrow;
    }
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
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      height: 200,
      width: 150,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4, // Optional: Add elevation for a shadow effect
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            items[index].imageName,
            height: 100,
            fit: BoxFit.cover,
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
