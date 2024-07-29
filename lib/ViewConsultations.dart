import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CommonUtils.dart';
import 'Consultation.dart';
import 'api_config.dart';

class ViewConsultations extends StatefulWidget {
  final int branchid;

  const ViewConsultations({super.key, required this.branchid});
  @override
  ViewConsultations_screenState createState() =>
      ViewConsultations_screenState();
}

class ViewConsultations_screenState extends State<ViewConsultations> {
  bool isLoading = true;
  List<Consultation> Consultations_List = [];
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        print('The Internet Is Connected');
        fetchConsultations(widget.branchid);
      } else {
        print('The Internet Is not  Connected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textscale = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(
      onWillPop: () async {
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => home_screen()),
        // ); // Navigate to the previous screen
        return true; // Prevent default back navigation behavior
      },
      child: Scaffold(
          backgroundColor: Colors.red,
          appBar: AppBar(
              elevation: 0,
              title: const Text(
                'View Consultations',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(builder: (context) => home_screen()),
                  // );
                  // Implement your logic to navigate back
                },
              )),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Consultations_List.isEmpty
                  ? const Center(
                      child: Text('No data found'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: Consultations_List.length,
                      itemBuilder: (context, index) {
                        Consultation branch = Consultations_List[index];
                        return GestureDetector(
                          onTap: () {
                            print('CardView clicked!');
                          },
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0),
                              // topRight: Radius.circular(42.5),
                              // bottomLeft: Radius.circular(42.5),
                            ),
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0),
                              )),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    bottom: 10, top: 5, left: 0, right: 0),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFFFFF),
                                      Color(0xFFFFFFFF),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  border: Border.all(
                                    color: Colors.grey,
                                    //  color: const Color(0xFF8d97e2), // Add your desired border color here
                                    width:
                                    1.0, // Set the border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Optional: Add border radius if needed
                                ),
                                // decoration: const BoxDecoration(
                                //     gradient: LinearGradient(
                                //       colors: [
                                //         Color(0xFFfee7e1),
                                //         Color(0xFFd7defa),
                                //       ],
                                //       begin: Alignment.centerLeft,
                                //       end: Alignment.centerRight,
                                //     ),
                                //     borderRadius: BorderRadius.only(
                                //       topRight: Radius.circular(15.0),
                                //       bottomLeft: Radius.circular(15.0),
                                //     )),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 3,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    branch
                                                                        .branchName,
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xFFF44614),
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            'OpenSans'),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Expanded(
                                                            flex: 7,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    'Name',
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFFF44614),
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            'OpenSans'),
                                                                  ),
                                                                  // Icon(
                                                                  //   Icons.lock_clock,
                                                                  //   size: 16,
                                                                  //   color: Color(0xFFF44614),
                                                                  // ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Expanded(
                                                            flex: 0,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    ' : ',
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFFF44614),
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            'OpenSans'),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 12,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    branch
                                                                        .consultationName,
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xFF042DE3),
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'OpenSans'),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Expanded(
                                                            flex: 6,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    'Phone',
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFFF44614),
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            'OpenSans'),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Expanded(
                                                            flex: 0,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    ': ',
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFFF44614),
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            'OpenSans'),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 10,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    branch
                                                                        .phoneNumber,
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xFF042DE3),
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'OpenSans'),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.25,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  const Expanded(
                                                    flex: 6,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 0),
                                                          child: Text(
                                                            'Gender',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFFF44614),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'OpenSans'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Expanded(
                                                    flex: 0,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 0),
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFFF44614),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'OpenSans'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 10,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 0, 0, 0),
                                                          child: Text(
                                                            branch.gender,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF042DE3),
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'OpenSans'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Expanded(
                                                    flex: 6,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 0),
                                                          child: Text(
                                                            'Email',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFFF44614),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'OpenSans'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Expanded(
                                                    flex: 0,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 0),
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFFF44614),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'OpenSans'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 10,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 0, 0, 0),
                                                          child: Text(
                                                            branch.email,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFF042DE3),
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'OpenSans'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        const Expanded(
                                          flex: 6,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left:
                                                    15.0), // Add left padding to the Feedback text
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Remarks',
                                                  style: TextStyle(
                                                    color: Color(0xFFF44614),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'OpenSans',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 0,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                ': ',
                                                style: TextStyle(
                                                  color: Color(0xFFF44614),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'OpenSans',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 22,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize
                                                .min, // Ensure the Column takes minimum vertical space
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 0),
                                                child: Text(
                                                  branch.remarks,
                                                  style: const TextStyle(
                                                    color: Color(0xFF042DE3),
                                                    fontSize: 12,
                                                    fontFamily: 'OpenSans',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),

                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       flex: 2,
                                    //       child: RichText(
                                    //         text: const TextSpan(
                                    //           children: <TextSpan>[
                                    //             TextSpan(
                                    //               text: 'Feedback : ',
                                    //               style: TextStyle(
                                    //                 color: Colors.black,
                                    //               ),
                                    //             ),
                                    //             TextSpan(
                                    //               text:
                                    //               'This is very very very very very very very very very very very very very very very very very very very very big text',
                                    //               style: TextStyle(
                                    //                 color: Colors.black,
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // Feedback row
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )

          // SingleChildScrollView for scrollable content

          ),
    );
  }

  Future<void> fetchConsultations(int userid) async {
    // final String url =
    //     'http://182.18.157.215/SaloonApp/API/api/Consultation/GetConsultationsByBranchId/$userid';
    final String url = '$baseUrl$getconsulationbyranchid/$userid';
    print('url: $url');
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['listResult'] != null) {
          final List<dynamic> appointmentsData = responseData['listResult'];
          setState(() {
            Consultations_List = appointmentsData
                .map((appointment) => Consultation.fromJson(appointment))
                .toList();
            isLoading = false; // Set isLoading to false when data is fetched
          });
        } else {
          setState(() {
            Consultations_List = []; // Empty the list when no data is found
            isLoading = false; // Set isLoading to false when data is fetched
          });
          print('No data found');
          // Display 'No data found' in your UI or handle it accordingly
        }
      } else {
        print(
            'Failed to fetch appointments. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to fetch appointments. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to connect to the API: $error');
      throw Exception('Failed to connect to the API: $error');
    }
  }
}
