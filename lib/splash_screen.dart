import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'HomeScreen.dart';

class  SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
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
        navigateToHome();
      }
    });

    _animationController.forward();

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
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
    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      // The user granted permission
      // You can now send notifications
      navigateToHome();
    } else if (status.isDenied) {
      navigateToHome();
      // The user denied permission
      // You may want to inform the user about why you need this permission
    } else if (status.isPermanentlyDenied) {
      // The user denied permission permanently
      // You should guide the user to app settings to enable the permission manually
      openAppSettings();
    }
  }
}
