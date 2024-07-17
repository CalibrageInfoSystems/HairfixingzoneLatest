import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hairfixingzone/CustomerLoginScreen.dart';
import 'package:hairfixingzone/MyAppointment_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Booking_Screen.dart';
import 'CityData_Model.dart';
import 'Common/common_styles.dart';
import 'Common/custom_button.dart';
import 'CommonUtils.dart';
import 'CustomRadioButton.dart';
import 'Model_Branch.dart';
import 'Room.dart';
import 'api_config.dart';

class SelectCity_Branch_screen extends StatefulWidget {
  const SelectCity_Branch_screen({super.key});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class Slot {
  final int branchId;
  final String name;
  final DateTime date;
  final int room;
  final String slot;
  final String SlotTimeSpan;

  final int availableSlots;

  Slot({
    required this.branchId,
    required this.name,
    required this.date,
    required this.room,
    required this.slot,
    required this.availableSlots,
    required this.SlotTimeSpan,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      branchId: json['branchId'],
      name: json['name'],
      date: DateTime.parse(json['dates']),
      room: json['room'],
      slot: json['slot'],
      availableSlots: json['availableSlots'],
      SlotTimeSpan: json['slotTimeSpan'],
    );
  }
}

class _BookingScreenState extends State<SelectCity_Branch_screen> {
  List<Model_branch> model_branches = [];
  List<dynamic> dropdownItems = [];
  List<CityItem> citydatamodel = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int selectedTypeCdId = -1;
  late int selectedValue;
  late String selectedName;
  bool isLoading = false;

  @override
  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();

    getcitylist();
    getbrancheslist(null);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => onBackPressed(context),
        child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: const Color(0xFFf3e3ff),
                title: const Text(
                  'Select City and Branch',
                  style: TextStyle(
                      color: Color(0xFF0f75bc),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600),
                ),
                // actions: [
                //   IconButton(
                //     icon: SvgPicture.asset(
                //       'assets/sign-out-alt.svg', // Path to your SVG asset
                //       color: Color(0xFF662e91),
                //       width: 24, // Adjust width as needed
                //       height: 24, // Adjust height as needed
                //     ),
                //     onPressed: () {
                //       logOutDialog(context);
                //       // Add logout functionality here
                //     },
                //   ),
                // ],
                // centerTitle: true,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: CommonUtils.primaryTextColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )),
            //body: YourBodyWidget(),
            body: SingleChildScrollView(
              //physics: NeverScrollableScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            'City ',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Muli",
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF662e91),
                            ),
                          ),
                          Text(
                            '',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 0, top: 5.0, right: 0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: CommonUtils.primaryTextColor,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButtonFormField<int>(
                                  value: selectedTypeCdId,
                                  iconSize: 30,
                                  //  validator: (value) => value == null ? "Select a country" : null,
                                  validator: (value) {
                                    if (value == -1) {
                                      return 'Select a City';
                                    }
                                    return null;
                                  },
                                  icon: null,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder
                                        .none, // Hide the underline here
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedTypeCdId = value!;
                                      if (selectedTypeCdId != -1) {
                                        selectedValue = dropdownItems[selectedTypeCdId]['typecdid'];
                                        selectedName = dropdownItems[selectedTypeCdId]['desc'];
                                        getbrancheslist(selectedValue);
                                        print("selectedValue:$selectedValue");
                                        print("selectedName:$selectedName");
                                      } else {
                                        print("==========");
                                        getbrancheslist(null);
                                        print(selectedValue);
                                        print(selectedName);
                                      }

                                      // isDropdownValid = selectedTypeCdId != -1;
                                    });
                                  },
                                  items: [
                                    const DropdownMenuItem<int>(
                                      value: -1,
                                      child: Text(
                                        'Select City',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      // Static text
                                    ),
                                    ...dropdownItems
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final index = entry.key;
                                      final item = entry.value;
                                      return DropdownMenuItem<int>(
                                        value: index,
                                        child: Text(item['desc']),
                                      );
                                    }).toList(),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                  if ( model_branches.isEmpty)
                    const SizedBox(
                      height: 200.0,
                    ), // Default image asset path
                      const SizedBox(
                        height: 15.0,
                      ), //

                      isLoading
                          ? Center(
                        child: CircularProgressIndicator(),
                      )
                          : model_branches.isEmpty
                          ? Center(
                        child: Text(
                          'No Branches Available',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto",
                          ),
                        ),
                      )

                          : ListView.builder(
                          itemCount: model_branches.length,
                          shrinkWrap: true,
                          physics: const PageScrollPhysics(),
                          itemBuilder: (context, index) {
                            Model_branch branchnames = model_branches[index];
                            String? imageUrl = branchnames.imageName;

                            // Check if imageUrl is null or empty, then assign default image URL or asset path
                            if (imageUrl!.isEmpty) {
                              imageUrl =
                              'assets/top_image.png'; // Default image asset path
                            }
                            return Container(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                width: MediaQuery.of(context).size.width,
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Bookingscreen(
                                            branchId: branchnames.id!,
                                            branchname: branchnames.branchName!,
                                            branchaddress: branchnames.address!,
                                            phonenumber: branchnames.mobileNumber!,
                                            branchImage: branchnames.imageName!,
                                            latitude: branchnames.latitude,
                                            longitude: branchnames.longitude,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height:
                                      MediaQuery.of(context).size.height /
                                          8,
                                      width: MediaQuery.of(context).size.width,
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(color: Color(0xFF662e91), width: 1.0),
                                      //   borderRadius: BorderRadius.circular(10.0),
                                      // ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        // borderRadius: BorderRadius.circular(30), //border corner radius
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF960efd)
                                                .withOpacity(
                                                0.2), //color of shadow
                                            spreadRadius: 2, //spread radius
                                            blurRadius: 4, // blur radius
                                            offset: const Offset(0,
                                                2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child:
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            child: Image.network(
                                              imageUrl.isNotEmpty
                                                  ? imageUrl
                                                  : 'https://example.com/placeholder-image.jpg',
                                              fit: BoxFit.cover,
                                              height: MediaQuery.of(context).size.height / 4 / 2,
                                              width: MediaQuery.of(context).size.width / 3.2,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/hairfixing_logo.png', // Path to your PNG placeholder image
                                                  fit: BoxFit.cover,
                                                  height: MediaQuery.of(context).size.height / 4 / 2,
                                                  width: MediaQuery.of(context).size.width / 3.2,
                                                );
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              width: MediaQuery.of(context).size.width / 2.2,
                                              padding: const EdgeInsets.only(top: 7,right: 7),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          branchnames.branchName!,
                                                          style: const TextStyle(
                                                            color: Color(0xFF0f75bc),
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          openMap(branchnames); // Call the openMap method
                                                        },
                                                        child: SvgPicture.asset(
                                                          'assets/map_marker.svg',
                                                          width: 20,
                                                          height: 20,
                                                          color: CommonStyles.statusGreenText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    branchnames.address!,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: CommonStyles.txSty_12b_f5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )



                                    )));
                          })
                    ],
                  ),
                ),
              ),
            )));
  }

  void getcitylist() async {
    final url = Uri.parse(baseUrl + getcity);
    print('url$url');
    try {
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);

        List<CityItem> cityList = [];
        if (jsonData['listResult'] != null && jsonData['listResult'] is List) {
          for (var item in jsonData['listResult']) {
            cityList.add(CityItem.fromJson(item));
            print('typecdid: ${item['typecdid']}, desc: ${item['desc']}');
          }

// To print the entire listResult JSON data
          print('listResult JSON data: ${jsonData['listResult']}');
        } else {
          print('Error: listResult is null or not a List');
        }

        setState(() {
          dropdownItems = jsonData['listResult'];
          citydatamodel = cityList;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data from API: $error');
    }
  }

  void getbrancheslist(int? cityid) async {
    setState(() {
      isLoading = true; // Start loading
    });

    final url = Uri.parse(baseUrl + getbrancheselectedcity + cityid.toString());
    print('getbrancheslist: $url');
    try {
      final http.Response response = await http.get(url);

      print('Response body: ${response.body}'); // Print response body for debugging

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);

        List<Model_branch> brancheslist = [];
        if (jsonData['listResult'] != null && jsonData['listResult'] is List) {
          for (var item in jsonData['listResult']) {
            brancheslist.add(Model_branch.fromJson(item));
            print('id: ${item['id']}, branchName: ${item['branchName']}');
          }
        } else {
          print('Error: listResult is null or not a List');
        }

        setState(() {
          model_branches = brancheslist;
          isLoading = false; // Stop loading
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        setState(() {
          model_branches = [];
          isLoading = false; // Stop loading
        });
      }
    } catch (error) {
      print('Error fetching data from API: $error');
      setState(() {
        model_branches = [];
        isLoading = false; // Stop loading
      });
    }
  }

  void showCustomToastMessageLong(
      String message,
      BuildContext context,
      int backgroundColorType,
      int length,
      ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textWidth = screenWidth / 1.5; // Adjust multiplier as needed

    final double toastWidth = textWidth + 32.0; // Adjust padding as needed
    final double toastOffset = (screenWidth - toastWidth) / 2;

    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        bottom: 16.0,
        left: toastOffset,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: toastWidth,
            decoration: BoxDecoration(
              border: Border.all(
                color: backgroundColorType == 0 ? Colors.green : Colors.red,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Center(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    Future.delayed(Duration(seconds: length)).then((value) {
      overlayEntry.remove();
    });
  }

  bool validateEmailFormat(String email) {
    const pattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    final regex = RegExp(pattern);

    if (email.isEmpty) {
      return false;
    }

    // Check if the email address ends with a dot in the domain part
    if (email.endsWith('.')) {
      return false;
    }

    return regex.hasMatch(email);
  }

  Future<bool> onBackPressed(BuildContext context) {
    // Navigate back when the back button is pressed
    Navigator.pop(context);
    // Return false to indicate that we handled the back button press
    return Future.value(false);
  }

  Future<void> openMap(Model_branch branchnames) async {

    // Replace with your logic to open the map, for example:
    final url = 'https://www.google.com/maps/search/?api=1&query=${branchnames.latitude},${branchnames.longitude}';
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }
  }

}
