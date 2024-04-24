import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                    color: _currentPage == i
                        ? Colors.grey.withOpacity(0.9)
                        : Colors.transparent,
                  ),
                )
            ],
          ),
          Expanded(
            child: Marquee(
              text: 'The quick brown fox jumps over the lazy dog',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize:20),
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
          )
        ],
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
    return
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        height: 200,
        width: 150,
        child:
        Card(
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
