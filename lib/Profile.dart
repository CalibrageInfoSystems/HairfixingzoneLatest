import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CommonUtils.dart';

class Profile extends StatefulWidget {
  @override
  Profile_screenState createState() => Profile_screenState();
}

class Profile_screenState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        print('The Internet Is Connected');

        // fetchMyAppointments(userId);
      } else {
        print('The Internet Is not  Connected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Column(
        children: [
          // search and filter
          GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushNamed("/EditProfile");
              },
              child: Icon(Icons.icecream_sharp)),
          //MARK: Appointment
        ],
      ),
    );
  }
}
