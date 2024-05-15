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
  final String imageName;
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
  final double? latitude;
  final double? longitude;

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
    required this.imageName,
    required this.rating,
    required this.reviewSubmittedDate,
    required this.timeofSlot,
    required this.slotDuration,
    required this.latitude,
    required this.longitude,
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
      rating: json['rating']?.toDouble(),
      reviewSubmittedDate: json['reviewSubmittedDate'] != null
          ? DateTime.parse(json['reviewSubmittedDate'])
          : null,
      timeofSlot: json['timeofSlot'],
      slotDuration: json['slotDuration'],
      imageName: json['imageName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

// class MyAppointment_Model {
//   final int id;
//   final int branchId;
//   final String branch;
//   final String imageName;
//   final String filePath;
//   final String fileName;
//   final String fileExtension;
//   final String address;
//   final double? latitude;
//   final double? longitude;
//   final String date;
//   final int slotTime;
//   final String customerName;
//   final String contactNumber;
//   final String email;
//   final int genderTypeId;
//   final String genderName;
//   final int statusTypeId;
//   final String status;
//   final int purposeOfVisitId;
//   final String purposeOfVisit;
//   final bool isActive;
//   final String review;
//   final double rating;
//   final String reviewsubmittedDate;
//   final int price;
//   final int customerId;
//   final String timeofSlot;
//   final String slotDuration;

//   MyAppointment_Model({
//     required this.id,
//     required this.branchId,
//     required this.branch,
//     required this.imageName,
//     required this.filePath,
//     required this.fileName,
//     required this.fileExtension,
//     required this.address,
//     required this.latitude,
//     required this.longitude,
//     required this.date,
//     required this.slotTime,
//     required this.customerName,
//     required this.contactNumber,
//     required this.email,
//     required this.genderTypeId,
//     required this.genderName,
//     required this.statusTypeId,
//     required this.status,
//     required this.purposeOfVisitId,
//     required this.purposeOfVisit,
//     required this.isActive,
//     required this.review,
//     required this.rating,
//     required this.reviewsubmittedDate,
//     required this.price,
//     required this.customerId,
//     required this.timeofSlot,
//     required this.slotDuration,
//   });

//   factory MyAppointment_Model.fromJson(Map<String, dynamic> json) =>
//       MyAppointment_Model(
//         id: json["id"],
//         branchId: json["branchId"],
//         branch: json["branch"],
//         imageName: json["imageName"],
//         filePath: json["filePath"],
//         fileName: json["fileName"],
//         fileExtension: json["fileExtension"],
//         address: json["address"],
//         latitude: json["latitude"]?.toDouble(),
//         longitude: json["longitude"]?.toDouble(),
//         date: json["date"],
//         slotTime: json["slotTime"],
//         customerName: json["customerName"],
//         contactNumber: json["contactNumber"],
//         email: json["email"],
//         genderTypeId: json["genderTypeId"],
//         genderName: json["genderName"],
//         statusTypeId: json["statusTypeId"],
//         status: json["status"],
//         purposeOfVisitId: json["purposeOfVisitId"],
//         purposeOfVisit: json["purposeOfVisit"],
//         isActive: json["isActive"],
//         review: json["review"],
//         rating: json["rating"]?.toDouble(),
//         reviewsubmittedDate: json["reviewsubmittedDate"],
//         price: json["price"],
//         customerId: json["customerId"],
//         timeofSlot: json["timeofSlot"],
//         slotDuration: json["slotDuration"],
//       );
// }
