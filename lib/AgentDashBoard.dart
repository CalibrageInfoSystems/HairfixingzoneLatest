import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class AgentDashBoard extends StatefulWidget {
  const AgentDashBoard({
    super.key,
  });

  @override
  State<AgentDashBoard> createState() => _AgentDashBoardState();
}

class _AgentDashBoardState extends State<AgentDashBoard> {
  List<Item> _items = [];
  late PageController _pageController;
  late Timer _timer;
  String marqueeText = '';
  int _currentPage = 0;
  Future<List<BranchList>>? apiData;
  String userFullName = '';
  String email = '';
  String phonenumber = '';
  int? AgentId;
//  String gender ='';
  String Gender = '';
  @override
  void initState() {
    super.initState();
    checkLoginAgentdata();
    _fetchItems();
    _startAutoScroll();
    apiData = getBranchsData();
    // apiData = getAgentBranches(widget.agentId);
    _pageController = PageController(initialPage: _currentPage);
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_currentPage < _items.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
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
    final response = await http.get(Uri.parse('http://182.18.157.215/SaloonApp/API/GetBanner?Id=null'));

    if (response.statusCode == 200) {
      setState(() {
        _items = (json.decode(response.body)['listResult'] as List).map((item) => Item.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<List<Consultation>?> getAgentBranches(int agentId) async {
    final apiUrl = Uri.parse('http://182.18.157.215/SaloonApp/API/api/Consultation/GetConsultationsByBranchId/$agentId');
    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['listResult'] != null) {
          final List<dynamic> appointmentsData = responseData['listResult'];
          return appointmentsData.map((appointment) => Consultation.fromJson(appointment)).toList();
        } else {
          print('No data found');
          return null;
        }
      } else {
        print('Failed to fetch appointments. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch appointments. Status code: ${response.statusCode}');
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
          //MARK: Welcome Text
          //     welcomeText(),
          //MARK: Main Card
          Container(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: CommonStyles.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  marquee(),
                  Column(
                    children: [
                      carousel(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < _items.length; i++)
                            Container(
                              margin: const EdgeInsets.all(2),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: CommonStyles.primaryTextColor, width: 1.5),
                                color: _currentPage == i ? Colors.grey.withOpacity(0.9) : Colors.transparent,
                              ),
                            )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            screens(),
                            const SizedBox(height: 10),
                            agentBranches(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  getMarqueeText() async {
    final apiUrl = Uri.parse('http://182.18.157.215/SaloonApp/API/GetContent/true');

    try {
      final jsonResponse = await http.get(apiUrl);

      if (jsonResponse.statusCode == 200) {
        final response = json.decode(jsonResponse.body);

        if (response['isSuccess']) {
          int records = response['affectedRecords'];
          for (var i = 0; i < records; i++) {
            marqueeText = '${marqueeText + response['listResult'][i]['text']}  ';
            // marqueeText += response['listResult'][i]['text'];
          }
        } else {
          print('api failed');
          throw Exception('api failed');
        }
      } else {
        throw Exception('Request failed with status: ${jsonResponse.statusCode}');
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
        style: TextStyle(color: Color(0xFF0f75bc), fontSize: 16.0, fontWeight: FontWeight.w600),
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
                style: const TextStyle(fontSize: 16, fontFamily: "Calibri", fontWeight: FontWeight.w600, color: Color(0xFFff0176)),
              );
            }
          },
        ),
      ),
    );
  }

  Widget carousel() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final itemIndex = index % _items.length;
          return SizedBox(
            child: Row(
              children: [
                Container(
                  child: ItemBuilder(items: _items, index: itemIndex),
                ),
              ],
            ),
          );
        },
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
      ),
    );
    // Container(
    //   color: Colors.grey,
    //   width: MediaQuery.of(context).size.width,
    //   height: 200,
    //   child: PageView.builder(
    //     controller: _pageController,
    //     itemCount: _items.length,
    //     itemBuilder: (context, index) {
    //       final itemIndex = index % _items.length;
    //       return SizedBox(
    //         child: Row(
    //           children: [
    //             Expanded(
    //               child: ItemBuilder(items: _items, index: itemIndex),
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //     onPageChanged: (int page) {
    //       setState(() {
    //         _currentPage = page;
    //       });
    //     },
    //   ),
    // );
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
            List<BranchList>? data = snapshot.data!;
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

  Future<List<BranchList>> getBranchsData() async {
    var apiUrl = 'http://182.18.157.215/SaloonApp/API/GetBranchById/null/true';

    try {
      final jsonResponse = await http.get(
        Uri.parse(apiUrl),
      );

      if (jsonResponse.statusCode == 200) {
        Map<String, dynamic> response = jsonDecode(jsonResponse.body);
        List<dynamic> branchesData = response['listResult'];
        List<BranchList> result = branchesData.map((e) => BranchList.fromJson(e)).toList();
        print('result: ${result[0].name}');
        print('result: ${result[0].address}');
        print('result: ${result[0].imageName}');
        return result;
      } else {
        throw Exception('api failed');
      }
    } catch (e) {
      print('errorin$e');
      rethrow;
    }
  }

  Widget screens() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Branches_screen(userId: AgentId!)),
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
