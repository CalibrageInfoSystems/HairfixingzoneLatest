import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Branches_screen.dart';
import 'HomeScreen.dart';
import 'UserLoginScreen.dart';
import 'UserSelectionScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    requestNotificationPermission();

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
       // navigateTouserselection();
        checkLoginStatus();

        //  navigateToHome();
      }
    });

    _animationController.forward();
    // Call checkLoginStatus here

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateTouserselection() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => UserSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: _animation.value,
                child: Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 200,
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  Future<void> requestNotificationPermission() async {
    final prefs = await SharedPreferences.getInstance();
    final isGranted = prefs.getBool('notificationPermissionStatus') ?? false;
    PermissionStatus status = await Permission.notification.request();
    if (!isGranted) {
      if (status.isGranted) {
        print('permissionisaccepted');
        await storeNotificationPermissionStatus(true);
        print('permissionisstored');
      }
    } else if (status.isDenied) {
      navigateTouserselection();
      // The user denied permission
      // You may want to inform the user about why you need this permission
    } else if (status.isPermanentlyDenied) {
      // The user denied permission permanently
      // You should guide the user to app settings to enable the permission manually
      openAppSettings();
    }
  }

  Future<void> storeNotificationPermissionStatus(bool isGranted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationPermissionStatus', isGranted);
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print('isLoggedIn: $isLoggedIn');
    if (isLoggedIn) {
      int? userId = prefs.getInt('userId'); // Retrieve the user ID
      int? roleId = prefs.getInt('userRoleId'); // Retrieve the role ID

     // if (userId != null && roleId != null) {
      if (userId != null ) {
        // Use the user ID and role ID as needed
        print('User ID: $userId, Role ID: $roleId');
        if (roleId == 2) {
          // Navigate to home screen for users with role ID 1
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          // Navigate to another screen for users with different role ID
          // For example, you might have a different screen for users with role ID 2
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Branches_screen(userId: userId)));

        }
      } else {
        // Handle the case where the user ID or role ID is not available
        print('User ID or Role ID not found in SharedPreferences');
      }
    } else {
      // If not logged in, navigate to the login screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserSelectionScreen()),
      );
    }
  }

}
