class Model_branch {
  int? Id;
  String? branchName;
  String? address;
  String? imageName;
  String? PhoneNumber;

  Model_branch({required this.Id, required this.branchName, required this.address, required this.imageName, required this.PhoneNumber});

  factory Model_branch.fromJson(Map<String, dynamic> json) {
    return Model_branch(
      Id: json['id'] ?? 0,
      branchName: json['branchName'] ?? '',
      address: json['address'] ?? '',
      imageName: json['imageName'] ?? '',
      PhoneNumber: json['mobileNumber'],
    );
  }
}
