import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hairfixingzone/Common/common_styles.dart';
import 'package:hairfixingzone/CommonUtils.dart';
import 'package:hairfixingzone/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SlotSuccessScreen extends StatefulWidget {
  final String slotdate;
  final String slottime;
  final String Purpose;
  final String slotbranchname;
  final String slotbrnach_address;
  final String phonenumber;
  final String branchImage;
  final double? latitude;
  final double? longitude;

  const SlotSuccessScreen(
      {super.key,
      required this.slotdate,
      required this.slottime,
      required this.Purpose,
      required this.slotbranchname,
      required this.slotbrnach_address,
      required this.phonenumber,
      required this.branchImage,
      required this.latitude,
      required this.longitude});
  @override
  State<SlotSuccessScreen> createState() => _SlotSuccessScreenState();
}

class _SlotSuccessScreenState extends State<SlotSuccessScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller2;
  static const textStyle = TextStyle(
    fontSize: 20,
    fontFamily: "Outfit",
    color: Colors.black,
  );

  static const txSty_20pr_fb = TextStyle(
    fontSize: 20,
    fontFamily: "Outfit",
    fontWeight: FontWeight.bold,
    color: Color(0xFF662e91),
  );

  @override
  void initState() {
    super.initState();
    print('latitude  success${widget.latitude}');
    print('longitude success  ${widget.longitude}');

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  final primaryTextColor = const Color(0xFF662e91);
  final primaryGreen = const Color.fromARGB(255, 4, 138, 73);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xffffffff),
            title: const Text(
              'Booked Successfully',
              style: TextStyle(color: Color(0xFF0f75bc), fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Center(
                                child: RotationTransition(
                                  turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                                  child: DottedBorder(
                                    borderType: BorderType.Circle,
                                    strokeWidth: 3,
                                    dashPattern: const <double>[9, 5],
                                    padding: const EdgeInsets.all(25),
                                    color: primaryGreen,
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              RotationTransition(
                                turns: Tween(begin: 0.0, end: 1.0).animate(_controller2),
                                child: SvgPicture.asset(
                                  'assets/check.svg',
                                  width: 60,
                                  height: 60,
                                  color: primaryGreen,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Column(
                        children: [
                          Text(
                            'Appointment',
                            style: txSty_20pr_fb,
                          ),
                          Text(
                            'Booked Successfully',
                            style: txSty_20pr_fb,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          //height: MediaQuery.of(context).size.height / 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  const Text(
                                    'On ',
                                    style: textStyle,
                                  ),
                                  Text(
                                    widget.slotdate,
                                    style: CommonStyles.txSty_20b_fb,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                  const Text(
                                    ' ',
                                    style: textStyle,
                                  ),
                                  Text(
                                    widget.slottime,
                                    style: CommonStyles.txSty_20b_fb,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  const Text(
                                    'for ',
                                    style: textStyle,
                                  ),
                                  Text(
                                    widget.Purpose,
                                    style: CommonStyles.txSty_20b_fb,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                  const Text(
                                    ' at ',
                                    style: textStyle,
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    Flexible(
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: widget.slotbranchname,
                                          style: CommonStyles.txSty_20b_fb,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ' Branch',
                                              style: textStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          // decoration: BoxDecoration(
                          //   color: Colors.white,
                          //   borderRadius: BorderRadius.circular(10),
                          // ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            // borderRadius: BorderRadius.circular(30), //border corner radius
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF960efd).withOpacity(0.2), //color of shadow
                                spreadRadius: 2, //spread radius
                                blurRadius: 4, // blur radius
                                offset: const Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      widget.branchImage,
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 60,
                                    ),
                                    // Image.asset(
                                    //   'assets/hairfixing_logo.png',
                                    //   width: 100,
                                    //   height: 60,
                                    // ),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        // onTap: () {
                                        //   String phoneNumber =
                                        //       widget.phonenumber;
                                        //   launch("tel:$phoneNumber");
                                        // },
                                        onTap: openPhone,
                                        child: Container(
                                          padding: const EdgeInsets.all(1),
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(
                                          //       color: CommonStyles.statusGreenText,
                                          //     ),
                                          //     shape: BoxShape.circle),
                                          child:
                                          SvgPicture.asset(
                                            'assets/phone_call.svg',
                                            width: 25,
                                            height: 25,
                                            color: CommonStyles.statusGreenText,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      GestureDetector(
                                        onTap: openMap,
                                        child: Container(
                                          padding: const EdgeInsets.all(1),
                                        //  decoration: BoxDecoration(border: Border.all(color: CommonStyles.primaryTextColor), shape: BoxShape.circle),
                                          child: Image.asset(
                                            'assets/location_icon.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.slotbranchname,
                                style: CommonStyles.txSty_20blu_fb,
                              ),
                              Text(
                                widget.slotbrnach_address,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                print('Back to Home btn clicked');
                                // sharedprefsdelete();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  HomeScreen()),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: primaryTextColor),
                                ),
                                child: const Center(child: Text('Back to Home')),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                print('My Appointments btn clicked');
                                Navigator.of(context, rootNavigator: true).pushNamed("/Mybookings");
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: primaryTextColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: primaryTextColor),
                                ),
                                child: const Center(
                                  child: Text(
                                    'My Appointments',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // Future<void> _makePhoneCall(String phoneNumber) async {
  //   if (await canLaunch(phoneNumber)) {
  //     await launch(phoneNumber);
  //   } else {
  //     throw 'Could not launch $phoneNumber';
  //   }
  // }

  Future<void> openPhone() async {
    final url = 'tel:${widget.phonenumber}';
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      print(e);
    }
  }

  Future<void> openMap() async {
    // if (widget.latitude != null && widget.longitude != null) {
    //   final String url = 'https://www.google.com/maps?q=${widget.latitude},${widget.longitude}';
    //   print('getbrancheslist: $url');
    //   try {
    //     await launchUrl(Uri.parse(url));
    //   } catch (e) {
    //     print(e);
    //   }
    // } else {
    //   CommonUtils.showCustomToastMessageLong('Location not found', context, 1, 3);
    // }
    // final String url =
    //     'https://www.google.com/maps?q=$label@${widget.latitude},${widget.longitude}';
    if (widget.latitude != null && widget.longitude != null) {
      final String label = 'Hair Fixing Zone - ${widget.slotbranchname}';
      final String url = 'geo:${widget.latitude},${widget.longitude}?q=${Uri.encodeComponent(label)}';

      // final String url =
      //     'https://maps.app.goo.gl/wp5rYLH6Z7sxnFDB6';
      print('getbrancheslist: $url');
      try {
        await launchUrl(Uri.parse(url));
      } catch (e) {
        print(e);
      }
    } else {
      CommonUtils.showCustomToastMessageLong(
          'Location not found', context, 1, 3);
    }
  }

  Future<void> sharedprefsdelete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.remove('userId'); // Remove userId from SharedPreferences
    prefs.remove('userRoleId');
  }
}
