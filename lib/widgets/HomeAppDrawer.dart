import 'package:auzomat_admin/provider/auth.dart';
import 'package:auzomat_admin/provider/thems.dart';
import 'package:auzomat_admin/screens/logn.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';



class homeAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _showChart=Provider.of<themes>(context,listen: false).is_dart;
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('مرحبا بكم'),
            backgroundColor:Color(0xFFFF7643),
            automaticallyImplyLeading: false,
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.map),
            title: Text('تحديد الموقع'),
            onTap: () async {

              Navigator.pop(context);

              //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Map()));
            },
          ),
          Divider(),

          ListTile(
            leading: Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (val) {
                if(!val){
                  //_showChart=false;
                  Provider.of<themes>(context,listen:false).setlightMode();

                }else{
                  Navigator.pop(context);
                  Provider.of<themes>(context,listen:false).setDartMode();
                  //_showChart=true;

                }
              },
            ),
            title: Text('الوضع المظلم'),

          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('تسحيل الخروج'),
            onTap: () {
              Navigator.of(context).pop();

              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              Provider.of<Auth>(context, listen: false).signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>login()));
            },
          ),

        ],
      ),
    );
  }
}
