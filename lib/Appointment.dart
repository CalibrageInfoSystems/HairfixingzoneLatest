class Appointment {
  final int id;
  final int branchId;
  final String name;
  final String date;
  final int slotTime;
  final String customerName;
  final String phoneNumber;
  final String email;
  final int genderTypeId;
  final String gender;
  final int statusTypeId;
  final String status;

  final int purposevisitid;
  final String purposeofvisit;
  final bool isActive;
  bool isAccepted;
  bool isRejected;
  final String SlotDuration;

  Appointment({
    required this.id,
    required this.branchId,
    required this.name,
    required this.date,
    required this.slotTime,
    required this.customerName,
    required this.phoneNumber,
    required this.email,
    required this.genderTypeId,
    required this.gender,
    required this.statusTypeId,
    required this.status,
    required this.purposevisitid,
    required this.purposeofvisit,
    required this.isActive,
    this.isAccepted = false,
    this.isRejected =false,
    required this.SlotDuration,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['Id'],
      branchId: json['BranchId'],
      name: json['Name'],
      date: json['Date'],
      slotTime: json['SlotTime'],
      customerName: json['CustomerName'],
      phoneNumber: json['PhoneNumber'],
      email: json['Email'],
      genderTypeId: json['GenderTypeId'],
      gender: json['Gender'],
      statusTypeId: json['StatusTypeId'],
      status: json['Status'],
      purposevisitid: json['PurposeOfVisitId'],
      purposeofvisit: json['PurposeOfVisit'],
      isActive: json['IsActive'],
      SlotDuration: json['SlotDuration'],
    );
  }
}

