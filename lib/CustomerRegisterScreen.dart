// import 'dart:convert';
// import 'dart:ffi';
// import 'package:intl/intl.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hairfixingzone/CommonUtils.dart';
// import 'package:hairfixingzone/api_config.dart';
// import 'package:hairfixingzone/slotbookingscreen.dart';
//
// import 'Common/custom_button.dart';
// import 'Common/custome_form_field.dart';
// import 'ForgotPasswordscreen.dart';
// import 'HomeScreen.dart';
// import 'package:http/http.dart' as http;
//
// class CustomerRegisterScreen extends StatefulWidget {
//   const CustomerRegisterScreen({super.key});
//
//   @override
//   State<CustomerRegisterScreen> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<CustomerRegisterScreen> {
//   bool isTextFieldFocused = false;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   TextEditingController Fullname = new TextEditingController();
//   TextEditingController DateofBirth = new TextEditingController();
//   TextEditingController Gender = new TextEditingController();
//   TextEditingController Mobilenumber = new TextEditingController();
//   TextEditingController AlernateMobilenum = new TextEditingController();
//   TextEditingController Email = new TextEditingController();
//   TextEditingController username = new TextEditingController();
//   TextEditingController Password = new TextEditingController();
//   TextEditingController ConfrimPassword = new TextEditingController();
//   List<RadioButtonOption> options = [];
//   ScrollController _scrollController = ScrollController();
//   FocusNode FullnameFocus = FocusNode();
//   FocusNode DateofBirthdFocus = FocusNode();
//   FocusNode GenderFocus = FocusNode();
//   FocusNode MobilenumberFocus = FocusNode();
//   FocusNode AlernateMobilenumFocus = FocusNode();
//   FocusNode EmailFocus = FocusNode();
//   FocusNode usernameFocus = FocusNode();
//   FocusNode PasswordFocus = FocusNode();
//   FocusNode ConfrimPasswordFocus = FocusNode();
//   DateTime selectedDate = DateTime.now();
//   List<dynamic> dropdownItems = [];
//   late String selectedName;
//   late int selectedValue;
//   int selectedTypeCdId = -1;
//   double keyboardHeight = 0.0;
//   @override
//   void initState() {
//     // TODO: implement initState
//     fetchRadioButtonOptions();
//     // DateofBirth.text = _formatDate(selectedDate);
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedYear = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(1900),
//       initialEntryMode: DatePickerEntryMode.calendarOnly,
//       lastDate: DateTime(2101),
//       initialDatePickerMode: DatePickerMode.year,
//     );
//     if (pickedYear != null && pickedYear != selectedDate) {
//       setState(() {
//         selectedDate = pickedYear;
//         DateofBirth.text = DateFormat('dd-MM-yyyy').format(selectedDate);
//       });
//       // After year selection, open month selection dialog
//       await _selectMonth(context);
//     }
//   }
//
//   String _formatDate(DateTime date) {
//     // Format the date in "dd MMM yyyy" format
//     return DateFormat('dd-MM-yyyy').format(date);
//   }
//
//   Future<void> _selectMonth(BuildContext context) async {
//     final DateTime? pickedMonth = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(selectedDate.year),
//       initialEntryMode: DatePickerEntryMode.calendarOnly,
//       lastDate: DateTime(selectedDate.year + 1),
//       initialDatePickerMode: DatePickerMode.day, // Start with day mode to enable month view
//     );
//     if (pickedMonth != null && pickedMonth != selectedDate) {
//       setState(() {
//         selectedDate = pickedMonth;
//         DateofBirth.text = DateFormat('dd-MM-yyyy').format(selectedDate);
//       });
//       // After month selection, open day selection dialog
//       await _selectDay(context);
//     }
//   }
//
//   Future<void> _selectDay(BuildContext context) async {
//     final DateTime? pickedDay = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       initialEntryMode: DatePickerEntryMode.calendarOnly,
//       firstDate: DateTime(selectedDate.year, selectedDate.month),
//       lastDate: DateTime(selectedDate.year, selectedDate.month + 1, 0),
//       initialDatePickerMode: DatePickerMode.day,
//     );
//     if (pickedDay != null && pickedDay != selectedDate) {
//       setState(() {
//         selectedDate = pickedDay;
//         DateofBirth.text = DateFormat('dd-MM-yyyy').format(selectedDate);
//       });
//     }
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CommonUtils.primaryColor,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: CommonUtils.primaryTextColor,
//           ),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         backgroundColor: Colors.transparent, // Transparent app bar
//         elevation: 0, // No shadow
//       ),
//       body: SingleChildScrollView(
//         physics: NeverScrollableScrollPhysics(),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height / 3.7,
//               decoration: const BoxDecoration(),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: MediaQuery.of(context).size.height / 3.5,
//                       child: Image.asset('assets/hfz_logo.png'),
//                     ),
//                     Text(
//                       'Customer Registration',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontFamily: "Calibri",
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 0.8,
//                         color: Color(0xFF662d91),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // SizedBox(
//             //   height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 2.5, // Adjust the height here
//             //   child: SingleChildScrollView(
//             //     physics: AlwaysScrollableScrollPhysics(),
//             //     child:
//             Form(
//               key: _formKey,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30.0),
//                     topRight: Radius.circular(30.0),
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                         height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 1.9,
//                         child: SingleChildScrollView(
//                             controller: _scrollController,
//                             physics: AlwaysScrollableScrollPhysics(),
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 CustomeFormField(
//                                   label: 'Full Name',
//                                   validator: validatefullname,
//                                   controller: Fullname,
//                                   keyboardType: TextInputType.name,
//
//                                   ///focusNode: FullnameFocus,
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//
//                                 // CustomeFormField(
//                                 //   label: 'Date of Birth',
//                                 //   validator: validatedob,
//                                 //   controller: DateofBirth,
//                                 //   focusNode: DateofBirthdFocus,
//                                 //   onTap: () => _selectDate(context),
//                                 // ),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Date of Birth',
//                                       style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                                     ),
//                                     Text(
//                                       '*',
//                                       style: TextStyle(color: Colors.red),
//                                     ),
//                                   ],
//                                 ),
//                                 TextFormField(
//                                   controller: DateofBirth, // Assigning the controller
//                                   keyboardType: TextInputType.visiblePassword,
//                                   onTap: () {
//                                     _selectDate(context);
//                                   },
//                                   focusNode: DateofBirthdFocus,
//                                   readOnly: true,
//                                   decoration: InputDecoration(
//                                     contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: Color(0xFF0f75bc),
//                                       ),
//                                       borderRadius: BorderRadius.circular(6.0),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: CommonUtils.primaryTextColor,
//                                       ),
//                                       borderRadius: BorderRadius.circular(6.0),
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.all(
//                                         Radius.circular(10),
//                                       ),
//                                     ),
//                                     hintText: 'Date of Birth',
//                                     counterText: "",
//                                     hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
//                                     suffixIcon: Icon(Icons.calendar_today),
//                                   ),
//                                   //  validator: validatePassword,
//                                 ),
//
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Gender ',
//                                       style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                                     ),
//                                     const Text(
//                                       '*',
//                                       style: TextStyle(color: Colors.red),
//                                     ),
//                                   ],
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.only(left: 0, top: 5.0, right: 0),
//                                   child: Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: CommonUtils.primaryTextColor,
//                                       ),
//                                       borderRadius: BorderRadius.circular(5.0),
//                                       color: Colors.white,
//                                     ),
//                                     child: DropdownButtonHideUnderline(
//                                       child: ButtonTheme(
//                                         alignedDropdown: true,
//                                         child: DropdownButton<int>(
//                                             value: selectedTypeCdId,
//                                             iconSize: 30,
//                                             icon: null,
//                                             style: TextStyle(
//                                               color: Colors.black,
//                                             ),
//                                             onChanged: (value) {
//                                               setState(() {
//                                                 selectedTypeCdId = value!;
//                                                 if (selectedTypeCdId != -1) {
//                                                   selectedValue = dropdownItems[selectedTypeCdId]['typeCdId'];
//                                                   selectedName = dropdownItems[selectedTypeCdId]['desc'];
//
//                                                   print("selectedValue:$selectedValue");
//                                                   print("selectedName:$selectedName");
//                                                 } else {
//                                                   print("==========");
//                                                   print(selectedValue);
//                                                   print(selectedName);
//                                                 }
//                                                 // isDropdownValid = selectedTypeCdId != -1;
//                                               });
//                                             },
//                                             items: [
//                                               DropdownMenuItem<int>(
//                                                 value: -1,
//                                                 child: Text(
//                                                   'Select Gender',
//                                                   style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
//                                                 ), // Static text
//                                               ),
//                                               ...dropdownItems.asMap().entries.map((entry) {
//                                                 final index = entry.key;
//                                                 final item = entry.value;
//                                                 return DropdownMenuItem<int>(
//                                                   value: index,
//                                                   child: Text(item['desc']),
//                                                 );
//                                               }).toList(),
//                                             ]),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 CustomeFormField(
//                                   label: 'Mobile Number',
//                                   validator: validateMobilenum,
//                                   controller: Mobilenumber,
//                                   maxLength: 10,
//                                   //focusNode: MobilenumberFocus,
//                                   keyboardType: TextInputType.number,
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 // CustomeFormField(
//                                 //   label: 'Alternate Mobile Number',
//                                 //   validator: validateAlterMobilenum,
//                                 //   controller: AlernateMobilenum,
//                                 //   maxLength: 10,
//                                 //   //   focusNode: AlernateMobilenumFocus,
//                                 //   keyboardType: TextInputType.number,
//                                 // ),
//                                 ListView(
//                                   padding: EdgeInsets.zero,
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   children: [
//                                     // SizedBox(height: 5),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           'Alternate Mobile Number',
//                                           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                                         ),
//                                         // Text(
//                                         //   '',
//                                         //   style: TextStyle(color: Colors.red),
//                                         // ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 5.0,
//                                     ),
//                                     TextFormField(
//                                       controller: AlernateMobilenum, // Assigning the controller
//                                       keyboardType: TextInputType.emailAddress,
//                                       onTap: () {
//                                         setState(() {
//                                           AlernateMobilenumFocus.addListener(() {
//                                             if (AlernateMobilenumFocus.hasFocus) {
//                                               Future.delayed(Duration(milliseconds: 300), () {
//                                                 Scrollable.ensureVisible(
//                                                   AlernateMobilenumFocus.context!,
//                                                   duration: Duration(milliseconds: 300),
//                                                   curve: Curves.easeInOut,
//                                                 );
//                                               });
//                                             }
//                                           });
//                                         });
//                                       },
//                                       focusNode: AlernateMobilenumFocus,
//                                       decoration: InputDecoration(
//                                         contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                             color: Color(0xFF0f75bc),
//                                           ),
//                                           borderRadius: BorderRadius.circular(6.0),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                             color: CommonUtils.primaryTextColor,
//                                           ),
//                                           borderRadius: BorderRadius.circular(6.0),
//                                         ),
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                             Radius.circular(10),
//                                           ),
//                                         ),
//                                         hintText: 'Alternate Mobile Number',
//                                         counterText: "",
//                                         hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
//                                       ),
//                                       maxLength: 10,
//                                       validator: validateAlterMobilenum,
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 // CustomeFormField(
//                                 //   label: 'Email',
//                                 //   validator: validateEmail,
//                                 //   controller: Email,
//                                 //   focusNode: EmailFocus,
//                                 //   keyboardType: TextInputType.emailAddress,
//                                 // ),
//                                 ListView(
//                                   padding: EdgeInsets.zero,
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   children: [
//                                     SizedBox(height: 5),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           'Email',
//                                           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                                         ),
//                                         Text(
//                                           '*',
//                                           style: TextStyle(color: Colors.red),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 5.0,
//                                     ),
//                                     TextFormField(
//                                       controller: Email, // Assigning the controller
//                                       keyboardType: TextInputType.emailAddress,
//                                       onTap: () {
//                                         setState(() {
//                                           EmailFocus.addListener(() {
//                                             if (EmailFocus.hasFocus) {
//                                               Future.delayed(Duration(milliseconds: 300), () {
//                                                 Scrollable.ensureVisible(
//                                                   EmailFocus.context!,
//                                                   duration: Duration(milliseconds: 300),
//                                                   curve: Curves.easeInOut,
//                                                 );
//                                               });
//                                             }
//                                           });
//                                         });
//                                       },
//                                       focusNode: EmailFocus,
//                                       decoration: InputDecoration(
//                                         contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                             color: Color(0xFF0f75bc),
//                                           ),
//                                           borderRadius: BorderRadius.circular(6.0),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                             color: CommonUtils.primaryTextColor,
//                                           ),
//                                           borderRadius: BorderRadius.circular(6.0),
//                                         ),
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                             Radius.circular(10),
//                                           ),
//                                         ),
//                                         hintText: 'Email',
//                                         counterText: "",
//                                         hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
//                                       ),
//                                       validator: validateEmail,
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 // CustomeFormField(
//                                 //   label: 'User Name',
//                                 //   validator: validateusername,
//                                 //   controller: username,
//                                 //   focusNode: usernameFocus,
//                                 //   keyboardType: TextInputType.name,
//                                 // ),
//                                 ListView(
//                                   padding: EdgeInsets.zero,
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   children: [
//                                     SizedBox(height: 5),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           'User Name',
//                                           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                                         ),
//                                         Text(
//                                           '*',
//                                           style: TextStyle(color: Colors.red),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 5.0,
//                                     ),
//                                     TextFormField(
//                                       controller: username, // Assigning the controller
//                                       keyboardType: TextInputType.visiblePassword,
//                                       onTap: () {
//                                         setState(() {
//                                           usernameFocus.addListener(() {
//                                             if (usernameFocus.hasFocus) {
//                                               Future.delayed(Duration(milliseconds: 300), () {
//                                                 Scrollable.ensureVisible(
//                                                   usernameFocus.context!,
//                                                   duration: Duration(milliseconds: 300),
//                                                   curve: Curves.easeInOut,
//                                                 );
//                                               });
//                                             }
//                                           });
//                                         });
//                                       },
//                                       focusNode: usernameFocus,
//                                       decoration: InputDecoration(
//                                         contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                             color: Color(0xFF0f75bc),
//                                           ),
//                                           borderRadius: BorderRadius.circular(6.0),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                             color: CommonUtils.primaryTextColor,
//                                           ),
//                                           borderRadius: BorderRadius.circular(6.0),
//                                         ),
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                             Radius.circular(10),
//                                           ),
//                                         ),
//                                         hintText: 'User Name',
//                                         counterText: "",
//                                         hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
//                                       ),
//                                       validator: validateusername,
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 // CustomeFormField(
//                                 //   label: 'Password',
//                                 //   controller: Password,
//                                 //   focusNode: PasswordFocus,
//                                 //   validator: validatePassword,
//                                 //   keyboardType: TextInputType.visiblePassword,
//                                 // ),
//                                 ListView(
//                                   padding: EdgeInsets.zero,
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   children: [
//                                     SizedBox(height: 5),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           'Password',
//                                           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                                         ),
//                                         Text(
//                                           '*',
//                                           style: TextStyle(color: Colors.red),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 5.0,
//                                     ),
//                                     TextFormField(
//                                       controller: Password, // Assigning the controller
//                                       keyboardType: TextInputType.visiblePassword,
//                                       onTap: () {
//                                         setState(() {
//                                           PasswordFocus.addListener(() {
//                                             if (PasswordFocus.hasFocus) {
//                                               Future.delayed(Duration(milliseconds: 300), () {
//                                                 Scrollable.ensureVisible(
//                                                   PasswordFocus.context!,
//                                                   duration: Duration(milliseconds: 300),
//                                                   curve: Curves.easeInOut,
//                                                 );
//                                               });
//                                             }
//                                           });
//                                         });
//                                       },
//                                       focusNode: PasswordFocus,
//                                       decoration: InputDecoration(
//                                         contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                             color: Color(0xFF0f75bc),
//                                           ),
//                                           borderRadius: BorderRadius.circular(6.0),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                             color: CommonUtils.primaryTextColor,
//                                           ),
//                                           borderRadius: BorderRadius.circular(6.0),
//                                         ),
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                             Radius.circular(10),
//                                           ),
//                                         ),
//                                         hintText: 'Password',
//                                         counterText: "",
//                                         hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
//                                       ),
//                                       validator: validatePassword,
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 ListView(
//                                   padding: EdgeInsets.zero,
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   children: [
//                                     SizedBox(height: 5),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           'Confirm Password ',
//                                           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                                         ),
//                                         Text(
//                                           '*',
//                                           style: TextStyle(color: Colors.red),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 5.0,
//                                     ),
//                                     TextFormField(
//                                       controller: ConfrimPassword, // Assigning the controller
//                                       keyboardType: TextInputType.visiblePassword,
//                                       onTap: () {
//                                         setState(() {
//                                           ConfrimPasswordFocus.addListener(() {
//                                             if (ConfrimPasswordFocus.hasFocus) {
//                                               Future.delayed(Duration(milliseconds: 300), () {
//                                                 Scrollable.ensureVisible(
//                                                   ConfrimPasswordFocus.context!,
//                                                   duration: Duration(milliseconds: 300),
//                                                   curve: Curves.easeInOut,
//                                                 );
//                                               });
//                                             }
//                                           });
//                                         });
//                                       },
//                                       focusNode: ConfrimPasswordFocus,
//                                       decoration: InputDecoration(
//                                         contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                             color: Color(0xFF0f75bc),
//                                           ),
//                                           borderRadius: BorderRadius.circular(6.0),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                             color: CommonUtils.primaryTextColor,
//                                           ),
//                                           borderRadius: BorderRadius.circular(6.0),
//                                         ),
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                             Radius.circular(10),
//                                           ),
//                                         ),
//                                         hintText: 'Confirm Password',
//                                         counterText: "",
//                                         hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
//                                       ),
//                                       validator: validateconfirmpassword,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ))),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                       child: GestureDetector(
//                         // onTap: () {
//                         //   validating();
//                         // },
//                         child: CustomButton(
//                           buttonText: 'Register',
//                           color: CommonUtils.primaryTextColor,
//                           onPressed: validating,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Already have an Account?',
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                         Text(
//                           ' Click Here',
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: CommonUtils.primaryTextColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> fetchRadioButtonOptions() async {
//     final url = Uri.parse(baseUrl + getgender);
//     print('url==>946: $url');
//
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final dynamic responseData = jsonDecode(response.body);
//         final data = json.decode(response.body);
//         setState(() {
//           dropdownItems = data['listResult'];
//         });
//         // if (responseData != null && responseData['listResult'] is List<dynamic>) {
//         //   List<dynamic> optionsData = responseData['listResult'];
//         //   setState(() {
//         //     dropdownItems = optionsData['listResult'];
//         //     //  options = optionsData.map((data) => RadioButtonOption.fromJson(data)).toList();
//         //   });
//         // } else {
//         //   throw Exception('Invalid response format');
//         // }
//       } else {
//         throw Exception('Failed to fetch radio button options');
//       }
//     } catch (e) {
//       throw Exception('Error Radio: $e');
//     }
//   }
//
//   String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please Enter Password';
//     }
//     if (value.length < 4) {
//       return 'Password must be 4 characters or more';
//     }
//     if (value.length > 8) {
//       return 'Password must be 8 characters or less';
//     }
//     return null;
//   }
//
//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please Enter Email/User Name';
//     }
//     // else if (!RegExp(
//     //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//     //     .hasMatch(value)) {
//     //   return 'Please enter a valid email address';
//     // }
//     return null;
//   }
//
//   String? validateGender(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please Enter Gender';
//     }
//
//     return null;
//   }
//
//   String? validatedob(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please Enter Date of Birth';
//     }
//
//     return null;
//   }
//
//   String? validatefullname(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please Enter Full Name';
//     }
//
//     return null;
//   }
//
//   String? validateMobilenum(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please Enter Mobile Number';
//     }
//
//     return null;
//   }
//
//   String? validateAlterMobilenum(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please Enter Alternate Mobile Number';
//     }
//
//     return null;
//   }
//
//   String? validateusername(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please Enter User Name';
//     }
//
//     return null;
//   }
//
//   String? validateconfirmpassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please Enter Confirm Password';
//     }
//     if (value.length < 4) {
//       return 'Password must be 4 characters or more';
//     }
//     if (value.length > 8) {
//       return 'Password must be 8 characters or less';
//     }
//     return null;
//   }
//
//   void loginUser() {
//     if (_formKey.currentState!.validate()) {
//       print('login: Login success!');
//     }
//   }
//
//   Future<void> validating() async {
//     if (_formKey.currentState!.validate()) {
//       String? fullName = Fullname.text;
//       String dob = DateofBirth.text;
//       //  String? gender = Gender.text;
//       String? mobileNum = Mobilenumber.text;
//       String? alternateMobileNum = AlernateMobilenum.text;
//       String? email = Email.text;
//       String? userName = username.text;
//       String? password = Password.text;
//       String? confirmPassword = ConfrimPassword.text;
//
//       String formattedDOB = ''; // Format the DateTime
//       print('Formatted Date of Birth: $formattedDOB');
//       if (formattedDOB != null) {
//         formattedDOB = DateFormat('yyyy-MM-dd').format(selectedDate); //
//       } else {
//         print('formattted date is null');
//       }
//
//       final url = Uri.parse(baseUrl + customeregisration);
//       print('url==>890: $url');
//
//       DateTime now = DateTime.now();
//       // Using toString() method
//
//       final request = {
//         "id": null,
//         "firstName": "${fullName.toString()}",
//         "middleName": null,
//         "lastName": null,
//         "contactNumber": "${mobileNum.toString()}",
//         "mobileNumber": "${alternateMobileNum.toString()}",
//         "userName": "${userName.toString()}",
//         "password": "${password.toString()}",
//         "confirmPassword": "${confirmPassword.toString()}",
//         "email": "${email.toString()}",
//         "isActive": true,
//         "createdByUserId": null,
//         "createdDate": "$now",
//         "updatedByUserId": null,
//         "updatedDate": "$now",
//         "roleId": 2,
//         "gender": selectedValue,
//         "dateOfBirth": "$formattedDOB",
//         "branchIds": "null"
//       };
//
//       print('Object: ${json.encode(request)}');
//       try {
//         // Send the POST request
//         final response = await http.post(
//           url,
//           body: json.encode(request),
//           headers: {
//             'Content-Type': 'application/json', // Set the content type header
//           },
//         );
//
//         if (response.statusCode == 200) {
//           Map<String, dynamic> data = json.decode(response.body);
//
//           // Extract the necessary information
//           bool isSuccess = data['isSuccess'];
//           if (isSuccess == true) {
//             print('Request sent successfully');
//             CommonUtils.showCustomToastMessageLong('${data['statusMessage']}', context, 1, 2);
//             Navigator.pop(context);
//           } else {
//             CommonUtils.showCustomToastMessageLong('${data['statusMessage']}', context, 0, 2);
//           }
//         } else {
//           print('Failed to send the request. Status code: ${response.statusCode}');
//         }
//       } catch (e) {
//         print('Error slot: $e');
//       }
//     }
//   }
//
//   bool isValidDateFormat(String date) {
//     try {
//       DateTime.parse(date);
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }
// }
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hairfixingzone/CommonUtils.dart';
import 'package:hairfixingzone/api_config.dart';
import 'package:hairfixingzone/slotbookingscreen.dart';
import 'package:loading_progress/loading_progress.dart';

import 'Common/common_styles.dart';
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
  // bool isTextFieldFocused = false;
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // TextEditingController fullNameController = TextEditingController();
  // TextEditingController dobController = TextEditingController();
  // TextEditingController genderController = TextEditingController();
  // TextEditingController mobileNumberController = TextEditingController();
  // TextEditingController alernateMobileNumberController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController userNameController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  // TextEditingController confirmPasswordController = TextEditingController();
  // List<RadioButtonOption> options = [];
  // final ScrollController _scrollController = ScrollController();
  // FocusNode FullnameFocus = FocusNode();
  // FocusNode DateofBirthdFocus = FocusNode();
  // FocusNode GenderFocus = FocusNode();
  // FocusNode MobilenumberFocus = FocusNode();
  // FocusNode AlernateMobilenumFocus = FocusNode();
  // FocusNode EmailFocus = FocusNode();
  // FocusNode usernameFocus = FocusNode();
  // FocusNode PasswordFocus = FocusNode();
  // FocusNode ConfrimPasswordFocus = FocusNode();
  // DateTime selectedDate = DateTime.now();
  // List<dynamic> dropdownItems = [];
  // String? selectedName;
  // late int selectedValue;
  // String? _userNameErrorMsg;
  // String? invalidCredentials;
  // bool _userNameError = false;
  // int selectedTypeCdId = -1;
  // double keyboardHeight = 0.0;
  // bool isGenderSelected = false;
  // bool password_obscuretext = true;
  // bool confirmpassword_obscuretext = true;
  //
  // bool isPasswordValidate = false;
  // String _passwordStrengthMessage = '';
  // Color _passwordStrengthColor = Colors.transparent;
  //
  // bool _emailError = false;
  // String? _emailErrorMsg;
  //
  // bool _passwordError = false;
  // String? _passwordErrorMsg;
  // bool _confirmPasswordError = false;
  // String? _confirmPasswordErrorMsg;
  //
  // bool _fullNameError = false;
  // String? _fullNameErrorMsg;
  // bool _dobError = false;
  // String? _dobErrorMsg;
  // bool _mobileNumberError = false;
  // String? _mobileNumberErrorMsg;
  // bool _altNumberError = false;
  // String? _altNumberErrorMsg;
  bool isTextFieldFocused = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController alernateMobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  List<RadioButtonOption> options = [];
  final ScrollController _scrollController = ScrollController();
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
  bool showPassword = true;
  bool showConfirmPassword = true;
  List<dynamic> dropdownItems = [];
  String? selectedName;
  String? _userNameErrorMsg;
  String? invalidCredentials;
  bool _userNameError = false;
  late int selectedValue;
  int selectedTypeCdId = -1;
  double keyboardHeight = 0.0;
  bool isGenderSelected = false;
  bool isPasswordValidate = false;
  String _passwordStrengthMessage = '';
  Color _passwordStrengthColor = Colors.transparent;

  bool _emailError = false;
  String? _emailErrorMsg;

  bool _passwordError = false;
  String? _passwordErrorMsg;
  bool _confirmPasswordError = false;
  String? _confirmPasswordErrorMsg;

  bool _fullNameError = false;
  String? _fullNameErrorMsg;
  bool _dobError = false;
  String? _dobErrorMsg;
  bool _mobileNumberError = false;
  String? _mobileNumberErrorMsg;
  bool _altNumberError = false;
  String? _altNumberErrorMsg;
  @override
  void initState() {
    super.initState();
    fetchRadioButtonOptions();
    // DateofBirth.text = _formatDate(selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedYear = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (pickedYear != null && pickedYear != selectedDate) {
      setState(() {
        selectedDate = pickedYear;
        dobController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
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
        dobController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
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
        dobController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonUtils.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
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
        physics: const NeverScrollableScrollPhysics(),
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
                    const Text(
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
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                // CustomeFormField(
                                //   label: 'Full Name ',
                                //   validator: validatefullname,
                                //   controller: fullNameController,
                                //   keyboardType: TextInputType.name,
                                //
                                //   ///focusNode: FullnameFocus,
                                // ),
                                CustomeFormField(
                                  //MARK: Full Name
                                  label: 'Full Name',
                                  validator: validatefullname,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                                  ],
                                  controller: fullNameController,
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
                                Row(
                                  children: [
                                    Text(
                                      'Date of Birth ',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '*',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                // TextFormField(
                                //   //MARK: DOB
                                //   controller: dobController,
                                //   onTap: () {
                                //     _selectDate(context);
                                //   },
                                //   focusNode: DateofBirthdFocus,
                                //   readOnly: true,
                                //   decoration: InputDecoration(
                                //     contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
                                //     focusedBorder: OutlineInputBorder(
                                //       borderSide: const BorderSide(
                                //         color: CommonUtils.primaryTextColor,
                                //       ),
                                //       borderRadius: BorderRadius.circular(6.0),
                                //     ),
                                //     enabledBorder: OutlineInputBorder(
                                //       borderSide: const BorderSide(
                                //         color: CommonUtils.primaryTextColor,
                                //       ),
                                //       borderRadius: BorderRadius.circular(6.0),
                                //     ),
                                //     border: const OutlineInputBorder(
                                //       borderRadius: BorderRadius.all(
                                //         Radius.circular(10),
                                //       ),
                                //     ),
                                //     hintText: 'Date of Birth',
                                //     counterText: "",
                                //     hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                //     suffixIcon: const Icon(Icons.calendar_today),
                                //   ),
                                //   validator: validateDOB,
                                // ),
                                TextFormField(
                                  //MARK: DOB
                                  controller: dobController,
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  focusNode: DateofBirthdFocus,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    errorText: _dobError ? _dobErrorMsg : null,
                                    contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: CommonUtils.primaryTextColor,
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
                                    hintText: 'Date of Birth',
                                    counterText: "",
                                    hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                    suffixIcon: const Icon(Icons.calendar_today),
                                  ),
                                  validator: validateDOB,
                                  onChanged: (value) {
                                    setState(() {
                                      _dobError = false;
                                    });
                                  },
                                ),

                                const SizedBox(
                                  height: 10,
                                ),
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 0, top: 5.0, right: 0),
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
                                          'Please select gender',
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
                                // CustomeFormField(
                                //   label: 'Mobile Number ',
                                //   validator: validateMobilenum,
                                //   controller: mobileNumberController,
                                //   maxLength: 10,
                                //
                                //   //focusNode: MobilenumberFocus,
                                //   keyboardType: TextInputType.number,
                                // ),
                                CustomeFormField(
                                  //MARK: Mobile Number
                                  label: 'Mobile Number',
                                  validator: validateMobilenum,
                                  controller: mobileNumberController,
                                  maxLength: 10,

                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(r'[0-4]')),
                                    // FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  keyboardType: TextInputType.phone,
                                  errorText: _mobileNumberError ? _mobileNumberErrorMsg : null,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.startsWith(' ')) {
                                        fullNameController.value = TextEditingValue(
                                          text: value.trimLeft(),
                                          selection: TextSelection.collapsed(offset: value.trimLeft().length),
                                        );
                                      }
                                      _mobileNumberError = false;
                                    });
                                  },
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    // SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          'Alternate Mobile Number ',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                        // Text(
                                        //   '',
                                        //   style: TextStyle(color: Colors.red),
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    TextFormField(
                                      controller: alernateMobileNumberController,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(RegExp(r'[0-4]')),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onTap: () {
                                        setState(() {
                                          AlernateMobilenumFocus.addListener(() {
                                            if (AlernateMobilenumFocus.hasFocus) {
                                              Future.delayed(const Duration(milliseconds: 300), () {
                                                Scrollable.ensureVisible(
                                                  AlernateMobilenumFocus.context!,
                                                  duration: const Duration(milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                );
                                              });
                                            }
                                          });
                                        });
                                      },
                                      focusNode: AlernateMobilenumFocus,
                                      decoration: InputDecoration(
                                          errorText: _altNumberError ? _altNumberErrorMsg : null,
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
                                          hintText: 'Alternate Mobile Number',
                                          hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                          counterText: ""),
                                      maxLength: 10,
                                      validator: validateAlterMobilenum,
                                      onChanged: (value) {
                                        setState(() {
                                          _altNumberError = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    //   const SizedBox(height: 5),
                                    const Row(
                                      children: [
                                        Text(
                                          'Email ',
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
                                    // TextFormField(
                                    //   controller: emailController,
                                    //   maxLength: 60,
                                    //   maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                    //   keyboardType: TextInputType.emailAddress,
                                    //   onTap: () {
                                    //     setState(() {
                                    //       EmailFocus.addListener(() {
                                    //         if (EmailFocus.hasFocus) {
                                    //           Future.delayed(const Duration(milliseconds: 300), () {
                                    //             Scrollable.ensureVisible(
                                    //               EmailFocus.context!,
                                    //               duration: const Duration(milliseconds: 300),
                                    //               curve: Curves.easeInOut,
                                    //             );
                                    //           });
                                    //         }
                                    //       });
                                    //     });
                                    //   },
                                    //   focusNode: EmailFocus,
                                    //   decoration: InputDecoration(
                                    //     contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
                                    //     focusedBorder: OutlineInputBorder(
                                    //       borderSide: const BorderSide(
                                    //         color: Color(0xFF0f75bc),
                                    //       ),
                                    //       borderRadius: BorderRadius.circular(6.0),
                                    //     ),
                                    //     enabledBorder: OutlineInputBorder(
                                    //       borderSide: const BorderSide(
                                    //         color: CommonUtils.primaryTextColor,
                                    //       ),
                                    //       borderRadius: BorderRadius.circular(6.0),
                                    //     ),
                                    //     border: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //         Radius.circular(10),
                                    //       ),
                                    //     ),
                                    //     hintText: 'Enter Email',
                                    //     counterText: "",
                                    //     hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                    //   ),
                                    //   validator: validateEmail,
                                    // ),
                                    TextFormField(
                                      controller: emailController,
                                      maxLength: 60,
                                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                      keyboardType: TextInputType.emailAddress,
                                      onTap: () {
                                        setState(() {
                                          EmailFocus.addListener(() {
                                            if (EmailFocus.hasFocus) {
                                              Future.delayed(const Duration(milliseconds: 300), () {
                                                Scrollable.ensureVisible(
                                                  EmailFocus.context!,
                                                  duration: const Duration(milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                );
                                              });
                                            }
                                          });
                                        });
                                      },
                                      focusNode: EmailFocus,
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
                                        hintText: 'Email',
                                        counterText: "",
                                        hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                      ),
                                      validator: validateEmail,
                                      onChanged: (value) {
                                        setState(() {
                                          _emailError = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    const SizedBox(height: 5),
                                    const Row(
                                      children: [
                                        Text(
                                          'User Name ',
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
                                    // TextFormField(
                                    //   controller: userNameController, // Assigning the controller
                                    //   keyboardType: TextInputType.name,
                                    //   // obscureText: true,
                                    //   onTap: () {
                                    //     setState(() {
                                    //       usernameFocus.addListener(() {
                                    //         if (usernameFocus.hasFocus) {
                                    //           Future.delayed(const Duration(milliseconds: 300), () {
                                    //             Scrollable.ensureVisible(
                                    //               usernameFocus.context!,
                                    //               duration: const Duration(milliseconds: 300),
                                    //               curve: Curves.easeInOut,
                                    //             );
                                    //           });
                                    //         }
                                    //       });
                                    //     });
                                    //   },
                                    //   focusNode: usernameFocus,
                                    //   decoration: InputDecoration(
                                    //     contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
                                    //     focusedBorder: OutlineInputBorder(
                                    //       borderSide: const BorderSide(
                                    //         color: Color(0xFF0f75bc),
                                    //       ),
                                    //       borderRadius: BorderRadius.circular(6.0),
                                    //     ),
                                    //     enabledBorder: OutlineInputBorder(
                                    //       borderSide: const BorderSide(
                                    //         color: CommonUtils.primaryTextColor,
                                    //       ),
                                    //       borderRadius: BorderRadius.circular(6.0),
                                    //     ),
                                    //     border: OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //         Radius.circular(10),
                                    //       ),
                                    //     ),
                                    //     hintText: 'Enter User Name',
                                    //     counterText: "",
                                    //     hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                    //   ),
                                    //   validator: validateusername,
                                    // ),
                                    TextFormField(
                                      controller: userNameController,
                                      maxLength: 50,
                                      keyboardType: TextInputType.visiblePassword,
                                      onTap: () {
                                        setState(
                                          () {
                                            usernameFocus.addListener(
                                              () {
                                                if (usernameFocus.hasFocus) {
                                                  Future.delayed(const Duration(milliseconds: 300), () {
                                                    Scrollable.ensureVisible(
                                                      usernameFocus.context!,
                                                      duration: const Duration(milliseconds: 300),
                                                      curve: Curves.easeInOut,
                                                    );
                                                  });
                                                }
                                              },
                                            );
                                          },
                                        );
                                      },
                                      focusNode: usernameFocus,
                                      decoration: InputDecoration(
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
                                        hintText: 'User Name',
                                        counterText: "",
                                        hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                        errorText: _userNameError ? _userNameErrorMsg : null,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          if (value.startsWith(' ')) {
                                            userNameController.value = TextEditingValue(
                                              text: value.trimLeft(),
                                              selection: TextSelection.collapsed(offset: value.trimLeft().length),
                                            );
                                            return;
                                          }
                                          _userNameError = false;
                                        });
                                      },
                                      // onChanged: (_) {
                                      //   setState(() {
                                      //     _userNameError = false;
                                      //   });
                                      // },
                                      validator: validateUserName,
                                    ),
                                  ],
                                ),

                                const SizedBox(
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    const SizedBox(height: 5),
                                    const Row(
                                      children: [
                                        Text(
                                          'Password ',
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
                                    // TextFormField(
                                    //   obscureText: password_obscuretext,
                                    //   controller: passwordController, // Assigning the controller
                                    //   keyboardType: TextInputType.visiblePassword,
                                    //
                                    //   onTap: () {
                                    //     setState(() {
                                    //       PasswordFocus.addListener(() {
                                    //         if (PasswordFocus.hasFocus) {
                                    //           Future.delayed(const Duration(milliseconds: 300), () {
                                    //             Scrollable.ensureVisible(
                                    //               PasswordFocus.context!,
                                    //               duration: const Duration(milliseconds: 300),
                                    //               curve: Curves.easeInOut,
                                    //             );
                                    //           });
                                    //         }
                                    //       });
                                    //     });
                                    //   },
                                    //   focusNode: PasswordFocus,
                                    //   decoration: InputDecoration(
                                    //     contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
                                    //     focusedBorder: OutlineInputBorder(
                                    //       borderSide: const BorderSide(
                                    //         color: Color(0xFF0f75bc),
                                    //       ),
                                    //       borderRadius: BorderRadius.circular(6.0),
                                    //     ),
                                    //     enabledBorder: OutlineInputBorder(
                                    //       borderSide: const BorderSide(
                                    //         color: CommonUtils.primaryTextColor,
                                    //       ),
                                    //       borderRadius: BorderRadius.circular(6.0),
                                    //     ),
                                    //     border: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //         Radius.circular(10),
                                    //       ),
                                    //     ),
                                    //     hintText: 'Enter Password',
                                    //     counterText: "",
                                    //     suffixIcon: IconButton(
                                    //       icon: Icon(
                                    //         password_obscuretext ? Icons.visibility_off : Icons.visibility,
                                    //         color: Colors.black,
                                    //       ),
                                    //       onPressed: () {
                                    //         // Toggle the password visibility
                                    //         setState(() {
                                    //           password_obscuretext = !password_obscuretext;
                                    //         });
                                    //       },
                                    //     ),
                                    //     hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                    //   ),
                                    //   validator: validatePassword,
                                    // ),
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller: passwordController,
                                          keyboardType: TextInputType.visiblePassword,
                                          obscureText: showPassword,
                                          maxLength: 25,
                                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                          onTap: () {
                                            setState(() {
                                              PasswordFocus.addListener(() {
                                                if (PasswordFocus.hasFocus) {
                                                  Future.delayed(const Duration(milliseconds: 300), () {
                                                    Scrollable.ensureVisible(
                                                      PasswordFocus.context!,
                                                      duration: const Duration(milliseconds: 300),
                                                      curve: Curves.easeInOut,
                                                    );
                                                  });
                                                }
                                              });
                                            });
                                          },
                                          focusNode: PasswordFocus,
                                          decoration: InputDecoration(
                                            errorText: _passwordError ? _passwordErrorMsg : null,
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  showPassword = !showPassword;
                                                });
                                              },
                                              child: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                                            ),
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
                                            hintText: 'Password',
                                            counterText: "",
                                            hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                          ),
                                          validator: validatePassword,
                                          onChanged: (value) {
                                            setState(() {
                                              if (value.startsWith(' ')) {
                                                passwordController.value = TextEditingValue(
                                                  text: value.trimLeft(),
                                                  selection: TextSelection.collapsed(offset: value.trimLeft().length),
                                                );
                                                return;
                                              }
                                              _passwordError = false;
                                              if (isPasswordValidate) {
                                                _updatePasswordStrengthMessage(value);
                                              }
                                            });
                                          },
                                        ),
                                        if (isPasswordValidate)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5, left: 12),
                                                child: Text(
                                                  _passwordStrengthMessage,
                                                  style: TextStyle(color: _passwordStrengthColor, fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ListView(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    const SizedBox(height: 5),
                                    const Row(
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
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    // TextFormField(
                                    //   obscureText: confirmpassword_obscuretext,
                                    //   controller: confirmPasswordController, // Assigning the controller
                                    //   keyboardType: TextInputType.visiblePassword,
                                    //
                                    //   onTap: () {
                                    //     setState(() {
                                    //       ConfrimPasswordFocus.addListener(() {
                                    //         if (ConfrimPasswordFocus.hasFocus) {
                                    //           Future.delayed(const Duration(milliseconds: 300), () {
                                    //             Scrollable.ensureVisible(
                                    //               ConfrimPasswordFocus.context!,
                                    //               duration: const Duration(milliseconds: 300),
                                    //               curve: Curves.easeInOut,
                                    //             );
                                    //           });
                                    //         }
                                    //       });
                                    //     });
                                    //   },
                                    //   focusNode: ConfrimPasswordFocus,
                                    //   decoration: InputDecoration(
                                    //     contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
                                    //     focusedBorder: OutlineInputBorder(
                                    //       borderSide: const BorderSide(
                                    //         color: CommonUtils.primaryTextColor,
                                    //       ),
                                    //       borderRadius: BorderRadius.circular(6.0),
                                    //     ),
                                    //     enabledBorder: OutlineInputBorder(
                                    //       borderSide: const BorderSide(
                                    //         color: CommonUtils.primaryTextColor,
                                    //       ),
                                    //       borderRadius: BorderRadius.circular(6.0),
                                    //     ),
                                    //     border: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //         Radius.circular(10),
                                    //       ),
                                    //     ),
                                    //     hintText: 'Confirm Password',
                                    //     counterText: "",
                                    //     suffixIcon: IconButton(
                                    //       icon: Icon(
                                    //         confirmpassword_obscuretext ? Icons.visibility_off : Icons.visibility,
                                    //         color: Colors.black,
                                    //       ),
                                    //       onPressed: () {
                                    //         // Toggle the password visibility
                                    //         setState(() {
                                    //           confirmpassword_obscuretext = !confirmpassword_obscuretext;
                                    //         });
                                    //       },
                                    //     ),
                                    //     hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                    //   ),
                                    //   validator: validateconfirmpassword,
                                    // ),
                                    TextFormField(
                                      controller: confirmPasswordController,
                                      keyboardType: TextInputType.visiblePassword,
                                      obscureText: showConfirmPassword,
                                      maxLength: 25,
                                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                      onTap: () {
                                        setState(() {
                                          ConfrimPasswordFocus.addListener(() {
                                            if (ConfrimPasswordFocus.hasFocus) {
                                              Future.delayed(const Duration(milliseconds: 300), () {
                                                Scrollable.ensureVisible(
                                                  ConfrimPasswordFocus.context!,
                                                  duration: const Duration(milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                );
                                              });
                                            }
                                          });
                                        });
                                      },
                                      focusNode: ConfrimPasswordFocus,
                                      decoration: InputDecoration(
                                        errorText: _confirmPasswordError ? _confirmPasswordErrorMsg : null,
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showConfirmPassword = !showConfirmPassword;
                                            });
                                          },
                                          child: Icon(showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                                        ),
                                        contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: CommonUtils.primaryTextColor,
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
                                        hintText: 'Confirm Password',
                                        counterText: "",
                                        hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                                      ),
                                      validator: validateconfirmpassword,
                                      onChanged: (value) {
                                        setState(() {
                                          if (value.startsWith(' ')) {
                                            confirmPasswordController.value = TextEditingValue(
                                              text: value.trimLeft(),
                                              selection: TextSelection.collapsed(offset: value.trimLeft().length),
                                            );
                                            return;
                                          }
                                          _confirmPasswordError = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ))),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            buttonText: 'Register',
                            color: CommonUtils.primaryTextColor,
                            onPressed: validating,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an Account?',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            ' Click Here',
                            style: TextStyle(
                              fontSize: 15,
                              color: CommonUtils.primaryTextColor,
                            ),
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
      } else {
        throw Exception('Failed to fetch radio button options');
      }
    } catch (e) {
      throw Exception('Error Radio: $e');
    }
  }

  // String? validateEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please Enter Email/User Name';
  //   } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
  //     return 'Please enter a valid email address';
  //   }
  //   return null;
  // }
  //
  // String? validatePassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please Enter Password';
  //   } else if (value.length < 8) {
  //     return 'Password must be 8 characters or above';
  //   }
  //   return null;
  // }
  //
  // String? validateconfirmpassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please Enter Confirm Password';
  //   }
  //   if (passwordController.text != confirmPasswordController.text) {
  //     return 'Confirm Password must be same as Password';
  //   }
  //   return null;
  // }
  //
  // void validateGender(String? value) {
  //   print('gender: $value');
  //   if (value == null || value.isEmpty) {
  //     isGenderSelected = true;
  //   } else {
  //     isGenderSelected = false;
  //   }
  //   setState(() {});
  // }
  //
  // String? validatedob(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please Enter Date of Birth';
  //   }
  //
  //   return null;
  // }
  //
  // String? validatefullname(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please Enter Full Name';
  //   }
  //   return null;
  // }
  //
  // String? validateMobilenum(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please Enter Mobile Number';
  //   } else if (value.contains(RegExp(r'[a-zA-Z]'))) {
  //     return 'Mobile number should contain only digits';
  //   } else if (value.length != 10) {
  //     return 'Mobile Number must have 10 digits';
  //   }
  //
  //   return null;
  // }
  //
  // String? validateAlterMobilenum(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please Enter Alternate Mobile Number';
  //   } else if (value.contains(RegExp(r'[a-zA-Z]'))) {
  //     return 'Alternate number should contain only digits';
  //   } else if (value.length != 10) {
  //     return 'Alternate Number must have 10 digits';
  //   }
  //
  //   return null;
  // }
  //
  // String? validateusername(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please Enter User Name';
  //   }
  //   return null;
  // }
  //
  // String? validateDOB(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please Select DOB';
  //   }
  //   return null;
  // }
  String? validatefullname(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _fullNameError = true;
        _fullNameErrorMsg = 'Full Name is Required';
      });
      return null;
    }
    if (value.length < 2) {
      setState(() {
        _fullNameError = true;
        _fullNameErrorMsg = 'Full Name should contains minimum 2 charactes';
      });
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
      return null;
    }
    return null;
  }

  String? validateDOB(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _dobError = true;
        _dobErrorMsg = 'Please Select Date of Birth';
      });
      return null;
    }
    return null;
  }

  void validateGender(String? value) {
    if (value == null || value.isEmpty) {
      isGenderSelected = true;
    } else {
      isGenderSelected = false;
    }
    setState(() {});
  }

  String? validateMobilenum(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _mobileNumberError = true;
        _mobileNumberErrorMsg = 'Please Enter Mobile Number';
      });
      return null;
    }
    if (value.startsWith(RegExp('[1-4]'))) {
      setState(() {
        _mobileNumberError = true;
        _mobileNumberErrorMsg = 'Mobile Number Should Not Start with 1-4';
      });
      return null;
    }
    if (value.contains(RegExp(r'[a-zA-Z]'))) {
      setState(() {
        _mobileNumberError = true;
        _mobileNumberErrorMsg = 'Mobile Number should contain only digits';
      });
      return null;
    }
    if (value.length != 10) {
      setState(() {
        _mobileNumberError = true;
        _mobileNumberErrorMsg = 'Mobile Number Must Have 10 Digits';
      });
      return null;
    }

    return null;
  }

  String? validateAlterMobilenum(String? value) {
    if (value!.isEmpty) {
      return null;
    }
    if (value.startsWith(RegExp('[1-4]'))) {
      setState(() {
        _altNumberError = true;
        _altNumberErrorMsg = 'Alternate Number Should Not Start with 1-4';
      });
      return null;
    }
    if (value.contains(RegExp(r'[a-zA-Z]'))) {
      setState(() {
        _altNumberError = true;
        _altNumberErrorMsg = 'Alternate Number Should Contain Only Digits';
      });
      return null;
    }
    if (value.length != 10) {
      setState(() {
        _altNumberError = true;
        _altNumberErrorMsg = 'Alternate Number Must Have 10 Digits';
      });
      return null;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _emailError = true;
        _emailErrorMsg = 'Email is Required';
      });
      return null;
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      setState(() {
        _emailError = true;
        _emailErrorMsg = 'Please Enter a Valid Email Address';
      });
      return null;
    }
    return null;
  }

  String? validateUserName(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _userNameError = true;
        _userNameErrorMsg = 'User Name is Required';
      });
      return null;
    }
    if (value.length < 2) {
      setState(() {
        _userNameError = true;
        _userNameErrorMsg = 'User Name Should Contains Minimum 2 Charactes';
      });
      return null;
    }
    if (invalidCredentials != null) {
      setState(() {
        _userNameError = true;
        _userNameErrorMsg = null;
      });
      return null;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      setState(() {
        isPasswordValidate = false;
        _passwordError = true;
        _passwordErrorMsg = 'Password is Required';
      });
      return null;
    } else if (value.length < 8) {
      setState(() {
        isPasswordValidate = false;
        _passwordError = true;
        _passwordErrorMsg = 'Password must be 8 characters or above';
      });
      return null;
    } else if (value.length > 30) {
      setState(() {
        isPasswordValidate = false;
        _passwordError = true;
        _passwordErrorMsg = 'Password must be below 30 characters';
      });
      return null;
    }

    final hasAlphabets = RegExp(r'[a-zA-Z]').hasMatch(value);
    final hasNumbers = RegExp(r'\d').hasMatch(value);
    final hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
    final hasCapitalLetter = RegExp(r'[A-Z]').hasMatch(value);

    if (!hasAlphabets || !hasNumbers || !hasSpecialCharacters || !hasCapitalLetter) {
      setState(() {
        isPasswordValidate = false;
        _passwordError = true;
        _passwordErrorMsg = 'Password must contain at least one alphabets, numbers, special characters, and capital letter';
      });
      return null;
    }
    setState(() {
      isPasswordValidate = true;
    });
    return null;
  }

  void _updatePasswordStrengthMessage(String password) {
    setState(() {
      if (password.isEmpty) {
        _passwordStrengthMessage = '';
        _passwordStrengthColor = Colors.transparent;
      } else if (_containsSpecialCharacters(password) && _containsNumbers(password)) {
        _passwordStrengthMessage = 'Strong password';
        _passwordStrengthColor = const Color.fromARGB(255, 2, 131, 68);
      } else if (_containsNumbers(password)) {
        _passwordStrengthMessage = 'Good password';
        _passwordStrengthColor = Colors.orange;
      } else {
        _passwordStrengthMessage = 'Weak password';
        _passwordStrengthColor = Colors.yellow;
      }
    });
  }

  bool _containsNumbers(String value) {
    return RegExp(r'\d').hasMatch(value);
  }

  bool _containsSpecialCharacters(String value) {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
  }

  String? validateconfirmpassword(String? value) {
    if (value!.isEmpty) {
      setState(() {
        _confirmPasswordError = true;
        _confirmPasswordErrorMsg = 'Confirm Password is Required';
      });
      return null;
    } else if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        _confirmPasswordError = true;
        _confirmPasswordErrorMsg = 'Confirm Password Must be Same as Password';
      });
      return null;
    }
    return null;
  }

  void endUserMessageFromApi(String endUserMessage) {
    setState(() {
      _userNameError = true;
      _userNameErrorMsg = 'User with this name is already exits';
      FocusScope.of(context).requestFocus(ConfrimPasswordFocus);
    });
  }

  void loginUser() {
    if (_formKey.currentState!.validate()) {
      print('login: Login success!');
    }
  }

  Future<void> validating() async {
    validateGender(selectedName);
    if (_formKey.currentState!.validate()) {
      String? fullName = fullNameController.text;
      String dob = dobController.text;
      //  String? gender = Gender.text;
      String? mobileNum = mobileNumberController.text;
      String? alternateMobileNum = alernateMobileNumberController.text;
      String? email = emailController.text;
      String? userName = userNameController.text;
      String? password = passwordController.text;
      String? confirmPassword = confirmPasswordController.text;

      String formattedDOB = ''; // Format the DateTime
      print('Formatted Date of Birth: $formattedDOB');
      formattedDOB = DateFormat('yyyy-MM-dd').format(selectedDate); //

      final url = Uri.parse(baseUrl + customeregisration);
      print('url==>890: $url');

      DateTime now = DateTime.now();
      // Using toString() method

      final request = {
        "id": null,
        "firstName": fullName.toString(),
        "middleName": null,
        "lastName": null,
        "contactNumber": mobileNum.toString(),
        "mobileNumber": alternateMobileNum.toString(),
        "userName": userName.toString(),
        "password": password.toString(),
        "confirmPassword": confirmPassword.toString(),
        "email": email.toString(),
        "isActive": true,
        "createdByUserId": null,
        "createdDate": "$now",
        "updatedByUserId": null,
        "updatedDate": "$now",
        "roleId": 2,
        "gender": selectedValue,
        "dateOfBirth": formattedDOB,
        "branchIds": "null"
      };

      print('Object: ${json.encode(request)}');
      CommonStyles.progressBar(context);
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
            CommonUtils.showCustomToastMessageLong('${data['statusMessage']}', context, 0, 5);
            Navigator.pop(context);
            LoadingProgress.stop(context);
          } else {
            LoadingProgress.stop(context);

            CommonUtils.showCustomToastMessageLong('${data['statusMessage']}', context, 0, 5);
          }
        } else {
          LoadingProgress.stop(context);

          print('Failed to send the request. Status code: ${response.statusCode}');
        }
      } catch (e) {
        LoadingProgress.stop(context);

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
