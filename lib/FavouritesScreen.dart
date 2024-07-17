import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hairfixingzone/Common/common_styles.dart';

import 'CommonUtils.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CommonStyles.whiteColor,
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
        ),
      ),
      body: Center(
        child: errorMessage(),
      ),
    );
  }

  Widget errorMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/filter.svg',
          width: 24,
          height: 24,
        ),

        const SizedBox(height: 10),
        const Text('No favourites', style: CommonStyles.txSty_20black_fb),
        const SizedBox(height: 5),
        const Text('Your favourites list is empty, Let\'s fill it up!',
            style: CommonStyles.txSty_16black_f5),
        const SizedBox(height: 8),
        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //     // backgroundColor: CommonStyles.primaryTextColor,
        //     padding: const EdgeInsets.all(10),
        //     shape: RoundedRectangleBorder(
        //       side: const BorderSide(color: Colors.black),
        //       borderRadius: BorderRadius.circular(20.0),
        //     ),
        //     // shape: const StadiumBorder(),
        //   ),
        //   onPressed: () {},
        //   child: const Text(
        //     'Start searching',
        //     style: TextStyle(color: Colors.black),
        //   ),
        // )
      ],
    );
  }
}
