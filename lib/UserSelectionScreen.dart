import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hairfixingzone/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UserLoginScreen.dart';
import 'agentloginscreen.dart';

class UserSelectionScreen extends StatefulWidget {
  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();

          return false;
        },
    child: Scaffold(

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Navigate to user login screen
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserLoginScreen()),
                  );
                },
                child: Text('User Login'),
              ),
              SizedBox(height: 20), // Add some space between buttons
              ElevatedButton(
                onPressed: () {
                  // Navigate to agent login screen
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => agentloginscreen()),
                  );
                },
                child: Text('Agent Login'),
              ),
            ],
          ),
        ),
      ),


    ));
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print('isLoggedIn: $isLoggedIn');
    if (isLoggedIn) {
      int? userId = prefs.getInt('id'); // Retrieve the user ID

      if (userId != null) {
        // Use the user ID as needed
        print('User ID: $userId');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      //  Navigator.push(context, MaterialPageRoute(builder: (context) => Branches_screen(userId: userId)));
      } else {
        // Handle the case where the user ID is not available
        print('User ID not found in SharedPreferences');
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserLoginScreen()),
      );
    }
  }
}
