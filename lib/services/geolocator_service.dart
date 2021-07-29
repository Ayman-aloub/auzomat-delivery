import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  //final Geolocator geo = Geolocator();

  Stream<Position> getCurrentLocation(){
    return Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high,distanceFilter: 10);
  }



  Future<Position> getInitialLocation() async {
    return  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}