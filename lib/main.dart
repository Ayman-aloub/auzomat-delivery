import 'package:auzomat_admin/provider/CurrentCustomer.dart';
import 'package:auzomat_admin/provider/Restaurant.dart';
import 'package:auzomat_admin/provider/auth.dart';
import 'package:auzomat_admin/provider/orders.dart';
import 'package:auzomat_admin/provider/thems.dart';
import 'package:auzomat_admin/screens/map.dart';
import 'package:auzomat_admin/screens/logn.dart';
import 'package:auzomat_admin/screens/next.dart';
import 'package:auzomat_admin/screens/splash_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();

  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  /*var to_map;
  MyApp(this.to_map);
   */

  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {




  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: themes(),
        ),

        ChangeNotifierProxyProvider<Auth,orders>(
            create: (context) => orders(),
            update: (_,auth,res) => res!..setUser(auth.userId)
        ),
        ChangeNotifierProvider.value(
        value: CurrentCustomer(),),
        ChangeNotifierProvider.value(
          value: Restaurant(),
        ),




      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => Consumer<themes>(
          builder: (context,theme,_)=> MaterialApp(
            //builder: DevicePreview.appBuilder,
            title: 'عزومات',
            theme:theme.getthemeData(),/* ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),*/
            debugShowCheckedModeBanner: false,
            //home: Map(),
            home: auth.isAuth?next():FutureBuilder(future:auth.autoLogn(),builder: (ctxn,snapshot)=>snapshot.connectionState==ConnectionState.waiting?SplashPage():login()),
            //home: auth.isAuth?next():FutureBuilder(future:auth.autoLogn(),builder: (ctxn,snapshot)=>snapshot.connectionState==ConnectionState.waiting?SplashPage():auth.isAuth?next():login()),




          ),
        ),
      ),
    );


  }
}
