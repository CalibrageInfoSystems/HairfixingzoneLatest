import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CommonUtils.dart';

class FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFf3e3ff),
          title: const Text(
            'Favourites',
            style: TextStyle(
                color: Color(0xFF0f75bc),
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: CommonUtils.primaryTextColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: Center(
        child: Text('Favourites Screen'),
      ),
    );
  }
}