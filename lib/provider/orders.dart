import 'dart:convert';
import 'dart:ffi';

import 'package:auzomat_admin/model/cartItem.dart';
import 'package:auzomat_admin/model/order.dart';
import 'package:auzomat_admin/model/restaurant.dart';
import 'package:auzomat_admin/model/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class orders with ChangeNotifier {
  List<order> _myOrders=[];
  //restaurant? res;
  order? currentOtder;
  String _userId='';
  setUser(uId){
    _userId=uId;

    print("1111tokken"+_userId);

  }
  List<order> get items {
    return [..._myOrders];

  }
  Future<bool> check() async {
    SharedPreferences value=await SharedPreferences.getInstance();
    if(value.containsKey('orderID')&&value.containsKey('customerID')){
      String currentCustomerId=value.getString('customerID').toString();
      String currentorderID=value.getString('orderID').toString();
      print(currentCustomerId);

      await FirebaseDatabase.instance.reference().child('orders').child(currentCustomerId).child(currentorderID).once().then((value){
        Map<dynamic, dynamic> values = value.value ;
        Map<dynamic, dynamic> single_order_items = values['items'];
        final List< CartItem> user_items=[] ;
        single_order_items.forEach((key, item) {
          user_items.add(CartItem(name: item['name'], price: item['price'], quantity: item['quantity']));
        });
        Map<dynamic, dynamic> single_order_info = values['information'];

        currentOtder=order(user_items, single_order_info['restaurantId'],currentCustomerId, single_order_info['is_received'], DateTime.parse(single_order_info['datetime']), currentorderID);
        print(currentOtder!.orderTime.toString());
        print(currentOtder!.items.length);
      }).catchError((e){});
      //await getCustomerNanePhone(currentCustomerId);
      notifyListeners();
      return true;


    }
    notifyListeners();
    return false;

  }
  Future<void> downloadOrders() async {

    _myOrders.clear();
    bool result=false;

    //String? checkedID;


    await FirebaseDatabase.instance.reference().child('orders').once().then((value){print(value.value );
    Map<dynamic, dynamic> values = value.value;
    values.forEach((user_id, user_orders) async {

      Map<dynamic, dynamic> single_user_orders = user_orders;
      //print(user_id);
      single_user_orders.forEach((order_id, value) async {
        Map<dynamic, dynamic> user_oders = value;
        Map<dynamic, dynamic> single_order_items = user_oders['items'];
        final List< CartItem> user_items=[] ;
        //print(order_id);

          single_order_items.forEach((key, item) {
            user_items.add(CartItem(name: item['name'], price: item['price'], quantity: item['quantity']));

          });
        Map<dynamic, dynamic> single_order_info = user_oders['information'];
        if(single_order_info['is_received']==false&& single_order_info.containsKey('deliveryID')==true ){
          if(single_order_info['deliveryID']==_userId){
            /*SharedPreferences _pref=await SharedPreferences.getInstance();
            _pref.setString('orderID', order_id);
            _pref.setString('customerID', user_id);*/
            currentOtder=order(user_items, single_order_info['restaurantId'],user_id, single_order_info['is_received'], DateTime.parse(single_order_info['datetime']), order_id);
            result=true;}

        }

        if(single_order_info['is_received']==false && single_order_info.containsKey('deliveryID')==false){

          _myOrders.add(order(user_items, single_order_info['restaurantId'],user_id, single_order_info['is_received'], DateTime.parse(single_order_info['datetime']), order_id));

        }
        //user_items.clear();





      });

    });


    }).catchError((e){});
    if(result==true &&currentOtder!=null ){

        SharedPreferences _pref=await SharedPreferences.getInstance();
        _pref.setString('orderID', currentOtder!.orderID);
        _pref.setString('customerID', currentOtder!.customer);
        result=true;

    }
    if(_myOrders.isEmpty==false && result==false){
      await getFirstOtder();
    }




      notifyListeners();



  }
  Future<void> orederIsDeliverd() async {
    if(currentOtder!=null) {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      _pref.clear();
      await FirebaseDatabase.instance.reference().child('orders').child(
          currentOtder!.customer).child(currentOtder!.orderID).child(
          'information').update({
        'is_received': true
      });
      currentOtder=null;
    }
    notifyListeners();

  }
  Future<void> getFirstOtder() async {
    DateTime smallest=_myOrders[0].orderTime;
    order firstOrder=_myOrders[0];
    for(int i=1;i<_myOrders.length;i++){
      if(_myOrders[i].orderTime.isBefore(smallest)){
        firstOrder=_myOrders[i];
        smallest=_myOrders[i].orderTime;

      }
    }
    print(_userId);
    await FirebaseDatabase.instance.reference().child('orders').child(firstOrder.customer).child(firstOrder.orderID).child('information').update({
      'deliveryID':_userId
    });
    SharedPreferences _pref=await SharedPreferences.getInstance();
    _pref.setString('orderID', firstOrder.orderID);
    _pref.setString('customerID', firstOrder.customer);
    print(smallest);
    currentOtder=firstOrder;
    //return firstOrder;
    notifyListeners();

  }
  void display(){

    print(_myOrders.length);
    _myOrders.forEach((e) {
      print(e.orderID);
      //print(e.customer.uid+e.customer.displayName);
      print(e.orderTime);
      print(e.items.length);
      print(e.restaurantID);
      print('done');
    });

  }
}
