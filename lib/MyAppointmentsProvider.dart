import 'package:flutter/material.dart';
import 'package:hairfixingzone/MyAppointment_Model.dart';

class MyAppointmentsProvider extends ChangeNotifier {
  List<MyAppointment_Model> proAppointments = [];
  int selectedCategoryIndex = 0;
 List<MyAppointment_Model> get storeIntoProvider => proAppointments;
  int? _selectedCategory;
  set storeIntoProvider(List<MyAppointment_Model> products) {
    proAppointments.clear();
    proAppointments = products;
    notifyListeners();
  }

  void filterProviderData(List<MyAppointment_Model> items) {
    proAppointments.clear();
    proAppointments.addAll(items);
    notifyListeners();
  }

  void clearFilter() {
    proAppointments = [];
    notifyListeners();
  }



  int get selectedCategory => selectedCategoryIndex;
  set selectedCategory(int newStatus) {
    selectedCategoryIndex = newStatus;
    notifyListeners();
  }
  int? get getCategory => _selectedCategory;
  set getCategory(int? newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }
}
