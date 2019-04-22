import 'package:flutter/material.dart';
import 'package:ualberta_campus_map/feature.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CoffeeShop extends Feature {

  CoffeeShop(String title, LatLng position, BuildContext context) : super(title, position, context, Icons.local_cafe, BitmapDescriptor.hueRose);
}