import 'package:uber_driver_app/models/AddressModel.dart';
import 'package:uber_driver_app/models/userModel.dart';

class TripModel {
  final UserModel rider;
  final UserModel driver;
  final Address pickupAddress;
  final Address destAddress;
  final String paymentMethod;

  TripModel({
    required this.rider,
    required this.driver,
    required this.pickupAddress,
    required this.destAddress,
    required this.paymentMethod,
  });

  @override
  String toString() {
    return 'TripModel{rider: $rider, driver: $driver, pickupAddress: $pickupAddress, destAddress: $destAddress, paymentMethod: $paymentMethod}';
  }
}