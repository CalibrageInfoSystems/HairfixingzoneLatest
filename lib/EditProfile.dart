import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Common/custom_button.dart';
import 'Common/custome_form_field.dart';
import 'CommonUtils.dart';
import 'package:intl/intl.dart';

import 'api_config.dart';

class EditProfile extends StatefulWidget {
  @override
  EditProfile_screenState createState() => EditProfile_screenState();
}

class EditProfile_screenState extends State<EditProfile> {
  List<dynamic> dropdownItems = [];
  late String selectedName;
  late int selectedValue;
  int selectedTypeCdId = -1;
  TextEditingController Fullname = new TextEditingController();
  TextEditingController DateofBirth = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController AlernateMobilenum = new TextEditingController();
  TextEditingController Mobilenumber = new TextEditingController();
  TextEditingController Email = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        print('The Internet Is Connected');
        fetchRadioButtonOptions();
        // fetchMyAppointments(userId);
      } else {
        print('The Internet Is not  Connected');
      }
    });
  }

  String? validatefullname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Full Name';
    }

    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedYear = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (pickedYear != null && pickedYear != selectedDate) {
      setState(() {
        selectedDate = pickedYear;
        DateofBirth.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
      // After year selection, open month selection dialog
    }
  }

  String? validateMobilenum(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Mobile Number';
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Email/User Name';
    }
    // else if (!RegExp(
    //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //     .hasMatch(value)) {
    //   return 'Please enter a valid email address';
    // }
    return null;
  }

  // String? validateMobilenum(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please Enter Mobile Number';
  //   }
  //
  //   return null;
  // }
  String? validateAlterMobilenum(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Alternate Mobile Number';
    }

    return null;
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: const Color(0xFFf3e3ff),
                title: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Color(0xFF0f75bc), fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: CommonUtils.primaryTextColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )),
            body: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          CustomeFormField(
                            label: 'Full Name',
                            validator: validatefullname,
                            controller: Fullname,
                            keyboardType: TextInputType.name,

                            ///focusNode: FullnameFocus,
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          // CustomeFormField(
                          //   label: 'Date of Birth',
                          //   validator: validatedob,
                          //   controller: DateofBirth,
                          //   focusNode: DateofBirthdFocus,
                          //   onTap: () => _selectDate(context),
                          // ),
                          Row(
                            children: [
                              Text(
                                'Date of Birth',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: DateofBirth, // Assigning the controller
                            keyboardType: TextInputType.visiblePassword,
                            onTap: () {
                              _selectDate(context);
                            },
                            // focusNode: DateofBirthdFocus,
                            readOnly: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF0f75bc),
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CommonUtils.primaryTextColor,
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              hintText: 'Date of Birth',
                              counterText: "",
                              hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            //  validator: validatePassword,
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Gender ',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 0, top: 0.0, right: 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: CommonUtils.primaryTextColor,
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
                                      style: TextStyle(
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
                                        });
                                      },
                                      items: [
                                        DropdownMenuItem<int>(
                                          value: -1,
                                          child: Text(
                                            'Select Gender',
                                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                                          ), // Static text
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
                          SizedBox(
                            height: 10,
                          ),
                          CustomeFormField(
                            label: 'Mail ID',
                            validator: validateEmail,
                            controller: Email,
                            maxLength: 10,
                            //focusNode: MobilenumberFocus,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomeFormField(
                            label: 'Mobile Number',
                            validator: validateMobilenum,
                            controller: Mobilenumber,
                            maxLength: 10,
                            //focusNode: MobilenumberFocus,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // CustomeFormField(
                          //   label: 'Alternate Mobile Number',
                          //   validator: validateAlterMobilenum,
                          //   controller: AlernateMobilenum,
                          //   maxLength: 10,
                          //   //   focusNode: AlernateMobilenumFocus,
                          //   keyboardType: TextInputType.number,
                          // ),
                          ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              // SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    'Alternate Mobile Number',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  // Text(
                                  //   '',
                                  //   style: TextStyle(color: Colors.red),
                                  // ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              TextFormField(
                                controller: AlernateMobilenum, // Assigning the controller
                                keyboardType: TextInputType.emailAddress,
                                onTap: () {
                                  setState(() {});
                                },

                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF0f75bc),
                                    ),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: CommonUtils.primaryTextColor,
                                    ),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  hintText: 'Alternate Mobile Number',
                                  counterText: "",
                                  hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                ),
                                maxLength: 10,
                                validator: validateAlterMobilenum,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: CustomButton(
                              buttonText: 'Update Details',
                              color: CommonUtils.primaryTextColor,
                              onPressed: validating,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ))),
            )));
  }

  Future<void> validating() async {
    if (_formKey.currentState!.validate()) {}
  }
}
