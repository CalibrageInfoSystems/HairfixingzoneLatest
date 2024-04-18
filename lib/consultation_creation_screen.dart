import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hairfixingzone/CommonUtils.dart';
import 'package:hairfixingzone/CustomRadioButton.dart';
import 'package:hairfixingzone/branches_model.dart';
import 'package:hairfixingzone/slotbookingscreen.dart';
import 'package:http/http.dart' as http;

import 'BranchModel.dart';
import 'api_config.dart';

class ConsulationCreationScreen extends StatefulWidget {
  // const ConsulationCreationScreen({super.key});
  final int userid;
  ConsulationCreationScreen({required this.userid});
  @override
  _ConsulationCreationScreenState createState() => _ConsulationCreationScreenState();
}

class _ConsulationCreationScreenState extends State<ConsulationCreationScreen> {
  List<String> gendersList = [];
  List<RadioButtonOption> options = [];
  final username = TextEditingController();
  final phonenumber = TextEditingController();
  final remarks = TextEditingController();
  final email = TextEditingController();
  String? _selectedState;
  List<String> states = [];
  List<BranchModel> brancheslist = [];
  int? gender;
  late Future<List<Branch>> apiData;
  int selectedTypeCdId = -1;
  late String branchname;
  List<dynamic> dropdownItems = [];
  late int branchvalue;
  bool isGenderSelected = false;
  @override
  void initState() {
    super.initState();
    apiData = fetchBranches();
    _getBranchData(widget.userid);
    fetchRadioButtonOptions();
  }

  Future<void> fetchRadioButtonOptions() async {
    final url = Uri.parse(baseUrl + getgender);
    print('url==>946: $url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        if (responseData != null && responseData['listResult'] is List<dynamic>) {
          final List<dynamic> optionsData = responseData['listResult'];
          setState(() {
            options = optionsData.map((data) => RadioButtonOption.fromJson(data)).toList();
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to fetch radio button options');
      }
    } catch (e) {
      throw Exception('Error Radio: $e');
    }
  }

  Future<List<Branch>> fetchBranches() async {
    String apiUrl = 'http://182.18.157.215/SaloonApp/API/GetBranchByUserId/null';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse['isSuccess'] == true) {
        final branches = mapResponse['listResult'].cast<Map<String, dynamic>>();
        final listOfBranches = await branches.map<Branch>((json) {
          return Branch.fromJson(json);
        }).toList();
        return listOfBranches;
      } else {
        throw Exception('Failed to load branches');
      }
    } else {
      throw Exception('Failed to load branches');
    }
  }

  Future<void> _getBranchData(int userId) async {
    // setState(() {
    //   _isLoading = true; // Set isLoading to true before making the API call
    // });

    String apiUrl = baseUrl + GetBranchByUserId + '$userId';
    // const maxRetries = 1; // Set maximum number of retries
    // int retries = 0;

    //while (retries < maxRetries) {
    try {
      // Make the HTTP GET request with a timeout of 30 seconds
      final response = await http.get(Uri.parse(apiUrl));
      print('apiUrl: $apiUrl');
      if (response.statusCode == 200) {
        // final data = json.decode(response.body);
        final data = json.decode(response.body);
        setState(() {
          dropdownItems = data['listResult'];
        });
        // List<BranchModel> branchList = [];
        // for (var item in data['listResult']) {
        //   branchList.add(BranchModel(
        //     id: item['id'],
        //     name: item['name'],
        //     imageName: item['imageName'],
        //     address: item['address'],
        //     startTime: item['startTime'],
        //     closeTime: item['closeTime'],
        //     room: item['room'],
        //     mobileNumber: item['mobileNumber'],
        //     isActive: item['isActive'],
        //   ));
        // }
        //
        // setState(() {
        //   brancheslist = branchList;
        //
        //   // _isLoading = false;
        // });
        return; // Exit the function after successful response
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    // retries++;
    // await Future.delayed(Duration(seconds: 2 * retries)); // Exponential backoff
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 1.0, right: 0),
                child: GestureDetector(
                  child: Container(
                    width: screenWidth * 0.9,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: const Color(0xFF163CF1),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'assets/User_icon.svg',
                            width: 20.0,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, top: 6.0),
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                controller: username,
                                style: const TextStyle(
                                  fontFamily: 'Calibri',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Customer Name',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Calibri',
                                    fontSize: 14,
                                    color: Color(0xFFFB4110),
                                    fontWeight: FontWeight.w300,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 10.0, right: 0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: screenWidth * 0.9,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: const Color(0xFF163CF1),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'assets/phone_1.svg',
                            width: 20.0,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextFormField(
                                maxLength: 10,
                                keyboardType: TextInputType.number,
                                controller: phonenumber,
                                style: const TextStyle(
                                  fontFamily: 'Calibri',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Phone Number',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Calibri',
                                    fontSize: 14,
                                    color: Color(0xFFFB4110),
                                    fontWeight: FontWeight.w300,
                                  ),
                                  counterText: '',

                                  border: InputBorder.none,
                                  // Remove the underline border
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: screenWidth * 0.9,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: const Color(0xFF163CF1),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'assets/Mail_icon.svg',
                            width: 20.0,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextFormField(
                                controller: email,
                                style: const TextStyle(
                                  fontFamily: 'Calibri',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Calibri',
                                    fontSize: 14,
                                    color: Color(0xFFFB4110),
                                    fontWeight: FontWeight.w300,
                                  ),
                                  border: InputBorder.none,
                                  // Remove the underline border
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, top: 10.0, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: options.map((option) {
                          return Row(
                            children: [
                              CustomRadioButton(
                                selected: gender == option.typeCdId,
                                onTap: () {
                                  setState(() {
                                    gender = option.typeCdId;
                                    print('selectedGenderid:$gender');
                                    isGenderSelected = true;
                                  });
                                  print(option.typeCdId);
                                  print(option.desc);
                                },
                              ),
                              SizedBox(width: 5),
                              Text(
                                option.desc,
                                style: TextStyle(
                                  fontFamily: 'Calibri',
                                  fontSize: 14,
                                  color: Color(0xFFFB4110),
                                ),
                              ),
                              SizedBox(width: 26),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, top: 10.0, right: 5),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Color(0xFF163CF1),
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<int>(
                          value: selectedTypeCdId,
                          iconSize: 30,
                          icon: null,
                          style: TextStyle(
                            color: Color(0xFFFB4110),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedTypeCdId = value!;
                              if (selectedTypeCdId != -1) {
                                branchvalue = dropdownItems[selectedTypeCdId]['id'];
                                branchname = dropdownItems[selectedTypeCdId]['name'];

                                print("branchvalue:$branchvalue");
                                print("branchname:$branchname");
                              } else {
                                print("==========");
                                print(branchvalue);
                                print(branchname);
                              }
                              // isDropdownValid = selectedTypeCdId != -1;
                            });
                          },
                          items: [
                            DropdownMenuItem<int>(
                              value: -1,
                              child: Text('Select Branches'), // Static text
                            ),
                            ...dropdownItems.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return DropdownMenuItem<int>(
                                value: index,
                                child: Text(item['name']),
                              );
                            }).toList(),
                          ]),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, top: 10.0, right: 5),
                child: GestureDetector(
                  onTap: () async {},
                  child: Container(
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF163CF1), width: 1.5),
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        TextFormField(
                          controller: remarks,
                          style: TextStyle(
                            fontFamily: 'Calibri',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Remarks',
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Calibri',
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: SizedBox(
                  child: Center(
                    child: GestureDetector(
                      onTap: () => {validatedata()},
                      child: Container(
                        width: screenWidth * 0.9,
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: const Color(0xFFFB4110),
                          // color: isButtonEnabled
                          //     ? const Color(0xFFFB4110)
                          //     : Colors.grey,
                        ),
                        child: const Center(
                          child: Text(
                            'Add Costumer',
                            style: TextStyle(
                              fontFamily: 'Calibri',
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFf15f22),
      title: const Text(
        'Customer Deatils',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> validatedata() async {
    bool isValid = true;
    bool hasValidationFailed = false;
    if (isValid && username.text.isEmpty) {
      CommonUtils.showCustomToastMessageLong('Please Enter Customer Name', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }
    if (isValid && phonenumber.text.isEmpty) {
      CommonUtils.showCustomToastMessageLong('Please Enter Customer Phone Number', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    } else {
      String value = phonenumber.text;
      int? number = int.tryParse(value);
      if (isValid && number != null && number.toString().length < 10) {
        CommonUtils.showCustomToastMessageLong('Please Enter Customer Valid Mobile Number', context, 1, 2);
        isValid = false;
        hasValidationFailed = true;
      }
    }

    if (isValid && email.text.isEmpty) {
      CommonUtils.showCustomToastMessageLong('Please Enter Customer Email', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }
    if (isValid && !validateEmailFormat(email.text)) {
      CommonUtils.showCustomToastMessageLong('Please Enter Customer Email', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }
    if (isValid && selectedTypeCdId == -1) {
      CommonUtils.showCustomToastMessageLong('Please Select Branch', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }
    if (isValid) {
      DateTime now = DateTime.now();
      String mobilenumber = phonenumber.text;
      String api_email = email.text.toString();
      String api_usrname = username.text.toString();
      String api_remarks = remarks.text.toString();
      final request = {
        "id": null,
        "name": api_usrname,
        "genderTypeId": gender,
        "phoneNumber": mobilenumber,
        "email": api_email,
        "branchId": branchvalue,
        "isActive": true,
        "remarks": api_remarks,
        "createdByUserId": '${widget.userid}',
        "createdDate": '$now',
        "updatedByUserId": null,
        "updatedDate": null
      };
      print('Object: ${json.encode(request)}');
      try {
        final String ee = 'http://182.18.157.215/SaloonApp/API/api/Consultation/AddUpdateConsultation';
        final url1 = Uri.parse(ee);

        // Send the POST request
        final response = await http.post(
          url1,
          body: json.encode(request),
          headers: {
            'Content-Type': 'application/json', // Set the content type header
          },
        );
        final jsonResponse = json.decode(response.body);
        final statusMessage = jsonResponse['statusMessage'];
        // Check the response status code
        if (response.statusCode == 200) {
          print('Request sent successfully');

          CommonUtils.showCustomToastMessageLong('$statusMessage', context, 0, 2);
          print('${response.body}');
          Navigator.pop(context);
        } else {
          CommonUtils.showCustomToastMessageLong('$statusMessage', context, 1, 2);
          print('Failed to send the request. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error slot: $e');
      }
    }
  }

  bool validateEmailFormat(String email) {
    final pattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
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
}
