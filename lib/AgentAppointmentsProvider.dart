import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Appointment.dart';

class AgentAppointmentsProvider extends ChangeNotifier {
  List<Appointment> proAppointments = [];
  int selectedCategoryIndex = 0;
  int? _selectedCategory;
// varibles
  String displayDate = 'Select Dates';
  String? apiFromDate;
  String? apiToDate;
  int? apiBranchId;
  int? apiStatusTypeId;
  bool isFilterApplied = false;
  List<Appointment> filteredAppointments = []; // Add this property

  // Method to update filtered data
  void updateFilteredData(List<Appointment> data) {
    filteredAppointments = data;
    notifyListeners(); // Ensure listeners are notified when filtered data changes
  }

  List<Appointment> get storeIntoProvider => proAppointments;
  set storeIntoProvider(List<Appointment> products) {
    proAppointments = List<Appointment>.from(products);
    notifyListeners();
  }

  void filterProviderData(List<Appointment> items) {
    proAppointments = List<Appointment>.from(items);
    notifyListeners();
  }

  bool get filterStatus => isFilterApplied;
  set filterStatus(bool newStatus) {
    isFilterApplied = newStatus;
    notifyListeners();
  }

  String get getDisplayDate => displayDate;
  set getDisplayDate(String newCode) {
    displayDate = newCode;
    notifyListeners();
  }

  String? get getApiFromDate => apiFromDate;
  // set getApiFromDate(String? newCode) {
  //   DateTime dateTime = DateTime.parse('2022-08-22');
  //   DateFormat('yyyy-MM-dd').format(dateTime);
  //   apiFromDate = newCode;
  //   notifyListeners();
  // }
  set getApiFromDate(String? newCode) {
    if (newCode != null) {
      try {
        DateFormat inputFormat = DateFormat('dd/MM/yyyy');

        DateTime dateTime = inputFormat.parse(newCode);

        DateFormat outputFormat = DateFormat('yyyy-MM-dd');

        String formattedDateStr = outputFormat.format(dateTime);

        apiFromDate = formattedDateStr;
      } catch (e) {
        print('Error parsing date: $e');
        apiFromDate = null;
      }
    } else {
      apiFromDate = null;
    }

    notifyListeners();
  }

  String? get getApiToDate => apiToDate;
  set getApiToDate(String? newCode) {
    if (newCode != null) {
      try {
        DateFormat inputFormat = DateFormat('dd/MM/yyyy');

        DateTime dateTime = inputFormat.parse(newCode);

        DateFormat outputFormat = DateFormat('yyyy-MM-dd');

        String formattedDateStr = outputFormat.format(dateTime);

        apiToDate = formattedDateStr;
      } catch (e) {
        print('Error parsing date: $e');
        apiToDate = null;
      }
    } else {
      apiToDate = null;
    }

    notifyListeners();
  }

  int? get getApiBranchId => apiBranchId;
  set getApiBranchId(int? newCode) {
    apiBranchId = newCode;
    notifyListeners();
  }

  int? get getApiStatusTypeId => apiStatusTypeId;
  set getApiStatusTypeId(int? newCode) {
    apiStatusTypeId = newCode;
    notifyListeners();
  }

  List<Statusmodel> prostatus = [];
  int selectedstatusIndex = 0;
  List<Statusmodel> get storeIntostatusProvider => prostatus;
  int? _selectedStatus;

  List<Statusmodel> probranches = [];
  int selectedbranchesIndex = 0;
  List<Statusmodel> get storeIntobranchProvider => probranches;
  int? _selectedbranch;

  // void filterProviderData(List<Appointment> items) {
  //   proAppointments.clear();
  //   proAppointments.addAll(items);
  //   notifyListeners();
  // }
  void clearFilter() {
    displayDate = 'Select Dates';
    selectedStatus = 0;
    selectedBranch = 0;
    apiFromDate = null;
    apiToDate = null;
    filterStatus = false;
    notifyListeners();
  }

  int? get getbranch => _selectedbranch;
  set getbranch(int? newCategory) {
    _selectedbranch = newCategory;
    notifyListeners();
  }

  int get selectedBranch => selectedbranchesIndex;
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
