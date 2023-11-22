class BranchModel {
  final int id;
  final String name;
  final String filePath;
  final String address;
  final int startTime;
  final int closeTime;
  final int room;
  final String mobileNumber;
  final bool isActive;

  BranchModel({
    required this.id,
    required this.name,
    required this.filePath,
    required this.address,
    required this.startTime,
    required this.closeTime,
    required this.room,
    required this.mobileNumber,
    required this.isActive,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['Id'],
      name: json['Name'],
      filePath: json['FilePath'],
      address: json['Address'],
      startTime: json['StartTime'],
      closeTime: json['CloseTime'],
      room: json['Room'],
      mobileNumber: json['MobileNumber'],
      isActive: json['IsActive'],
    );
  }
}