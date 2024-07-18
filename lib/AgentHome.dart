import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Adjustable Height Widget'),
        ),
        body: const Center(
          child: AdjustableHeightWidget(),
        ),
      ),
    );
  }
}

class AdjustableHeightWidget extends StatelessWidget {
  static final List<String> items = [
    'Segmented buttons are used to help people select options, switch views, or sort elements. They are typically used in cases where there are only 2-5 options.',
    'By default, a checkmark icon is used to show electedIcon fields.',
    'To configure this behavior, you can use the showSelectedIcon and selectedIcon fields.',
    'The options are represented by segments described with ButtonSegment entries in the segments field. Each segment has a ButtonSegment.value that is used to indicate which segments are selected.',
    'It is used to show electedIcon fields.',
    'To configure this behavior, yelectedIcon and selectedIcon fields.',
    'To configure this behavior, yoIcon fields.',
    'To configure this behavior, a checkmark icon is used to show electedIcon fields. you can use the showSelectedIcon and selectedIcon fields.',
    'Segmented buttons are used to help people select options, switch views, or sort elements. They are typically used in cases where there are only 2-5 options.',
    'By default, a checkmark icon is used to show electedIcon fields.',
    'To configure this behavior, you can use the showSelectedIcon and selectedIcon fields.',
    'The options are represented by segments described with ButtonSegment entries in the segments field. Each segment has a ButtonSegment.value that is used to indicate which segments are selected.',
    'It is used to show electedIcon fields.',
    'To configure this behavior, yelectedIcon and selectedIcon fields.',
    'To configure this behavior, yoIcon fields.',
    'To configure this behavior, a checkmark icon is used to show electedIcon fields. you can use the showSelectedIcon and selectedIcon fields.',
  ];
  const AdjustableHeightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final content = items[index];
        return item(content);
      },
    );
  }

  Padding item(String item) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue,
          child: Text(
            'x',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            item,
          ),
        ),
        const SizedBox(width: 10),
        const Icon(
          Icons.arrow_right_rounded,
          size: 26,
        ),
      ]),
    );
  }
}
