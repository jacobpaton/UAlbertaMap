import 'package:flutter/material.dart';
import 'package:ualberta_campus_map/feature.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Campus extends Feature {
  double _zoom;
  double _tilt;

  Campus(String title, LatLng position, BuildContext context, {double zoom, double tilt})
      : super(title, position, context, Icons.account_balance, BitmapDescriptor.hueRed) {
    zoom ??= 15.0;
    tilt ??= 0.0;
    this._zoom = zoom;
    this._tilt = tilt;
  }

  double get tilt => _tilt;

  double get zoom => _zoom;


}
