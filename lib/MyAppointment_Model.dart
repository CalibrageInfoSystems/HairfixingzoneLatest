class MyAppointment_Model {
  final int id;
  final int branchId;
  final String branch;
  final String date;
  final int slotTime;
  final String customerName;
  final String contactNumber;
  final String email;
  final int genderTypeId;
  final String genderName;
  final String imagename;
  final int statusTypeId;
  final String status;
  final int purposeOfVisitId;
  final String purposeOfVisit;
  final bool isActive;
  final String? review;
  final double? rating;
  final String? address;
  final DateTime? reviewSubmittedDate;
  final String slotDuration;
  final String? timeofSlot;


  MyAppointment_Model({
    required this.id,
    required this.branchId,
    required this.branch,
    required this.date,
    required this.slotTime,
    required this.customerName,
    required this.contactNumber,
    required this.email,
    required this.genderTypeId,
    required this.genderName,
    required this.statusTypeId,
    required this.status,
    required this.purposeOfVisitId,
    required this.purposeOfVisit,
    required this.isActive,
    required this.review,
    required this.address,
    required this.imagename,
    required this.rating,
    required this.reviewSubmittedDate,
    required this.timeofSlot,
    required this.slotDuration,
  });

  factory MyAppointment_Model.fromJson(Map<String, dynamic> json) {
    return MyAppointment_Model(
      id: json['id'],
      branchId: json['branchId'],
      branch: json['branch'],
      date: json['date'],
      slotTime: json['slotTime'],
      customerName: json['customerName'],
      contactNumber: json['contactNumber'],
      email: json['email'],
      genderTypeId: json['genderTypeId'],
      genderName: json['genderName'],
      statusTypeId: json['statusTypeId'],
      status: json['status'],
      purposeOfVisitId: json['purposeOfVisitId'],
      purposeOfVisit: json['purposeOfVisit'],
      isActive: json['isActive'],
      review: json['review'],
      address: json['address'],
      rating: json['rating'] != null ? json['rating'].toDouble() : null,
      reviewSubmittedDate: json['reviewSubmittedDate'] != null ? DateTime.parse(json['reviewSubmittedDate']) : null,
      timeofSlot: json['timeofSlot'],
      slotDuration: json['slotDuration'],
      imagename: json['imageName'],
    );
  }
}
