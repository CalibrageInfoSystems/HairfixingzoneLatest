import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:hairfixingzone/AgentDashBoard.dart';
import 'package:hairfixingzone/AgentHome.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  AddConsulationscreen_screenState createState() => AddConsulationscreen_screenState();
}

class AddConsulationscreen_screenState extends State<AddConsulationscreen> {
  List<dynamic> dropdownItems = [];
  List<dynamic> BranchesdropdownItems = [];
  String? selectedName;
  late int selectedValue;
  FocusNode remarksFocus = FocusNode();
  String? branchName;
  int? branchValue;
  int selectedTypeCdId = -1;
  int branchselectedTypeCdId = -1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
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
  bool _altNumberError = false;
  String? _altNumberErrorMsg;

  bool isFullNameValidate = false;
  bool isDobValidate = false;
  bool isGenderValidate = false;
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
  String? formattedDate;
  int? roleId;
  String? password;
  String? fullname;
  DateTime selectedDate = DateTime.now();
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
          fetchRadioButtonOptions();
          _getBranchData(widget.agentId);
        });

        // fetchMyAppointments(userId);
      } else {
        CommonUtils.showCustomToastMessageLong('Please Check Your Internet Connection', context, 1, 4);
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
          BranchesdropdownItems = data['listResult'];
        });

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
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgentHome(userId: widget.agentId)),
          );
          return false;
        },
        child: Scaffold(
            // appBar: AppBar(
            //     elevation: 0,
            //     backgroundColor: const Color(0xFFf3e3ff),
            //     title: const Text(
            //       'Add Consultation',
            //       style: TextStyle(color: Color(0xFF0f75bc), fontSize: 16.0, fontWeight: FontWeight.w600),
            //     ),
            //     leading: IconButton(
            //       icon: const Icon(
            //         Icons.arrow_back_ios,
            //         color: CommonUtils.primaryTextColor,
            //       ),
            //       onPressed: () {
            //         Navigator.of(context).pop();
            //       },
            //     )),
            body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
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
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                        ],
                        controller: fullNameController,
                        maxLength: 40,
                        keyboardType: TextInputType.name,

                        errorText: _fullNameError ? _fullNameErrorMsg : null,
                        onChanged: (value) {
                          //MARK: Space restrict
                          setState(() {
                            if (value.startsWith(' ')) {
                              fullNameController.value = TextEditingValue(
                                text: value.trimLeft(),
                                selection: TextSelection.collapsed(offset: value.trimLeft().length),
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
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                        padding: const EdgeInsets.only(left: 0, top: 0.0, right: 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isGenderSelected ? const Color.fromARGB(255, 175, 15, 4) : CommonUtils.primaryTextColor,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white,
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
                                        selectedValue = dropdownItems[selectedTypeCdId]['typeCdId'];
                                        selectedName = dropdownItems[selectedTypeCdId]['desc'];

                                        print("selectedValue:$selectedValue");
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
                                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    ...dropdownItems.asMap().entries.map((entry) {
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
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        keyboardType: TextInputType.phone,
                        errorText: _mobileNumberError ? _mobileNumberErrorMsg : null,
                        onChanged: (value) {
                          setState(() {
                            if (value.length == 1 && ['1', '2', '3', '4'].contains(value)) {
                              mobileNumberController.clear();
                            }
                            if (value.startsWith(' ')) {
                              mobileNumberController.value = TextEditingValue(
                                text: value.trimLeft(),
                                selection: TextSelection.collapsed(offset: value.trimLeft().length),
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
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                        controller: emailController,
                        maxLength: 40,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        keyboardType: TextInputType.emailAddress,
                        onTap: () {
                          // setState(() {
                          //   EmailFocus.addListener(() {
                          //     if (EmailFocus.hasFocus) {
                          //       Future.delayed(
                          //           const Duration(
                          //               milliseconds: 300), () {
                          //         // Scrollable.ensureVisible(
                          //         //   EmailFocus.context!,
                          //         //   duration: const Duration(
                          //         //       milliseconds: 300),
                          //         //   curve: Curves.easeInOut,
                          //         // );
                          //       });
                          //     }
                          //   });
                          // });
                        },
                        decoration: InputDecoration(
                          errorText: _emailError ? _emailErrorMsg : null,
                          contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
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
                          hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                        ),
                        validator: validateEmail,
                        onChanged: (value) {
                          setState(() {
                            _emailError = false;
                          });
                        },
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Branch ',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0, top: 5.0, right: 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isBranchSelected ? const Color.fromARGB(255, 175, 15, 4) : CommonUtils.primaryTextColor,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<int>(
                                  value: branchselectedTypeCdId,
                                  iconSize: 30,
                                  icon: null,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      branchselectedTypeCdId = value!;
                                      if (branchselectedTypeCdId != -1) {
                                        branchValue = BranchesdropdownItems[branchselectedTypeCdId]['id'];
                                        branchName = BranchesdropdownItems[branchselectedTypeCdId]['name'];

                                        print("branchValue:$branchValue");
                                        print("branchName:$branchName");
                                      } else {
                                        print("==========");
                                        print(branchValue);
                                        print(branchName);
                                      }
                                      // isDropdownValid = selectedTypeCdId != -1;
                                      isBranchSelected = false;
                                    });
                                  },
                                  items: [
                                    const DropdownMenuItem<int>(
                                      value: -1,
                                      child: Text(
                                        'Select Branch',
                                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    ...BranchesdropdownItems.asMap().entries.map((entry) {
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
                      //MARK: Gender condition
                      if (isBranchSelected)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                              child: Text(
                                'Please Select Branch',
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
                      const Row(
                        children: [
                          Text(
                            'Remarks ',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                        controller: remarksController,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        maxLength: 256,
                        maxLines: 6,
                        onTap: () {
                          setState(() {
                            remarksFocus.addListener(() {
                              if (remarksFocus.hasFocus) {
                                Future.delayed(const Duration(milliseconds: 300), () {
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
                          errorText: _remarksError ? _remarksErrorMsg : null,
                          contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
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
                          // counterText: "",
                          hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                        ),
                        validator: validateremarks,
                        onChanged: (value) {
                          setState(() {
                            if (value.startsWith(' ')) {
                              remarksController.value = TextEditingValue(
                                text: value.trimLeft(),
                                selection: TextSelection.collapsed(offset: value.trimLeft().length),
                              );
                            }
                            if (value.length > 256) {
                              // Trim the text if it exceeds 256 characters
                              remarksController.value = TextEditingValue(
                                text: value.substring(0, 256),
                                selection: TextSelection.collapsed(offset: 256),
                              );
                            }
                            _remarksError = false;
                          }); // Update the UI when text changes
                        },
                      ),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: Positioned(
                      //     bottom: 8.0,
                      //     right: 8.0,
                      //     child: Container(
                      //       padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      //       // decoration: BoxDecoration(
                      //       //   color: Colors.black.withOpacity(0.6),
                      //       //   borderRadius: BorderRadius.circular(4.0),
                      //       // ),
                      //       child: Text(
                      //         '${remarksController.text.length}/${remarksController.text.length > 256 ? 256 : 256}',
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.bold,
                      //           fontFamily: 'Calibri',
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),

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
    validatebranch(branchName);
    if (_formKey.currentState!.validate()) {
      updateUser();
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
        _fullNameErrorMsg = 'Full Name should contains minimum 2 charactes';
      });
      isFullNameValidate = false;
      return null;
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'Full Name should only contain alphabetic characters';
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
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

  String? validateremarks(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _remarksError = true;
        _remarksErrorMsg = 'Please Enter Remark';
      });
      isRemarksValidate = false;
      return null;
    }
  }

  void validatebranch(String? value) {
    if (value == null || value.isEmpty) {
      isBranchSelected = true;
      isGenderValidate = false;
    } else {
      isBranchSelected = false;
      isGenderValidate = true;
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
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      setState(() {
        _emailError = true;
        _emailErrorMsg = 'Please Enter a Valid Email Address';
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
      String api_email = emailController.text.toString();
      String api_usrname = fullNameController.text.toString();
      String api_remarks = remarksController.text.toString();
      final request = {
        "id": null,
        "name": api_usrname,
        "genderTypeId": selectedValue,
        "phoneNumber": mobilenumber,
        "email": api_email,
        "branchId": branchValue,
        "isActive": true,
        "remarks": api_remarks,
        "createdByUserId": 8,
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

          CommonUtils.showCustomToastMessageLong('$statusMessage', context, 0, 5);
          print('${response.body}');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgentHome(userId: widget.agentId)),
          );
          // Navigator.pop(context);
        } else {
          CommonUtils.showCustomToastMessageLong('$statusMessage', context, 1, 5);
          print('Failed to send the request. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error slot: $e');
      }
    }
  }
}
