import 'package:auzomat_admin/provider/CurrentCustomer.dart';
import 'package:auzomat_admin/provider/auth.dart';
import 'package:auzomat_admin/provider/orders.dart';
import 'package:auzomat_admin/screens/currentOrderScreen.dart';
import 'package:auzomat_admin/screens/logn.dart';
import 'package:auzomat_admin/widgets/HomeAppDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class next extends StatefulWidget {
  @override
  _nextState createState() => _nextState();
}

class _nextState extends State<next> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,

            title: Center(
              child: Text(
                "الصفحة الرئسية",
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
            future: Provider.of<orders>(context, listen: false).check(),
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
                  //if(dataSnapshot.data != null&&dataSnapshot.data==true){Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>orderItemsScreen()));}
                  return dataSnapshot.data != null&&dataSnapshot.data==true?Center(
                    child: TextButton(onPressed: () async {
                      await Provider.of<CurrentCustomer>(context,listen: false).getCustomerNanePhone(Provider.of<orders>(context,listen: false).currentOtder!.customer);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>orderItemsScreen()));

                      //Provider.of<orders>(context, listen: false).getFirstOtder();
                    }, child: Text('الحصول علي بيانات الطلب',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23,color: Theme.of(context).accentColor),)),
                  ) :Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: TextButton(onPressed: () async {
                          await Provider.of<orders>(
                              context, listen: false).downloadOrders();
                          if(Provider.of<orders>(
                              context, listen: false).currentOtder!=null){
                            setState(() {

                            });

                          }

                          //Provider.of<orders>(context, listen: false).getFirstOtder();
                        }, child: Text('الحصول علي طلب',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23,color: Theme.of(context).accentColor),)),
                      ),


                    ],
                  );
                }
              }
            },
          ),
          /*Center(
            child: Column(
              children: [
                Text('hello',style: TextStyle(fontSize: 30),),
                TextButton(onPressed: () async {
                  await Provider.of<Auth>(
                      context, listen: false).signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>login()));
                }, child: Text('signOut')),
                TextButton(onPressed: () async {
                  await Provider.of<orders>(
                      context, listen: false).downloadOrders();
                   //Provider.of<orders>(context, listen: false).getFirstOtder();
                }, child: Text('orders')),
                TextButton(onPressed: () async {
                  await Provider.of<orders>(
                      context, listen: false).orederIsDeliverd();
                  //Provider.of<orders>(context, listen: false).getFirstOtder();
                }, child: Text('is delivered'))

              ],
            ),
          ),*/
        ),
      ),
    );
  }
}
