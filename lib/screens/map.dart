import 'dart:async';

import 'package:auzomat_admin/provider/CurrentCustomer.dart';
import 'package:auzomat_admin/provider/Restaurant.dart';
import 'package:auzomat_admin/provider/orders.dart';
import 'package:auzomat_admin/services/geolocator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/core/ripple_marker.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class Map extends StatefulWidget {
  var saveLocation;
  Map([this.saveLocation=false]);

  static const routeName = '/map';



  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<Map> {
  int _selectedIndex = 0;
  final GeolocatorService geoService = GeolocatorService();


  Completer<GoogleMapController> _controller = Completer();
  //String? searchAddr;
  List<Marker> markers=[];
  LatLng? restauratLocation;
  LatLng? customerLocation;
  LatLng? p;
  bool is_apload=false;
  LatLng? inti;
  BitmapDescriptor? customIcon;



  @override void didChangeDependencies() {
    customerLocation=Provider.of<CurrentCustomer>(context, listen: false).customerInfo!.myLocation;
    restauratLocation=Provider.of<Restaurant>(context, listen: false).currentResstaurant!.location;
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(configuration, 'assets/p4.png')
        .then((icon) {

      Marker mkcustomer=Marker(markerId: MarkerId('customer'),position: customerLocation!,icon: icon!);
      markers.add(mkcustomer);

      customIcon = icon;
      
    }).catchError((e){
      Marker mkcustomer=Marker(markerId: MarkerId('customer'),position: customerLocation!);
      markers.add(mkcustomer);
    });
    BitmapDescriptor.fromAssetImage(configuration, 'assets/bbb.png')
        .then((icon) {

      Marker mkcustomer=Marker(markerId: MarkerId('restaurant'),position: restauratLocation!,icon: icon!);
      markers.add(mkcustomer);

      customIcon = icon;

    }).catchError((e){
      Marker mkcustomer=Marker(markerId: MarkerId('restaurant'),position: restauratLocation!);
      markers.add(mkcustomer);
    });


    //Marker mkcustomer=Marker(markerId: MarkerId('customer'),position: customerLocation!,icon: customIcon!);
    //Marker mkrestaurant=Marker(markerId: MarkerId('restaurant'),position: restauratLocation!);
    //markers.add(mkrestaurant);
    //markers.add(mkcustomer);

    enablelocation().then((value){
      inti = LatLng(value.latitude,value.longitude) ;
      p=inti!;
      setState(() {
        is_apload= true;
      });

    }).catchError((onError){});


    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  Future<void> _onItemTapped(int index) async {
    print(index);
    if(index==0){
      Position value=await geoService.getInitialLocation();
      p=LatLng(value.latitude, value.longitude);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:LatLng(value.latitude, value.longitude),
          zoom: 17.0)));

    }else if(index==1){
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:customerLocation!,
          zoom: 17.0)));

    }else{
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:restauratLocation!,
          zoom: 17.0)));

    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {

    super.initState();
  }
  Widget menu() {
    return  BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.update),
          label: 'موقعي',
          backgroundColor: Colors.deepOrange,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          label: 'العميل',
          backgroundColor:Colors.deepOrange,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          label: 'المطعم',
          backgroundColor:Colors.deepOrange,
        ),


      ],
      backgroundColor: Theme.of(context).backgroundColor,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.greenAccent,
      onTap: _onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {

    return  Directionality(
      textDirection:  TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor:Theme.of(context).backgroundColor,
              title: Center(child: Text('الخريطة ')),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,

                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

          bottomNavigationBar: menu(),
          body: !is_apload?Center(child: CircularProgressIndicator(),):Stack(
                    children: [
                      GoogleMap(
                        /*onTap: (mkposition){
                          Marker mk=Marker(markerId: MarkerId('orderPosition'),position: mkposition);
                          // print("latitude"+(mkposition.latitude).toString());
                          //print("longitude"+(mkposition.longitude).toString());
                          print('marker :${mkposition.latitude}');

                          setState(() {
                            p=LatLng(mkposition.latitude,mkposition.longitude);
                            markers.add(mk);

                          });
                        },*/
                        markers:Set.from(markers),



                        initialCameraPosition: CameraPosition(
                            target: inti!,
                            zoom: 17.0),
                        mapType: MapType.normal,


                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },

                      ),



                    ])

          ),
      ),
    );

  }

  Future<void> centerScreen(Position position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 18.0)));
  }
  Future<Position> enablelocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    /*PermissionStatus _permissionGranted;
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>enable_location()));

      }
    }*/


    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        //return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>enable_location()));
      }
    }


    Position value=await geoService.getInitialLocation();
    //inti = LatLng(value.latitude,value.longitude) ;
    //p=inti;
    return value;

  }
}
