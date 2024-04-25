import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hairfixingzone/MyAppointment_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CommonUtils.dart';
import 'CustomRadioButton.dart';
import 'Room.dart';
import 'api_config.dart';

class Rescheduleslotscreen extends StatefulWidget {
  // final int branchId;
  // final String branchname;
  // final String branchlocation;
  // final String filepath;
 final MyAppointment_Model data;
  // final int appointmentId; // New field
  // final String screenFrom; // New field

  // Rescheduleslotscreen(MyAppointment_Model data, {
  //   required this.data,
  //  // New field
  // });
 Rescheduleslotscreen({required this.data});
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

class _BookingScreenState extends State<Rescheduleslotscreen>  {
  List<String> timeSlots = [];
  List<String> availableSlots = [];
  List<String> timeSlotParts = [];
  String _selectedTimeSlot = '';
  String _selectedSlot = '';
  String AvailableSlots = '';
  String? dropValue;
  List<dropdown> drop = [];
  int? dropdownid;
  late List<String> _subSlots;
  late String selectedOption;
  late String selecteddate;
  List<RadioButtonOption> options = [];
  bool isDropdownValid = true;
  int selectedGender = -1;
  bool isGenderSelected = false;
  bool slotselection = false;

  bool _isPhoneIconFocused = false;
  TextEditingController dateinput = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Room? _selectedRoom;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _fullnameController1 = TextEditingController();
  TextEditingController _phonenumberController2 = TextEditingController();
  TextEditingController _emailController3 = TextEditingController();
  TextEditingController _purposeController4 = TextEditingController();
  bool isBackButtonActivated = false;
//  TextEditingController textController4 = TextEditingController(text: 'Initial value 4');
  List<Slot> slots = [];

  // String _selectedTimeSlot = '';
  // String AvailableSlots = '';
  // List<String> timeSlotParts =[];
  bool isButtonEnabled = true;
  bool isLoading = true;
  late bool isSlotsAvailable;
  List<Slot> disabledSlots = [];
  List<Slot> visableSlots = [];
  late int BranchId;
  List<DateTime> disabledDates = [];
  List<Holiday> holidayList = [];
  bool _isTodayHoliday = false;
  late DateTime holidayDate;
  bool isTodayHoliday = false;
  List<dynamic> dropdownItems = [];
  int selectedTypeCdId = -1;
  late int selectedValue;
  late String selectedName;
  String userFullName = '';
  String email = '';
  String phonenumber = '';
  int gender = 0;
  String Gender = '';
  int? userId;
  bool showConfirmationDialog = false;
  @override

  @override
  void dispose() {
    _dateController.dispose();

    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final desiredWidth = screenWidth;
    isSlotsAvailable = getVisibleSlots(slots, isTodayHoliday).isNotEmpty;
    disabledSlots = getDisabledSlots(slots);
    visableSlots = getVisibleSlots(slots, isTodayHoliday);
    // return WillPopScope(
    //     onWillPop: () async {
    //       // Show a confirmation dialog
    //       Navigator.of(context).pop(); // Navigate back to the previous screen
    //       // Return false to prevent default back button behavior
    //       return true;
    //     },
    //     child:
    return  WillPopScope(
        onWillPop: () => onBackPressed(context), child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Color(0xFFFB4110),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop(); // Navigate back to the previous screen
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2)),
                Image.asset(
                  'assets/logo.png',
                  width: 100,
                  height: 180,
                ),
              ],
            )),
        //body: YourBodyWidget(),
        // Replace YourBodyWidget with your actual content

      ));
  }

  // Future<void> _openDatePicker(bool isTodayHoliday) async {
  //   setState(() {
  //     _isTodayHoliday = isTodayHoliday;
  //   });
  //
  //   DateTime initialDate = _selectedDate;
  //
  //   // Adjust the initial date if it doesn't satisfy the selectableDayPredicate
  //   if (_isTodayHoliday && initialDate.isBefore(DateTime.now())) {
  //     initialDate = getNextNonHoliday(DateTime.now()); // Use getNextNonHoliday to get the next available non-holiday day
  //   }
  //
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialEntryMode: DatePickerEntryMode.calendarOnly,
  //     initialDate: initialDate,
  //     firstDate: DateTime.now().subtract(Duration(days: 0)),
  //     lastDate: DateTime(2125),
  //     selectableDayPredicate: selectableDayPredicate,
  //   );
  //
  //   if (pickedDate != null) {
  //     setState(() {
  //       _selectedDate = pickedDate;
  //       onDateSelected(pickedDate);
  //     });
  //   }
  // }

  bool isHoliday(DateTime date) {
    return holidayList
        .any((holiday) => date.year == holiday.holidayDate.year && date.month == holiday.holidayDate.month && date.day == holiday.holidayDate.day);
  }

  DateTime getNextNonHoliday(DateTime currentDate) {
    // Keep moving forward until a non-holiday day is found
    while (isHoliday(currentDate)) {
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return currentDate;
  }

  bool selectableDayPredicate(DateTime date) {
    final isPastDate = date.isBefore(DateTime.now().subtract(Duration(days: 1)));
    final isHolidayDate = isHoliday(date);
    final isPreviousYear = date.year < DateTime.now().year;

    // If today is a holiday and the selected date is a past date, allow selecting the next non-holiday date
    if (_isTodayHoliday && isHolidayDate && isPastDate) {
      return true;
    }

    // Return false if any of the conditions are met
    return !isPastDate && !isHolidayDate && !isPreviousYear && date.year >= DateTime.now().year;
  }

  //Original Code commented by Arun on Jan25th
  // Future<void> _openDatePicker(bool isTodayHoliday) async {
  //   setState(() {
  //     _isTodayHoliday = isTodayHoliday;
  //   });
  //
  //   DateTime initialDate = _selectedDate;
  //
  //   // Adjust the initial date if it doesn't satisfy the selectableDayPredicate
  //   if (_isTodayHoliday && initialDate.isBefore(DateTime.now())) {
  //     initialDate = DateTime.now().add(const Duration(days: 1));
  //   }
  //
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialEntryMode: DatePickerEntryMode.calendarOnly,
  //     initialDate: initialDate,
  //     firstDate: DateTime.now().subtract(Duration(days: 0)),
  //     lastDate: DateTime(2125),
  //     // Assuming you have a variable '_isTodayHoliday' indicating whether today is a holiday or not.
  //
  //     selectableDayPredicate: (DateTime date) {
  //       final isPastDate = date.isBefore(DateTime.now().subtract(Duration(days: 1)));
  //    //   final isSunday = date.weekday == DateTime.tuesday; // Change to DateTime.sunday
  //       final isHoliday = holidayList.any((holiday) =>
  //       date.year == holiday.holidayDate.year &&
  //           date.month == holiday.holidayDate.month &&
  //           date.day == holiday.holidayDate.day);
  //
  //       // If today is a holiday and the selected date is a past date, allow selecting the holiday date
  //       if (_isTodayHoliday && isHoliday && isPastDate) {
  //         return true;
  //       }
  //
  //       final isPreviousYear = date.year < DateTime.now().year;
  //
  //       // Return false if any of the conditions are met
  //       return !isPastDate  && !isHoliday && !isPreviousYear && date.year >= DateTime.now().year;
  //     },
  //
  //   );
  //
  //   if (pickedDate != null) {
  //     setState(() {
  //       _selectedDate = pickedDate;
  //       onDateSelected(pickedDate);
  //     });
  //
  //   }
  // }

  void disableButton() {
    setState(() {
      isButtonEnabled = false;
    });
  }

  Future<void> validatedata() async {
    int disabledlength = disabledSlots.length;
    print('====887$disabledlength');
    int visablelength = visableSlots.length;
    print('==889$visablelength');
    bool isValid = true;
    bool hasValidationFailed = false;

    if (selectedTypeCdId == -1) {
      selectedName = "Select";
    }

    if (_dateController.text.isEmpty) {
      showCustomToastMessageLong('Please Select Date', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }
    if (!isSlotsAvailable) {
      showCustomToastMessageLong('No Slots Available Today', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    } else if (!slotselection) {
      showCustomToastMessageLong('Please Select slot', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }
    if (visablelength == disabledlength) {
      showCustomToastMessageLong('No Slots Available Today ', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }

    if (_selectedSlot == null) {
      showCustomToastMessageLong('Please Select Time Slot', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }
    if (isValid && _fullnameController1.text.isEmpty) {
      showCustomToastMessageLong('Please Enter Your Full Name', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }
    if (isValid && _phonenumberController2.text.isEmpty) {
      showCustomToastMessageLong('Please Enter Your Phone Number', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    } else {
      String value = _phonenumberController2.text;
      int? number = int.tryParse(value);
      if (isValid && number != null && number.toString().length < 10) {
        showCustomToastMessageLong('Please Enter Your Valid Mobile Number', context, 1, 2);
        isValid = false;
        hasValidationFailed = true;
      }
    }

    if (isValid && _emailController3.text.isEmpty) {
      showCustomToastMessageLong('Please Enter Your Email', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }
    if (isValid && !validateEmailFormat(_emailController3.text)) {
      showCustomToastMessageLong('Please Enter Valid Email', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }

    if (isValid && !isGenderSelected) {
      showCustomToastMessageLong('Please Select Gender', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }

    if (isValid && selectedTypeCdId == -1) {
      showCustomToastMessageLong('Please Select Purpose of Visit', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }


  }




  List<Slot> getVisibleSlots(List<Slot> slots, bool isTodayHoliday) {
    print('isTodayHoliday====$isTodayHoliday');
    // Get the current time
    DateTime now = DateTime.now();

    // Format the time in 12-hour format
    String formattedTime = DateFormat('hh:mm a').format(now);

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Combine the current date and formatted time
    String combinedDateTimeString = DateFormat('yyyy-MM-dd').format(currentDate) + ' ' + formattedTime;

    // Parse the combined date and time string into a DateTime object
    DateTime combinedDateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(combinedDateTimeString);

    if (isTodayHoliday) {
      // Today is a holiday, return an empty list
      return [];
    }

    if (slots.isEmpty) {
      // Return a list with a single Slot object containing the message
      // return 'Slots not available';
    }

    return slots.where((slot) {
      String timespan = slot.SlotTimeSpan;
      // Combine the current date and formatted time
      String SlotDateTimeString = DateFormat('yyyy-MM-dd').format(currentDate) + ' ' + timespan;

      DateFormat dateformat = DateFormat('yyyy-MM-dd');
      String currentdate = dateformat.format(DateTime.now());
      String formattedapiDate = dateformat.format(slot.date);

      // // Parse the combined date and time string into a DateTime object
      // DateTime SlotDateTime =
      // DateFormat('yyyy-MM-dd hh:mm a').parse(SlotDateTimeString);

      DateTime slotDateTime;
      if (currentdate == formattedapiDate) {
        // If the slot is for the current date, use the slot's time
        String timespan = slot.SlotTimeSpan;

        // Combine the current date and time span
        String SlotDateTimeString = DateFormat('yyyy-MM-dd').format(currentDate) + ' ' + timespan;

        // Parse the combined date and time string into a DateTime object
        slotDateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(SlotDateTimeString);
      } else {
        // If the slot is for a different date, use the slot's date and time
        slotDateTime = DateFormat('yyyy-MM-dd HH:mm').parse('${formattedapiDate} ${timespan}');
      }

      return !slotDateTime.isBefore(combinedDateTime);
    }).toList();
  }

  List<Slot> getDisabledSlots(List<Slot> slots) {
    // Get the current time
    DateTime now = DateTime.now();

    // Format the time in 12-hour format
    String formattedTime = DateFormat('hh:mm a').format(now);

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Combine the current date and formatted time
    String combinedDateTimeString = DateFormat('yyyy-MM-dd').format(currentDate) + ' ' + formattedTime;

    // Parse the combined date and time string into a DateTime object
    DateTime combinedDateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(combinedDateTimeString);

    // Filter the slots based on visibility criteria
    List<Slot> disabledSlots = slots.where((slot) {
      DateTime slotDateTime = DateFormat('yyyy-MM-dd HH:mm').parse('${slot.date} ${slot.date}');
      return !slotDateTime.isBefore(combinedDateTime) && slot.availableSlots <= 0;
    }).toList();

    return disabledSlots;
  }

  List<Slot> filteredSlots = [];

  //List<Slot> slots = [];

  // Future<List<Slot>> fetchTimeSlots(DateTime selectedDate, int branchId) async {
  //   isLoading = false;
  //   final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
  //   final url = Uri.parse(baseUrl + GetSlotsByDateAndBranch + "$formattedDate/$branchId");
  //   print('url==>969: $url');
  //
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final jsonResult = json.decode(response.body);
  //       final List<dynamic> slotData = jsonResult['listResult'];
  //
  //       slots = slotData.map((slotJson) => Slot.fromJson(slotJson)).toList();
  //
  //       setState(() {
  //         // Update any necessary state variables
  //       });
  //
  //       return slots;
  //     } else {
  //       throw Exception('Failed to fetch slots');
  //     }
  //   } catch (e) {
  //     throw Exception('Errortimeslots: $e');
  //   }
  // }
  Future<List<Slot>> fetchTimeSlots(DateTime selectedDate, int branchId) async {
    setState(() {
      isLoading = true; // Set isLoading to true before making the API request
    });

    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    final url = Uri.parse(baseUrl + GetSlotsByDateAndBranch + "$formattedDate/$branchId");
    print('url==>969: $url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResult = json.decode(response.body);
        final List<dynamic> slotData = jsonResult['listResult'];

        List<Slot> slots = slotData.map((slotJson) => Slot.fromJson(slotJson)).toList();

        setState(() {
          isLoading = false; // Set isLoading to false after data is fetched
          // Update any necessary state variables
        });

        return slots;
      } else {
        throw Exception('Failed to fetch slots');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Set isLoading to false if error occurs
      });
      throw Exception('Error fetching time slots: $e');
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
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Center(
                child: Text(
                  message,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
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





  Future<void> fetchData() async {
    final url = Uri.parse(baseUrl + getdropdown);
    final response = await http.get((url));
    // final url =  Uri.parse(baseUrl+GetHolidayListByBranchId+'$branchId');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        dropdownItems = data['listResult'];
      });
    } else {
      print('Failed to fetch data');
    }
  }

  Future<bool> onBackPressed(BuildContext context) {
    // Navigate back when the back button is pressed
    Navigator.pop(context);
    // Return false to indicate that we handled the back button press
    return Future.value(false);
  }
}

class RadioButtonOption {
  final int? typeCdId;
  final String desc;

  RadioButtonOption({required this.typeCdId, required this.desc});

  factory RadioButtonOption.fromJson(Map<String, dynamic> json) {
    return RadioButtonOption(
      typeCdId: json['typeCdId'] ?? 0,
      desc: json['desc'] ?? '',
    );
  }
}

class dropdown {
  final int typeCdId_1;
  final String desc_1;

  dropdown({required this.typeCdId_1, required this.desc_1});

  factory dropdown.fromJson(Map<String, dynamic> json) {
    return dropdown(
      typeCdId_1: json['TypeCdId'] ?? 0,
      desc_1: json['Desc'] ?? '',
    );
  }
}


class Holiday {
  final int id;
  final int branchId;
  final DateTime holidayDate;
  final bool isActive;
  final String comments;
  final String name;
  final String createdBy;
  final String updatedBy;

  Holiday({
    required this.id,
    required this.branchId,
    required this.holidayDate,
    required this.isActive,
    required this.comments,
    required this.name,
    required this.createdBy,
    required this.updatedBy,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      id: json['id'] ?? 0,
      branchId: json['branchId'] ?? 0,
      holidayDate: DateTime.parse(json['holidayDate'] ?? ''),
      isActive: json['isActive'] ?? false,
      comments: json['comments'] ?? '',
      name: json['name'] ?? '',
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
    );
  }
}

class HolidayResponse {
  final List<Holiday> listResult;

  HolidayResponse({required this.listResult});

  factory HolidayResponse.fromJson(List<dynamic> json) {
    List<Holiday> holidays = json.map((holidayJson) => Holiday.fromJson(holidayJson)).toList();
    return HolidayResponse(listResult: holidays);
  }
}
