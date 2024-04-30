import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hairfixingzone/EditProfile.dart';
import 'package:hairfixingzone/Product_My.dart';
import 'package:hairfixingzone/SelectCity_Branch.dart';
import 'package:hairfixingzone/MyProductsProvider.dart';
import 'package:hairfixingzone/Rescheduleslotscreen.dart';
import 'package:hairfixingzone/aboutus_screen.dart';
import 'package:hairfixingzone/services/local_notifications.dart';
import 'package:hairfixingzone/splash_screen.dart';
import 'package:provider/provider.dart';
// import 'package:hairfixingservice/services/local_notifications.dart';
// import 'package:hairfixingservice/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'GetAppointments.dart';
import 'HomeScreen.dart';
import 'MyAppointment_Model.dart';
import 'MyAppointmentsProvider.dart';
import 'notifications_screen.dart';

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  print("This is a message from the background");
  print(message.notification!.title);
  print(message.notification!.body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // LocalNotificationService.initialize();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => MyProductProvider()),
    ChangeNotifierProvider(create: (context) => MyAppointmentsProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late String formattedDate;
  late final int userId;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize your LocalNotificationService here.

    _firebaseMessaging.requestPermission();
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // Handle the notification when the app is in the foreground
      print("onMessage: $message");
      String? messageBody = message.notification!.body;
      String? messagelog = message.data["message"];
      print("onMessageOpenedApp: $messageBody");
      print("onMessageOpenedApp: $messagelog");
      LocalNotificationService.showNotificationOnForeground(context, message);

      RegExp datePattern = RegExp(r'\b(\d{1,2} \w+ \d{4})\b');
      Match? match = datePattern.firstMatch(messageBody!);

      if (match != null) {
        String dateString = match.group(1)!;
        DateTime date = DateFormat("dd MMMM yyyy").parse(dateString);
        formattedDate = DateFormat("yyyy-MM-dd").format(date);
        print("Formatted Date: $formattedDate");
      } else {
        print("Date not found in the message.");
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        userId = prefs.getInt('userId')!;

        print('User ID: $userId');
        LocalNotificationService.initialize(context, navigatorKey, userId, formattedDate);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // Handle the notification when the app is opened from a terminated state
      print("onMessageOpenedApp: $message");

      String? messageBody = message.notification!.body;
      print("onMessageOpenedApp: $messageBody");

      RegExp datePattern = RegExp(r'\b(\d{1,2} \w+ \d{4})\b');
      Match? match = datePattern.firstMatch(messageBody!);

      if (match != null) {
        String dateString = match.group(1)!;
        DateTime date = DateFormat("dd MMMM yyyy").parse(dateString);
        formattedDate = DateFormat("yyyy-MM-dd").format(date);
        print("Formatted Date: $formattedDate");
      } else {
        print("Date not found in the message.");
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        int? userId = prefs.getInt('userId');

        if (userId != null) {
          print('User ID: $userId');
          navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => notifications_screen(userId: userId, formattedDate: formattedDate), // Replace with your screen widget
          ));
        } else {
          print('User ID not found in SharedPreferences');
        }
      }
    });

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   // Handle the notification when the app is in the foreground
    //   print("onMessage: $message");
    //   String? messageBody = message.notification!.body;
    //   print("onMessageOpenedApp: $messageBody");
    //
    //   RegExp datePattern = RegExp(r'\b(\d{1,2} \w+ \d{4})\b');
    //   Match? match = datePattern.firstMatch(messageBody!);
    //
    //   if (match != null) {
    //     String dateString = match.group(1)!;
    //     DateTime date = DateFormat("dd MMMM yyyy").parse(dateString);
    //     formattedDate = DateFormat("yyyy-MM-dd").format(date);
    //     print("Formatted Date: $formattedDate");
    //   } else {
    //     print("Date not found in the message.");
    //   }
    //
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    //
    //   if (isLoggedIn) {
    //     int? userId = prefs.getInt('userId');
    //
    //     if (userId != null) {
    //       print('User ID: $userId');
    //       navigatorKey.currentState?.push(MaterialPageRoute(
    //         builder: (context) =>    notifications_screen(userId: userId, formattedDate: formattedDate), // Replace with your screen widget
    //       ));
    //
    //     } else {
    //       print('User ID not found in SharedPreferences');
    //     }
    //   }
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   // Handle the notification when the app is opened from a terminated state
    //   print("onMessageOpenedApp: $message");
    //
    //   String? messageBody = message.notification!.body;
    //   print("onMessageOpenedApp: $messageBody");
    //
    //   RegExp datePattern = RegExp(r'\b(\d{1,2} \w+ \d{4})\b');
    //   Match? match = datePattern.firstMatch(messageBody!);
    //
    //   if (match != null) {
    //     String dateString = match.group(1)!;
    //     DateTime date = DateFormat("dd MMMM yyyy").parse(dateString);
    //     formattedDate = DateFormat("yyyy-MM-dd").format(date);
    //     print("Formatted Date: $formattedDate");
    //   } else {
    //     print("Date not found in the message.");
    //   }
    //
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    //
    //   if (isLoggedIn) {
    //     int? userId = prefs.getInt('userId');
    //
    //     if (userId != null) {
    //       print('User ID: $userId');
    //
    //       Future.delayed(Duration.zero, () {
    //         navigatorKey.currentState?.push(MaterialPageRoute(
    //           builder: (context) =>
    //               notifications_screen(userId: userId, formattedDate: formattedDate),
    //         ));
    //       });
    //     } else {
    //       print('User ID not found in SharedPreferences');
    //     }
    //   }
    // });

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'My App',
      routes: {
        // Home screen route
        '/about': (context) => AboutUsScreen(), // About Us screen route
        '/ReSchedulescreen': (context) {
          MyAppointment_Model? data = null;
          return data != null ? Rescheduleslotscreen(data: data) : Rescheduleslotscreen(data: data!);
        },
        '/BookAppointment': (context) => SelectCity_Branch_screen(),
        '/Mybookings': (context) => GetAppointments(),
        '/Products': (context) => ProductsMy(),
        '/EditProfile': (context) => EditProfile()

        // Add routes for other screens here
      },
      home: SplashScreen(),
    );
  }
}
