import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/color.dart';



class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {

    // TODO: implement initState
    super.initState();

   /* Timer(const Duration(milliseconds: 4000), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [orangeColors, orangeLightColors],
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter),
          ),
          /*child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "dev_assets/icon.jpeg",
                height: MediaQuery.of(context).size.height*0.8,
                width: MediaQuery.of(context).size.width*0.8,
              ),
            ],
          ),*/
          child: Center(
            child:Container(
              width: double.infinity,
              height: MediaQuery.of(context).orientation==Orientation.portrait? MediaQuery.of(context).size.height*0.1:MediaQuery.of(context).size.width*0.1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text("3zomat",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              ),
              ),
          ),
        ),
      ),
    );
  }
}
