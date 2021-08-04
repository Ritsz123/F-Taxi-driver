
import 'package:uber_driver_app/models/vehicleModel.dart';

class UserModel {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final VehicleModel? vehicleModel;
  final bool isAvailable;

  UserModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.fullName,
    this.vehicleModel,
    required this.isAvailable,
  });

  static UserModel fromJson(Map<String, dynamic> json){
    return UserModel(
      id: json['_id'].toString(),
      email: json['email'].toString(),
      phone: json['phone'].toString(),
      fullName: json['name'].toString(),
      isAvailable: json['available'] == null ? true : json['available'] as bool,
      vehicleModel: json['vehicle_details'] == null ? null : VehicleModel.fromJson(json['vehicle_details'])
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, fullName: $fullName, phone: $phone, email: $email, isAvailable: $isAvailable}';
  }
}
