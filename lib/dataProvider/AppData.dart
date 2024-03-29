import 'package:flutter/cupertino.dart';
import 'package:uber_driver_app/models/AddressModel.dart';
import 'package:uber_driver_app/models/userModel.dart';

class AppData extends ChangeNotifier{
  late Address _pickUpAddress;
  late Address _destinationAddress;
  late String _authToken;
  late UserModel _currentUser;

  void updateDestinationAddress(Address newAddress) {
    _destinationAddress = newAddress;
    notifyListeners();
  }

  void updatePickupAddress(Address newAddress) {
    _pickUpAddress = newAddress;
    notifyListeners();
  }

  Address getPickUpAddress() {
    return _pickUpAddress;
  }

  Address getDestinationAddress() {
    return _destinationAddress;
  }

  UserModel getCurrentUser() {
    return _currentUser;
  }

  void setCurrentUser(UserModel userModel){
    _currentUser = userModel;
    notifyListeners();
  }

  void setAuthToken(String token){
    _authToken = token;
    notifyListeners();
  }

  String getAuthToken() {
    return _authToken;
  }
}