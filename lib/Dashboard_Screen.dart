import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  final List<Item> _items = [
    Item('A', Colors.red),
    Item('B', Colors.yellow),
    Item('C', Colors.green),
    Item('D', Colors.purple),
    Item('E', Colors.blue),
    Item('F', Colors.pink),
    Item('G', Colors.orange)
  ];
  final PageController _pageController =
  PageController(viewportFraction: 0.8, initialPage: 0);
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != null) {
        _page = _pageController.page!;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Two Card PageView'),
      //   centerTitle: true,
      // ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length ~/ 2 + _items.length % 2,
                itemBuilder: (context, index) {
                  return SizedBox(
                    child: Row(
                      children: [
                        Expanded(
                            child:
                            ItemBuilder(items: _items, index: index * 2)),
                        Expanded(
                            child: index * 2 + 1 >= _items.length
                                ? const SizedBox()
                                : ItemBuilder(
                                items: _items, index: index * 2 + 1)),
                      ],
                    ),
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < _items.length ~/ 2 + _items.length % 2; i++)
                Container(
                  margin: const EdgeInsets.all(2),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1.5),
                      color: _page - i > 1 || _page - i < -1
                          ? Colors.transparent
                          : _page - i > 0
                          ? Colors.grey.withOpacity(1 - (_page - i))
                          : Colors.grey.withOpacity(1 - (i - _page))),
                )
            ],
          )
        ],
      ),
    );
  }
}

class ItemBuilder extends StatelessWidget {
  const ItemBuilder({
    Key? key,
    required List<Item> items,
    required this.index,
  })  : _items = items,
        super(key: key);

  final List<Item> _items;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      height: 200,
      color: _items[index].color,
      child: Center(
          child: Text(
            _items[index].title,
            style: const TextStyle(fontSize: 25),
          )),
    );
  }
}

class Item {
  final String title;
  final Color color;

  Item(this.title, this.color);
}