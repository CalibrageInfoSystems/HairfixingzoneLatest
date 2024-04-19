import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hairfixingzone/MyProductsProvider.dart';
import 'package:hairfixingzone/Product_Model.dart';
import 'package:hairfixingzone/slotbookingscreen.dart';

// import 'package:hrms/api%20config.dart';
// import 'package:hrms/home_screen.dart';
// import 'package:hrms/personal_details.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'Commonutils.dart';
import 'CustomRadioButton.dart';
import 'LatestAppointment.dart';
import 'MyAppointment_Model.dart';
import 'ProductCategory.dart';
import 'api_config.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  MyProducts_screenState createState() => MyProducts_screenState();
}

class MyProducts_screenState extends State<MyProducts> {
  bool isLoading = true;
  List<Product_Model> products_List = [];
  late Future<List<ProductList>> apiData;

  List<RadioButtonOption> options = [];
  int? gender;
  int? categoryid;
  bool isGenderSelected = false;
  List<ProductCategory> products = [];
  late Future<List<ProductCategory>> proCatogary;
  ProductCategory? selectedCategory;

  final orangeColor = const Color(0xFFe78337);

  @override
  void initState() {
    super.initState();
    initializeData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    CommonUtils.checkInternetConnectivity().then((isConnected) {
      if (isConnected) {
        print('The Internet Is Connected');

        // initializeData();
        fetchRadioButtonOptions();
        proCatogary = fetchProductsCategory();
      } else {
        print('The Internet Is not  Connected');
      }
    });
  }

  void initializeData() {
    fetchproducts().then((data) {
      myProductProvider.getProProducts = data;
    }).catchError((error) {
      print('catchError: Error occurred.');
    });
    apiData = fetchproducts();
  }

  late MyProductProvider myProductProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    myProductProvider = Provider.of<MyProductProvider>(context);
  }

  Future<void> fetchRadioButtonOptions() async {
    final url = Uri.parse(baseUrl + getgender);
    print('url==>946: $url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        if (responseData != null &&
            responseData['listResult'] is List<dynamic>) {
          final List<dynamic> optionsData = responseData['listResult'];
          setState(() {
            options = optionsData
                .map((data) => RadioButtonOption.fromJson(data))
                .toList();
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
    final response = await http
        .get(Uri.parse('http://182.18.157.215/SaloonApp/API/GetProduct/6'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData =
      json.decode(response.body)['listResult'];
      List<ProductCategory> result =
      responseData.map((json) => ProductCategory.fromJson(json)).toList();
      print('fetchProductsCategory: ${result[0].desc}');
      return result;
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textscale = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Consumer<MyProductProvider>(
          builder: (context, provider, child) => Scaffold(
            appBar: _appBar(),
            body:
            FutureBuilder(
              future: apiData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(orangeColor),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto",
                      ),
                    ),
                  );
                } else {
                  List<ProductList>? data = provider.getProProducts;
                  print('provider: ${provider.getProProducts.length}');
                  print('data: ${data}');
                  if (data != null && data.isNotEmpty && data.length != 0) { // Check if data is not null and not empty
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, crossAxisSpacing: 16.0, mainAxisSpacing: 16.0, mainAxisExtent: 190, childAspectRatio: 8 / 2),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    ProductList productmodel = data[index];

                                    return GestureDetector(
                                      onTap: () {
                                        // fetchProjectList(employeid);
                                      },
                                      child:
                                      // Scrollbar(
                                      //   child:
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          gradient: const LinearGradient(
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
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child:
                                          // SingleChildScrollView(
                                          //   child:
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 120,
                                                child: Center(
                                                  child: Image.network(
                                                    productmodel.imageName,
                                                    //    "https://images.moneycontrol.com/static-mcnews/2023/08/Health-benefits-of-almond-oil-770x433.jpg?impolicy=website&width=770&height=431", // Placeholder URL
                                                    fit: BoxFit.fill,
                                                    loadingBuilder: (context, child, loadingProgress) {
                                                      if (loadingProgress == null) {
                                                        return child;
                                                      }

                                                      return const Center(child: CircularProgressIndicator.adaptive());
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                productmodel.categoryName,
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                productmodel.name,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          //  ),
                                        ),
                                      ),
                                      //   ),
                                    );


                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'No products found!',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
              },
            ),

            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              // isExtended: true,
              backgroundColor: const Color(0xFFFB4110),
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
              // isExtended: true,
              child: const Icon(
                Icons.filter_alt,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }

  Future<List<ProductList>> fetchproducts(
      {int? id, int? categoryTypeId, int? genderTypeId}) async {
    const apiurl = 'http://182.18.157.215/SaloonApp/API/GetProductById';

    try {
      final request = {
        "id": id,
        "categoryTypeId": categoryTypeId,
        "genderTypeId": genderTypeId
      };
      final response = await http.post(
        Uri.parse(apiurl),
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('api: ${json.encode(request)}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['listResult'] != null) {
          List<dynamic> list = data['listResult'];
          List<ProductList> result =
          list.map((item) => ProductList.fromJson(item)).toList();
          return result;
        } else {
          print('listResult is null');
          throw Exception('else: listResult is null');
        }
        // myProductProvider.proProducts = productlist;
      } else {
        print('api failed');
        throw Exception('else: api failed');
      }
    } catch (error) {
      print('Error data is not getting from the api: $error');
      throw Exception('catch: $error');
    }
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFf15f22),
      title: const Text(
        'Products',
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
        },
      ),
    );
  }
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
  late Future<List<ProductCategory>> proCatogary;
  ProductCategory? selectedCategory;

  final orangeColor = const Color(0xFFe78337);
  late Future<List<ProductList>> apiData;

  @override
  void initState() {
    // Initialize state
    super.initState();
    fetchRadioButtonOptions();
    proCatogary = fetchProductsCategory();
  }

  void filterProducts() {
    apiData = fetchproducts(
        genderTypeId: gender, categoryTypeId: selectedCategory?.typecdid);
    apiData.then((data) {
      myProductProvider.getProProducts = data;
      // Navigator.of(context).pop();
    }).catchError((error) {
      print('catchError: Error occurred.');
    });
  }

  @override
  void dispose() {
    // Dispose resources
    super.dispose();
  }

  late MyProductProvider myProductProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    myProductProvider = Provider.of<MyProductProvider>(context);
  }


  Future<List<ProductList>> fetchproducts(
      {int? id, int? categoryTypeId, int? genderTypeId}) async {
    const apiurl = 'http://182.18.157.215/SaloonApp/API/GetProductById';

    try {
      final request = {
        "id": id,
        "categoryTypeId": categoryTypeId,
        "genderTypeId": genderTypeId
      };
      final response = await http.post(
        Uri.parse(apiurl),
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('api: ${json.encode(request)}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['listResult'] != null) {
          List<dynamic> list = data['listResult'];
          List<ProductList> result =
          list.map((item) => ProductList.fromJson(item)).toList();
          return result;
        } else {
          // If listResult is null, return an empty list
          print('listResult is null');
          return [];
        }
        // myProductProvider.proProducts = productlist;
      } else {
        print('api failed');
        throw Exception('else: api failed');
      }
    } catch (error) {
      print('Error data is not getting from the api: $error');
      throw Exception('catch: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProductProvider>(
      builder: (context, provider, child) => SingleChildScrollView(
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  width: double.infinity,
                  height: 0.2,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // radio buttons
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: options.map((option) {
                          return Row(
                            children: [
                              CustomRadioButton(
                                selected: gender == option.typeCdId,
                                onTap: () {
                                  setState(() {
                                    gender = option.typeCdId;
                                    print('filter: $gender');
                                    isGenderSelected = true;
                                  });
                                  print(option.typeCdId);
                                  print(option.desc);
                                },
                              ),
                              const SizedBox(width: 5),
                              Text(
                                option.desc,
                                style: const TextStyle(
                                  fontFamily: 'Calibri',
                                  fontSize: 14,
                                  color: Color(0xFFFB4110),
                                ),
                              ),
                              const SizedBox(width: 26),
                            ],
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // category
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: FutureBuilder(
                          future: proCatogary,
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
                              List<ProductCategory> data = snapshot.data!;
                              return SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: data.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    bool isSelected =
                                        index == provider.dropDownStatus;
                                    ProductCategory productCategory;

                                    if (index == 0) {
                                      productCategory = ProductCategory(
                                        typecdid: null,
                                        desc: 'All',
                                      );
                                    } else {
                                      productCategory = data[index - 1];
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          provider.dropDownStatus = index;

                                          selectedCategory = productCategory;
                                          print(
                                              'filter: ${selectedCategory?.typecdid}');
                                        });
                                        // payid = currentPaymode.typeCdId;
                                        // provider.getApiStatusId =
                                        //     currentPaymode.typeCdId;
                                        // Selected_PaymentMode = currentPaymode.desc;
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
                                                      productCategory.desc
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
                  ],
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
                    child: SizedBox(
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            filterProducts();
                            Navigator.of(context).pop();
                            // fetchproducts(
                            //     genderTypeId: gender,
                            //     categoryTypeId: selectedCategory?.typecdid);
                          },
                          child: Container(
                            // width: desiredWidth * 0.9,
                            height: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color(0xFFFB4110),
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
        if (responseData != null &&
            responseData['listResult'] is List<dynamic>) {
          final List<dynamic> optionsData = responseData['listResult'];
          setState(() {
            options = optionsData
                .map((data) => RadioButtonOption.fromJson(data))
                .toList();
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
    final response = await http
        .get(Uri.parse('http://182.18.157.215/SaloonApp/API/GetProduct/6'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData =
      json.decode(response.body)['listResult'];
      List<ProductCategory> result =
      responseData.map((json) => ProductCategory.fromJson(json)).toList();
      print('fetchProductsCategory: ${result[0].desc}');
      return result;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
