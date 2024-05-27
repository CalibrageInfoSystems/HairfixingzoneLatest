import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hairfixingzone/BranchModel.dart';
import 'package:hairfixingzone/BranchesModel.dart';
import 'package:hairfixingzone/Common/common_styles.dart';
import 'package:hairfixingzone/Consultation.dart';
import 'package:hairfixingzone/Dashboard_Screen.dart';
import 'package:hairfixingzone/View_Consultation_screen.dart';

import 'package:marquee/marquee.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'AddConsulationscreen.dart';
import 'Add_Consultation_Screen.dart';
import 'Branches_screen.dart';
import 'api_config.dart';

class AgentDashBoard extends StatefulWidget {
  final int agentid;
  const AgentDashBoard({super.key, required this.agentid});

  @override
  State<AgentDashBoard> createState() => _AgentDashBoardState();
}

class _AgentDashBoardState extends State<AgentDashBoard> {
  List<Item> _items = [];
  late Timer _timer;
  String marqueeText = '';
  final int _currentPage = 0;
  late Future<List<BranchModel>> apiData;
  String userFullName = '';
  String email = '';
  String phonenumber = '';
  int? AgentId;
//  String gender ='';
  String Gender = '';
  final bool _shouldStartMarquee =
      true; // Variable to control Marquee scrolling

  @override
  void initState() {
    super.initState();

    checkLoginAgentdata();
    _fetchItems();
    apiData = getBranches(widget.agentid);
    // apiData = getAgentBranches(widget.agentId);
  }

  void checkLoginAgentdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userFullName = prefs.getString('userFullName') ?? '';
      email = prefs.getString('email') ?? '';
      phonenumber = prefs.getString('contactNumber') ?? '';
      Gender = prefs.getString('gender') ?? '';
      AgentId = prefs.getInt('userId');
      // _fullnameController1.text = userFullName;
      // _emailController3.text = email;
      // _phonenumberController2.text = phonenumber;
      // gender = selectedGender;
      print('AgentId:$AgentId');
      print('userFullName:$userFullName');
      print('gender:$Gender');
      // if (gender == 1) {
      //   Gender = 'Female';
      // } else if (gender == 2) {
      //   Gender = 'Male';
      // } else if (gender == 3) {
      //   Gender = 'Other';
      // }
    });
  }

  void _fetchItems() async {
    final response = await http.get(Uri.parse(baseUrl + getbanner));

    if (response.statusCode == 200) {
      setState(() {
        _items = (json.decode(response.body)['listResult'] as List)
            .map((item) => Item.fromJson(item))
            .toList();
      });
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<List<Consultation>?> getAgentBranches(int agentId) async {
    final apiUrl = Uri.parse(
        baseUrl + getconsulationbranchesbyagentid + agentId.toString());
    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['listResult'] != null) {
          final List<dynamic> appointmentsData = responseData['listResult'];
          return appointmentsData
              .map((appointment) => Consultation.fromJson(appointment))
              .toList();
        } else {
          print('No data found');
          return null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //  backgroundColor: CommonStyles.primaryTextColor,
        // appBar: _appBar(),
        body: IntrinsicHeight(
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
                child: FutureBuilder(
                  future: getMarqueeText(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    } else if (snapshot.hasError) {
                      return const SizedBox();
                    } else {
                      return Marquee(
                        text: marqueeText,
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Calibri",
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFff0176)),
                        velocity: _shouldStartMarquee
                            ? 30
                            : 0, // Control Marquee scrolling with velocity
                      );
                    }
                  },
                ),
              ),

              // Carousel widget
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: FlutterCarousel(
                  options: CarouselOptions(
                    // height: 400.0,
                    showIndicator: true,
                    autoPlay: true,
                    floatingIndicator: false,
                    autoPlayCurve: Curves.linear,
                    // enlargeCenterPage: true,
                    slideIndicator: const CircularSlideIndicator(
                      indicatorBorderColor: CommonStyles.blackColor,
                      currentIndicatorColor: CommonStyles.primaryTextColor,
                    ),
                  ),
                  items: _items.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          // margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          // decoration: const BoxDecoration(color: Colors.grey),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item.imageName,
                                height: 100,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;

                                  return const Center(
                                      child:
                                          CircularProgressIndicator.adaptive());
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                screens(),
                const SizedBox(height: 15),
                //MARK: Branches
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Branches',
                      style: CommonStyles.txSty_16p_fb,
                    ),
                  ],
                ),
                agentBranches(),
              ],
            ),
          ),
          //MARK: Welcome Text
          //     welcomeText(),
          //MARK: Main Card
          // Expanded(
          //   child: Container(
          //     height: MediaQuery.of(context).size.height,
          //     decoration: const BoxDecoration(
          //       color: CommonStyles.whiteColor,
          //       borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(20),
          //         topRight: Radius.circular(20),
          //       ),
          //     ),
          //     child: Column(
          //       children: [
          //         marquee(),
          //         Column(
          //           children: [
          //             carousel(),
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: <Widget>[
          //                 for (int i = 0; i < _items.length; i++)
          //                   Container(
          //                     margin: const EdgeInsets.all(2),
          //                     width: 10,
          //                     height: 10,
          //                     decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(10),
          //                       border: Border.all(color: CommonStyles.primaryTextColor, width: 1.5),
          //                       color: _currentPage == i ? Colors.grey.withOpacity(0.9) : Colors.transparent,
          //                     ),
          //                   )
          //               ],
          //             ),
          //             const SizedBox(
          //               height: 15,
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 20),
          //               child: Column(
          //                 children: [
          //                   screens(),
          //                   const SizedBox(height: 10),
          //                   agentBranches(),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    ));
  }

  getMarqueeText() async {
    final apiUrl = Uri.parse(baseUrl + getcontent);

    try {
      final jsonResponse = await http.get(apiUrl);

      if (jsonResponse.statusCode == 200) {
        final response = json.decode(jsonResponse.body);

        if (response['isSuccess']) {
          int records = response['affectedRecords'];
          for (var i = 0; i < records; i++) {
            marqueeText += '${response['listResult'][i]['text']}  -  ';
          }
        } else {
          print('api failed');
          throw Exception('api failed');
        }
      } else {
        throw Exception(
            'Request failed with status: ${jsonResponse.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFf3e3ff),
      title: const Text(
        'Agent DashBoard',
        style: TextStyle(
            color: Color(0xFF0f75bc),
            fontSize: 16.0,
            fontWeight: FontWeight.w600),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: CommonStyles.primaryTextColor,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  // Widget welcomeText() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
  //     height: 80,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         const Text(
  //           'Hello!',
  //           style: CommonStyles.txSty_16w_fb,
  //         ),
  //         Text(
  //           userFullName,
  //           style: CommonStyles.txSty_18w_fb,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget marquee() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 30,
        child: FutureBuilder(
          future: getMarqueeText(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            } else if (snapshot.hasError) {
              return const SizedBox();
            } else {
              return Marquee(
                text: marqueeText,
                style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "Calibri",
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFff0176)),
              );
            }
          },
        ),
      ),
    );
  }

  Widget agentBranches() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      child: FutureBuilder(
        future: apiData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            List<BranchModel>? data = snapshot.data!;
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height / 3.5,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return BranchCard(
                    branch: data[index],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  // Future<List<BranchList>> getBranchsData() async {
  // //  var apiUrl = 'http://182.18.157.215/SaloonApp/API/GetBranchById/null/true';
  //   var apiUrl = baseUrl + GetBranchByUserId + '$AgentId';
  //   try {
  //     final jsonResponse = await http.get(
  //       Uri.parse(apiUrl),
  //     );
  //
  //     if (jsonResponse.statusCode == 200) {
  //       Map<String, dynamic> response = jsonDecode(jsonResponse.body);
  //       List<dynamic> branchesData = response['listResult'];
  //       List<BranchList> result = branchesData.map((e) => BranchList.fromJson(e)).toList();
  //       print('result: ${result[0].name}');
  //       print('result: ${result[0].address}');
  //       print('result: ${result[0].imageName}');
  //       return result;
  //     } else {
  //       throw Exception('api failed');
  //     }
  //   } catch (e) {
  //     print('errorin$e');
  //     rethrow;
  //   }
  // }
  Future<List<BranchModel>> getBranches(int userId) async {
    String apiUrl = '$baseUrl$GetBranchByUserId$userId/null';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      print('apiUrl: $apiUrl');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic>? listResult = data['listResult']; // Add a check for null
        if (listResult != null) {
          List<BranchModel> result =
              listResult.map((e) => BranchModel.fromJson(e)).toList();
          return result;
        } else {
          print('listResult is null');
          throw Exception('listResult is null');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      // throw Exception('Error: $error');
      rethrow;
    }
  }

  // Future<List<BranchList>> getBranches(int userId) async {
  //   String apiUrl = '$baseUrl$GetBranchByUserId$userId';
  //
  //   try {
  //     final response = await http.get(Uri.parse(apiUrl));
  //     print('apiUrl: $apiUrl');
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       List<dynamic> listresult = data['listResult'];
  //       print('response$listresult');
  //       List<BranchList> result = listresult.map((e) => BranchList.fromJson(e)).toList();
  //       return result;
  //     } else {
  //       print('Request failed with status: ${response.statusCode}');
  //       throw Exception('Request failed with status: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //     throw Exception('Error: $error');
  //   }
  // }

  Widget screens() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Branches_screen(userId: AgentId!)),
            );
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width / 7,
                //   height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFe656ae),
                  // color: Color(0xFF295f5a),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/calendar-lines.svg',
                  color: CommonStyles.whiteColor,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Check',
                style: CommonStyles.txSty_14p_f5,
                textAlign: TextAlign.center,
              ),
              const Text(
                'Appointments',
                style: CommonStyles.txSty_14p_f5,
              ),
            ],
          ),
        ),
        GestureDetector(
          // onTap: () {
          //   print('_______test_______');
          //   Navigator.of(context, rootNavigator: true)
          //       .pushNamed("/ViewConsultation");
          // },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Add_Consulation_screen(
                        agentId: AgentId!,
                      )),
            );
            // Navigator.of(context, rootNavigator: true)
            //     .pushNamed("/Products");
          },
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 7,
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color(0xFFe44561),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/calendar-day.svg',
                  color: CommonStyles.whiteColor,
                ),
              ),
              const SizedBox(height: 5),
              // const Text(
              //   'Add Consultation',
              //   style: CommonStyles.txSty_14p_f5,
              // ),
              const Text(
                'Add',
                style: CommonStyles.txSty_14p_f5,
                textAlign: TextAlign.center,
              ),
              const Text(
                'Consultation',
                style: CommonStyles.txSty_14p_f5,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => View_Consultation_screen(
                        agentId: AgentId!,
                      )),
            );
            // Navigator.of(context, rootNavigator: true)
            //     .pushNamed("/Products");
          },
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 7,
                //height: 60,
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color(0xFF662d91),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/overview.svg',
                  color: CommonStyles.whiteColor,
                ),
              ),
              const SizedBox(height: 5),
              // const Text(
              //   'View Consultation',
              //   style: CommonStyles.txSty_14p_f5,
              // ),
              const Text(
                'View',
                style: CommonStyles.txSty_14p_f5,
                textAlign: TextAlign.center,
              ),
              const Text(
                'Consultation',
                style: CommonStyles.txSty_14p_f5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BranchCard extends StatelessWidget {
  final BranchModel branch;

  const BranchCard({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        // width: 170,
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: Colors.grey,
          color: CommonStyles.branchBg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 8.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  branch.imageName!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Expanded(
            //   child: ClipRRect(
            //     borderRadius: const BorderRadius.only(
            //       topLeft: Radius.circular(10),
            //       topRight: Radius.circular(10),
            //     ),
            //     child: Image.network(
            //       branch.imageName,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            // Expanded(
            //   child: Container(
            //     padding: const EdgeInsets.all(5),
            //     decoration: const BoxDecoration(
            //       borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(10),
            //         topRight: Radius.circular(10),
            //       ),
            //       color: Colors.greenAccent,
            //     ),
            //     child: Image.network(
            //       // 'https://via.placeholder.com/600/92c952',
            //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH7vDN07mCqaSv-VvdFX3VYd2Ic9uFyha4kA&s',
            //       fit: BoxFit.fill,
            //     ),
            //   ),
            // ),
            // Expanded(
            //   child: Container(
            //     padding: const EdgeInsets.all(10),
            //     decoration: const BoxDecoration(
            //       borderRadius: BorderRadius.only(
            //         bottomLeft: Radius.circular(10),
            //         bottomRight: Radius.circular(10),
            //       ),
            //       color: CommonStyles.branchBg,
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.stretch,
            //       children: [
            //         Text(
            //           branch.name,
            //           style: CommonStyles.txSty_16p_fb,
            //         ),
            //         Text(branch.address, style: CommonStyles.txSty_12b_f5),
            //       ],
            //     ),
            //   ),
            // ),
            Container(
              // height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: CommonStyles.branchBg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    branch.name,
                    style: CommonStyles.txSty_16p_fb,
                  ),
                  Text(branch.address,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: CommonStyles.txSty_12b_f5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
