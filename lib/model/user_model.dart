import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserModel {
  String uid;
  LatLng myLocation;
  String displayName;
  String phoneNumber;


  UserModel(
      this.uid,
        this.displayName,
        this.phoneNumber,
        this.myLocation);

}