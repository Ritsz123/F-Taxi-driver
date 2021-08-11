class VehicleModel {
  final bool verified;
  final String regNumber;
  final String model;
  final String color;

  VehicleModel({
    required this.verified,
    required this.regNumber,
    required this.model,
    required this.color
  });

  static VehicleModel fromJson(Map<String, dynamic> json){
    return VehicleModel(
      verified: json['vehicle_verified'] as bool,
      regNumber: json['reg_number'].toString(),
      model: json['model'].toString(),
      color: json['color'].toString(),
    );
  }
}