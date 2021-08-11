import 'package:uber_driver_app/models/AddressModel.dart';
import 'package:uber_driver_app/models/userModel.dart';

class TripModel {
  final UserModel rider;
  final UserModel driver;
  final Address pickupAddress;
  final Address destAddress;
  final String paymentMethod;
  final String id;

  TripModel({
    required this.rider,
    required this.driver,
    required this.pickupAddress,
    required this.destAddress,
    required this.paymentMethod,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'riderId': rider.id,
      'driverId': driver.id,
      'source_address': pickupAddress.toJson(),
      'destination_address': destAddress.toJson(),
    };
  }


  @override
  String toString() {
    return 'TripModel{rider: $rider, driver: $driver, pickupAddress: $pickupAddress, destAddress: $destAddress, paymentMethod: $paymentMethod}';
  }
}