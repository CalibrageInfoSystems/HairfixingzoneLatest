import 'dart:convert';

import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hairfixingzone/BranchModel.dart';
import 'package:hairfixingzone/Common/common_styles.dart';
import 'package:hairfixingzone/CommonUtils.dart';
import 'package:hairfixingzone/MyAppointment_Model.dart';

import 'package:hairfixingzone/api_config.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'AgentBranchesModel.dart';
import 'Consultation.dart';

class viewconsulationlistscreen extends StatefulWidget {
  final int branchid;
  final String fromdate;
  final String todate;
  final BranchModel agent;
  final int userid;
  const viewconsulationlistscreen(
      {super.key,
        required this.branchid,
        required this.fromdate,
        required this.todate,
        required this.agent,
        required this.userid});

  @override
  State<viewconsulationlistscreen> createState() => _ViewConsultationState();
}

class _ViewConsultationState extends State<viewconsulationlistscreen> {
  List<Consultation> consultationslist = [];

  TextEditingController fromToDates = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  String? month;
  String? date;
  String? year;
  late Future<List<Consultation>> ConsultationData;
  @override
  void initState() {
    super.initState();
    startDate = DateTime.now().subtract(const Duration(days: 14));
    endDate = DateTime.now();
    fromToDates.text =
    '${startDate != null ? DateFormat("dd, MMM").format(startDate!) : '-'} / ${endDate != null ? DateFormat("dd, MMM").format(endDate!) : '-'}';

    print(
        'branchid ${widget.branchid} fromdate${widget.fromdate} todate ${widget.todate}');
    ConsultationData = getviewconsulationlist(
        DateFormat('yyyy-MM-dd').format(startDate!),
        DateFormat('yyyy-MM-dd').format(endDate!));
  }

// http://182.18.157.215/SaloonApp/API/api/Consultation/GetConsultationsByBranchId
  Future<List<Consultation>> getviewconsulationlist(
      String fromdate, String todate) async {
    const String apiUrl =
        'http://182.18.157.215/SaloonApp/API/api/Consultation/GetConsultationsByBranchId';
    print('getconsulationapi:$apiUrl');
    final Map<String, dynamic> requestObject = {
      "userId": widget.userid, // userId
      "branchId": widget.agent.id, //widget.branchid,
      "fromDate": fromdate, //widget.fromdate,
      "toDate": todate,
      "isActive": true, //widget.todate
    };

    // {
    //   "branchId": widget.branchid,
    //   "fromDate": widget.fromdate,
    //   "toDate": widget.todate
    // };

    print('requestObject==${jsonEncode(requestObject)}');

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestObject),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["isSuccess"]) {
          List<dynamic> jsonList = responseData["listResult"];
          final dynamic listResult = responseData["listResult"];
          if (listResult != null && listResult is List<dynamic>) {
            List<Consultation> consultations =
            jsonList.map((e) => Consultation.fromJson(e)).toList();
            // for (var consultation in consultations) {
            //   DateTime createdDateTime = DateTime.parse(consultation.createdDate);
            //   month = DateFormat('MMM').format(createdDateTime);
            //   date = DateFormat('dd').format(createdDateTime);
            //   year = DateFormat('yyyy').format(createdDateTime);
            //
            //   print('month: $month, Date: $date, Year: $year');
            // }
            setState(() {
              consultationslist = consultations;
            });
            return consultations;
            print(consultations);
          } else {
            print("ListResult is null or not a List<dynamic>");
          }
        } else {
          print("ListResult is null");
        }
      } else {}
    } catch (e) {
      print("Exception: $e");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(context),
        body: Column(
          children: [
            // branch and dates
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 12,
                          //height: 60,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: CommonStyles.primaryTextColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  '${widget.agent.imageName}',
                                  fit: BoxFit.cover,
                                  width: 100.0,
                                  height:
                                  MediaQuery.of(context).size.height / 13,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/hairfixing_logo.png',
                                      fit: BoxFit.cover,
                                      width: 60.0,
                                      height:
                                      MediaQuery.of(context).size.height /
                                          13,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   widget.agent.name,
                                  //   style: CommonStyles.txSty_16p_f5,
                                  // ),
                                  SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width / 2.2,
                                    //    padding: EdgeInsets.only(top: 7),
                                    // width: MediaQuery.of(context).size.width / 4,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.agent.name,
                                          style: const TextStyle(
                                            color: Color(0xFF0f75bc),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          widget.agent.address,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      // Container(
                      //   height: MediaQuery.of(context).size.height / 12,
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 5, horizontal: 10),
                      //   decoration: BoxDecoration(
                      //     border:
                      //         Border.all(color: CommonStyles.primaryTextColor),
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Container(
                      //     padding: const EdgeInsets.all(15),
                      //     decoration: const BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: CommonStyles.primaryTextColor),
                      //     child: Center(
                      //       child: SvgPicture.asset(
                      //         'assets/noun-appointment-date-2417776.svg',
                      //         width: 30.0,
                      //         height: 30.0,
                      //         color: CommonStyles.whiteColor,
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //MARK: FromToDates
                  TextFormField(
                    controller: fromToDates,
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
                            fromToDates.text =
                            '${startDate != null ? DateFormat("dd, MMM").format(startDate!) : '-'} / ${endDate != null ? DateFormat("dd, MMM").format(endDate!) : '-'}';
                            ConsultationData = getviewconsulationlist(
                                DateFormat('yyyy-MM-dd').format(startDate!),
                                DateFormat('yyyy-MM-dd').format(endDate!));
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
                      hintText: 'Select Between Dates',
                      counterText: "",
                      hintStyle: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w400),
                      prefixIcon: const Icon(Icons.calendar_today),
                    ),
                    //  validator: validatePassword,
                  ),
                ],
              ),
            ),

            FutureBuilder(
              future: ConsultationData,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  List<Consultation> data = snapshot.data!;
                  if (data.isEmpty) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.height,
                        child: const Center(
                          child: Text('No  Consultation Found'),
                        ));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        // shrinkWrap: true,
                          itemCount: consultationslist.isEmpty
                              ? 1
                              : consultationslist.length,
                          itemBuilder: (context, index) {
                            DateTime createdDateTime = DateTime.parse(
                              consultationslist[index].createdDate,
                            );
                            month = DateFormat('MMM').format(createdDateTime);
                            date = DateFormat('dd').format(createdDateTime);
                            year = DateFormat('yyyy').format(createdDateTime);
                            print('month: $month, Date: $date, Year: $year');
                            // if (consultationslist.length > 0) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 5,
                                child: IntrinsicHeight(
                                    child: Container(
                                      //   height: MediaQuery.of(context).size.height / 5,
                                      padding: const EdgeInsets.all(10),
                                      // decoration: BoxDecoration(
                                      //   borderRadius: BorderRadius.circular(10.0),
                                      //   color: Colors.white,
                                      //
                                      // ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10.0),
                                        // borderRadius: BorderRadius.circular(30), //border corner radius
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF960efd)
                                                .withOpacity(0.2), //color of shadow
                                            spreadRadius: 2, //spread radius
                                            blurRadius: 4, // blur radius
                                            offset: const Offset(
                                                0, 2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            //  height: MediaQuery.of(context).size.height,
                                            //  width: MediaQuery.of(context).size.height / 16,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '$month',
                                                  style: CommonUtils.txSty_18p_f7,
                                                ),
                                                Text(
                                                  '$date',
                                                  style: const TextStyle(
                                                    fontSize: 22,
                                                    fontFamily: "Calibri",
                                                    // letterSpacing: 1.5,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF0f75bc),
                                                  ),
                                                ),
                                                Text(
                                                  '$year',
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
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                consultationslist[
                                                                index]
                                                                    .consultationName,
                                                                style:
                                                                const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                  "Calibri",
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                                  color: Color(
                                                                      0xFF0f75bc),
                                                                ),
                                                              ),
                                                              Text(
                                                                consultationslist[
                                                                index]
                                                                    .email,
                                                                style:
                                                                const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                  "Calibri",
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                                  color: Color(
                                                                      0xFF5f5f5f),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                consultationslist[
                                                                index]
                                                                    .gender,
                                                                style:
                                                                const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                  "Calibri",
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                                  color: Color(
                                                                      0xFF5f5f5f),
                                                                ),
                                                              ),
                                                              Text(
                                                                consultationslist[
                                                                index]
                                                                    .phoneNumber,
                                                                style:
                                                                const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                  "Calibri",
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                                  color: Color(
                                                                      0xFF5f5f5f),
                                                                ),
                                                              ),
                                                              //Text('', style: CommonStyles.txSty_16black_f5),
                                                              // Text(consultationslist[index].gender, style: CommonStyles.txSty_16black_f5),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  consultationslist[index].remarks,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Calibri",
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF5f5f5f),
                                                  ),
                                                ),
                                                // based on status hide this row
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            );
                            //  }
                          }),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFf3e3ff),
        title: const Text(
          'View Consultation',
          style: TextStyle(color: Color(0xFF0f75bc), fontSize: 16.0),
        ),
        // actions: [
        //   IconButton(
        //     icon: SvgPicture.asset(
        //       'assets/sign-out-alt.svg', // Path to your SVG asset
        //       color: const Color(0xFF662e91),
        //       width: 24, // Adjust width as needed
        //       height: 24, // Adjust height as needed
        //     ),
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //   ),
        // ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: CommonUtils.primaryTextColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ));
  }
}
