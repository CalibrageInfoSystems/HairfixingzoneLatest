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

  const viewconsulationlistscreen({super.key, required this.branchid, required this.fromdate, required this.todate});

  @override
  State<viewconsulationlistscreen> createState() => _ViewConsultationState();
}

class _ViewConsultationState extends State<viewconsulationlistscreen> {
  List<Consultation> consultationslist = [];
  String? month;
  String? date;
  String? year;
  late Future<List<Consultation>> ConsultationData;
  @override
  void initState() {
    super.initState();
    print('branchid ${widget.branchid} fromdate${widget.fromdate} todate ${widget.todate}');
    ConsultationData = getviewconsulationlist();
  }

  Future<List<Consultation>> getviewconsulationlist() async {
    final String apiUrl = 'http://182.18.157.215/SaloonApp/API/api/Consultation/GetConsultationsByBranchId';
    print('getconsulationapi:$apiUrl');
    final Map<String, dynamic> requestObject = {"branchId": widget.branchid, "fromDate": "${widget.fromdate}", "toDate": "${widget.todate}"};

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
            List<Consultation> consultations = jsonList.map((e) => Consultation.fromJson(e)).toList();
            consultations.forEach((consultation) {
              DateTime createdDateTime = DateTime.parse(consultation.createdDate);
              month = DateFormat('MMM').format(createdDateTime);
              date = DateFormat('dd').format(createdDateTime);
              year = DateFormat('yyyy').format(createdDateTime);

              print('month: $month, Date: $date, Year: $year');
            });
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
            body: SingleChildScrollView(
                child: Container(
              padding: const EdgeInsets.all(10),
              child: FutureBuilder(
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
                      return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Text('No  Consultation Found'),
                          ));
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: consultationslist.length == 0 ? 1 : consultationslist.length,
                          itemBuilder: (context, index) {
                            // if (consultationslist.length > 0) {
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                      color: Color(0xFF960efd).withOpacity(0.2), //color of shadow
                                      spreadRadius: 2, //spread radius
                                      blurRadius: 4, // blur radius
                                      offset: Offset(0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      //  height: MediaQuery.of(context).size.height,
                                      //  width: MediaQuery.of(context).size.height / 16,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${month}',
                                            style: CommonUtils.txSty_18p_f7,
                                          ),
                                          Text(
                                            '${date}',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontFamily: "Calibri",
                                              // letterSpacing: 1.5,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF0f75bc),
                                            ),
                                          ),
                                          Text(
                                            '${year}',
                                            style: TextStyle(
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
                                                          consultationslist[index].consultationName,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: "Calibri",
                                                            fontWeight: FontWeight.w700,
                                                            color: Color(0xFF0f75bc),
                                                          ),
                                                        ),
                                                        Text(
                                                          consultationslist[index].email,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: "Calibri",
                                                            fontWeight: FontWeight.w500,
                                                            color: Color(0xFF5f5f5f),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          consultationslist[index].gender,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: "Calibri",
                                                            fontWeight: FontWeight.w500,
                                                            color: Color(0xFF5f5f5f),
                                                          ),
                                                        ),
                                                        Text(
                                                          consultationslist[index].phoneNumber,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: "Calibri",
                                                            fontWeight: FontWeight.w500,
                                                            color: Color(0xFF5f5f5f),
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
                                            '${consultationslist[index].remarks}',
                                            style: TextStyle(
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
                            );
                            //  }
                          });
                    }
                  }
                },
              ),
            ))));
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFf3e3ff),
        title: const Text(
          'View Consultation',
          style: TextStyle(color: Color(0xFF0f75bc), fontSize: 16.0),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/sign-out-alt.svg', // Path to your SVG asset
              color: const Color(0xFF662e91),
              width: 24, // Adjust width as needed
              height: 24, // Adjust height as needed
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
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
