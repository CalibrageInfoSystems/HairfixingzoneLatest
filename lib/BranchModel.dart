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
      id: json['Id'] ?? 0,
      name: json['Name'] ?? '',
      filePath: json['FilePath'] ?? '',
      address: json['Address'] ?? '',
      startTime: json['StartTime'] ?? 0,
      closeTime: json['CloseTime'] ?? 0,
      room: json['Room'] ?? 0,
      mobileNumber: json['MobileNumber'] ?? '',
      isActive: json['IsActive'] ?? false,
    );
  }


}