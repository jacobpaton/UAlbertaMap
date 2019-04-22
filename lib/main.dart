import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ualberta_campus_map/campus.dart';
import 'package:ualberta_campus_map/building.dart';
import 'package:ualberta_campus_map/coffee_shop.dart';
import 'feature.dart';

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
  // Campuses.
  Campus _selectedCampus;
  Campus _northCampus;
  Campus _southCampus;
  Campus _campusStJean;
  Campus _augustanaCampus;

  // Feature lists.
  List<Building> _buildings = List();
  List<CoffeeShop> _coffeeShops = List();

  // Feature display marker flags.
  bool _showBuildings = true;
  bool _showCoffeeShop = false;

  // Set of markers to display.
  Set<Marker> _markers = Set();

  @protected
  @mustCallSuper
  void initState() {
    _initFeatures();
    _selectedCampus = _northCampus;
    super.initState();
  }

  void _initFeatures() {
    // Add campuses
    _northCampus = Campus("North Campus", LatLng(53.522883, -113.525557), context);
    _southCampus = Campus("South Campus", LatLng(53.502624, -113.528480), context);
    _campusStJean = Campus("Campus St Jean", LatLng(53.522883, -113.525557), context, zoom: 12.0, tilt: 1.0);
    _augustanaCampus = Campus("Augustana Campus", LatLng(53.522883, -113.525557), context);

    // Add buildings
    _buildings.add(Building("Lister Centre", LatLng(53.522315, -113.530421), context));
    _buildings.add(Building("Butter Dome", LatLng(53.523429, -113.527846), context));
    _buildings.add(Building("Van Vliet", LatLng(53.524092, -113.527443), context));
    _buildings.add(Building("Wilson Climbing Centre", LatLng(53.523221, -113.526165), context));
    _buildings.add(Building("Administration", LatLng(53.525267, -113.525473), context));
    _buildings.add(Building("Agriculture/Forestry Centre", LatLng(53.526121, -113.528029), context));

    // Add coffee shops
    _coffeeShops.add(CoffeeShop("ECHA Starbucks", LatLng(53.522277, -113.526477), context));
  }

  Future<void> _goToCampus() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _selectedCampus.pos,
        zoom: _selectedCampus.zoom, tilt: _selectedCampus.tilt)));
  }

  void _updateMarkers() {
    // Empty markers and add current campus marker
    _markers.clear();
    _markers.add(_selectedCampus.marker);

    // Add enabled markers for enabled features
    if (_showBuildings)
      _addMarkers(_buildings);
    if (_showCoffeeShop)
      _addMarkers(_coffeeShops);
  }

  void _addMarkers(List<Feature> _featuresToAdd) {
    for (Feature feature in _featuresToAdd) {
      _markers.add(feature.marker);
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateMarkers();

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
                child: Column(
                  children: <Widget>[
                    Text("Yeet!"),
                    //Image.asset("assets/graphics/ualberta_seal.png", fit: BoxFit.cover,),
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
                height: 2.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0,),
                child: Row(
                  children: <Widget>[
                    Text("Campus: "),
                    DropdownButton<Campus>(
                      value: _selectedCampus,
                      onChanged: (Campus newValue) {
                        setState(() {
                          print(_markers.contains(_selectedCampus.marker));
                          _selectedCampus = newValue;
                          _goToCampus();
                        });
                      },
                      items: <Campus>[_northCampus, _southCampus, _campusStJean, _augustanaCampus]
                          .map<DropdownMenuItem<Campus>>((Campus campus) {
                        return DropdownMenuItem<Campus>(
                          value: campus,
                          child: Text(campus.title),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              CheckboxListTile(
                title: const Text('Campus Buildings'),
                value: _showBuildings,
                activeColor: Colors.amber.withOpacity(0.8),
                onChanged: (bool value) {
                  setState(() {
                    _showBuildings = !_showBuildings;
                    _updateMarkers();
                  });
                },
                secondary: Icon(Icons.business, color: Colors.amber.withOpacity(0.95),),
              ),
              CheckboxListTile(
                title: const Text('Coffee Shops'),
                value: _showCoffeeShop,
                activeColor: Colors.amber.withOpacity(0.8),
                onChanged: (bool value) {
                  setState(() {
                    _showCoffeeShop = !_showCoffeeShop;
                    _updateMarkers();
                  });
                },
                secondary: Icon(Icons.local_cafe, color: Colors.amber.withOpacity(0.95),),
              ),
              Divider(
                color: Colors.black,
                height: 2.0,
              ),
              ListTile(
                title: const Text('About'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: _selectedCampus.pos, zoom: 15.0),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: _goToCampus, icon: Icon(Icons.my_location), label: Text("Go To Campus")),
    );
  }
}
