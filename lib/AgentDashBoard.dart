import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hairfixingzone/BranchesModel.dart';
import 'package:hairfixingzone/Common/common_styles.dart';
import 'package:hairfixingzone/Consultation.dart';
import 'package:hairfixingzone/Dashboard_Screen.dart';
import 'package:hairfixingzone/api_config.dart';

import 'package:marquee/marquee.dart';
import 'package:http/http.dart' as http;

import 'AddConsulationscreen.dart';

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

  @override
  void initState() {
    super.initState();
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

  void _fetchItems() async {
    final response = await http.get(
        Uri.parse('http://182.18.157.215/SaloonApp/API/GetBanner?Id=null'));

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
        'http://182.18.157.215/SaloonApp/API/api/Consultation/GetConsultationsByBranchId/$agentId');
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
      backgroundColor: CommonStyles.primaryTextColor,
      // appBar: _appBar(),
      body: Column(
        children: [
          //MARK: Welcome Text
          welcomeText(),
          //MARK: Main Card
          Expanded(
            child: SingleChildScrollView(
              child: Container(
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
            ),
          )
        ],
      ),
    );
  }

  getMarqueeText() {}

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

  Widget welcomeText() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      height: 80,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hello!',
            style: CommonStyles.txSty_16w_fb,
          ),
          Text(
            'AgentName',
            style: CommonStyles.txSty_18w_fb,
          ),
        ],
      ),
    );
  }

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
                text: 'marqueeText   ',
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
                Expanded(
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
      height: MediaQuery.of(context).size.height / 3.5,
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
            return Expanded(
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
        List<BranchList> result =
        branchesData.map((e) => BranchList.fromJson(e)).toList();
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
            // Navigator.of(context, rootNavigator: true)
            //     .pushNamed("/ProfileMy");
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width / 7,
                //   height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFF295f5a),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/my_profile_icon.svg',
                  color: CommonStyles.whiteColor,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Check Appointments',
                style: CommonStyles.txSty_14p_f5,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            print('_______test_______');
            Navigator.of(context, rootNavigator: true)
                .pushNamed("/ViewConsultation");
          },
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 7,
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color(0xFFe656ae),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/my_bookings_icon.svg',
                  color: CommonStyles.whiteColor,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'View Consultation',
                style: CommonStyles.txSty_14p_f5,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddConsulationscreen()),
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
                  color: Color(0xFFe44561),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/products_icon.svg',
                  color: CommonStyles.whiteColor,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Add Consultation',
                style: CommonStyles.txSty_14p_f5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
