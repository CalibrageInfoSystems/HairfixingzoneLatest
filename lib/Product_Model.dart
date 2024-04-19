class Product_Model {
  final int id;
  final String code;
  final String name;
  final int categoryTypeId;
  final int genderTypeid;
  final double minPrice;
  final double maxPrice;
  final double minDiscountPrice;
  final double maxDiscountPrice;
  final String imageName;
  final String fileLocation;
  final String fileName;
  final String fileExtension;
  final bool isActive;
  final String categoryName;
  final String gender;
  final String createdBy;
  final String updatedBy;

  Product_Model({
    required this.id,
    required this.code,
    required this.name,
    required this.categoryTypeId,
    required this.genderTypeid,
    required this.minPrice,
    required this.maxPrice,
    required this.minDiscountPrice,
    required this.maxDiscountPrice,
    required this.imageName,
    required this.fileLocation,
    required this.fileName,
    required this.fileExtension,
    required this.isActive,
    required this.categoryName,
    required this.gender,
    required this.createdBy,
    required this.updatedBy,
  });

  factory Product_Model.fromJson(Map<String, dynamic> json) {
    return Product_Model(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      categoryTypeId: json['categoryTypeId'],
      minPrice: json['minPrice'].toDouble(),
      maxPrice: json['maxPrice'].toDouble(),
      minDiscountPrice: json['minDiscountPrice'].toDouble(),
      maxDiscountPrice: json['maxDiscountPrice'].toDouble(),
      imageName: json['imageName'],
      fileLocation: json['fileLocation'],
      fileName: json['fileName'],
      fileExtension: json['fileExtension'],
      isActive: json['isActive'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      genderTypeid: json['genderTypeId'],
      gender: json['gender'],
      categoryName: json['categoryName'],
    );
  }
}