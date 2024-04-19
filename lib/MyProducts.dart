import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hairfixingzone/Product_Model.dart';
import 'package:hairfixingzone/slotbookingscreen.dart';

// import 'package:hrms/api%20config.dart';
// import 'package:hrms/home_screen.dart';
// import 'package:hrms/personal_details.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'Commonutils.dart';
import 'CustomRadioButton.dart';
import 'LatestAppointment.dart';
import 'MyAppointment_Model.dart';
import 'ProductCategory.dart';
import 'api_config.dart';

// import 'Model Class/EmployeeLeave.dart';
// import 'SharedPreferencesHelper.dart';

class MyProducts extends StatefulWidget {
  @override
  MyProducts_screenState createState() => MyProducts_screenState();
}

class MyProducts_screenState extends State<MyProducts> {
  bool isLoading = true;
  List<Product_Model> products_List = [];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        print('The Internet Is Connected');
        fetchproducts();
      } else {
        print('The Internet Is not  Connected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textscale = MediaQuery
        .of(context)
        .textScaleFactor;
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
                'Products',
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
                },
              )),
          body: Stack(
            children: [
              // Background Image

              // SingleChildScrollView for scrollable content
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  // padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Text(
                    //   "Hello!",
                    //   style: TextStyle(fontSize: 26, color: Colors.black, fontFamily: 'Calibri'),
                    // ),
                    // SizedBox(
                    //   height: 8.0,
                    // ),
                    // Text(
                    //   "$EmployeName",
                    //   style: TextStyle(fontSize: 26, color: Color(0xFFf15f22), fontFamily: 'Calibri'),
                    // ),

                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          mainAxisExtent: 150,
                          childAspectRatio: 8 / 2),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: products_List.length,
                      itemBuilder: (BuildContext context, int index) {
                        Product_Model productmodel = products_List[index];
                        if (isLoading) {
                          // Return shimmer effect if isLoading is true
                          return GestureDetector(
                            onTap: () {
                              //  fetchProjectList(employeid);
                            },
                            child: Scrollbar(
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFFEE7E1), // Start color
                                        Color(0xFFD7DEFA),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        // Container(
                                        //   height: 130,
                                        //   padding: EdgeInsets.only(left: 20, right: 20),
                                        //   child: Shimmer.fromColors(
                                        //     baseColor: Colors.grey[300]!,
                                        //     highlightColor: Colors.grey[100]!,
                                        //     child: Image.network(
                                        //       productmodel.imageName,
                                        //       width: 110,
                                        //       height: 65,
                                        //       fit: BoxFit.fill,
                                        //     ),
                                        //   ),
                                        // ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 20, right: 20),
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor: Colors.grey.shade100,
                                            child: Text('${productmodel.categoryName}'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 20, right: 20),
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor: Colors.grey.shade100,
                                            child: Text('${productmodel.name}'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          Product_Model productmodel = products_List[index];
                          return GestureDetector(
                            onTap: () {
                              // fetchProjectList(employeid);
                            },
                            child: Scrollbar(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFEE7E1), // Start color
                                      Color(0xFFD7DEFA),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          child: Center(
                                            child: Image.network(
                                              productmodel.imageName,
                                              //    "https://images.moneycontrol.com/static-mcnews/2023/08/Health-benefits-of-almond-oil-770x433.jpg?impolicy=website&width=770&height=431", // Placeholder URL
                                              fit: BoxFit.fill,
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) return child;

                                                return const Center(child: CircularProgressIndicator.adaptive());
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '${productmodel.categoryName}',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '${productmodel.name}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ]),
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            // isExtended: true,
            child: Icon(
              Icons.filter_alt,
              color: Colors.white,
            ),
            backgroundColor: Color(0xFFFB4110),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: const FilterBottomSheet(),
                ),
              );

            },
          ),
        ));
  }

  Future<void> fetchproducts() async {
    setState(() {
      isLoading = true; // Set isLoading to true before making the API call
    });
    final apiurl = 'http://182.18.157.215/SaloonApp/API/GetProductById';
    final url = Uri.parse(apiurl);
    print('url==>products: $url');

    bool success = false;
    int retries = 0;
    const maxRetries = 1;

    while (!success && retries < maxRetries) {
      try {
        final request = {"id": null, "categoryTypeId": null, "genderTypeId": null};
        final response = await http.post(
          url,
          body: json.encode(request),
          headers: {
            'Content-Type': 'application/json', // Set the content type header
          },
        );

        // Check if the request was successful
        if (response.statusCode == 200) {
          // Parse the response body
          final data = json.decode(response.body);

          List<Product_Model> productlist = [];
          for (var item in data['listResult']) {
            productlist.add(Product_Model(
              id: item['id'],
              name: item['name'],
              imageName: item['imageName'],
              isActive: item['isActive'],
              code: item['code'],
              categoryTypeId: item['categoryTypeId'],
              minPrice: item['minPrice'],
              maxPrice: item['maxPrice'],
              minDiscountPrice: item['minDiscountPrice'],
              maxDiscountPrice: item['maxDiscountPrice'],
              fileLocation: item['fileLocation'],
              fileName: item['fileName'],
              fileExtension: item['fileExtension'],
              createdBy: item['createdBy'],
              updatedBy: item['updatedBy'],
              genderTypeid: item['genderTypeId'] ?? 0,
              categoryName: item['categoryName'],
              gender: item['gender'] ?? '',
            ));
          }

          // Update the state with the fetched data
          setState(() {
            products_List = productlist;
            isLoading = false; // Set isLoading to false after data is fetched
          });

          success = true;
        } else {
          // Handle error if the API request was not successful
          print('Request failed with status: ${response.statusCode}');
          setState(() {
            isLoading = false; // Set isLoading to false if request fails
          });
        }
      } catch (error) {
        // Handle any exception that occurred during the API call
        print('Error data is not getting from the api: $error');
        setState(() {
          isLoading = false; // Set isLoading to false if error occurs
        });
      }

      retries++;
    }

    if (!success) {
      // Handle the case where all retries failed
      print('All retries failed. Unable to fetch data from the API.');
    }
  }

// void ShowBottomsheet() {
//   showModalBottomSheet(
//     isScrollControlled: true,
//     context: context,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (BuildContext context) {
//       return Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [],
//           ),
//         ),
//       );
//     },
//   );
// }
}
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  List<RadioButtonOption> options = [];
  int? gender;
  int? categoryid;
  bool isGenderSelected = false;
  List<ProductCategory> products = [];
  @override
  void initState() {
    // Initialize state
    super.initState();
    fetchRadioButtonOptions();
    fetchProductsCategory();
    fetchProductsCategory();
  }

  @override
  void dispose() {
    // Dispose resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Filter By',
                ),
                GestureDetector(
                  onTap: () {
                    // Clear filters
                    // provider.clearFilter(); // You need to provide the provider instance here if you are using a state management solution
                  },
                  child: const Text(
                    'Clear all filters',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.only(left: 5, top: 10.0, right: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: options.map((option) {
                        return Row(
                          children: [
                            CustomRadioButton(
                              selected: gender == option.typeCdId,
                              onTap: () {
                                setState(() {
                                  gender = option.typeCdId;
                                  print('selectedGenderid:$gender');
                                  isGenderSelected = true;
                                });
                                print(option.typeCdId);
                                print(option.desc);
                              },
                            ),
                            SizedBox(width: 5),
                            Text(
                              option.desc,
                              style: TextStyle(
                                fontFamily: 'Calibri',
                                fontSize: 14,
                                color: Color(0xFFFB4110),
                              ),
                            ),
                            SizedBox(width: 26),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

       // Added SizedBox for spacing
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        color: Colors.red,
                      ),
                      side: const BorderSide(
                        color: Colors.red,
                      ),
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      // style: CommonStyles.txSty_14r_fb,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Apply filters
                      // getAppliedFilterData(context);
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      // backgroundColor: CommonStyles.orangeColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      // style: CommonStyles.txSty_14w_fb,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchRadioButtonOptions() async {
    final url = Uri.parse(baseUrl + getgender);
    print('url==>946: $url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        if (responseData != null && responseData['listResult'] is List<dynamic>) {
          final List<dynamic> optionsData = responseData['listResult'];
          setState(() {
            options = optionsData.map((data) => RadioButtonOption.fromJson(data)).toList();
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to fetch radio button options');
      }
    } catch (e) {
      throw Exception('Error Radio: $e');
    }
  }

  Future<List<ProductCategory>> fetchProductsCategory() async {
    final response = await http.get(Uri.parse('http://182.18.157.215/SaloonApp/API/GetProduct/6'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['listResult'];
      return responseData.map((json) => ProductCategory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

}