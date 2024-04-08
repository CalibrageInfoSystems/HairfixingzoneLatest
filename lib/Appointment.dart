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
      id: json['id'],
      branchId: json['branchId'],
      name: json['name'],
      date: json['date'],
      slotTime: json['slotTime'],
      customerName: json['customerName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      genderTypeId: json['genderTypeId'],
      gender: json['gender'],
      statusTypeId: json['statusTypeId'],
      status: json['status'],
      purposevisitid: json['purposeOfVisitId'],
      purposeofvisit: json['purposeOfVisit'],
      isActive: json['isActive'],
      SlotDuration: json['slotDuration'],
    );
  }
}

