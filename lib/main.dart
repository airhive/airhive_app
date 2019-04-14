import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(0, 0),
    zoom: 4,
  );

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  GoogleMap googleMap;
  Drawer MenuLaterale;

  @override
  Widget build(BuildContext context) {

    MenuLaterale = new Drawer(
        child: new ListView(
          children: <Widget> [
            new DrawerHeader(child: new Text('AirHive'),),
            new ListTile(
              title: new Text('Roba uno'),
              onTap: () {},
            ),
            new ListTile(
              title: new Text('Roba due'),
              onTap: () {},
            ),
            new Divider(),
            new ListTile(
              title: new Text('We are what we breathe.'),
              onTap: () {},
            ),
          ],
        )
    );

    googleMap = GoogleMap(
      onMapCreated: _onMapCreated,
      //myLocationEnabled: true,
      initialCameraPosition: _initialCamera,
      mapType: MapType.terrain,
    );

    return MaterialApp(
      home: Scaffold(
          drawer: MenuLaterale,
        body: Stack(
            children: <Widget>[
              googleMap,
              new Positioned( //Place it at the top, and not use the entire screen
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: AppBar(title: Text('AirHive', style: TextStyle(
                  color: Colors.white,
                  //background: Paint()..color = Colors.blue,
                ),),
                  backgroundColor: Colors.transparent,
                  elevation: 1.0, //Shadow gone
                ),),
            ], ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _currentLocation,
          label: Text('Localizzami'),
          icon: Icon(Icons.location_on),
          backgroundColor: Colors.transparent,
          elevation: 1.0,
        ),
      ),
    );
  }

  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.0,
      ),
    ));
  }

}


