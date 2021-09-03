import 'package:flutter/cupertino.dart';
import 'package:drivers_app/Assistants/address.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation, dropOffLocation;

  void updatePickUpLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updatedropOffLocationAddress(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
