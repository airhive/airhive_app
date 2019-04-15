import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

Future<Sensori> fetchPhotos(http.Client client) async {
  final response =
  await client.get('https://house.zan-tech.com/dati/');

  // Use the compute function to run parsePhotos in a separate isolate
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>
Sensori parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  print(parsed);

  return parsed.map<Sensori>((json) => Sensori.fromJson(json)).toList();
}

class Properties{
  final String id_sensore;
  final double pm_10;
  final double pm_10_1;
  final double pm_10_2;
  final double pm_10_3;
  final double temp;
  final double umi;
  final double prec;
  final double vento;

  Properties({
    this.id_sensore,
    this.pm_10,
    this.pm_10_1,
    this.pm_10_2,
    this.pm_10_3,
    this.temp,
    this.umi,
    this.prec,
    this.vento,
  });

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      id_sensore: json['id_sensore'] as String,
      pm_10: json['pm10'] as double,
      pm_10_1: json['pm10-1'] as double,
      pm_10_2: json['pm10-2'] as double,
      pm_10_3: json['pm10-3'] as double,
      temp: json['temp'] as double,
      umi: json['umi'] as double,
      prec: json['prec'] as double,
      vento: json['vento'] as double,
    );
  }
}

class Geometry{
  final String type;
  final List<double> coordinates;

  Geometry({
    this.type,
    this.coordinates,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'] as String,
      coordinates: json['coordinates'] as List<double>,
    );
  }
}

class Features{
  final String type;
  final Geometry geometry;
  final Properties properties;

  Features({
    this.type,
    this.geometry,
    this.properties,
  });

  factory Features.fromJson(Map<String, dynamic> json) {

    return Features(
      type: json['type'] as String,
      geometry : Geometry.fromJson(json['geometry']),
      properties : Properties.fromJson(json['properties']),
    );
  }
}

class Sensori {
  final String type;
  final String tempo;
  final List<Features> features;

  Sensori({
    this.type,
    this.tempo,
    this.features,
  });

  factory Sensori.fromJson(Map<String, dynamic> json) {
    var list = json['features'] as List;
    print(list);
    List<Features> featureslist = list.map((i) => Features.fromJson(i)).toList();

    return Sensori(
      type: json['type'] as String,
      tempo: json['tempo'] as String,
      features: featureslist,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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

  bool pressed = false;

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
        key: _scaffoldKey,
        drawer: MenuLaterale,
        body: Stack(
            children: <Widget>[
              googleMap,
              new Align(
                alignment: FractionalOffset(0.01, 0.02),
                child: GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: new Image.asset(
                      "immagini/airhive.png",
                      scale: 7.5,
                  ),
                ),),
              new Align(
                      alignment: FractionalOffset(0.95, 0.87),
                      child: FloatingActionButton(
                        onPressed: () => _currentLocation(),
                        tooltip: 'Localizzami',
                        child: Icon(Icons.location_on),
                        backgroundColor: Colors.yellow[700].withOpacity(0.95),
                        elevation: 1.0,
                      )
                  ),
              new Align(
                  alignment: FractionalOffset(0.95, 0.96),
                  child: FloatingActionButton(
                    onPressed: () => {},
                    tooltip: 'Cerca',
                    child: Icon(Icons.search),
                    backgroundColor: Colors.yellow[700].withOpacity(0.95),
                    elevation: 1.0,
                  )
              ),
              pressed ? Text(" text is here ") : SizedBox(),
              RaisedButton(
                child: Text(pressed.toString()),
                onPressed: () {
                  setState(() {
                    pressed = true;
                  });
                },
              )
            ], ),
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
        zoom: 16.0,
      ),
    ));
  }
}


