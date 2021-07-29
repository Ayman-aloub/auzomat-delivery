import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class restaurant  {
  final String id;
  final String name;
  final String description;
  final int price;
  final int time;
  final String imageUrl;
  final LatLng location;


  restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.time,
    required this.location,
    required this.imageUrl,

  });


}
