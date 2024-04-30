import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hairfixingzone/Common/common_styles.dart';
import 'package:hairfixingzone/HomeScreen.dart';

class SlotSuccessScreen extends StatefulWidget {
  final String slotdate;
  final String slottime;
  final String Purpose;
  final String slotbranchname;
  final String slotbrnach_address;
//  final int phonenumber;

  SlotSuccessScreen({
    required this.slotdate,
    required this.slottime,
    required this.Purpose,
    required this.slotbranchname,
    required this.slotbrnach_address,
    // required this.phonenumber
  });
  @override
  State<SlotSuccessScreen> createState() => _SlotSuccessScreenState();
}

class _SlotSuccessScreenState extends State<SlotSuccessScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller2;
  static const textStyle = TextStyle(
    fontSize: 20,
    fontFamily: "Calibri",
    color: Colors.black,
  );

  static const txSty_20pr_fb = TextStyle(
    fontSize: 20,
    fontFamily: "Calibri",
    fontWeight: FontWeight.bold,
    color: Color(0xFF662e91),
  );

  @override
  void initState() {
    super.initState();
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
            backgroundColor: const Color(0xFFf3e3ff),
            title: const Text(
              'Booked Successfully',
              style: TextStyle(color: Color(0xFF0f75bc), fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            // leading: IconButton(
            //   icon: Icon(
            //     Icons.arrow_back_ios,
            //     color: CommonUtils.primaryTextColor,
            //   ),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // )
          ),
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    padding: const EdgeInsets.all(30),
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
                                  width: 70,
                                  height: 70,
                                  color: primaryGreen,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
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
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'On ',
                                style: textStyle,
                              ),
                              Text(
                                '${widget.slotdate}',
                                style: CommonStyles.txSty_20b_fb,
                              ),
                              Text(
                                ' by ',
                                style: textStyle,
                              ),
                              Text(
                                '${widget.slottime}',
                                style: CommonStyles.txSty_20b_fb,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'for ',
                                style: textStyle,
                              ),
                              Text(
                                '${widget.Purpose}',
                                style: CommonStyles.txSty_20b_fb,
                              ),
                              Text(
                                ' at ',
                                style: textStyle,
                              ),
                              Text(
                                '${widget.slotbranchname}',
                                style: CommonStyles.txSty_20b_fb,
                              ),
                              Text(
                                ' branch',
                                style: textStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
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
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    color: Colors.red,
                                    child: Image.asset(
                                      'assets/hairfixing_logo.png',
                                      width: 100,
                                      height: 60,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: CommonStyles.statusGreenText,
                                            ),
                                            shape: BoxShape.circle),
                                        child: SvgPicture.asset(
                                          'assets/phone_call.svg',
                                          width: 30,
                                          height: 30,
                                          color: CommonStyles.statusGreenText,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(border: Border.all(color: CommonStyles.primaryTextColor), shape: BoxShape.circle),
                                        child: SvgPicture.asset(
                                          'assets/map_marker.svg',
                                          width: 30,
                                          height: 30,
                                          color: CommonStyles.primaryTextColor,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${widget.slotbranchname}',
                                style: CommonStyles.txSty_20blu_fb,
                              ),
                              Text(
                                '${widget.slotbrnach_address}',
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen()),
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
}
