import 'dart:convert';
import 'dart:math';

import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hairfixingzone/HomeScreen.dart';
import 'package:hairfixingzone/MyAppointmentsProvider.dart';
import 'package:hairfixingzone/slotbookingscreen.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'BranchModel.dart';
import 'Common/common_styles.dart';
import 'Common/custom_button.dart';
import 'Commonutils.dart';
import 'MyAppointment_Model.dart';
import 'Rescheduleslotscreen.dart';
import 'api_config.dart';

class GetAppointments extends StatefulWidget {
  const GetAppointments({super.key});

  @override
  MyAppointments_screenState createState() => MyAppointments_screenState();
}

class MyAppointments_screenState extends State<GetAppointments> {
  String accessToken = '';
  String empolyeid = '';
  String todate = "";
  final TextEditingController _commentstexteditcontroller =
      TextEditingController();
  double rating_star = 0.0;

  List<BranchModel> brancheslist = [];

  bool isLoading = true;
  List<MyAppointment_Model> MyAppointmentList = [];
  List<UserFeedback> userfeedbacklist = [];
  Future<List<MyAppointment_Model>>? apiData;
  int? userId;
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
        // fetchMyAppointments(userId);
      } else {
        print('The Internet Is not  Connected');
      }
    });
  }

  MyAppointmentsProvider? myAppointmentsProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    myAppointmentsProvider = Provider.of<MyAppointmentsProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
          myAppointmentsProvider!.clearFilter();

          return false;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            refreshTheScreen();
          },
          child: Consumer<MyAppointmentsProvider>(
            builder: (context, provider, _) => Scaffold(
              appBar: AppBar(
                  backgroundColor: const Color(0xFFf3e3ff),
                  title: const Text(
                    'My Bookings',
                    style: TextStyle(
                      color: Color(0xFF0f75bc),
                      fontSize: 16.0,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                      provider.clearFilter();
                    },
                  )),
              body: Column(
                children: [
                  // search and filter
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10)
                        .copyWith(top: 10),
                    child: _searchBarAndFilter(),
                  ),

                  //MARK: Appointment
                  Expanded(
                    child: FutureBuilder(
                      future: apiData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              'No appointments found',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Roboto",
                              ),
                            ),
                          );
                        } else {
                          List<MyAppointment_Model> data =
                              provider.proAppointments;
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
                                      ),
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
    apiData = fetchMyAppointments(userId);
    apiData!.then((value) {
      myAppointmentsProvider!.storeIntoProvider = value;
    }).catchError((error) {
      print('catchError: Error occurred.');
    });
  }

  Future<List<MyAppointment_Model>> fetchMyAppointments(int? userId) async {
    final url = Uri.parse(baseUrl + GetAppointmentByUserid);

    try {
      final request = {
        "userid": userId,
        "branchId": null,
        "fromdate": null,
        "toDate": null,
        "statustypeId": null
      };
      print('GetAppointmentByUserid: ${json.encode(request)}');

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

          // Filter out records with "statusTypeId": 19
          listResult =
              listResult.where((item) => item['statusTypeId'] != 19).toList();

          List<MyAppointment_Model> result = listResult
              .map((item) => MyAppointment_Model.fromJson(item))
              .toList();

          return result;
        } else {
          throw Exception('No appointments found!');
        }
      } else {
        print('Request failed with status: ${jsonResponse.statusCode}');
        throw Exception(
            'Request failed with status: ${jsonResponse.statusCode}');
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
          CommonUtils.showCustomToastMessageLong(
              'Please check your internet  connection', context, 1, 4);
          print('The Internet Is not  Connected');
        }
      },
    );
  }

  Widget _searchBarAndFilter() {
    return Container(
      child: Row(
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
                    borderSide:
                        const BorderSide(color: CommonUtils.primaryTextColor),
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
              color: myAppointmentsProvider!.filterStatus
                  ? const Color.fromARGB(255, 220, 186, 243)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: CommonUtils.primaryTextColor,
              ),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/filter.svg',
                color: myAppointmentsProvider!.filterStatus
                    ? Colors.black
                    : CommonUtils.primaryTextColor,
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
                    child: FilterAppointmentBottomSheet(
                      userId: userId,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int parseDayFromDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    print(
        'dateFormate: ${dateTime.day} - ${DateFormat.MMM().format(dateTime)} - ${dateTime.year}');
    // int ,       String ,                           int
    return dateTime
        .day; //[dateTime.day, DateFormat.MMM().format(dateTime), dateTime.year];
  }

  // void filterAppointment(String input) {
  //   apiData!.then((data) {
  //     setState(() {
  //       myAppointmentsProvider!.filterProviderData(data
  //           .where((item) =>
  //               item.purposeOfVisit.toLowerCase().contains(input.toLowerCase()))
  //           .toList());
  //     });
  //   });
  // }
  void filterAppointment(String input) {
    print('xxx: $input');
    apiData!.then((data) {
      setState(() {
        myAppointmentsProvider!.filterProviderData(data
            .where((item) =>
                // Uncomment and modify the condition to filter by name
                item.purposeOfVisit
                    .toLowerCase()
                    .contains(input.toLowerCase()) ||
                item.branch.toLowerCase().contains(input.toLowerCase()))
            .toList());
      });
    });
  }

  // void filterAppointment(String input) {
  //   print('xxx: $input');
  //   apiData!.then((data) {
  //     setState(() {
  //       myAppointmentsProvider!.filterProviderData(data
  //           .where((item) =>
  //       // item.customerName
  //       //         .toLowerCase()
  //       //         .contains(input.toLowerCase())
  //       // ||
  //       // item.name.toLowerCase().contains(input.toLowerCase()) ||
  //       // item.email!.toLowerCase().contains(input.toLowerCase()) ||
  //       item.purposeOfVisit.toLowerCase().contains(input.toLowerCase()))
  //           .toList());
  //     });
  //   });
  // }
}

class FilterAppointmentBottomSheet extends StatefulWidget {
  final int? userId;
  const FilterAppointmentBottomSheet({Key? key, required this.userId})
      : super(key: key);

  @override
  State<FilterAppointmentBottomSheet> createState() =>
      _FilterBottomSheetState();
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

  late MyAppointmentsProvider myAppointmentsProvider;
  @override
  void initState() {
    super.initState();
    apiData = fetchbranches();
    prostatus = fetchstatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    myAppointmentsProvider = Provider.of<MyAppointmentsProvider>(context);
    From_todates.text = myAppointmentsProvider.getDisplayDate;
  }

  Future<void> filterAppointments(Map<String, dynamic> requestBody) async {
    final url = Uri.parse(baseUrl + GetAppointmentByUserid);

    try {
      Map<String, dynamic> request = requestBody;
      print('filterAppointments: ${json.encode(request)}');

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
          print('listResult: ${listResult.length}');
          // Filter out records with "statusTypeId": 19
          List<dynamic> filteredList =
              listResult.where((item) => item['statusTypeId'] != 19).toList();
          print('filteredList: ${filteredList.length}');
          // Convert the filtered list to MyAppointment_Model objects if needed
          myAppointmentsProvider.storeIntoProvider = filteredList
              .map((item) => MyAppointment_Model.fromJson(item))
              .toList();
        } else {
          myAppointmentsProvider.storeIntoProvider = [];
          throw Exception('No appointments found!');
        }
      } else {
        myAppointmentsProvider.storeIntoProvider = [];
        print('Request failed with status: ${jsonResponse.statusCode}');
        throw Exception(
            'Request failed with status: ${jsonResponse.statusCode}');
      }
    } catch (error) {
      print('catch: $error');
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAppointmentsProvider>(
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
                        "branchId": null,
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
                          maximumDate:
                              DateTime.now().add(const Duration(days: 50)),
                          minimumDate:
                              DateTime.now().subtract(const Duration(days: 50)),
                          onApplyClick: (s, e) {
                            setState(() {
                              //MARK: Date
                              endDate = e;
                              startDate = s;
                              // provider.getDisplayDate =
                              //     '${startDate != null ? DateFormat("dd, MMM").format(startDate!) : '-'} / ${endDate != null ? DateFormat("dd, MMM").format(endDate!) : '-'}';

                              provider.getDisplayDate =
                                  '${startDate != null ? DateFormat('dd/MM/yyyy').format(startDate!) : '-'}  -  ${endDate != null ? DateFormat('dd/MM/yyyy').format(endDate!) : '-'}';
                              From_todates.text = provider.getDisplayDate;
                              provider.getApiFromDate =
                                  DateFormat('yyyy-MM-dd').format(startDate!);
                              provider.getApiToDate =
                                  DateFormat('yyyy-MM-dd').format(endDate!);

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
                        hintText: 'Select Dates',
                        counterText: "",
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w400),
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      //  validator: validatePassword,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //MARK: Filter Category
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: FutureBuilder(
                          future: apiData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.transparent,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(orangeColor),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<BranchModel> data = snapshot.data!;
                              return SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: data.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    bool isSelected =
                                        index == provider.selectedBranch;
                                    BranchModel branchmodel;

                                    if (index == 0) {
                                      branchmodel = BranchModel(
                                        id: 0,
                                        name: "All",
                                        imageName: null,
                                        address: " ",
                                        startTime: 0,
                                        closeTime: 0,
                                        room: 0,
                                        mobileNumber: "",
                                        isActive: true,
                                      );
                                    } else {
                                      branchmodel = data[index - 1];
                                    }
                                    return GestureDetector(
                                      //MARK: Brach id
                                      onTap: () {
                                        setState(() {
                                          provider.selectedBranch = index;

                                          // provider.getbranch = branchmodel.id;
                                          provider.getApiBranchId =
                                              branchmodel.id;
                                          print(
                                              'filter: ${provider.getbranch}');

                                          print(
                                              'Filter branchmodel: ${branchmodel.id}');
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? orangeColor
                                              : orangeColor.withOpacity(0.1),
                                          border: Border.all(
                                            color: isSelected
                                                ? orangeColor
                                                : orangeColor,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: IntrinsicWidth(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      branchmodel.name
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "Roboto",
                                                        color: isSelected
                                                            ? Colors.white
                                                            : Colors.black,
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
                    //MARK: Filter Status
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10),
                    //   child: FutureBuilder(
                    //       future: prostatus,
                    //       builder: (context, snapshot) {
                    //         if (snapshot.connectionState == ConnectionState.waiting) {
                    //           return CircularProgressIndicator.adaptive(
                    //             backgroundColor: Colors.transparent,
                    //             valueColor: AlwaysStoppedAnimation<Color>(orangeColor),
                    //           );
                    //         } else if (snapshot.hasError) {
                    //           return Text('Error: ${snapshot.error}');
                    //         } else {
                    //           List<Statusmodel> data = snapshot.data!;
                    //           return SizedBox(
                    //             height: 40,
                    //             child: ListView.builder(
                    //               scrollDirection: Axis.horizontal,
                    //               shrinkWrap: true,
                    //               itemCount: data.length + 1,
                    //               itemBuilder: (BuildContext context, int index) {
                    //                 bool isSelected = index == provider.selectedstatus;
                    //                 Statusmodel status;
                    //
                    //                 if (index == 0) {
                    //                   status = Statusmodel(
                    //                     typeCdId: null,
                    //                     desc: 'All',
                    //                   );
                    //                 } else {
                    //                   status = data[index - 1];
                    //                 }
                    //                 return GestureDetector(
                    //                   onTap: () {
                    //                     setState(() {
                    //                       provider.selectedStatus = index;
                    //
                    //                       // provider.getStatus = status.typeCdId;
                    //                       provider.getApiStatusTypeId = status.typeCdId;
                    //                       print('filter: ${provider.getStatus}');
                    //                       print('Filter status.typeCdId: ${status.typeCdId}');
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
                    //                                   status.desc.toString(),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: FutureBuilder(
                          future: prostatus,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.transparent,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(orangeColor),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<Statusmodel> data = snapshot.data!;

                              // Filter out items with "typeCdId": 19
                              data = data
                                  .where((item) => item.typeCdId != 19)
                                  .toList();

                              return SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: data.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    bool isSelected =
                                        index == provider.selectedstatus;
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
                                          provider.getApiStatusTypeId =
                                              status.typeCdId;
                                          print(
                                              'filter: ${provider.getStatus}');
                                          print(
                                              'Filter status.typeCdId: ${status.typeCdId}');
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? orangeColor
                                              : orangeColor.withOpacity(0.1),
                                          border: Border.all(
                                            color: isSelected
                                                ? orangeColor
                                                : orangeColor,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: IntrinsicWidth(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      status.desc.toString(),
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "Roboto",
                                                        color: isSelected
                                                            ? Colors.white
                                                            : Colors.black,
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
                                    "userid": widget.userId,
                                    "branchId":
                                        myAppointmentsProvider.getApiBranchId,
                                    "fromdate":
                                        myAppointmentsProvider.getApiFromDate,
                                    "toDate":
                                        myAppointmentsProvider.getApiToDate,
                                    "statustypeId": myAppointmentsProvider
                                        .getApiStatusTypeId,
                                  }).whenComplete(
                                      () => provider.filterStatus = true);
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

  // Future<List<Statusmodel>> fetchstatus() async {
  //   final response = await http.get(Uri.parse(baseUrl + getstatus));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> responseData = json.decode(response.body)['listResult'];
  //     List<Statusmodel> result = responseData.map((json) => Statusmodel.fromJson(json)).toList();
  //     print('fetch branchname: ${result[0].desc}');
  //     return result;
  //   } else {
  //     throw Exception('Failed to load products');
  //   }
  // }
  Future<List<Statusmodel>> fetchstatus() async {
    final response = await http.get(Uri.parse(baseUrl + getstatus));
    if (response.statusCode == 200) {
      final List<dynamic> responseData =
          json.decode(response.body)['listResult'];

      print('Before filtering: $responseData');

      // Filter out items with "typeCdId": 19
      final List<dynamic> filteredData =
          responseData.where((item) => item['typeCdId'] != 19).toList();

      print('After filtering: $filteredData');

      // Map the filtered data to Statusmodel
      List<Statusmodel> result =
          filteredData.map((json) => Statusmodel.fromJson(json)).toList();

      print('fetch branchname: ${result[0].desc}');
      return result;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<BranchModel>> fetchbranches() async {
    final response = await http.get(Uri.parse(baseUrl + getbranches));
    if (response.statusCode == 200) {
      final List<dynamic> responseData =
          json.decode(response.body)['listResult'];
      List<BranchModel> result =
          responseData.map((json) => BranchModel.fromJson(json)).toList();
      print('fetch branchname: ${result[0].name}');
      return result;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> clearFilterAppointments(Map<String, dynamic> requestBody) async {
    // final url = Uri.parse(
    //     'http://182.18.157.215/SaloonApp/API/api/Appointment/GetAppointmentByUserid');
    final url = Uri.parse(baseUrl + GetAppointmentByUserid);
    // baseUrl+GetAppointmentByUserid
    try {
      Map<String, dynamic> request = requestBody;
      print('filterAppointments: ${json.encode(request)}');

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

          // Filter out records with "statusTypeId": 19
          List<dynamic> filteredList =
              listResult.where((item) => item['statusTypeId'] != 19).toList();

          // Convert the filtered list to MyAppointment_Model objects if needed
          myAppointmentsProvider.storeIntoProvider = filteredList
              .map((item) => MyAppointment_Model.fromJson(item))
              .toList();
        } else {
          myAppointmentsProvider.storeIntoProvider = [];
          throw Exception('No Appointments found');
        }
      } else {
        myAppointmentsProvider.storeIntoProvider = [];
        print('Request failed with status: ${jsonResponse.statusCode}');
        throw Exception(
            'Request failed with status: ${jsonResponse.statusCode}');
      }
    } catch (error) {
      print('catch: $error');
    }
    Navigator.of(context).pop();
    myAppointmentsProvider.clearFilter();
  }
}

class UserFeedback {
  double? ratingstar;
  String comments;

  UserFeedback({required this.ratingstar, required this.comments});
}

class OpCard extends StatefulWidget {
  final MyAppointment_Model data;
  const OpCard({super.key, required this.data});

  @override
  State<OpCard> createState() => _OpCardState();
}

class _OpCardState extends State<OpCard> {
  late List<dynamic> dateValues;
  final TextEditingController _commentstexteditcontroller =
      TextEditingController();
  double rating_star = 0.0;
  int? userId;

  @override
  void initState() {
    super.initState();
    dateValues = parseDateString(widget.data.date);
  }

  @override
  void dispose() {
    _commentstexteditcontroller.dispose();
    super.dispose();
  }

  List<dynamic> parseDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    print(
        'dateFormate: ${dateTime.day} - ${DateFormat.MMM().format(dateTime)} - ${dateTime.year}');
    //         int ,       String ,                           int
    return [dateTime.day, DateFormat.MMM().format(dateTime), dateTime.year];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Container(
        height: widget.data.statusTypeId == 4 || widget.data.statusTypeId == 6
            ? 90
            : 120,
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
              width: MediaQuery.of(context).size.height / 18,
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
                      //letterSpacing: 1.5,
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
                                Text(widget.data.purposeOfVisit,
                                    style: CommonStyles.txSty_16black_f5),
                                Text(widget.data.branch,
                                    style: CommonStyles.txSty_16black_f5),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              statusBasedBgById(
                                  widget.data.statusTypeId, widget.data.status),
                              // Text('status'),
                              const SizedBox(
                                height: 10.0,
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
                                          padding: const EdgeInsets.only(
                                              right:
                                                  8.0), // Adjust the value as needed
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
                    mainAxisAlignment: widget.data.rating != null
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      verifyStatus(
                        widget.data,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: statusBgColor),
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

  Widget verifyStatus(MyAppointment_Model data) {
    switch (data.statusTypeId) {
      case 4: // Submited
        return const SizedBox();
      case 5: // Accepted
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                int timeDifference =
                    calculateTimeDifference(data.date, data.slotDuration);
                print(
                    '====timeDifference $timeDifference'); // assuming you have a function to calculate time difference
                // if (timeDifference <= 0) {
                //   // Show error toast if time difference is 0 or negative
                //   CommonUtils.showCustomToastMessageLong(
                //     'The request should not be rescheduled within 1 hour before the slot',
                //     context,
                //     0,
                //     2,
                //   );
                // } else
                if (timeDifference <= 60) {
                  // Show error toast if time difference is less than or equal to 60 minutes
                  CommonUtils.showCustomToastMessageLong(
                    'The Request Should Not be Rescheduled Within 1 hour Before The Slot',
                    context,
                    0,
                    2,
                  );
                } else {
                  // Navigate to reschedule screen if time difference is greater than 60 minutes
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Rescheduleslotscreen(
                        data: data,
                      ),
                    ),
                  );
                }
              },
              child: IgnorePointer(
                ignoring: isPastDate(data.date, data.slotDuration),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: isPastDate(data.date, data.slotDuration)
                          ? Colors.grey
                          : CommonStyles.primaryTextColor,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/calendar-_3_.svg',
                        width: 13,
                        color: isPastDate(data.date, data.slotDuration)
                            ? Colors.grey
                            : CommonUtils.primaryTextColor,
                      ),
                      Text(
                        '  Reschedule',
                        style: TextStyle(
                          fontSize: 15,
                          color: isPastDate(data.date, data.slotDuration)
                              ? Colors.grey
                              : CommonUtils.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // GestureDetector(
            //   onTap: () {
            //     if (!isPastDate(data.date, data.slotDuration)) {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => Rescheduleslotscreen(
            //             data: data,
            //           ),
            //         ),
            //       );
            //     }
            //
            //
            //   },
            //   child: IgnorePointer(
            //     ignoring: isPastDate(data.date, data.slotDuration),
            //     child: Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(3),
            //         border: Border.all(
            //             color: isPastDate(data.date, data.slotDuration)
            //                 ? Colors.grey
            //                 : CommonStyles.primaryTextColor),
            //       ),
            //       padding:
            //       const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            //       child: Row(
            //         children: [
            //           SvgPicture.asset(
            //             'assets/calendar-_3_.svg',
            //             width: 13,
            //             color: isPastDate(data.date, data.slotDuration)
            //                 ? Colors.grey
            //                 : CommonUtils.primaryTextColor,
            //           ),
            //           Text(
            //             '  Reschedule',
            //             style: TextStyle(
            //               fontSize: 15,
            //               color: isPastDate(data.date, data.slotDuration)
            //                   ? Colors.grey
            //                   : CommonUtils.primaryTextColor,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
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
                      color: isPastDate(data.date, data.slotDuration)
                          ? Colors.grey
                          : CommonStyles.statusRedText,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/calendar-xmark.svg',
                        width: 12,
                        color: isPastDate(data.date, data.slotDuration)
                            ? Colors.grey
                            : CommonStyles.statusRedText,
                      ),
                      Text(
                        '  Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Calibri",
                          fontWeight: FontWeight.w500,
                          color: isPastDate(data.date, data.slotDuration)
                              ? Colors.grey
                              : CommonStyles.statusRedText,
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
          return GestureDetector(
            onTap: () {
              showDialogForRating(data);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: CommonStyles.primaryTextColor,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: const Row(
                children: [
                  Icon(
                    Icons.star_border_outlined,
                    size: 13,
                    color: CommonStyles.primaryTextColor,
                  ),
                  Text(
                    ' Rate Us',
                    style: TextStyle(
                      fontSize: 16,
                      color: CommonStyles.primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // If status is not Closed, show the review
          return Flexible(
            child: Text('" ${data.review} "' ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: CommonStyles.txSty_16blu_f5),
          );
        }
      case 19: // Reschuduled
        return const SizedBox();
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
    String formattedTime = DateFormat('hh:mm a').format(now);

    final selectedDateTime = DateTime.parse(selectedDate!);
    final currentDate = DateTime(now.year, now.month, now.day);

    bool isBeforeTime = false;
    bool isBeforeDate = selectedDateTime.isBefore(currentDate);

    DateTime desiredTime = DateFormat('hh:mm a').parse(time);
    DateTime currentTime = DateFormat('hh:mm a').parse(formattedTime);

    if (selectedDateTime == currentDate) {
      int comparison = currentTime.compareTo(desiredTime);
      print('current hours: $comparison');
      if (comparison < 0) {
        isBeforeTime = false;
      } else if (comparison > 0) {
        isBeforeTime = true;
      } else {
        isBeforeTime = true;
      }
    }

    return isBeforeTime || isBeforeDate;
  }

  // bool isPastDate(String? selectedDate, String time) {
  //   final now = DateTime.now();
  //   // DateTime currentTime = DateTime.now();
  //   //  print('currentTime: $currentTime');
  //   //   int hours = currentTime.hour;
  //   //  print('current hours: comparison');
  //   // Format the time using a specific pattern with AM/PM
  //   String formattedTime = DateFormat('hh:mm a').format(now);
  //
  //   final selectedDateTime = DateTime.parse(selectedDate!);
  //   final currentDate = DateTime(now.year, now.month, now.day);
  //
  //   // Agent login chey
  //
  //   bool isBeforeTime = false; // Assume initial value as true
  //   bool isBeforeDate = selectedDateTime.isBefore(currentDate);
  //   // Parse the desired time for comparison
  //   DateTime desiredTime = DateFormat('hh:mm a').parse(time);
  //   // Parse the current time for comparison
  //   DateTime currentTime = DateFormat('hh:mm a').parse(formattedTime);
  //
  //   if (selectedDateTime == currentDate) {
  //     int comparison = currentTime.compareTo(desiredTime);
  //     print('comparison$comparison');
  //     // Print the comparison result
  //     if (comparison < 0) {
  //       isBeforeTime = false;
  //       print('The current time is earlier than 10:15 AM.');
  //     } else if (comparison > 0) {
  //       isBeforeTime = true;
  //     } else {
  //       isBeforeTime = true;
  //     }
  //
  //     //  isBeforeTime = hours >= time;
  //   }
  //
  //   print('isBeforeTime: $isBeforeTime');
  //   print('isBeforeDate: $isBeforeDate');
  //   return isBeforeTime || isBeforeDate;
  // }

  void showDialogForRating(MyAppointment_Model appointments) {
    _commentstexteditcontroller.clear();
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              title: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                      top: 15.0, left: 15.0, right: 15.0, bottom: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xffffffff),
                        Color(0xffffffff),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Feedback',
                        style: TextStyle(
                          fontSize: 24,
                          color: CommonUtils.primaryTextColor,
                          fontFamily: 'Calibri',
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        'Please Rate Your Experience For The ${appointments.slotDuration} Slot At The ${appointments.branch} Hair Fixing Zone',
                        style: const TextStyle(
                          fontSize: 16,
                          color: CommonUtils.primaryTextColor,
                          fontFamily: 'Calibri',
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: RatingBar.builder(
                            initialRating: 0,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: CommonUtils.primaryTextColor,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                rating_star = rating;
                                print('rating_star$rating_star');
                              });
                            },
                          )),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 0, top: 10.0, right: 0),
                        child: GestureDetector(
                          onTap: () async {},
                          child: Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: CommonUtils.primaryTextColor,
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              controller: _commentstexteditcontroller,
                              style: const TextStyle(
                                fontFamily: 'Calibri',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                              maxLines: null,
                              maxLength: 250,
                              // Set maxLines to null for multiline input
                              decoration: const InputDecoration(
                                hintText: 'Comment',
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
                          ),
                        ),
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
                                    Radius.circular(10),
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
                                    validateRating(appointments);
                                  },
                                  child: Container(
                                    // width: desiredWidth * 0.9,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: CommonUtils.primaryTextColor,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Submit',
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
              ),
            );
          },
        );
      },
    );
  }

  Future<void> validateRating(MyAppointment_Model appointmens) async {
    //  print('indexinvalidating$index');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    print('userId validaterating : $userId');
    bool isValid = true;
    bool hasValidationFailed = false;
    int myInt = rating_star.toInt();
    print('changedintoint$myInt');
    if (isValid && rating_star <= 0.0) {
      FocusScope.of(context).unfocus();
      CommonUtils.showCustomToastMessageLong(
          'Please Rate Your Experience', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }

    if (isValid && _commentstexteditcontroller.text.trim().isEmpty) {
      FocusScope.of(context).unfocus();
      CommonUtils.showCustomToastMessageLong(
          'Please Enter Comment', context, 1, 4);
      isValid = false;
      hasValidationFailed = true;
    }
    if (isValid) {
      final url = Uri.parse(baseUrl + postApiAppointment);
      print('url==>890: $url');
      DateTime now = DateTime.now();
      String dateTimeString = now.toString();
      print('DateTime as String: $dateTimeString');

      //  for (MyAppointment_Model appointment in appointmens) {
      // Create the request object for each appointment
      final request = {
        "Id": appointmens.id,
        "BranchId": appointmens.branchId,
        "Date": appointmens.date,
        "SlotTime": appointmens.slotTime,
        "CustomerName": appointmens.customerName,
        "PhoneNumber":
            appointmens.contactNumber, // Changed from appointments.phoneNumber
        "Email": appointmens.email,
        "GenderTypeId": appointmens.genderTypeId,
        "StatusTypeId": 18,
        "PurposeOfVisitId": appointmens.purposeOfVisitId,
        "PurposeOfVisit": appointmens.purposeOfVisit,
        "IsActive": true,
        "CreatedDate": dateTimeString,
        "UpdatedDate": dateTimeString,
        "UpdatedByUserId": null,
        "rating": rating_star,
        "review": _commentstexteditcontroller.text.toString(),
        "reviewSubmittedDate": dateTimeString,
        "timeofslot": appointmens.timeofSlot,
        "customerId": userId
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
          print('Request sent successfully');
          //  fetchMyAppointments(userId);
          CommonUtils.showCustomToastMessageLong(
              'Feedback Successfully Submitted', context, 0, 4);
          // refreshTheScreen();
          // if (index >= 0.0 && index < userfeedbacklist.length) {
          //   // Ensure index is within the valid range
          //   userfeedbacklist.ratingstar = rating_star;
          //   userfeedbacklist.comments = _commentstexteditcontroller.text.toString();
          //
          //   print('rating_starapi${userfeedbacklist[].ratingstar}  comments${userfeedbacklist[].comments}');
          //
          //   Navigator.pop(context);
          // } else {
          //   print('Invalid index: $index');
          // }
          // _printAppointments();
          // userfeedbacklist[index].ratingstar = rating_star;
          // userfeedbacklist[index].comments = _commentstexteditcontroller.text.toString();

          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const GetAppointments(),
            ),
          );
        } else {
          print(
              'Failed to send the request. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error while sending : $e');
      }
      //  }
    }
  }

  void conformation(BuildContext context, MyAppointment_Model appointments) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmation',
            style: TextStyle(
              fontSize: 16,
              color: CommonUtils.blueColor,
              fontFamily: 'Calibri',
            ),
          ),
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
                  'Are You Sure You Want To Cancel Your  ${appointments.slotDuration} Slot At The${appointments.branch} Hair Fixing Zone ?',
                  style: CommonUtils.txSty_18b_fb,
                  textAlign:
                      TextAlign.center, // Optionally, align the text center
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
        );
      },
    );
  }

  Future<void> cancelAppointment(MyAppointment_Model appointmens) async {
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
      "PhoneNumber":
          appointmens.contactNumber, // Changed from appointments.phoneNumber
      "Email": appointmens.email,
      "GenderTypeId": appointmens.genderTypeId,
      "StatusTypeId": 6,
      "PurposeOfVisitId": appointmens.purposeOfVisitId,
      "PurposeOfVisit": appointmens.purposeOfVisit,
      "IsActive": true,
      "CreatedDate": dateTimeString,
      "UpdatedDate": dateTimeString,
      "UpdatedByUserId": null,
      "rating": null,
      "review": null,
      "reviewSubmittedDate": null,
      "timeofslot": appointmens.timeofSlot,
      "customerId": userId
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
          //   CommonUtils.showCustomToastMessageLong('Cancelled  Successfully ', context, 0, 4);
          //   Navigator.pop(context);
          // Success case
          // Handle success scenario here
        } else {
          // Failure case
          // Handle failure scenario here
          CommonUtils.showCustomToastMessageLong(
              'The Request Should Not Be Canceled Within 1 hour Before The Slot',
              context,
              0,
              2);
        }
      } else {
        //showCustomToastMessageLong(
        // 'Failed to send the request', context, 1, 2);
        print(
            'Failed to send the request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while sending : $e');
    }
    //  }
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
                  textAlign:
                      TextAlign.center, // Optionally, align the text center
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                buttonText: 'Done',
                color: CommonUtils.primaryTextColor,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GetAppointments(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  int calculateTimeDifference(String selectedDate, String time) {
    final now = DateTime.now();
    String formattedTime = DateFormat('yyyy-MM-dd hh:mm a').format(now);

    // Extract the date part (first 10 characters) from selectedDate
    String datePart = selectedDate.substring(0, 10);

    // Concatenate datePart and time
    String selectedDateTimeString = '$datePart $time';

    // Parse the concatenated string into a DateTime object
    DateTime selectedDateTime =
        DateFormat('yyyy-MM-dd hh:mm a').parse(selectedDateTimeString);
    DateTime currentDateTime =
        DateFormat('yyyy-MM-dd hh:mm a').parse(formattedTime);

    print(
        'Time difference in selectedDateTime: ${selectedDateTime.toString()}');
    print('Time difference in currentDateTime: ${currentDateTime.toString()}');

    Duration difference = selectedDateTime.difference(currentDateTime);
    int differenceInMinutes = difference.inMinutes;

    print('Time difference in minutes: $differenceInMinutes');

    return differenceInMinutes
        .abs(); // Return the absolute value of the difference
  }

// int calculateTimeDifference(String selectedDate, String time) {
  //   final now = DateTime.now();
  //   String formattedTime = DateFormat('hh:mm a').format(now);
  //
  //   final selectedDateTime = DateTime.parse(selectedDate);
  //   final currentDate = DateTime(now.year, now.month, now.day);
  //
  //   int differenceInMinutes = 0; // Initializing the time difference variable
  //
  //   DateTime desiredTime = DateFormat('hh:mm a').parse(time);
  //   DateTime currentTime = DateFormat('hh:mm a').parse(formattedTime);
  //   Duration difference = desiredTime.difference(currentTime);
  //   differenceInMinutes = difference.inMinutes;
  //   print('Time difference in minutes: $differenceInMinutes');
  //   // if (selectedDateTime == currentDate) {
  //   //   Duration difference = desiredTime.difference(currentTime);
  //   //   differenceInMinutes = difference.inMinutes;
  //   //   print('Time difference in minutes: $differenceInMinutes');
  //   // }
  //
  //   return differenceInMinutes;
  // }
}
