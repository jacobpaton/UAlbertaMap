import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainMapPage(title: 'UAlberta Campus Maps'),
    );
  }
}

class MainMapPage extends StatefulWidget {
  MainMapPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainMapPageState createState() => _MainMapPageState();
}

class _MainMapPageState extends State<MainMapPage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _northcampus = CameraPosition(
    target: LatLng(53.522883, -113.525557),
    zoom: 15.0,
    tilt: 0.0,
  );

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_northcampus));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(color: Colors.green),
          child: Column(
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.all(16.0),
                child: Text("Yeet!"),
              ),
            ],
          ),
        ),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _northcampus,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text("Find me!"),
        icon: Icon(Icons.my_location),
        shape: RoundedRectangleBorder(),
      ),
    );
  }
}
