import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

abstract class Feature {
  LatLng _pos;
  String _title;
  Marker _marker;
  String _uuid;
  double _hue;
  IconData _icon;
  BuildContext _context;

  Feature(this._title, this._pos, this._context, this._icon, this._hue) {
    _uuid = (Uuid()).v1();
    _marker = Marker(markerId: MarkerId(_uuid), position: _pos, icon: BitmapDescriptor.defaultMarkerWithHue(_hue),
      infoWindow: InfoWindow(title: _title, onTap: displayFeature),);
  }

  void displayFeature() {
    showModalBottomSheet<void>(context: _context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(_icon),
                title: Text(_title),
                onTap: () {},
              ),
            ],
          );
        });
  }

//  Getters and Setters
  LatLng get pos => _pos;

  String get title => _title;

  Marker get marker => _marker;
}