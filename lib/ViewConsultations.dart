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

  ViewConsultations({required this.branchid});
  @override
  ViewConsultations_screenState createState() => ViewConsultations_screenState();
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
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Color(0xFFf15f22),
              title: Text(
                'View Consultations',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
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
          body: Stack(
            children: [
              // Background Image
              ListView.builder(
                shrinkWrap: true,
                itemCount: Consultations_List.length,
                itemBuilder: (context, index) {
                  Consultation branch = Consultations_List[index];

                  return GestureDetector(
                    onTap: () {
                      print('CardView clicked!');
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(42.5),
                        bottomLeft: Radius.circular(42.5),
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                        )),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10, top: 5, left: 5, right: 10),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFfee7e1),
                                  Color(0xFFd7defa),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                              )),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListTile(
                                  subtitle: Row(
                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   'Branch Name',
                                      //   style: TextStyle(color: Color(0xFFF44614), fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Calibri'),
                                      // ),
                                      Container(
                                        width: MediaQuery.of(context).size.width / 2.5,
                                        //   height: MediaQuery.of(context).size.height,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: Text(
                                                          '${branch.branchName}',
                                                          style: TextStyle(
                                                              color: Color(0xFFF44614),
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: 'Calibri'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                              child: Text(
                                                '${branch.consultationName}',
                                                style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                              child: Text(
                                                '${branch.phoneNumber}',
                                                style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width / 2.5,
                                        //   height: MediaQuery.of(context).size.height,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 5,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: Text(
                                                          '',
                                                          style: TextStyle(
                                                              color: Color(0xFFF44614),
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: 'Calibri'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                  child: Text(
                                                    '${branch.consultationName}',
                                                    style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                        child: Text(
                                                          '${branch.phoneNumber}',
                                                          style: TextStyle(color: Color(0xFF042DE3), fontSize: 12, fontFamily: 'Calibri'),
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

                                      //Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )

              // SingleChildScrollView for scrollable content
            ],
          ),
        ));
  }

  Future<void> fetchConsultations(int userid) async {
    final String ee = 'http://182.18.157.215/SaloonApp/API/api/Consultation/GetConsultationsByBranchId/$userid';
    //final url1 = Uri.parse(ee);
    final url = Uri.parse(ee);
    print('url==842===$url');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['listResult'] != null) {
          final List<dynamic> appointmentsData = responseData['listResult'];
          setState(() {
            Consultations_List = appointmentsData.map((appointment) => Consultation.fromJson(appointment)).toList();
            // isLoading = false;
          });
        } else {
          //  textFieldController.text = 'No Slots Available';
          print('No Slots Available');
        }
      } else {
        throw Exception('Failed to fetch appointments');
      }
    } catch (error) {
      throw Exception('Failed to connect to the API $error');
    }
  }
}
