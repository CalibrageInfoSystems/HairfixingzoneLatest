import 'dart:convert';
import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hairfixingzone/CommonUtils.dart';
import 'package:hairfixingzone/api_config.dart';
import 'package:hairfixingzone/slotbookingscreen.dart';

import 'Common/custom_button.dart';
import 'Common/custome_form_field.dart';
import 'ForgotPasswordscreen.dart';
import 'HomeScreen.dart';
import 'package:http/http.dart' as http;

class CustomerRegisterScreen extends StatefulWidget {
  const CustomerRegisterScreen({super.key});

  @override
  State<CustomerRegisterScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<CustomerRegisterScreen> {
  bool isTextFieldFocused = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController Fullname = new TextEditingController();
  TextEditingController DateofBirth = new TextEditingController();
  TextEditingController Gender = new TextEditingController();
  TextEditingController Mobilenumber = new TextEditingController();
  TextEditingController AlernateMobilenum = new TextEditingController();
  TextEditingController Email = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController Password = new TextEditingController();
  TextEditingController ConfrimPassword = new TextEditingController();
  List<RadioButtonOption> options = [];
  ScrollController _scrollController = ScrollController();
  FocusNode FullnameFocus = FocusNode();
  FocusNode DateofBirthdFocus = FocusNode();
  FocusNode GenderFocus = FocusNode();
  FocusNode MobilenumberFocus = FocusNode();
  FocusNode AlernateMobilenumFocus = FocusNode();
  FocusNode EmailFocus = FocusNode();
  FocusNode usernameFocus = FocusNode();
  FocusNode PasswordFocus = FocusNode();
  FocusNode ConfrimPasswordFocus = FocusNode();
  DateTime selectedDate = DateTime.now();
  List<dynamic> dropdownItems = [];
  late String selectedName;
  late int selectedValue;
  int selectedTypeCdId = -1;
  double keyboardHeight = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    fetchRadioButtonOptions();
    // DateofBirth.text = _formatDate(selectedDate);
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
      await _selectMonth(context);
    }
  }

  String _formatDate(DateTime date) {
    // Format the date in "dd MMM yyyy" format
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? pickedMonth = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(selectedDate.year),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      lastDate: DateTime(selectedDate.year + 1),
      initialDatePickerMode: DatePickerMode.day, // Start with day mode to enable month view
    );
    if (pickedMonth != null && pickedMonth != selectedDate) {
      setState(() {
        selectedDate = pickedMonth;
        DateofBirth.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
      // After month selection, open day selection dialog
      await _selectDay(context);
    }
  }

  Future<void> _selectDay(BuildContext context) async {
    final DateTime? pickedDay = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(selectedDate.year, selectedDate.month),
      lastDate: DateTime(selectedDate.year, selectedDate.month + 1, 0),
      initialDatePickerMode: DatePickerMode.day,
    );
    if (pickedDay != null && pickedDay != selectedDate) {
      setState(() {
        selectedDate = pickedDay;
        DateofBirth.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonUtils.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: CommonUtils.primaryTextColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // No shadow
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3.7,
              decoration: const BoxDecoration(),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.height / 3.5,
                      child: Image.asset('assets/hfz_logo.png'),
                    ),
                    Text(
                      'Customer Registration',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: "Calibri",
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Color(0xFF662d91),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 2.5, // Adjust the height here
            //   child: SingleChildScrollView(
            //     physics: AlwaysScrollableScrollPhysics(),
            //     child:
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 1.9,
                        child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
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
                                TextFormField(
                                  controller: DateofBirth, // Assigning the controller
                                  keyboardType: TextInputType.visiblePassword,
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  focusNode: DateofBirthdFocus,
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
                                Padding(
                                  padding: EdgeInsets.only(left: 0, top: 5.0, right: 0),
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
                                    SizedBox(height: 5.0,),
                                    TextFormField(
                                      controller: AlernateMobilenum, // Assigning the controller
                                      keyboardType: TextInputType.emailAddress,
                                      onTap: () {
                                        setState(() {
                                          AlernateMobilenumFocus.addListener(() {
                                            if (AlernateMobilenumFocus.hasFocus) {
                                              Future.delayed(Duration(milliseconds: 300), () {
                                                Scrollable.ensureVisible(
                                                  AlernateMobilenumFocus.context!,
                                                  duration: Duration(milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                );
                                              });
                                            }
                                          });
                                        });
                                      },
                                      focusNode: AlernateMobilenumFocus,
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
                                  height: 10,
                                ),
                                // CustomeFormField(
                                //   label: 'Email',
                                //   validator: validateEmail,
                                //   controller: Email,
                                //   focusNode: EmailFocus,
                                //   keyboardType: TextInputType.emailAddress,
                                // ),
                                ListView(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(height: 5),
                                    Row(
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
                                    SizedBox(height: 5.0,),
                                    TextFormField(
                                      controller: Email, // Assigning the controller
                                      keyboardType: TextInputType.emailAddress,
                                      onTap: () {
                                        setState(() {
                                          EmailFocus.addListener(() {
                                            if (EmailFocus.hasFocus) {
                                              Future.delayed(Duration(milliseconds: 300), () {
                                                Scrollable.ensureVisible(
                                                  EmailFocus.context!,
                                                  duration: Duration(milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                );
                                              });
                                            }
                                          });
                                        });
                                      },
                                      focusNode: EmailFocus,
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
                                        hintText: 'Email',
                                        counterText: "",
                                        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                      ),
                                      validator: validateEmail,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // CustomeFormField(
                                //   label: 'User Name',
                                //   validator: validateusername,
                                //   controller: username,
                                //   focusNode: usernameFocus,
                                //   keyboardType: TextInputType.name,
                                // ),
                                ListView(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          'User Name',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.0,),
                                    TextFormField(
                                      controller: username, // Assigning the controller
                                      keyboardType: TextInputType.visiblePassword,
                                      onTap: () {
                                        setState(() {
                                          usernameFocus.addListener(() {
                                            if (usernameFocus.hasFocus) {
                                              Future.delayed(Duration(milliseconds: 300), () {
                                                Scrollable.ensureVisible(
                                                  usernameFocus.context!,
                                                  duration: Duration(milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                );
                                              });
                                            }
                                          });
                                        });
                                      },
                                      focusNode: usernameFocus,
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
                                        hintText: 'User Name',
                                        counterText: "",
                                        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                      ),
                                      validator: validateusername,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // CustomeFormField(
                                //   label: 'Password',
                                //   controller: Password,
                                //   focusNode: PasswordFocus,
                                //   validator: validatePassword,
                                //   keyboardType: TextInputType.visiblePassword,
                                // ),
                                ListView(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          'Password',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.0,),
                                    TextFormField(
                                      controller: Password, // Assigning the controller
                                      keyboardType: TextInputType.visiblePassword,
                                      onTap: () {
                                        setState(() {
                                          PasswordFocus.addListener(() {
                                            if (PasswordFocus.hasFocus) {
                                              Future.delayed(Duration(milliseconds: 300), () {
                                                Scrollable.ensureVisible(
                                                  PasswordFocus.context!,
                                                  duration: Duration(milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                );
                                              });
                                            }
                                          });
                                        });
                                      },
                                      focusNode: PasswordFocus,
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
                                        hintText: 'Password',
                                        counterText: "",
                                        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                      ),
                                      validator: validatePassword,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListView(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          'Confirm Password ',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.0,),
                                    TextFormField(
                                      controller: ConfrimPassword, // Assigning the controller
                                      keyboardType: TextInputType.visiblePassword,
                                      onTap: () {
                                        setState(() {
                                          ConfrimPasswordFocus.addListener(() {
                                            if (ConfrimPasswordFocus.hasFocus) {
                                              Future.delayed(Duration(milliseconds: 300), () {
                                                Scrollable.ensureVisible(
                                                  ConfrimPasswordFocus.context!,
                                                  duration: Duration(milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                );
                                              });
                                            }
                                          });
                                        });
                                      },
                                      focusNode: ConfrimPasswordFocus,
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
                                        hintText: 'Confirm Password',
                                        counterText: "",
                                        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                      ),
                                      validator: validateconfirmpassword,
                                    ),
                                  ],
                                ),
                              ],
                            ))),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: GestureDetector(
                        // onTap: () {
                        //   validating();
                        // },
                        child: CustomButton(
                          buttonText: 'Register',
                          color: CommonUtils.primaryTextColor,
                          onPressed: validating,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an Account?',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          ' Click Here',
                          style: TextStyle(
                            fontSize: 15,
                            color: CommonUtils.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //   ),
            // ),
          ],
        ),
      ),
    );
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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Password';
    }
    if (value.length < 4) {
      return 'Password must be 4 characters or more';
    }
    if (value.length > 8) {
      return 'Password must be 8 characters or less';
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

  String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Gender';
    }

    return null;
  }

  String? validatedob(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Date of Birth';
    }

    return null;
  }

  String? validatefullname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Full Name';
    }

    return null;
  }

  String? validateMobilenum(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Mobile Number';
    }

    return null;
  }

  String? validateAlterMobilenum(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Alternate Mobile Number';
    }

    return null;
  }

  String? validateusername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter User Name';
    }

    return null;
  }

  String? validateconfirmpassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Confirm Password';
    }
    if (value.length < 4) {
      return 'Password must be 4 characters or more';
    }
    if (value.length > 8) {
      return 'Password must be 8 characters or less';
    }
    return null;
  }

  void loginUser() {
    if (_formKey.currentState!.validate()) {
      print('login: Login success!');
    }
  }

  Future<void> validating() async {
    if (_formKey.currentState!.validate()) {
      String? fullName = Fullname.text;
      String dob = DateofBirth.text;
      //  String? gender = Gender.text;
      String? mobileNum = Mobilenumber.text;
      String? alternateMobileNum = AlernateMobilenum.text;
      String? email = Email.text;
      String? userName = username.text;
      String? password = Password.text;
      String? confirmPassword = ConfrimPassword.text;

      String formattedDOB = ''; // Format the DateTime
      print('Formatted Date of Birth: $formattedDOB');
      if (formattedDOB != null) {
        formattedDOB = DateFormat('yyyy-MM-dd').format(selectedDate); //
      } else {
        print('formattted date is null');
      }

      final url = Uri.parse(baseUrl + customeregisration);
      print('url==>890: $url');

      DateTime now = DateTime.now();
      // Using toString() method

      final request = {
        "id": null,
        "firstName": "${fullName.toString()}",
        "middleName": null,
        "lastName": null,
        "contactNumber": "${mobileNum.toString()}",
        "mobileNumber": "${alternateMobileNum.toString()}",
        "userName": "${userName.toString()}",
        "password": "${password.toString()}",
        "confirmPassword": "${confirmPassword.toString()}",
        "email": "${email.toString()}",
        "isActive": true,
        "createdByUserId": null,
        "createdDate": "$now",
        "updatedByUserId": null,
        "updatedDate": "$now",
        "roleId": 2,
        "gender": selectedValue,
        "dateOfBirth": "$formattedDOB",
        "branchIds": "null"
      };

      print('Object: ${json.encode(request)}');
      try {
        // Send the POST request
        final response = await http.post(
          url,
          body: json.encode(request),
          headers: {
            'Content-Type': 'application/json', // Set the content type header
          },
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);

          // Extract the necessary information
          bool isSuccess = data['isSuccess'];
          if (isSuccess == true) {
            print('Request sent successfully');
            CommonUtils.showCustomToastMessageLong('${data['statusMessage']}', context, 1, 2);
            Navigator.pop(context);
          } else {
            CommonUtils.showCustomToastMessageLong('${data['statusMessage']}', context, 0, 2);
          }
        } else {
          print('Failed to send the request. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error slot: $e');
      }
    }
  }

  bool isValidDateFormat(String date) {
    try {
      DateTime.parse(date);
      return true;
    } catch (e) {
      return false;
    }
  }
}
