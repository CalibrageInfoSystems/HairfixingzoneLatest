import 'package:flutter/material.dart';
import 'package:hairfixingzone/Product_Model.dart';

class MyProductProvider extends ChangeNotifier {
  List<ProductList> proProducts = [];
  int selectedStatusIndex = 0;

  int get dropDownStatus => selectedStatusIndex;
  set dropDownStatus(int newStatus) {
    selectedStatusIndex = newStatus;
    notifyListeners();
  }

  List<ProductList> get getProProducts => proProducts;
  set getProProducts(List<ProductList> products) {
    proProducts.clear();
    proProducts = products;
    notifyListeners();
  }

  void storeIntoProvider(List<ProductList> items) {
    proProducts.clear();
    proProducts.addAll(items);
    notifyListeners();
  }
}
