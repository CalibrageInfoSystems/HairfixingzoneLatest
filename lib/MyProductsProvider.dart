import 'package:flutter/material.dart';
import 'package:hairfixingzone/Product_Model.dart';

class MyProductProvider extends ChangeNotifier {
  List<ProductList> proProducts = [];
  int selectedCategoryIndex = 0;
  int selectedGenderIndex = 0;
  int? _selectedGender;
  int? _selectedCategory;

  int? get getGender => _selectedGender;
  set getGender(int? newGender) {
    _selectedGender = newGender;
    notifyListeners();
  }

  int? get getCategory => _selectedCategory;
  set getCategory(int? newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }

  int get selectedCategory => selectedCategoryIndex;
  set selectedCategory(int newStatus) {
    selectedCategoryIndex = newStatus;
    notifyListeners();
  }

  int get selectedGender => selectedGenderIndex;
  set selectedGender(int newStatus) {
    selectedGenderIndex = newStatus;
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


  void clearFilter() {
    selectedGender = 0;
    selectedCategory = 0;
    getGender = null;
    getCategory = null;

    proProducts = [];
    notifyListeners();
  }
}
