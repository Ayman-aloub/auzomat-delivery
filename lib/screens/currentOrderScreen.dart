import 'package:auzomat_admin/model/order.dart';
import 'package:auzomat_admin/model/restaurant.dart';
import 'package:auzomat_admin/provider/CurrentCustomer.dart';
import 'package:auzomat_admin/provider/Restaurant.dart';
import 'package:auzomat_admin/provider/orders.dart';
import 'package:auzomat_admin/screens/next.dart';
import 'package:auzomat_admin/screens/map.dart';
import 'package:auzomat_admin/widgets/HomeAppDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class orderItemsScreen extends StatefulWidget {


  @override
  _orderItemsScreenState createState() => _orderItemsScreenState();
}

class _orderItemsScreenState extends State<orderItemsScreen> {

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:  TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,

              title: Center(
                child: Text(
                  "الطلب",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              //brightness: Brightness.light,

            ),
            endDrawer: homeAppDrawer(),
            body:FutureBuilder(
              future: Provider.of<Restaurant>(context, listen: false).getRestautant(Provider.of<orders>(context, listen: false).currentOtder!.restaurantID),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (dataSnapshot.error != null) {
                    // ...
                    // Do error handling stuff
                    return Center(
                      child: Text('An error occurred!'),
                    );
                  } else {
                    restaurant res=dataSnapshot.data as restaurant;
                    order? currentOreder= Provider.of<orders>(context, listen: false).currentOtder;
                    return dataSnapshot.data != null? SingleChildScrollView(
                      child: Column(
                        //mainAxisSize: MainAxisSize.min,
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      ListTile(
                      leading: Card(

                      child: Container(
                        width: 70,
                        height: 150,
                        foregroundDecoration:  BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  res.imageUrl
                              ),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                //dense: true,
                title: Text(res.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('جاري التوصيل',style: TextStyle(color: Colors.red),),
                Text('  ${currentOreder!.orderTime.hour}:${currentOreder.orderTime.minute}  ${currentOreder.orderTime.day}/${currentOreder!.orderTime.month}/${currentOreder!.orderTime.year}'),
                ],
                ),
                isThreeLine: true ,
                ),
                Divider(),
                ListTile(
                leading: Icon(Icons.shop,size: 60,),
                isThreeLine: true,
                title: Text('معلومات عن الطالب',style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,

                children: [
                Text('الاسم : '+'${Provider.of<CurrentCustomer>(context, listen: false).customerInfo!.displayName}'),
                Row(
                  children: [
                    Text('رقم الهاتف : '),
                    GestureDetector(
                      child: Text('${Provider.of<CurrentCustomer>(context, listen: false).customerInfo!.phoneNumber}',style: TextStyle(color:  Colors.blue,decoration: TextDecoration.underline,)),
                      onTap: (){launch("tel://"+'${Provider.of<CurrentCustomer>(context, listen: false).customerInfo!.phoneNumber}');},

                      //child: TextButton(onPressed:(){launch("tel://"+'${Provider.of<CurrentCustomer>(context, listen: false).customerInfo!.phoneNumber}');},child: Text('${Provider.of<CurrentCustomer>(context, listen: false).customerInfo!.phoneNumber}',
                      //style: TextStyle(color:  Colors.blue,decoration: TextDecoration.underline,)),),
                    ),
                  ],
                ),
                Row(
                children: [
                Text('العنوان: '),
                GestureDetector(
                child: Text('الخريطة',
                style: TextStyle(color:  Colors.blue,decoration: TextDecoration.underline,)),
                onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Map()));},

                //child: TextButton(onPressed:(){launch("tel://"+'${Provider.of<CurrentCustomer>(context, listen: false).customerInfo!.phoneNumber}');},child: Text('${Provider.of<CurrentCustomer>(context, listen: false).customerInfo!.phoneNumber}',
                //style: TextStyle(color:  Colors.blue,decoration: TextDecoration.underline,)),),
                ),
                ],
                ),

                ],),
                ),
                Divider(),
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('تفاصيل الطلب',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                ],
                ),
                for(var i in currentOreder.items) Container(
                height: 40,
                child:Padding(
                padding: const EdgeInsets.only(left:10.0, right: 10),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text('x${i.quantity}  ${i.name}'),
                Text('${i.quantity*i.price}(ج.م)'),
                ],
                ),
                ),),

                Divider(),
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('الايصال',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                ],
                ),
                Container(
                height: 40,
                child: Padding(
                padding: const EdgeInsets.only(left:10.0, right: 10),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text('سعر الطلبات' ,style: TextStyle(fontWeight: FontWeight.bold),),
                Text('${currentOreder.totalAmount}(ج.م)'),
                ],
                ),
                ),
                ),
                Container(
                height: 40,
                child: Padding(
                padding: const EdgeInsets.only(left:10.0, right: 10),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text('سعر الخدمة' ,style: TextStyle(fontWeight: FontWeight.bold),),
                Text('${res.price}(ج.م)'),
                ],
                ),
                ),
                ),
                Container(
                height: 40,
                child: Padding(
                padding: const EdgeInsets.only(left:10.0, right: 10),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text('الاجمالي' ,style: TextStyle(fontWeight: FontWeight.bold),),
                Text('${res.price+currentOreder.totalAmount}(ج.م)'),
                ],
                ),
                ),
                ),
                SizedBox(height: 20),
                FloatingActionButton(onPressed:() async {
                await Provider.of<orders>(
                context, listen: false).orederIsDeliverd();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>next()));
                //Provider.of<orders>(context, listen: false).getFirstOtder();
                },child: new Icon(Icons.check),)


                ],
                ),
                ):Center(
                      child: Column(
                        children: [
                          Text('false',
                            style:TextStyle(fontSize: 20,color: Color(0xFFFF7643),fontWeight: FontWeight.bold),),


                        ],
                      ),
                    );
                  }
                }
              },
            ),
        ),
      ),
    );
  }
}