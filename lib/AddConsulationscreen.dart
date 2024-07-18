import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:hairfixingzone/AgentDashBoard.dart';
import 'package:hairfixingzone/AgentHome.dart';
import 'package:hairfixingzone/services/notifi_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Common/common_styles.dart';
import 'Common/custom_button.dart';
import 'Common/custome_form_field.dart';
import 'CommonUtils.dart';
import 'package:intl/intl.dart';

import 'HomeScreen.dart';
import 'api_config.dart';

class AddConsulationscreen extends StatefulWidget {
  final int agentId;
  const AddConsulationscreen({super.key, required this.agentId});

  @override
  AddConsulationscreen_screenState createState() =>
      AddConsulationscreen_screenState();
}

class AddConsulationscreen_screenState extends State<AddConsulationscreen> {
  List<dynamic> dropdownItems = [];
  List<dynamic> BranchesdropdownItems = [];
  List<dynamic> cityDropdownItems = [];
  String? selectedName;
  late int selectedValue;
  FocusNode remarksFocus = FocusNode();
  String? branchName;
  int? branchValue;
  int selectedTypeCdId = -1;
  int branchselectedTypeCdId = -1;
  String formattedDate = '';
  String? cityName;
  int? cityValue;
  int citySelectedTypeCdId = -1;
  bool isCitySelected = false;
  bool isCityValidate = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  bool _fullNameError = false;
  String? _fullNameErrorMsg;
  bool _dobError = false;
  String? _dobErrorMsg;
  bool _emailError = false;
  String? _emailErrorMsg;

  bool _remarksError = false;
  String? _remarksErrorMsg;

  bool _mobileNumberError = false;
  String? _mobileNumberErrorMsg;
  final bool _altNumberError = false;
  String? _altNumberErrorMsg;
  bool isremarksValidate = false;
  bool isFullNameValidate = false;
  bool isDobValidate = false;
  bool isGenderValidate = false;
  bool isBranchValidate = false;
  bool isMobileNumberValidate = false;
  bool isAltMobileNumberValidate = false;
  bool isEmailValidate = false;
  bool isRemarksValidate = false;
  bool isGenderSelected = false;
  bool isBranchSelected = false;

  int? Id;
  String? phonenumber;
  String? username;
  String? email;
  String? contactNumber;
  String? gender;
  String? dob;
  String? formattedDateapi;
  int? roleId;
  String? password;
  String? fullname;
  late String visiteddate;
  //DateTime _selectedDate = DateTime.now();
  DateTime? selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  late String slot_time;
  String? visitingDateTime;
  DateTime? VisitslotDateTime;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    CommonUtils.checkInternetConnectivity().then((isConnected) async {
      if (isConnected) {
        print('The Internet Is Connected');

        setState(() async {
          _dateController.text =
              DateFormat('dd-MM-yyyy').format(DateTime.now());
          visiteddate = DateFormat('yyyy-MM-dd').format(DateTime.now());
          fetchRadioButtonOptions();
          getCities(widget.agentId);
          // _getBranchData(widget.agentId, 0);
        });

        // fetchMyAppointments(userId);
      } else {
        CommonUtils.showCustomToastMessageLong(
            'Please Check Your Internet Connection', context, 1, 4);
        print('The Internet Is not  Connected');
      }
    });
  }

  Future<void> fetchRadioButtonOptions() async {
    final url = Uri.parse(baseUrl + getgender);
    print('url==>946: $url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        final data = json.decode(response.body);
        setState(() {
          dropdownItems = data['listResult'];
        });
        // if (responseData != null && responseData['listResult'] is List<dynamic>) {
        //   List<dynamic> optionsData = responseData['listResult'];
        //   setState(() {
        //     dropdownItems = optionsData['listResult'];
        //     //  options = optionsData.map((data) => RadioButtonOption.fromJson(data)).toList();
        //   });
        // } else {
        //   throw Exception('Invalid response format');
        // }
      } else {
        throw Exception('Failed to fetch radio button options');
      }
    } catch (e) {
      throw Exception('Error Radio: $e');
    }
  }

  Future<void> _getBranchData(int userId, int cityid) async {
    // setState(() {
    //   _isLoading = true; // Set isLoading to true before making the API call
    // });

    String apiUrl = '$baseUrl$GetBranchByUserId$userId/$cityid';
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
          BranchesdropdownItems = data['listResult'];
        });

        return; // Exit the function after successful response
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AgentHome(userId: widget.agentId)),
          );
          return false;
        },
        child: Scaffold(
            backgroundColor: CommonStyles.whiteColor,
            body: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          CustomeFormField(
                            //MARK: Full Name
                            label: 'Full Name',
                            validator: validatefullname,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(
                                  r'[a-zA-Z\s]')), // Including '\s' for space
                            ],
                            controller: fullNameController,
                            maxLength: 50,
                            keyboardType: TextInputType.name,

                            errorText:
                                _fullNameError ? _fullNameErrorMsg : null,
                            onChanged: (value) {
                              //MARK: Space restrict
                              setState(() {
                                if (value.startsWith(' ')) {
                                  fullNameController.value = TextEditingValue(
                                    text: value.trimLeft(),
                                    selection: TextSelection.collapsed(
                                        offset: value.trimLeft().length),
                                  );
                                }
                                _fullNameError = false;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          // CustomeFormField(
                          //   label: 'Date of Birth',
                          //   validator: validatedob,
                          //   controller: DateofBirth,
                          //   focusNode: DateofBirthdFocus,
                          //   onTap: () => _selectDate(context),
                          // ),

                          // const SizedBox(
                          //   height: 10,
                          // ),
                          const Row(
                            children: [
                              Text(
                                'Gender ',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 0, top: 0.0, right: 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isGenderSelected
                                      ? const Color.fromARGB(255, 175, 15, 4)
                                      : CommonUtils.primaryTextColor,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton<int>(
                                      value: selectedTypeCdId,
                                      iconSize: 30,
                                      icon: null,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedTypeCdId = value!;
                                          if (selectedTypeCdId != -1) {
                                            selectedValue =
                                                dropdownItems[selectedTypeCdId]
                                                    ['typeCdId'];
                                            selectedName =
                                                dropdownItems[selectedTypeCdId]
                                                    ['desc'];

                                            print(
                                                "selectedValue:$selectedValue");
                                            print("selectedName:$selectedName");
                                          } else {
                                            print("==========");
                                            print(selectedValue);
                                            print(selectedName);
                                          }
                                          // isDropdownValid = selectedTypeCdId != -1;
                                          isGenderSelected = false;
                                        });
                                      },
                                      items: [
                                        const DropdownMenuItem<int>(
                                          value: -1,
                                          child: Text(
                                            'Select Gender',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
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
                          //MARK: Gender condition
                          if (isGenderSelected)
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: Text(
                                    'Please Select Gender',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 175, 15, 4),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(
                            height: 10,
                          ),

                          CustomeFormField(
                            //MARK: Mobile Number
                            label: 'Mobile Number',
                            validator: validateMobilenum,
                            controller: mobileNumberController,
                            maxLength: 10,

                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            keyboardType: TextInputType.phone,
                            errorText: _mobileNumberError
                                ? _mobileNumberErrorMsg
                                : null,
                            onChanged: (value) {
                              setState(() {
                                if (value.length == 1 &&
                                    ['0', '1', '2', '3', '4'].contains(value)) {
                                  mobileNumberController.clear();
                                }
                                if (value.startsWith(' ')) {
                                  mobileNumberController.value =
                                      TextEditingValue(
                                    text: value.trimLeft(),
                                    selection: TextSelection.collapsed(
                                        offset: value.trimLeft().length),
                                  );
                                }
                                _mobileNumberError = false;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          const Row(
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              // Text(
                              //   ' *',
                              //   style: TextStyle(color: Colors.red),
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
                            controller: emailController,
                            maxLength: 60,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            keyboardType: TextInputType.emailAddress,
                            onTap: () {},
                            decoration: InputDecoration(
                              errorText: _emailError ? _emailErrorMsg : null,
                              contentPadding: const EdgeInsets.only(
                                  top: 15, bottom: 10, left: 15, right: 15),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFF0f75bc),
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: CommonUtils.primaryTextColor,
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              hintText: 'Enter Email',
                              counterText: "",
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                            ),
                            //  validator: validateEmail,
                            onChanged: (value) {
                              setState(() {
                                _emailError = false;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            children: [
                              Text(
                                'City ',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 0, top: 5.0, right: 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isCitySelected
                                      ? const Color.fromARGB(255, 175, 15, 4)
                                      : CommonUtils.primaryTextColor,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton<int>(
                                    value: citySelectedTypeCdId,
                                    iconSize: 30,
                                    icon: null,
                                    style: const TextStyle(color: Colors.black),
                                    onChanged: (value) async {
                                      setState(() {
                                        citySelectedTypeCdId = value!;
                                        branchselectedTypeCdId =
                                            -1; // Reset selected branch
                                        branchValue = null;
                                        branchName = null;
                                        BranchesdropdownItems =
                                            []; // Clear branches list
                                      });

                                      if (citySelectedTypeCdId != -1) {
                                        cityValue = cityDropdownItems[
                                            citySelectedTypeCdId]['typecdid'];
                                        cityName = cityDropdownItems[
                                            citySelectedTypeCdId]['desc'];
                                        print("==========$cityValue$cityName");

                                        await _getBranchData(
                                            widget.agentId, cityValue!);
                                        // The BranchesdropdownItems is updated within _getBranchData
                                      } else {
                                        print("==========");
                                        print(cityValue);
                                        print(cityName);
                                      }
                                      setState(() {
                                        isCitySelected = false;
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
                                      ),
                                      ...cityDropdownItems
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isCitySelected)
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: Text(
                                    'Please Select City',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 175, 15, 4),
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(height: 10),

                          const Row(
                            children: [
                              Text(
                                'Branch ',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              if (citySelectedTypeCdId == -1) {
                                setState(() {
                                  isCitySelected = true;
                                });
                              }
                            },
                            child: AbsorbPointer(
                              absorbing: citySelectedTypeCdId == -1,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, top: 5.0, right: 0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isBranchSelected
                                          ? const Color.fromARGB(
                                              255, 175, 15, 4)
                                          : CommonUtils.primaryTextColor,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton<int>(
                                        value: branchselectedTypeCdId,
                                        iconSize: 30,
                                        icon: null,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        onChanged: (value) {
                                          setState(() {
                                            branchselectedTypeCdId = value!;
                                            if (branchselectedTypeCdId != -1) {
                                              branchValue =
                                                  BranchesdropdownItems[
                                                          branchselectedTypeCdId]
                                                      ['id'];
                                              branchName = BranchesdropdownItems[
                                                      branchselectedTypeCdId]
                                                  ['name'];

                                              print("branchValue:$branchValue");
                                              print("branchName:$branchName");
                                            } else {
                                              print("==========");
                                              print(branchValue);
                                              print(branchName);
                                            }
                                            isBranchSelected = false;
                                          });
                                        },
                                        items: [
                                          const DropdownMenuItem<int>(
                                            value: -1,
                                            child: Text(
                                              'Select Branch',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          ...BranchesdropdownItems.asMap()
                                              .entries
                                              .map((entry) {
                                            final index = entry.key;
                                            final item = entry.value;
                                            return DropdownMenuItem<int>(
                                              value: index,
                                              child: Text(item['name']),
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isBranchSelected)
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: Text(
                                    'Please Select Branch',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 175, 15, 4),
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            children: [
                              Text(
                                'Visiting Date ',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
                            controller: _dateController,
                            keyboardType: TextInputType.visiblePassword,
                            onTap: () {
                              _openDatePicker();
                            },
                            // focusNode: DateofBirthdFocus,
                            readOnly: true,
                            validator: (value) {
                              if (value!.isEmpty || value.isEmpty) {
                                return 'Choose Date ';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  top: 15, bottom: 10, left: 15, right: 15),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFF662e91),
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: CommonUtils.primaryTextColor,
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              hintText: 'Date',
                              counterText: "",
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                              suffixIcon: const Icon(
                                Icons.calendar_today,
                                color: Color(0xFF662e91),
                              ),
                            ),
                            //          validator: validateDate,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            children: [
                              Text(
                                'Visiting Time ',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
                            controller: _timeController,
                            keyboardType: TextInputType.visiblePassword,
                            onTap: () {
                              _openTimePicker();
                            },
                            readOnly: true,
                            validator: (value) {
                              if (value!.isEmpty || value.isEmpty) {
                                return 'Choose Time ';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  top: 15, bottom: 10, left: 15, right: 15),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFF662e91),
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: CommonUtils.primaryTextColor,
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              hintText: 'Time',
                              counterText: "",
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                              suffixIcon: const Icon(
                                Icons.access_time,
                                color: Color(0xFF662e91),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            children: [
                              Text(
                                'Remark ',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              // Text(
                              //   '*',
                              //   style: TextStyle(color: Colors.red),
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
                            controller: remarksController,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            maxLength: 250,
                            maxLines: 6,
                            onTap: () {
                              setState(() {
                                remarksFocus.addListener(() {
                                  if (remarksFocus.hasFocus) {
                                    Future.delayed(
                                        const Duration(milliseconds: 300), () {
                                      // Scrollable.ensureVisible(
                                      //   EmailFocus.context!,
                                      //   duration: const Duration(
                                      //       milliseconds: 300),
                                      //   curve: Curves.easeInOut,
                                      // );
                                    });
                                  }
                                });
                              });
                            },
                            decoration: InputDecoration(
                              errorText:
                                  _remarksError ? _remarksErrorMsg : null,
                              contentPadding: const EdgeInsets.only(
                                  top: 15, bottom: 10, left: 15, right: 15),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFF0f75bc),
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: CommonUtils.primaryTextColor,
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              hintText: 'Enter Remark ',
                              counterText: "",
                              // counterText: "",
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                            ),
                            //  validator: validateremarks,
                            onChanged: (value) {
                              setState(() {
                                if (value.startsWith(' ')) {
                                  remarksController.value = TextEditingValue(
                                    text: value.trimLeft(),
                                    selection: TextSelection.collapsed(
                                        offset: value.trimLeft().length),
                                  );
                                }
                                if (value.length > 250) {
                                  // Trim the text if it exceeds 256 characters
                                  remarksController.value = TextEditingValue(
                                    text: value.substring(0, 250),
                                    selection: const TextSelection.collapsed(
                                        offset: 250),
                                  );
                                }
                                _remarksError = false;
                              }); // Update the UI when text changes
                            },
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  buttonText: 'Add Consultation',
                                  color: CommonUtils.primaryTextColor,
                                  onPressed: validating,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ))),
            )));
  }

  Future<void> validating() async {
    validateGender(selectedName);
    validateCity(cityName);
    validatebranch(branchName);

    if (_formKey.currentState!.validate()) {
      _printVisitingDateTime();
      print(isFullNameValidate);
      print(isGenderValidate);
      print(isMobileNumberValidate);
      //  print(isEmailValidate);
      print(isBranchValidate);
      //  print(isRemarksValidate);

      if (isFullNameValidate &&
          isGenderValidate &&
          isMobileNumberValidate &&
          isBranchValidate) {
        updateUser();
      }
    }
  }

//MARK: Validations

  String? validatefullname(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _fullNameError = true;
        _fullNameErrorMsg = 'Please Enter Full Name';
      });
      isFullNameValidate = false;
      return null;
    }
    if (value.length < 2) {
      setState(() {
        _fullNameError = true;
        _fullNameErrorMsg = 'Full Name should contains minimum 2 Characters';
      });
      isFullNameValidate = false;
      return null;
    }

    if (!RegExp(r'[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Full Name Should Only Contain Alphabetic Characters';
    }
    if (!RegExp(r'[a-zA-Z\s]+$').hasMatch(value)) {
      setState(() {
        _fullNameError = true;
        _fullNameErrorMsg = 'Full Name Should Only Contain Alphabets';
      });
      isFullNameValidate = false;
      return null;
    }
    isFullNameValidate = true;
    return null;
  }

  String? validateremarks(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _remarksError = true;
        _remarksErrorMsg = 'Please Enter Remark';
      });
      isRemarksValidate = false;
      return null;
    }
    if (value.length < 3) {
      setState(() {
        _remarksError = true;
        _remarksErrorMsg = 'Please Enter Remarks';
      });
      isRemarksValidate = false;
      return null;
    }
    isRemarksValidate = true;
    return null;
  }

  String? validateDOB(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _dobError = true;
        _dobErrorMsg = 'Please Select Date of Birth';
      });
      isDobValidate = false;
      return null;
    }
    isDobValidate = true;
    return null;
  }

  void validateGender(String? value) {
    if (value == null || value.isEmpty) {
      isGenderSelected = true;
      isGenderValidate = false;
    } else {
      isGenderSelected = false;
      isGenderValidate = true;
    }
    //   setState(() {});
  }

  void validateCity(String? value) {
    if (value == null || value.isEmpty) {
      isCitySelected = true;
      isCityValidate = false;
    } else {
      isCitySelected = false;
      isCityValidate = true;
    }
  }

  void validatebranch(String? value) {
    if (value == null || value.isEmpty) {
      isBranchSelected = true;
      isBranchValidate = false;
    } else {
      isBranchSelected = false;
      isBranchValidate = true;
    }
    //  setState(() {});
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _emailError = true;
        _emailErrorMsg = 'Please Enter Email';
      });
      isEmailValidate = false;
      return null;
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      setState(() {
        _emailError = true;
        _emailErrorMsg = 'Please Enter A Valid Email';
      });
      isEmailValidate = false;
      return null;
    }
    isEmailValidate = true;
    return null;
  }

  String? validateMobilenum(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _mobileNumberError = true;
        _mobileNumberErrorMsg = 'Please Enter Mobile Number';
      });
      isMobileNumberValidate = false;
      return null;
    }
    if (value.startsWith(RegExp('[1-4]'))) {
      setState(() {
        _mobileNumberError = true;
        _mobileNumberErrorMsg = 'Mobile Number Should Not Start with 1-4';
      });
      isMobileNumberValidate = false;
      return null;
    }
    if (value.contains(RegExp(r'[a-zA-Z]'))) {
      setState(() {
        _mobileNumberError = true;
        _mobileNumberErrorMsg = 'Mobile Number should contain only digits';
      });
      isMobileNumberValidate = false;
      return null;
    }
    if (value.length != 10) {
      setState(() {
        _mobileNumberError = true;
        _mobileNumberErrorMsg = 'Mobile Number Must Have 10 Digits';
      });
      isMobileNumberValidate = false;
      return null;
    }
    isMobileNumberValidate = true;
    return null;
  }

  Future<void> updateUser() async {
    validateGender(selectedName);
    validatebranch(branchName);
    if (_formKey.currentState!.validate()) {
      DateTime now = DateTime.now();
      String mobilenumber = mobileNumberController.text;
      String apiEmail = emailController.text.toString();
      String apiUsrname = fullNameController.text.toString();
      String apiRemarks = remarksController.text.toString();
      ProgressDialog progressDialog = ProgressDialog(context);

      // Show the progress dialog
      progressDialog.show();
      final request = {
        "id": null,
        "name": apiUsrname,
        "genderTypeId": selectedValue,
        "phoneNumber": mobilenumber,
        "email": apiEmail,
        "branchId": branchValue,
        "isActive": true,
        "remarks": apiRemarks,
        "createdByUserId": 8,
        "createdDate": '$now',
        "updatedByUserId": null,
        "updatedDate": null,
        "visitingDate": visitingDateTime
      };
      print('Object: ${json.encode(request)}');
      try {
        // final String ee = baseUrl + addupdateconsulation;
        const String ee =
            'http://182.18.157.215/SaloonApp/API/api/Consultation/AddUpdateConsultation';
        print(ee);
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
          final isSuccess = jsonResponse['isSuccess'];

          if (isSuccess) {
            DateTime testdate = DateTime.now();
            print('Request sent successfully');
            progressDialog.dismiss();
            CommonUtils.showCustomToastMessageLong(
                '$statusMessage', context, 0, 5);
            print(response.body);
            final int notificationId1 = UniqueKey().hashCode;
            // debugPrint('Notification Scheduled for $testdate with ID: $notificationId1');
            debugPrint(
                'Notification Scheduled for $VisitslotDateTime with ID: $notificationId1');
            await NotificationService().scheduleNotification(
              title: 'Reminder Notification',
              //An Consulatation has been booked by Manohar at 17th july 10.30 AM Marathahalli Branch. Please check with him once -- Consultation Reminder Notification
              body:
                  'An Consulatation has been booked by $apiUsrname at $formattedDateapi $slot_time $branchName Branch. Please check with him once ',
              //  body: 'Hey $userFullName, Today Your Appointment is Scheduled for  $_selectedTimeSlot at the ${widget.branchname} Branch, Located at ${widget.branchaddress}.',
              //  scheduledNotificationDateTime: testdate!,
              scheduledNotificationDateTime: VisitslotDateTime!,
              id: notificationId1,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AgentHome(userId: widget.agentId)),
            );
          }
          // Navigator.pop(context);
        } else {
          progressDialog.dismiss();
          CommonUtils.showCustomToastMessageLong(
              '$statusMessage', context, 1, 5);
          print(
              'Failed to send the request. Status code: ${response.statusCode}');
        }
      } catch (e) {
        progressDialog.dismiss();
        print('Error slot: $e');
      }
    }
  }

  Future<void> getCities(int userId) async {
    // String apiUrl = '$baseUrl$GetBranchByUserId$userId';
    String apiUrl = 'http://182.18.157.215/SaloonApp/API/GetCityById/4';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      print('apiUrl: $apiUrl');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          cityDropdownItems = data['listResult'];
        });
        return;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _openDatePicker() async {
    selectedDate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
        visiteddate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  void _openTimePicker() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        slot_time = pickedTime.format(context);
        print('selected Time $slot_time');
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.Hm(); // 24-hour format
    return format.format(dt);
  }

  String getDayOfMonthSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  void _printVisitingDateTime() {
    print('selectedDate $selectedDate');
    print('selected Time $slot_time');
    if (selectedDate != null && _selectedTime != null) {
      //   final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final formattedTime = _formatTimeOfDay(_selectedTime!);
      visitingDateTime = '$visiteddate $formattedTime';
      print('SlotselectedDateTime: $visitingDateTime');
      print('formattedTime: $formattedTime');

      DateTime visitslotDatetime =
          DateFormat('yyyy-MM-dd HH:mm').parse(visitingDateTime!);
      //  DateTime VisitslotDateTime = VisitslotDateTime.subtract(const Duration(hours: 1));

      print('Visiting Date: $visitingDateTime');
      print('Visitslot DateTime:1230 $visitslotDatetime');

      VisitslotDateTime = visitslotDatetime.subtract(const Duration(hours: 2));

      print('Visiting Date:1234 $VisitslotDateTime');

      formattedDateapi =
          '${DateFormat('d').format(selectedDate!)}${getDayOfMonthSuffix(selectedDate!.day)} ${DateFormat('MMMM').format(selectedDate!)}';
      //  String formattedTime_ = DateFormat('h:mm a').format(selectedDate!);

      print('Date: $formattedDateapi');
      //    print('Time: $formattedTime_');
    } else {
      print('Please select both date and time.');
    }
  }
}
