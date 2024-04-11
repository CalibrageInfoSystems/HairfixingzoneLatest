class LastAppointment {
  final int id;
  final int branchId;
  final String branch;
  final String date;
  final int slotTime;
  final String customerName;
  final int customerId;
  final String contactNumber;
  final String email;
  final int genderTypeId;
  final String gender;
  final int statusTypeId;
  final String status;
  final int purposeOfVisitId;
  final String purposeOfVisit;
  final bool isActive;
  final String slotDuration;
  final String appointmentTime;

  LastAppointment({
    required this.id,
    required this.branchId,
    required this.branch,
    required this.date,
    required this.slotTime,
    required this.customerName,
    required this.customerId,
    required this.contactNumber,
    required this.email,
    required this.genderTypeId,
    required this.gender,
    required this.statusTypeId,
    required this.status,
    required this.purposeOfVisitId,
    required this.purposeOfVisit,
    required this.isActive,
    required this.slotDuration,
    required this.appointmentTime,
  });

  factory LastAppointment.fromJson(Map<String, dynamic> json) {
    return LastAppointment(
      id: json['id'],
      branchId: json['branchId'],
      branch: json['branch'],
      date: json['date'],
      slotTime: json['slotTime'],
      customerName: json['customerName'],
      customerId: json['customerId'],
      contactNumber: json['contactNumber'],
      email: json['email'],
      genderTypeId: json['genderTypeId'],
      gender: json['gender'],
      statusTypeId: json['statusTypeId'],
      status: json['status'],
      purposeOfVisitId: json['purposeOfVisitId'],
      purposeOfVisit: json['purposeOfVisit'],
      isActive: json['isActive'],
      slotDuration: json['slotDuration'],
      appointmentTime: json['appointmentTime'],
    );
  }
}
