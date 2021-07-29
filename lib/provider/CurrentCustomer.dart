import 'package:auzomat_admin/model/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class CurrentCustomer with ChangeNotifier{
  UserModel? customerInfo;
  Future<void> getCustomerNanePhone(String user_id ) async {
    await FirebaseDatabase.instance.reference().child('users').child(user_id).once().then((val){
      String customerName='';
      String customerPhone='';
      LatLng customerLocation=LatLng(0.0, 0.0);
      Map<dynamic, dynamic> customer_info = val.value;
      customer_info.forEach((key, value) {
        Map<dynamic, dynamic> data = value;
        if(data.containsKey('phone')){
          customerName=data['name'];
          customerPhone=data['phone'];
        }else{
          customerLocation=LatLng(data['Lat'], data['Long']);
        }
      });
      customerInfo=UserModel(user_id, customerName, customerPhone, customerLocation);
    }).catchError((e){});
    notifyListeners();
  }
}