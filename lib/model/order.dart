
import 'package:auzomat_admin/model/cartItem.dart';
import 'package:auzomat_admin/model/user_model.dart';

class order {
  final DateTime orderTime;
  final String restaurantID;
  final String orderID;
  final bool is_received;
  final String customer;
  final List< CartItem> items ;
  double get totalAmount {
    var total = 0.0;
    items.forEach((cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }
  order(this.items,this.restaurantID,this.customer,this.is_received,this.orderTime,this.orderID);






}