import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CommonUtils.dart';
import 'CustomerLoginScreen.dart';
import 'CustomerRegisterScreen.dart';
import 'agentloginscreen.dart';


class startingscreen extends StatefulWidget {
  @override
  _startingscreenState createState() => _startingscreenState();
}

class _startingscreenState extends State<startingscreen>  {


  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    // Call checkLoginStatus here

  }

  @override
  void dispose() {

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Color(0xFFefdbfe), // Background color
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 3, // 3/4 of the space
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/befor_login_illustration.png'),
                    fit: BoxFit.fitWidth, // Adjusted BoxFit
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2, // 1/4 of the space
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Color of the second container
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 12.0, right: 12.0),
                            child: Text('Helping you to take good ', style: CommonUtils.header_Styles),
                          ),
                        ),

                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                            child: Text(' care of you Hair!', style: CommonUtils.header_Styles),
                          ),
                        ),
                        SizedBox(height: 20), // Space between text and buttons
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => CustomerLoginScreen()),
                                );

                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(fontSize: 20), // Increased font size
                              ),
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(Size(150, 40)), // Set the minimum size for the button
                                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                    return Colors.white; // Use white text color
                                  },
                                ),
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                    return Color(0xFF662e91); // Use purple background color
                                  },
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: BorderSide(color: Color(0xFF662e91), width: 2.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
    Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => CustomerRegisterScreen()),
    );

                                // Action for Register button
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(fontSize: 20), // Increased font size
                              ),
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(Size(150, 40)), // Set the minimum size for the button
                                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                    return Color(0xFF0f75bc); // Use blue text color
                                  },
                                ),
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                    return Colors.white; // Use white background color
                                  },
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: BorderSide(color: Color(0xFF0f75bc), width: 2.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 12.0, right: 12.0,bottom: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Agent Login?', style: CommonUtils.Mediumtext_14),
                              SizedBox(width: 8.0),
                              GestureDetector(
                                onTap: () {
                                  // Handle the click event for the "Click here!" text
                                  print('Click here! clicked');
                                 // Add your custom logic or navigation code here
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => agentloginscreen(),
                                    ),
                                  );
                                },
                                child: Text('Click Here!', style: CommonUtils.Mediumtext_o_14),
                              )
                            ],
                          ),
                        ),
                  ) ],
                    ),
                ),
              ),
            ),
          ],
        ),

      );



  }




}
