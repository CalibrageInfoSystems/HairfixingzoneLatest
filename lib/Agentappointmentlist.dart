import 'dart:convert';
import 'dart:math';

import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import 'package:hairfixingzone/slotbookingscreen.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'AgentAppointmentsProvider.dart';
import 'AgentHome.dart';
import 'Appointment.dart';
import 'BranchModel.dart';
import 'Common/common_styles.dart';
import 'Common/custom_button.dart';
import 'Commonutils.dart';
import 'MyAppointment_Model.dart';
import 'Rescheduleslotscreen.dart';
import 'api_config.dart';

class Agentappointmentlist extends StatefulWidget {
  final int userId;
  final int branchid;
  final String branchname;
  final String filepath;
  final String phonenumber;
  final String branchaddress;
  const Agentappointmentlist(
      {super.key,
      required this.userId,
      required this.branchid,
      required this.branchname,
      required this.filepath,
      required this.phonenumber,
      required this.branchaddress});
  @override
  MyAppointments_screenState createState() => MyAppointments_screenState();
}

class MyAppointments_screenState extends State<Agentappointmentlist> {
  Future<List<Appointment>>? apiData;
  List<Appointment> temp = [];
  int? userId;
  int? branchid;
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
        checkLoginuserdata();
        print('UserID==$userId');
        print('UserID==${widget.userId}');
        // fetchMyAppointments(userId);
      } else {
        print('The Internet Is not  Connected');
      }
    });
  }

  AgentAppointmentsProvider? myAppointmentsProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    myAppointmentsProvider = Provider.of<AgentAppointmentsProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgentHome(
                userId: widget.userId!,
              ),
            ),
          );
          myAppointmentsProvider!.clearFilter();
          return true;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            refreshTheScreen();
          },
          child: Scaffold(
            appBar: AppBar(
                backgroundColor: const Color(0xFFf3e3ff),
                title: const Text(
                  'Appointments',
                  style: TextStyle(
                    color: Color(0xFF0f75bc),
                    fontSize: 16.0,
                    fontFamily: "Calibri",
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: CommonUtils.primaryTextColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    myAppointmentsProvider!.clearFilter();
                  },
                )),
            body: Consumer<AgentAppointmentsProvider>(
              builder: (context, provider, _) => WillPopScope(
                onWillPop: () async {
                  provider.clearFilter();
                  return true;
                },
                child: Column(
                  children: [
                    // search and filter
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
                      child: _searchBarAndFilter(),
                    ),

                    //MARK: Appointment
                    Expanded(
                      child: FutureBuilder(
                        future: apiData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text(
                                'No Appointments Available',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            );
                          } else {
                            List<Appointment> data = provider.proAppointments;
                            if (data.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        OpCard(
                                          data: data[index],
                                          userId: widget.userId,
                                          branchid: widget.branchid,
                                          branchaddress: widget.branchaddress,
                                          onRefresh: () {
                                            // Implement the refresh logic here
                                            setState(() {
                                              // Refresh logic
                                              refreshTheScreen();

                                              // Navigator.of(context).push(
                                              //   MaterialPageRoute(
                                              //     builder: (context) => Agentappointmentlist(
                                              //       userId: widget.userId,
                                              //       branchid: widget.branchid,
                                              //       branchname: widget.branchname,
                                              //       filepath:widget.filepath != null ? widget.filepath! : 'assets/top_image.png',
                                              //       phonenumber: widget.phonenumber,
                                              //       branchaddress: widget.branchaddress,
                                              //     ),
                                              //   ),
                                              // );
                                            });
                                          },
                                        ),

                                        // OpCard(
                                        //     data: data[index], userId: widget.userId, branchid: widget.branchid, branchaddress: widget.branchaddress),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    );
                                    // return AppointmentCard(
                                    //     data: data[index],
                                    //     day: parseDayFromDate(data[index].date),);
                                  },
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  'No Appointments Available',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void checkLoginuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    print('userId: : $userId');
    // apiData = fetchMyAppointments(userId);
    // apiData.then((value) => myAppointmentsProvider.storeIntoProvider = value);
    initializeData(userId);
  }

  void initializeData(int? userId) {
    apiData = fetchagentAppointments(userId, widget.branchid);
    apiData!.then((value) {
      myAppointmentsProvider!.storeIntoProvider = value;
      temp.addAll(value);
    }).catchError((error) {
      print('catchError: Error occurred.');
    });
  }

  Future<List<Appointment>> fetchagentAppointments(int? userId, int branchid) async {
    final url = Uri.parse(baseUrl + GetAppointment);
    // {"userId":8,"branchId":2,"fromDate":"2024-05-01","toDate":"2024-05-17","statusTypeId":null}

    try {
      final request = {"userId": userId, "branchId": branchid, "fromdate": null, "toDate": null, "statustypeId": null};
      //   final request = {"userId": userId, "branchId": branchid, "fromdate":"2024-05-01", "toDate": "2024-05-17", "statustypeId": null};
      print('xxx: fetchagentAppointments ${json.encode(request)}');

      final jsonResponse = await http.post(
        url,
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (jsonResponse.statusCode == 200) {
        final response = json.decode(jsonResponse.body);

        if (response['listResult'] != null) {
          List<dynamic> listResult = response['listResult'];
          List<Appointment> result = listResult.map((item) => Appointment.fromJson(item)).toList();
          return result;
        } else {
          myAppointmentsProvider!.storeIntoProvider = [];
          throw Exception('No Appointments Available');
        }
      } else {
        print('Request failed with status: ${jsonResponse.statusCode}');
        throw Exception('Request failed with status: ${jsonResponse.statusCode}');
      }
    } catch (error) {
      print('catch: $error');
      rethrow;
    }
  }

  void refreshTheScreen() {
    CommonUtils.checkInternetConnectivity().then(
      (isConnected) {
        if (isConnected) {
          print('The Internet Is Connected');

          try {
            // reload the data
            checkLoginuserdata();
            setState(() {});
          } catch (error) {
            print('catch: $error');
            rethrow;
          }
        } else {
          CommonUtils.showCustomToastMessageLong('Please check your internet  connection', context, 1, 4);
          print('The Internet Is not  Connected');
        }
      },
    );
  }

  Widget _searchBarAndFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            height: 45,
            child: TextField(
              onChanged: (input) => filterAppointment(input),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 5, left: 12),
                hintText: 'Search Appointment',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: CommonUtils.primaryTextColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 1.5,
                    color: Color.fromARGB(255, 70, 3, 121),
                  ),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: CommonUtils.primaryTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: myAppointmentsProvider!.filterStatus ? const Color.fromARGB(255, 220, 186, 243) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: CommonUtils.primaryTextColor,
            ),
          ),
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/filter.svg',
              color: myAppointmentsProvider!.filterStatus ? Colors.black : CommonUtils.primaryTextColor,
              width: 24,
              height: 24,
            ),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: FilterAppointmentBottomSheet(userId: widget.userId, branchid: widget.branchid),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  int parseDayFromDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    print('dateFormate: ${dateTime.day} - ${DateFormat.MMM().format(dateTime)} - ${dateTime.year}');
    // int ,       String ,                           int
    return dateTime.day; //[dateTime.day, DateFormat.MMM().format(dateTime), dateTime.year];
  }

  void filterAppointment(String input) {
    myAppointmentsProvider!.filterProviderData(temp.where((item) {
      return item.purposeOfVisit.toLowerCase().contains(input.toLowerCase()) ||
          item.customerName.toLowerCase().contains(input.toLowerCase()) ||
          item.name.toLowerCase().contains(input.toLowerCase());
      // ||
      // item.email!.toLowerCase().contains(input.toLowerCase());
    }).toList());
  }
// void fetchAppointments(int userId, int branchid, {required status, required date}) async {
//   appointments.clear();
//   final url = Uri.parse(baseUrl + GetAppointment + '$userId/$branchid/$status/$date');
//   print('url==842===$url');
//   try {
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = jsonDecode(response.body);
//       if (responseData['listResult'] != null) {
//         final List<dynamic> appointmentsData = responseData['listResult'];
//         setState(() {
//           appointments = appointmentsData.map((appointment) => Appointment.fromJson(appointment)).toList();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         //  textFieldController.text = 'No Slots Available';
//         print('No Slots Available');
//       }
//     } else {
//       throw Exception('Failed to fetch appointments');
//     }
//   } catch (error) {
//     print('errorinappointmrent$error');
//     throw Exception('Failed to connect to the API');
//   }
// }
}

class FilterAppointmentBottomSheet extends StatefulWidget {
  final int? userId;
  final int? branchid;
  const FilterAppointmentBottomSheet({Key? key, required this.userId, required this.branchid}) : super(key: key);

  @override
  State<FilterAppointmentBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterAppointmentBottomSheet> {
  List<BranchModel> products = [];
  late Future<List<BranchModel>> branchname;
  BranchModel? selectedCategory;

  final orangeColor = CommonUtils.primaryTextColor;
  late Future<List<BranchModel>> apiData;
  TextEditingController From_todates = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  FocusNode DateofBirthdFocus = FocusNode();
  List<Statusmodel> statusoptions = [];
  late Future<List<Statusmodel>> prostatus;
  Statusmodel? selectedstatus;
  String? apiFromDate;
  String? apiToDate;

  AgentAppointmentsProvider? myAppointmentsProvider;
  @override
  void initState() {
    super.initState();
    apiData = fetchbranches(widget.userId);
    prostatus = fetchstatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    myAppointmentsProvider = Provider.of<AgentAppointmentsProvider>(context);
    From_todates.text = myAppointmentsProvider!.getDisplayDate;
  }

  Future<void> filterAppointments(Map<String, dynamic> requestBody) async {
    // final url = Uri.parse('http://182.18.157.215/SaloonApp/API/api/Appointment/GetAppointment');
    final url = Uri.parse(baseUrl + GetAppointment);

    try {
      Map<String, dynamic> request = requestBody;
      print('xxx: filterAppointments ${json.encode(request)}');

      final jsonResponse = await http.post(
        url,
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (jsonResponse.statusCode == 200) {
        final response = json.decode(jsonResponse.body);

        if (response['listResult'] != null) {
          List<dynamic> listResult = response['listResult'];
          myAppointmentsProvider!.storeIntoProvider = listResult.map((item) => Appointment.fromJson(item)).toList();
        } else {
          myAppointmentsProvider!.storeIntoProvider = [];
          throw Exception('No Appointments Available');
        }
      } else {
        myAppointmentsProvider!.storeIntoProvider = [];
        print('Request failed with status: ${jsonResponse.statusCode}');
        throw Exception('Request failed with status: ${jsonResponse.statusCode}');
      }
    } catch (error) {
      print('catch: $error');
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AgentAppointmentsProvider>(
      builder: (context, provider, _) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Filter By',
                    style: CommonStyles.txSty_16blu_f5,
                  ),
                  GestureDetector(
                    onTap: () {
                      clearFilterAppointments({
                        "userid": widget.userId,
                        "branchId": widget.branchid,
                        "fromdate": null,
                        "toDate": null,
                        "statustypeId": null,
                      });
                    },
                    child: const Text(
                      //MARK: Clear all filters
                      'Clear All Filters',
                      style: CommonStyles.txSty_16blu_f5,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  width: double.infinity,
                  height: 0.3,
                  color: CommonUtils.primaryTextColor,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: From_todates,
                      keyboardType: TextInputType.visiblePassword,
                      onTap: () {
                        showCustomDateRangePicker(
                          context,
                          dismissible: true,
                          endDate: endDate,
                          startDate: startDate,
                          maximumDate: DateTime.now().add(const Duration(days: 50)),
                          minimumDate: DateTime.now().subtract(const Duration(days: 50)),
                          onApplyClick: (s, e) {
                            setState(() {
                              //MARK: Date
                              endDate = e;
                              startDate = s;
                              provider.getDisplayDate =
                                  '${startDate != null ? DateFormat("dd, MMM").format(startDate!) : '-'} / ${endDate != null ? DateFormat("dd, MMM").format(endDate!) : '-'}';
                              From_todates.text = provider.getDisplayDate;
                              provider.getApiFromDate = DateFormat('yyyy-MM-dd').format(startDate!);
                              provider.getApiToDate = DateFormat('yyyy-MM-dd').format(endDate!);

                              print('Filter apiFromDate: $apiFromDate');
                              print('Filter apiToDate: $apiToDate');
                            });
                          },
                          onCancelClick: () {
                            setState(() {
                              endDate = null;
                              startDate = null;
                            });
                          },
                        );
                      },
                      focusNode: DateofBirthdFocus,
                      readOnly: true,
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
                     hintText: 'Select Dates',
                        counterText: "",
                        hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      //  validator: validatePassword,
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // //MARK: Filter Category
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10),
                    //   child: FutureBuilder(
                    //       future: apiData,
                    //       builder: (context, snapshot) {
                    //         if (snapshot.connectionState == ConnectionState.waiting) {
                    //           return CircularProgressIndicator.adaptive(
                    //             backgroundColor: Colors.transparent,
                    //             valueColor: AlwaysStoppedAnimation<Color>(orangeColor),
                    //           );
                    //         } else if (snapshot.hasError) {
                    //           return Text('Error: ${snapshot.error}');
                    //         } else {
                    //           List<BranchModel> data = snapshot.data!;
                    //           return SizedBox(
                    //             height: 40,
                    //             child: ListView.builder(
                    //               scrollDirection: Axis.horizontal,
                    //               shrinkWrap: true,
                    //               itemCount: data.length + 1,
                    //               itemBuilder: (BuildContext context, int index) {
                    //                 bool isSelected = index == provider.selectedBranch;
                    //                 BranchModel branchmodel;
                    //
                    //                 if (index == 0) {
                    //                   branchmodel = BranchModel(
                    //                     id: 0,
                    //                     name: "All",
                    //                     imageName: null,
                    //                     address: " ",
                    //                     startTime: 0,
                    //                     closeTime: 0,
                    //                     room: 0,
                    //                     mobileNumber: "",
                    //                     isActive: true,
                    //                   );
                    //                 } else {
                    //                   branchmodel = data[index - 1];
                    //                 }
                    //                 return GestureDetector(
                    //                   //MARK: Brach id
                    //                   onTap: () {
                    //                     setState(() {
                    //                       provider!.selectedBranch = index;
                    //
                    //                       // provider.getbranch = branchmodel.id;
                    //                       provider!.getApiBranchId = branchmodel.id;
                    //                       print('filter: ${provider.getbranch}');
                    //
                    //                       print('Filter branchmodel: ${branchmodel.id}');
                    //                     });
                    //                   },
                    //                   child: Container(
                    //                     margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    //                     decoration: BoxDecoration(
                    //                       color: isSelected ? orangeColor : orangeColor.withOpacity(0.1),
                    //                       border: Border.all(
                    //                         color: isSelected ? orangeColor : orangeColor,
                    //                         width: 1.0,
                    //                       ),
                    //                       borderRadius: BorderRadius.circular(8.0),
                    //                     ),
                    //                     child: IntrinsicWidth(
                    //                       child: Column(
                    //                         mainAxisAlignment: MainAxisAlignment.center,
                    //                         children: [
                    //                           Container(
                    //                             padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    //                             child: Row(
                    //                               children: [
                    //                                 Text(
                    //                                   branchmodel.name.toString(),
                    //                                   style: TextStyle(
                    //                                     fontSize: 12.0,
                    //                                     fontWeight: FontWeight.bold,
                    //                                     fontFamily: "Roboto",
                    //                                     color: isSelected ? Colors.white : Colors.black,
                    //                                   ),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 );
                    //               },
                    //             ),
                    //           );
                    //         }
                    //       }),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    //MARK: Filter Status
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: FutureBuilder(
                          future: prostatus,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(orangeColor),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<Statusmodel> data = snapshot.data!;
                              return SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: data.length + 1,
                                  itemBuilder: (BuildContext context, int index) {
                                    bool isSelected = index == provider.selectedstatus;
                                    Statusmodel status;

                                    if (index == 0) {
                                      status = Statusmodel(
                                        typeCdId: null,
                                        desc: 'All',
                                      );
                                    } else {
                                      status = data[index - 1];
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          provider.selectedStatus = index;

                                          // provider.getStatus = status.typeCdId;
                                          provider.getApiStatusTypeId = status.typeCdId;
                                          print('filter: ${provider.getStatus}');
                                          print('Filter status.typeCdId: ${status.typeCdId}');
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                        decoration: BoxDecoration(
                                          color: isSelected ? orangeColor : orangeColor.withOpacity(0.1),
                                          border: Border.all(
                                            color: isSelected ? orangeColor : orangeColor,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: IntrinsicWidth(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      status.desc.toString(),
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "Roboto",
                                                        color: isSelected ? Colors.white : Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                color: CommonUtils.primaryTextColor,
                              ),
                              side: const BorderSide(
                                color: CommonUtils.primaryTextColor,
                              ),
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                fontFamily: 'Calibri',
                                fontSize: 14,
                                color: CommonUtils.primaryTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: SizedBox(
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  //MARK: Filter Apply
                                  // filterAppointments(widget.userId);
                                  filterAppointments({
                                    "userId": widget.userId,
                                    "branchId": widget.branchid,
                                    // "branchId":
                                    //     myAppointmentsProvider?.getApiBranchId,
                                    "fromdate": myAppointmentsProvider?.getApiFromDate,
                                    "toDate": myAppointmentsProvider?.getApiToDate,
                                    "statustypeId": myAppointmentsProvider?.getApiStatusTypeId,
                                  }).whenComplete(() => provider.filterStatus = true);
                                },
                                child: Container(
                                  // width: desiredWidth * 0.9,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: CommonUtils.primaryTextColor,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Apply',
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Statusmodel>> fetchstatus() async {
    final response = await http.get(Uri.parse(baseUrl + getstatus));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['listResult'];
      List<Statusmodel> result = responseData.map((json) => Statusmodel.fromJson(json)).toList();
      print('fetch branchname: ${result[0].desc}');
      return result;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<BranchModel>> fetchbranches(userId) async {
    final response = await http.get(Uri.parse('$baseUrl$GetBranchByUserId$userId/null'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['listResult'];
      List<BranchModel> result = responseData.map((json) => BranchModel.fromJson(json)).toList();
      print('fetch branchname: ${result[0].name}');
      return result;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> clearFilterAppointments(Map<String, dynamic> requestBody) async {
    //   final url = Uri.parse('http://182.18.157.215/SaloonApp/API/api/Appointment/GetAppointment');
    final url = Uri.parse(baseUrl + GetAppointment);
    try {
      Map<String, dynamic> request = requestBody;
      print('xxx: clearFilterAppointments ${json.encode(request)}');

      final jsonResponse = await http.post(
        url,
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (jsonResponse.statusCode == 200) {
        final response = json.decode(jsonResponse.body);

        if (response['listResult'] != null) {
          List<dynamic> listResult = response['listResult'];
          myAppointmentsProvider!.storeIntoProvider = listResult.map((item) => Appointment.fromJson(item)).toList();
        } else {
          myAppointmentsProvider!.storeIntoProvider = [];
          throw Exception('No Appointments Available');
        }
      } else {
        myAppointmentsProvider!.storeIntoProvider = [];
        print('Request failed with status: ${jsonResponse.statusCode}');
        throw Exception('Request failed with status: ${jsonResponse.statusCode}');
      }
    } catch (error) {
      print('catch: $error');
    }
    Navigator.of(context).pop();
    myAppointmentsProvider!.clearFilter();
  }
}

class UserFeedback {
  double? ratingstar;
  String comments;

  UserFeedback({required this.ratingstar, required this.comments});
}

//
// class OpCard extends StatefulWidget {
//   final Appointment data;
//   int? userId;
//   int? branchid;
//   String? branchaddress;
//   OpCard({super.key, required this.data, required int userId, required int branchid, required String branchaddress});
//
//   @override
//   State<OpCard> createState() => _OpCardState();
// }
class OpCard extends StatefulWidget {
  final Appointment data;
  int? userId;
  int? branchid;
  String? branchaddress;
  final VoidCallback? onRefresh;

  OpCard({
    Key? key,
    required this.data,
    required int userId,
    required int branchid,
    required String branchaddress,
    this.onRefresh,
  }) : super(key: key);

  @override
  State<OpCard> createState() => _OpCardState();
}

class _OpCardState extends State<OpCard> {
  late List<dynamic> dateValues;
  final TextEditingController _commentstexteditcontroller = TextEditingController();
  double rating_star = 0.0;
  int? userId;

  @override
  void initState() {
    super.initState();
    dateValues = parseDateString(widget.data.date);
    print('userid===userId,$userId');
  }

  @override
  void dispose() {
    _commentstexteditcontroller.dispose();
    super.dispose();
  }

  List<dynamic> parseDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    print('dateFormate: ${dateTime.day} - ${DateFormat.MMM().format(dateTime)} - ${dateTime.year}');
    //         int ,       String ,                           int
    return [dateTime.day, DateFormat.MMM().format(dateTime), dateTime.year];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: IntrinsicHeight(
          child: Container(
            // height: widget.data.statusTypeId == 4 || widget.data.statusTypeId == 6
            //     ? 150
            //     : 180,
            //   height: 150,
            padding: const EdgeInsets.all(10),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10.0),
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
            child: Row(
              children: [
                SizedBox(
                  //  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.height / 16,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${dateValues[1]}',
                        style: CommonUtils.txSty_18p_f7,
                      ),
                      Text(
                        '${dateValues[0]}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontFamily: "Calibri",
                          // letterSpacing: 1.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0f75bc),
                        ),
                      ),
                      Text(
                        '${dateValues[2]}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "Calibri",
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0f75bc),
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                  color: CommonUtils.primaryTextColor,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.data.slotDuration,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Calibri",
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0f75bc),
                                      ),
                                    ),
                                    Text(widget.data.customerName, style: CommonStyles.txSty_16black_f5),
                                    Text(widget.data.email ?? '', style: CommonStyles.txSty_16black_f5),
                                    Text(widget.data.purposeOfVisit, style: CommonStyles.txSty_16black_f5),
                                    Text(widget.data.name, style: CommonStyles.txSty_16black_f5),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  statusBasedBgById(widget.data.statusTypeId, widget.data.status),
                                  const SizedBox(
                                    height: 2.0,
                                  ),

                                  Text(widget.data.phoneNumber ?? '', style: CommonStyles.txSty_16black_f5),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(widget.data.gender ?? ' ', style: CommonStyles.txSty_16black_f5),

                                  //    Text(widget.data.gender!, style: CommonStyles.txSty_16black_f5),
                                  const SizedBox(
                                    height: 5.0,
                                  ),

                                  if (widget.data.rating != null)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star_border_outlined,
                                              size: 13,
                                              color: CommonStyles.greenColor,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0), // Adjust the value as needed
                                              child: Text(
                                                '${widget.data.rating ?? ''}',
                                                style: CommonStyles.txSty_14g_f5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // based on status hide this row
                      Row(
                        mainAxisAlignment: widget.data.rating != null ? MainAxisAlignment.start : MainAxisAlignment.end,
                        children: [
                          verifyStatus(widget.data, userId),
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

  Widget statusBasedBgById(int statusTypeId, String status) {
    final Color statusColor;
    final Color statusBgColor;
    if (statusTypeId == 11) {
      status = "Closed";
    }

    switch (statusTypeId) {
      case 4: // Submited
        statusColor = CommonStyles.statusBlueText;
        statusBgColor = CommonStyles.statusBlueBg;
        break;
      case 5: // Accepted
        statusColor = CommonStyles.statusGreenText;
        statusBgColor = CommonStyles.statusGreenBg;
        break;
      case 6: // Declined
        statusColor = CommonStyles.statusRedText;
        statusBgColor = CommonStyles.statusRedBg;
        break;
      case 11: // FeedBack
        statusColor = const Color.fromARGB(255, 33, 129, 70);
        statusBgColor = CommonStyles.statusYellowBg;
        break;
      case 18: // Closed
        statusColor = CommonStyles.statusYellowText;
        statusBgColor = CommonStyles.statusYellowBg;
        break;
      case 100: // Rejected
        statusColor = CommonStyles.statusYellowText;
        statusBgColor = CommonStyles.statusYellowBg;
        break;
      default:
        statusColor = Colors.black26;
        statusBgColor = Colors.black26.withOpacity(0.2);
        break;
    }
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: statusBgColor),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
      child: Row(
        children: [
          // statusBasedBgById(widget.data.statusTypeId),
          Text(
            status,
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Calibri",
              fontWeight: FontWeight.w500,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget verifyStatus(Appointment data, int? userId) {
    switch (data.statusTypeId) {
      case 4: // Submited
        //   return const SizedBox();
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                if (!isPastDate(data.date, data.slotDuration)) {
                  print('Button 1 pressed for ${data.customerName}');

                  postAppointment(data, 5, 0, userId);
                  Get_ApprovedDeclinedSlots(data, 5);
                  print('accpteedbuttonisclicked');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => Rescheduleslotscreen(
                  //       data: data,
                  //     ),
                  //   ),
                  // );
                }
              },
              child: IgnorePointer(
                ignoring: isPastDate(data.date, data.slotDuration),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: isPastDate(data.date, data.slotDuration) ? Colors.grey : CommonStyles.primaryTextColor),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/calendar-_3_.svg',
                        width: 13,
                        color: isPastDate(data.date, data.slotDuration) ? Colors.grey : CommonUtils.primaryTextColor,
                      ),
                      Text(
                        '  Accept',
                        style: TextStyle(
                          fontSize: 15,
                          color: isPastDate(data.date, data.slotDuration) ? Colors.grey : CommonUtils.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                if (!isPastDate(data.date, data.slotDuration)) {
                  conformation(context, data);
                  // Add your logic here for when the 'Cancel' container is tapped
                }
              },
              child: IgnorePointer(
                ignoring: isPastDate(data.date, data.slotDuration),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: isPastDate(data.date, data.slotDuration) ? Colors.grey : CommonStyles.statusRedText,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/calendar-xmark.svg',
                        width: 12,
                        color: isPastDate(data.date, data.slotDuration) ? Colors.grey : CommonStyles.statusRedText,
                      ),
                      Text(
                        '  Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Calibri",
                          fontWeight: FontWeight.w500,
                          color: isPastDate(data.date, data.slotDuration) ? Colors.grey : CommonStyles.statusRedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      case 5: // Accepted
        //  return const SizedBox();
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                closepopup(data, 18, userId);
                // if (!isPastDate(data.date, data.SlotDuration)) {
                //   conformation(data);
                //   // Add your logic here for when the 'Cancel' container is tapped
                // }
              },
              child: IgnorePointer(
                ignoring: isPastDate(data.date, data.slotDuration),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: isPastDate(data.date, data.slotDuration) ? Colors.grey : CommonStyles.statusRedText,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/calendar-xmark.svg',
                        width: 12,
                        color: isPastDate(data.date, data.slotDuration) ? Colors.grey : CommonStyles.statusRedText,
                      ),
                      Text(
                        '  Close',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Calibri",
                          fontWeight: FontWeight.w500,
                          color: isPastDate(data.date, data.slotDuration) ? Colors.grey : CommonStyles.statusRedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      case 6: // Declined
        return const SizedBox();
      // case 11: // FeedBack
      //   return Flexible(
      //     child: Text('" ${data.review} "' ?? '',
      //         overflow: TextOverflow.ellipsis,
      //         maxLines: 2,
      //         style: CommonStyles.txSty_16blu_f5),
      //   );

      case 18: // Closed

        if (data.review == null) {
          // If status is Closed, show review or rate button
          return const SizedBox();
        } else {
          // If status is not Closed, show the review
          return Flexible(
            child: Text('" ${data.review} "' ?? '', overflow: TextOverflow.ellipsis, maxLines: 2, style: CommonStyles.txSty_16blu_f5),
          );
        }
      // case 19: // Reschuduled
      //   return const SizedBox();
      default:
        return const SizedBox();
      //  return Container(
      //     decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(3),
      //         border: Border.all(color: CommonUtils.blackColor)),
      //     padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      //     child: const Row(
      //       children: [
      //         Icon(
      //           Icons.star_border_outlined,
      //           size: 13,
      //           color: CommonStyles.primaryTextColor,
      //         ),
      //         Text(
      //           ' Rate Us',
      //           style: TextStyle(
      //             fontSize: 11,
      //             color: CommonStyles.primaryTextColor,
      //           ),
      //         ),
      //       ],
      //     ),
      //   );
    }
  }

  bool isPastDate(String? selectedDate, String time) {
    final now = DateTime.now();
    // DateTime currentTime = DateTime.now();
    //  print('currentTime: $currentTime');
    //   int hours = currentTime.hour;
    //  print('current hours: $hours');
    // Format the time using a specific pattern with AM/PM
    String formattedTime = DateFormat('hh:mm a').format(now);

    final selectedDateTime = DateTime.parse(selectedDate!);
    final currentDate = DateTime(now.year, now.month, now.day);

    // Agent login chey

    bool isBeforeTime = false; // Assume initial value as true
    bool isBeforeDate = selectedDateTime.isBefore(currentDate);
    // Parse the desired time for comparison
    DateTime desiredTime = DateFormat('hh:mm a').parse(time);
    // Parse the current time for comparison
    DateTime currentTime = DateFormat('hh:mm a').parse(formattedTime);

    if (selectedDateTime == currentDate) {
      int comparison = currentTime.compareTo(desiredTime);
      print('comparison$comparison');
      // Print the comparison result
      if (comparison < 0) {
        isBeforeTime = false;
        print('The current time is earlier than 10:15 AM.');
      } else if (comparison > 0) {
        isBeforeTime = true;
      } else {
        isBeforeTime = true;
      }

      //  isBeforeTime = hours >= time;
    }

    print('isBeforeTime: $isBeforeTime');
    print('isBeforeDate: $isBeforeDate');
    return isBeforeTime || isBeforeDate;
  }

  void conformation(BuildContext context, Appointment appointments) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text(
          //   'Confirmation',
          //   style: TextStyle(
          //     fontSize: 16,
          //     color: CommonUtils.blueColor,
          //     fontFamily: 'Calibri',
          //   ),
          // ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 130,
                child: Image.asset('assets/check.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                // Center the text
                child: Text(
                  'Are You Sure You Want to Cancel The appointment at ${appointments.name} Branch for ${appointments.purposeOfVisit}?',
                  style: CommonUtils.txSty_18b_fb,
                  textAlign: TextAlign.center, // Optionally, align the text center
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Text(
              //   'Are You Sure You Want To Cancel   ${appointments.purposeOfVisit} Slot At The ${appointments.name} Hair Fixing Zone',
              //   style: const TextStyle(
              //     fontSize: 16,
              //     color: CommonUtils.primaryTextColor,
              //     fontFamily: 'Calibri',
              //   ),
              // ),
            ],
          ),
          actions: [
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    color: CommonUtils.primaryTextColor,
                  ),
                  side: const BorderSide(
                    color: CommonUtils.primaryTextColor,
                  ),
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                child: const Text(
                  'No',
                  style: TextStyle(
                    fontSize: 16,
                    color: CommonUtils.primaryTextColor,
                    fontFamily: 'Calibri',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10), // Add spacing between buttons
            Container(
              child: ElevatedButton(
                onPressed: () {
                  cancelAppointment(appointments);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    color: CommonUtils.primaryTextColor,
                  ),
                  side: const BorderSide(
                    color: CommonUtils.primaryTextColor,
                  ),
                  backgroundColor: CommonUtils.primaryTextColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Calibri',
                  ),
                ),
              ),
            ),
          ],
          // actions: [
          //   TextButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //     child: const Text(
          //       'No',
          //       style: TextStyle(
          //         fontSize: 16,
          //         color: CommonUtils.blueColor,
          //         fontFamily: 'Calibri',
          //       ),
          //     ),
          //   ),
          //   TextButton(
          //     onPressed: () {
          //       cancelAppointment(appointments);
          //       Navigator.of(context).pop();
          //     },
          //     child: const Text(
          //       'Yes',
          //       style: TextStyle(
          //         fontSize: 16,
          //         color: CommonUtils.blueColor,
          //         fontFamily: 'Calibri',
          //       ),
          //     ),
          //   ),
          // ],
        );
      },
    );
  }

  // void conformation(Appointment appointments) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text(
  //           'Confirmation',
  //           style: TextStyle(
  //             fontSize: 16,
  //             color: CommonUtils.blueColor,
  //             fontFamily: 'Calibri',
  //           ),
  //         ),
  //          SizedBox(
  //           height: 10,
  //         ),
  //         SizedBox(
  //           width: 150,
  //           child: Image.asset('assets/rejected.png'),
  //         ),
  //         const SizedBox(
  //           height: 10,
  //         ),
  //         const Center(
  //           // Center the text
  //           child: Text(
  //             'Your Appointment Has Been Cancelled Successfully ',
  //             style: CommonUtils.txSty_18b_fb,
  //             textAlign: TextAlign.center, // Optionally, align the text center
  //           ),
  //         ),
  //         content: Text(
  //           'Are You Sure You Want To Cancel   ${appointments.purposeOfVisit} Slot At The${appointments.name} Hair Fixing Zone',
  //           style: const TextStyle(
  //             fontSize: 16,
  //             color: CommonUtils.primaryTextColor,
  //             fontFamily: 'Calibri',
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text(
  //               'No',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 color: CommonUtils.blueColor,
  //                 fontFamily: 'Calibri',
  //               ),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               cancelAppointment(appointments);
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text(
  //               'Yes',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 color: CommonUtils.blueColor,
  //                 fontFamily: 'Calibri',
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> cancelAppointment(Appointment appointmens) async {
    final url = Uri.parse(baseUrl + postApiAppointment);
    print('url==>890: $url');
    DateTime now = DateTime.now();
    String dateTimeString = now.toString();
    print('DateTime as String: $dateTimeString');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    print('userId CancelAppointment: $userId');
    //  for (MyAppointment_Model appointment in appointmens) {
    // Create the request object for each appointment
    final request = {
      "Id": appointmens.id,
      "BranchId": appointmens.branchId,
      "Date": appointmens.date,
      "SlotTime": appointmens.slotTime,
      "CustomerName": appointmens.customerName,
      "PhoneNumber": appointmens.phoneNumber, // Changed from appointments.phoneNumber
      "Email": appointmens.email,
      "GenderTypeId": appointmens.genderTypeId,
      "StatusTypeId": 6,
      "PurposeOfVisitId": appointmens.purposeOfVisitId,
      "PurposeOfVisit": appointmens.purposeOfVisit,
      "IsActive": true,
      "CreatedDate": dateTimeString,
      "UpdatedDate": dateTimeString,
      "UpdatedByUserId": userId!,
      "rating": null,
      "review": null,
      "reviewSubmittedDate": null,
      "timeofslot": appointmens.timeofSlot,
      "customerId": appointmens.customerId
    };
    print('AddUpdatefeedback object: : ${json.encode(request)}');

    try {
      // Send the POST request for each appointment
      final response = await http.post(
        url,
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        // Extract the necessary information
        bool isSuccess = data['isSuccess'];
        if (isSuccess == true) {
          print('Request sent successfully');
          openDialogreject();
          //  fetchMyAppointments(userId);
          //  CommonUtils.showCustomToastMessageLong('Cancelled  Successfully ', context, 0, 4);
          //   Navigator.pop(context);
          // Success case
          // Handle success scenario here
        } else {
          // Failure case
          // Handle failure scenario here
          CommonUtils.showCustomToastMessageLong('The Request Should Not Be Canceled Within 1 hour Before The Slot', context, 0, 2);
        }
      } else {
        //showCustomToastMessageLong(
        // 'Failed to send the request', context, 1, 2);
        print('Failed to send the request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while sending : $e');
    }
    //  }
  }

  Future<void> postAppointment(Appointment data, int i, int Amount, int? userId) async {
    final url = Uri.parse(baseUrl + postApiAppointment);
    print('url==>890: $url');
    print('url==>userId: $userId');
    // final url = Uri.parse('http://182.18.157.215/SaloonApp/API/api/Appointment');
    DateTime now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    print('userId CancelAppointment: $userId');
    // Using toString() method
    String dateTimeString = now.toString();
    print('DateTime as String: $dateTimeString');

    // Create the request object
    final request = {
      "Id": data.id,
      "BranchId": data.branchId,
      "Date": data.date,
      "SlotTime": data.slotTime,
      "CustomerName": data.customerName,
      "PhoneNumber": data.phoneNumber,
      "Email": data.email,
      "GenderTypeId": data.genderTypeId,
      "StatusTypeId": i,
      "PurposeOfVisitId": data.purposeOfVisitId,
      "PurposeOfVisit": data.purposeOfVisit,
      "IsActive": true,
      "CreatedDate": dateTimeString,
      "UpdatedDate": dateTimeString,
      "customerId": data.customerId,
      "UpdatedByUserId": userId,
      "timeofSlot": data.timeofSlot,
      if (i == 18) "price": Amount,

      // "rating": null,
      // "review": null,
      // "reviewSubmittedDate": null,
      // "timeofslot": null,
      // "customerId":  data.c
    };
    print('Accept Or reject object: : ${json.encode(request)}');
    print('Accept Or reject object: $request');
    try {
      // Send the POST request
      final response = await http.post(
        url,
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json', // Set the content type header
        },
      );

      // Check the response status code
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        // Extract the necessary information
        bool isSuccess = data['isSuccess'];
        if (isSuccess == true) {
          print('Request sent successfully');
          if (i == 5) {
            openDialogaccept();
          } else if (i == 18) {
            openDialogclosed();
          }
          // Success case
          // Handle success scenario here
        } else {
          // Failure case
          // Handle failure scenario here
          CommonUtils.showCustomToastMessageLong('Failed to Send The Request ', context, 0, 2);
        }
      } else {
        //showCustomToastMessageLong(
        // 'Failed to send the request', context, 1, 2);
        print('Failed to send the request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void closepopup(Appointment data, int i, int? userId) {
    TextEditingController priceController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Price '),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 345.0,
              height: 120.0,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      // CustomeFormField(
                      //   label: 'Email/User Name',
                      //   validator: validateEmail,
                      //   controller: _emailController,
                      // ),
                      const Row(
                        children: [
                          Text(
                            'Amount (Rs)',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      TextFormField(
                        controller: priceController, // Assigning the controller
                        keyboardType: TextInputType.number,
                        // obscureText: true,

                        maxLength: 10,
                        decoration: InputDecoration(
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
                          hintText: 'Enter Amount (Rs) ',
                          counterText: "",
                          hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                        ),
                        validator: validateAmount,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
              // child: Row(
              //   children: [
              //     Expanded(
              //       child: Align(
              //         alignment: Alignment.centerLeft,
              //         child: Padding(
              //           padding: EdgeInsets.only(left: 10.0, top: 6.0),
              //           child: TextFormField(
              //             controller: priceController,
              //             keyboardType: TextInputType.number,
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontFamily: 'Calibri',
              //               color: Color(0xFF042DE3),
              //               fontWeight: FontWeight.w300,
              //             ),
              //             validator: (value) {
              //               if (value!.isEmpty) {
              //                 CommonUtils.showCustomToastMessageLong('Please enter a price', context, 1, 4);
              //                 FocusScope.of(context).unfocus();
              //               }
              //               int? price = int.tryParse(value);
              //               if (price == null) {
              //                 CommonUtils.showCustomToastMessageLong('Please enter a valid  price', context, 1, 4);
              //                 FocusScope.of(context).unfocus();
              //                 // return 'Please enter a valid integer price';
              //               }
              //               return null;
              //             },
              //             decoration: InputDecoration(
              //               hintText: ' Price in Rs',
              //               hintStyle: TextStyle(
              //                 fontSize: 14,
              //                 fontFamily: 'Calibri',
              //                 color: Color(0xFF042DE3),
              //                 fontWeight: FontWeight.w300,
              //               ),
              //               border: InputBorder.none,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ),
          ),
          actions: [
            // TextButton(
            // onPressed: () {
            //   if (formKey.currentState!.validate()) {
            //     int? price = int.tryParse(priceController.text);
            //     postAppointment(data, 18, price!, userId);
            //     Navigator.of(context).pop();
            //
            //   }
            // },
            //
            // child:
            CustomButton(
              buttonText: 'Submit',
              color: CommonUtils.primaryTextColor,
              onPressed: () {
                // Refresh the screen
                if (formKey.currentState!.validate()) {
                  int? price = int.tryParse(priceController.text);
                  postAppointment(data, 18, price!, userId);
                  Navigator.of(context).pop();
                }
                //    Navigator.of(context).push(
                //      MaterialPageRoute(
                //        builder: (context) =>  Agentappointmentlist(),
                //      ),
                //    );
              },
            ),
          ],
        );
      },
    );
  }

  void openDialogreject() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 100,
                child: Image.asset('assets/rejected.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                // Center the text
                child: Text(
                  'Your Appointment Has Been Cancelled Successfully ',
                  style: CommonUtils.txSty_18b_fb,
                  textAlign: TextAlign.center, // Optionally, align the text center
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                buttonText: 'Done',
                color: CommonUtils.primaryTextColor,
                onPressed: () {
                  // Refresh the screen
                  widget.onRefresh?.call();
                  Navigator.of(context).pop();
                  //    Navigator.of(context).push(
                  //      MaterialPageRoute(
                  //        builder: (context) =>  Agentappointmentlist(),
                  //      ),
                  //    );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Amount (Rs)';
    }
    // else if (!RegExp(
    //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //     .hasMatch(value)) {
    //   return 'Please enter a valid email address';
    // }
    return null;
  }

  void openDialogaccept() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 130,
                child: Image.asset('assets/checked.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                // Center the text
                child: Text(
                  'Your Appointment Has Been Accepted Successfully ',
                  style: CommonUtils.txSty_18b_fb,
                  textAlign: TextAlign.center, // Optionally, align the text center
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                buttonText: 'Done',
                color: CommonUtils.primaryTextColor,
                onPressed: () {
                  widget.onRefresh?.call();
                  Navigator.of(context).pop();
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const CustomerLoginScreen(),
                  //   ),
                  // );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void openDialogclosed() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 130,
                child: Image.asset('assets/checked.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                // Center the text
                child: Text(
                  'Your Appointment Has Been Closed Successfully ',
                  style: CommonUtils.txSty_18b_fb,
                  textAlign: TextAlign.center, // Optionally, align the text center
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                buttonText: 'Done',
                color: CommonUtils.primaryTextColor,
                onPressed: () {
                  widget.onRefresh?.call();
                  Navigator.of(context).pop();
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const CustomerLoginScreen(),
                  //   ),
                  // );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> Get_ApprovedDeclinedSlots(Appointment data, int i) async {
  final url = Uri.parse(baseUrl + GetApprovedDeclinedSlots);
  print('url==>55555: $url');

  final request = {
    "Id": data.id,
    "StatusTypeId": 5,
    "BranchName": data.name,
    "Date": data.date,
    "SlotTime": data.slotTime,
    "CustomerName": data.customerName,
    "PhoneNumber": data.phoneNumber,
    "Email": data.email,
    "Address": data.name,
    "SlotDuration": data.slotDuration,
    "branchId": data.branchId,
  };
  print('Get_ApprovedSlotsmail: ${json.encode(request)}');
  try {
    // Send the POST request
    final response = await http.post(
      url,
      body: json.encode(request),
      headers: {
        'Content-Type': 'application/json', // Set the content type header
      },
    );

    // Check the response status code
    if (response.statusCode == 204) {
      print('Request sent successfully');
    } else {
      print('Failed to send the request. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
