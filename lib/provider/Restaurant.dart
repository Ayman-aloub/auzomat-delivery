import 'package:auzomat_admin/model/restaurant.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Restaurant with ChangeNotifier{
  restaurant? currentResstaurant;
  Future<restaurant> getRestautant(String restaurantID) async {
    restaurant res=restaurant(id: '', name: '', description: '', price: 0, time: 0, location: LatLng(0.0,0.0), imageUrl: '');
    await FirebaseDatabase.instance.reference().child('restaurants').child(restaurantID).once().then((value){
      print(value.value);
      Map<dynamic, dynamic> cur = value.value;
      print(cur['name']);
      res= restaurant(
          id: restaurantID,
          name: cur['name'],
          description: cur['describtion'],
          price: cur['service_price'],
          time:cur['time'],
          imageUrl:cur['img_url'] ,
          location:  LatLng(cur['latitude'],cur['longitude'])

      );


    }).onError((error, stackTrace) {throw(error!);});
    currentResstaurant=res;
    //await getCustomerNanePhone(user_id)


    return res;


  }
}