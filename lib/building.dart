import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ualberta_campus_map/feature.dart';

class Building extends Feature {
  // TODO: Hours
  String address;

  Building(String title, LatLng position, BuildContext context) : super(title, position, context, Icons.business, BitmapDescriptor.hueAzure);
}