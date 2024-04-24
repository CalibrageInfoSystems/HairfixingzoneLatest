import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _fetchItems();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _fetchItems() async {
    final response = await http.get(Uri.parse('http://182.18.157.215/SaloonApp/API/GetBranchById/null/true'));

    if (response.statusCode == 200) {
      setState(() {
        _items = (json.decode(response.body)['listResult'] as List).map((item) => Item.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load items');
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 5), (_) {
      if (_currentPage < _items.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
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
                    color: _currentPage == i ? Colors.grey.withOpacity(0.9) : Colors.transparent,
                  ),
                )
            ],
          ),
          Container(
            height: 30,
            child: Marquee(
              text: 'The quick brown fox jumps over the lazy dog',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              scrollAxis: Axis.horizontal, //scroll direction
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 20.0,
              velocity: 50.0, //speed
              pauseAfterRound: Duration(seconds: 1),
              startPadding: 10.0,
              accelerationDuration: Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            ),
          ),
          Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Add some spacing between the rows
                      // Second Row
                      Row(
                        children: [
                          // First Container with single card view
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height / 3, // Match height with the first container
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: _customcontainerCard(
                                        //imageUrl: "creditcard.svg",
                                        item: "Create About us",
                                        item1: "Create About us",
                                        color: Color(0xFFb7dbc1),
                                        color_1: Color(0xFF43a05a),
                                        textcolor: Color(0xFF118730),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => AboutUsScreen()),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Expanded(
                                    child: Container(
                                      child: _customcontainerCard(
                                        //     imageUrl: "arrows_repeat.svg",
                                        item: "Create Return order",
                                        item1: "Create a Reorder",
                                        color: Color(0xFFF8dac2),
                                        color_1: Color(0xFFec9d62),
                                        textcolor: Color(0xFFe78337),
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Second Container divided into two equal-sized containers

                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height / 3, // Match height with the first container
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: _customcontainerCard(
                                        //     imageUrl: "album_collection.svg",
                                        item: "View Collections",
                                        item1: "View All Collections",
                                        color: Color(0xFFF8dac2),
                                        color_1: Color(0xFFec9d62),
                                        textcolor: Color(0xFFe78337),
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Expanded(
                                    child: Container(
                                      child: _customcontainerCard(
                                        //     imageUrl: "bags-orders.svg",
                                        item: "View Return order",
                                        item1: "View All Reorders",
                                        color: Color(0xFFb7dbc1),
                                        color_1: Color(0xFF43a05a),
                                        textcolor: Color(0xFF118730),
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ))
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 0),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color_1,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SvgPicture.asset(
                    "assets/" + imageUrl,
                    width: 30.0,
                    height: 30.0,
                    color: Color(0xFF414141),
                  ),
                ),
                SizedBox(height: 15),
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
                        style: TextStyle(fontSize: 14, color: textcolor, fontFamily: "Roboto", fontWeight: FontWeight.w600),
                        children: [
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
                          TextSpan(text: 'All Incoming and Outgoing Transactions record', style: TextStyle(height: 2))
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 15, top: 7, bottom: 3),
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
                      style: TextStyle(fontSize: 16, fontFamily: "Roboto", fontWeight: FontWeight.w700, color: textcolor),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 8.0,
                // ),
                Text(
                  item1,
                  style: const TextStyle(fontSize: 12, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: Color(0xFF414141)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
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
                      style: TextStyle(fontSize: 16, fontFamily: "Roboto", fontWeight: FontWeight.w700, color: textcolor),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  item1,
                  style: const TextStyle(fontSize: 12, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: Color(0xFF414141)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
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
                    crossAxisAlignment: CrossAxisAlignment.start, // Adjusted to center
                    mainAxisAlignment: MainAxisAlignment.center, // Added to center
                    children: [
                      Text(
                        item,
                        maxLines: 1,
                        style: TextStyle(fontSize: 16, fontFamily: "Roboto", fontWeight: FontWeight.w700, color: textcolor),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        item1,
                        style: const TextStyle(fontSize: 12, fontFamily: "Roboto", fontWeight: FontWeight.w500, color: Color(0xFF414141)),
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
      json['imageName'] as String? ?? '', // Add null check and provide a default value
    );
  }
}
