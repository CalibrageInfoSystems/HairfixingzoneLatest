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
import 'package:hairfixingzone/viewconsulationlistscreen.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'AgentBranchesModel.dart';

class ViewConsultation extends StatefulWidget {
  final int agentId;
  const ViewConsultation({super.key, required this.agentId});

  @override
  State<ViewConsultation> createState() => _ViewConsultationState();
}

class _ViewConsultationState extends State<ViewConsultation> {
  TextEditingController fromToDates = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  late Future<List<BranchModel>> agentData;

  @override
  void initState() {
    super.initState();
    print('_____${widget.agentId}');
    agentData = getBranches(widget.agentId);
  }

  Future<List<BranchModel>> getBranches(int userId) async {
    String apiUrl = '$baseUrl$GetBranchByUserId$userId/null';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      print('apiUrl: $apiUrl');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> listresult = data['listResult'];
        List<BranchModel> result = listresult.map((e) => BranchModel.fromJson(e)).toList();
        return result;
      } else {
        print('Request failed with status: ${response.statusCode}');
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //    appBar: _appBar(context),
        body: Column(
          children: [
            //MARK: FromToDates
            // TextFormField(
            //   controller: fromToDates,
            //   keyboardType: TextInputType.visiblePassword,
            //   onTap: () {
            //     showCustomDateRangePicker(
            //       context,
            //       dismissible: true,
            //       endDate: endDate,
            //       startDate: startDate,
            //       maximumDate:
            //           DateTime.now().add(const Duration(days: 50)),
            //       minimumDate:
            //           DateTime.now().subtract(const Duration(days: 50)),
            //       onApplyClick: (s, e) {
            //         setState(() {
            //           //MARK: Date
            //           endDate = e;
            //           startDate = s;
            //           fromToDates.text =
            //               '${startDate != null ? DateFormat("dd, MMM").format(startDate!) : '-'} / ${endDate != null ? DateFormat("dd, MMM").format(endDate!) : '-'}';
            //         });
            //       },
            //       onCancelClick: () {
            //         setState(() {
            //           endDate = null;
            //           startDate = null;
            //         });
            //       },
            //     );
            //   },
            //   readOnly: true,
            //   decoration: InputDecoration(
            //     contentPadding: const EdgeInsets.only(
            //         top: 15, bottom: 10, left: 15, right: 15),
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
            //     hintText: 'Select Between Dates',
            //     counterText: "",
            //     hintStyle: const TextStyle(
            //         color: Colors.grey, fontWeight: FontWeight.w400),
            //     prefixIcon: const Icon(Icons.calendar_today),
            //   ),
            //   //  validator: validatePassword,
            // ),

            const SizedBox(
              height: 10.0,
            ),
            FutureBuilder(
              future: agentData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  List<BranchModel> data = snapshot.data!;
                  if (data.isEmpty) {
                    return const Center(
                      child: Text('No Branches are Found!'),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          BranchModel agent = data[index];
                          String? imageUrl = agent.imageName;
                          if (imageUrl == null || imageUrl.isEmpty) {
                            imageUrl = 'assets/top_image.png';
                          }
                          return ViewConsulatationBranchTemplate(
                            startDate: startDate,
                            endDate: endDate,
                            agent: agent,
                            imageUrl: imageUrl,
                            agentId: widget.agentId,
                          );
                        },
                      ),
                    );

                    // ListView.builder(
                    //   itemCount: data.length,
                    //   itemBuilder: (context, index) {
                    //     BranchModel agent = data[index];
                    //     String? imageUrl = agent.imageName;
                    //     if (imageUrl == null || imageUrl.isEmpty) {
                    //       imageUrl = 'assets/top_image.png';
                    //     }
                    //     return ViewConsulatationBranchTemplate(
                    //       startDate: startDate,
                    //       endDate: endDate,
                    //       agent: agent,
                    //       imageUrl: imageUrl,
                    //       agentId: widget.agentId,
                    //     );
                    //   },
                    // );
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

class ViewConsulatationBranchTemplate extends StatelessWidget {
  final BranchModel agent;
  final String imageUrl;
  final int agentId;
  final DateTime? startDate;
  final DateTime? endDate;

  const ViewConsulatationBranchTemplate(
      {super.key, required this.agent, required this.imageUrl, required this.agentId, this.startDate, this.endDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => viewconsulationlistscreen(
                        branchid: agent.id!,
                        fromdate: '$startDate',
                        todate: '$endDate',
                        agent: agent,
                        userid: agentId,
                      )),
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width,
            // decoration: BoxDecoration(
            //   border: Border.all(color: Color(0xFF662e91), width: 1.0),
            //   borderRadius: BorderRadius.circular(10.0),
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
                  padding: EdgeInsets.all(10),
                  // width: MediaQuery.of(context).size.width / 4,
                  child: Image.network(
                    imageUrl.isNotEmpty ? imageUrl : 'https://example.com/placeholder-image.jpg',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height / 4 / 2,
                    width: MediaQuery.of(context).size.width / 3.2,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/hairfixing_logo.png', // Path to your PNG placeholder image
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height / 4 / 2,
                        width: MediaQuery.of(context).size.width / 3.2,
                      );
                    },
                  ),
                ),
                Container(
                  // height: MediaQuery.of(context).size.height / 4 / 2,

                  width: MediaQuery.of(context).size.width / 2.2,
                  padding: EdgeInsets.only(top: 7),
                  // width: MediaQuery.of(context).size.width / 4,
                  child: Column(
                    //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        agent.name,
                        style: TextStyle(
                          color: Color(0xFF0f75bc),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(agent.address, maxLines: 2, overflow: TextOverflow.ellipsis, style: CommonStyles.txSty_12b_f5),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
