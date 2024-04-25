import 'package:flutter/material.dart';
import 'package:hairfixingzone/MyAppointment_Model.dart';
import 'package:hairfixingzone/slotbookingscreen.dart';

class MyAppointmentsProvider extends ChangeNotifier {
  List<MyAppointment_Model> proAppointments = [];
  int selectedCategoryIndex = 0;
 List<MyAppointment_Model> get storeIntoProvider => proAppointments;
  int? _selectedCategory;

  List<Statusmodel> prostatus = [];
  int selectedstatusIndex = 0;
  List<Statusmodel> get storeIntostatusProvider => prostatus;
  int? _selectedStatus;

  List<Statusmodel> probranches = [];
  int selectedbranchesIndex = 0;
  List<Statusmodel> get storeIntobranchProvider => probranches;
  int? _selectedbranch;

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



  // int get selectedCategory => selectedCategoryIndex;
  // set selectedCategory(int newStatus) {
  //   selectedCategoryIndex = newStatus;
  //   notifyListeners();
  // }
  // int? get getCategory => _selectedCategory;
  // set getCategory(int? newCategory) {
  //   _selectedCategory = newCategory;
  //   notifyListeners();
  // }
  int? get getbranch => _selectedbranch;
  set getbranch(int? newCategory) {
    _selectedbranch = newCategory;
    notifyListeners();
  }

  int get selectedBranch=> selectedbranchesIndex;
  set selectedBranch(int newStatus) {
    selectedbranchesIndex = newStatus;
    notifyListeners();
  }

  int get selectedstatus => selectedstatusIndex;
  set selectedStatus(int newStatus) {
    selectedstatusIndex = newStatus;
    notifyListeners();
  }
  int? get getStatus => _selectedStatus;
  set getStatus(int? newCategory) {
    _selectedStatus = newCategory;
    notifyListeners();
  }
}

class Statusmodel {
  final int? typeCdId;
  final String desc;

  Statusmodel({required this.typeCdId, required this.desc});

  factory Statusmodel.fromJson(Map<String, dynamic> json) {
    return Statusmodel(
      typeCdId: json['typeCdId'] ?? 0,
      desc: json['desc'] ?? '',
    );
  }
}
