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

  @override
  Widget build(BuildContext context) {

    googleMap = GoogleMap(
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      initialCameraPosition: _initialCamera,
      mapType: MapType.terrain,
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('AirHive'),
          backgroundColor: Colors.yellow[700],
        ),
        drawer: new Drawer(
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
        ),
        body: googleMap,
      ),
    );
  }
}
