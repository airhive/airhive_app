import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

LatLng posizione_assoluta = LatLng(45.4510525, 9.4126428);

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
  final List<dynamic> coordinates;

  Geometry({
    this.type,
    this.coordinates,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'] as String,
      coordinates: json['coordinates'] as List<dynamic>,
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
    List<Features> featureslist = list.map((i) => Features.fromJson(i)).toList();

    return Sensori(
      type: json['type'] as String,
      tempo: json['tempo'] as String,
      features: featureslist,
    );
  }
}

//void main() => runApp(MyApp());
main() async {
  await PrefService.init(prefix: 'pref_');
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//Writing Settings page code
class SettingsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: menulaterale(context),
        appBar: new AppBar(
          title: new Text("Impostazioni"),
          backgroundColor: Colors.yellow[700],
        ),
        body: new PreferencePage([
          PreferenceTitle("Mappa")

          ),
        ]),



        ),
      );
  }
}

//Writing account page code
class AccountPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: menulaterale(context),
        appBar: new AppBar(
          title: new Text("Account"),
          backgroundColor: Colors.yellow[700],
        ),
        body: new Text("Qui sarà inserita la pagina di relativa all'account"),
      ),
    );
  }
}

class _MyHomePageState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _initialCamera = CameraPosition(
    target: posizione_assoluta,
    zoom: 4,
  );

  GoogleMap googleMap;
  Drawer MenuLaterale;

  final Set<Marker> _posizione = {};
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {

    googleMap = GoogleMap(
      compassEnabled: false,
      onMapCreated: _onMapCreated,
      //myLocationEnabled: true,
      initialCameraPosition: posizione_camera(),
      mapType: MapType.terrain,
      markers: _markers,
    );

    return MaterialApp(
      home: Builder(
      builder: (context) => Scaffold(
        key: _scaffoldKey,
        drawer: menulaterale(context),
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
                alignment: FractionalOffset(0.90, 0.95),
                child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                            heroTag: "localizzazione",
                            onPressed: () => _currentLocation(),
                            tooltip: 'Localizzami',
                            child: Icon(Icons.location_on),
                            backgroundColor: Colors.yellow[700].withOpacity(0.95),
                            elevation: 1.0,
                          )
                      ),
                      SizedBox(height: 10),
                      new Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          heroTag: "cerca",
                          onPressed: () => {},
                          tooltip: 'Cerca',
                          child: Icon(Icons.search),
                          backgroundColor: Colors.yellow[700].withOpacity(0.95),
                          elevation: 1.0,
                      ),
                    ),
                  ]),
                  SizedBox(width: 15),
                ]),
                ),
            ], ),
      ),
      ),
    );
  }

  Future<void> fetchData(http.Client client) async {
    final response =
    await client.get('https://house.zan-tech.com/dati/');
    final parsed = json.decode(response.body);

    Sensori res =  Sensori.fromJson(parsed);
    String tempo = res.tempo;
    List<Features> features = res.features;
    for(var i = 0; i < features.length; i++) {
      Geometry geometry = features[i].geometry;
      Properties properties = features[i].properties;
      //Trucchetto per decidere di che colore mettere il marker
      String colore = properties.pm_10 < 50 ? "arancio" : "rosso";
      colore = properties.pm_10 < 30 ? colore = "giallo" : colore;
      colore = properties.pm_10 < 15 ? colore = "blu" : colore;
      setState(() {
      _markers.add(Marker(
        markerId: MarkerId(properties.id_sensore),
        position: LatLng(geometry.coordinates[1], geometry.coordinates[0]),
        alpha : 0.6,
        infoWindow: InfoWindow(
          title: properties.id_sensore,
          snippet: properties.pm_10.toString(),
        ),
        icon: BitmapDescriptor.fromAsset("immagini/punto_$colore.png"),
      ));
    });
    }
  }

  CameraPosition posizione_camera() {
    return CameraPosition(
      target: posizione_assoluta,
      zoom: 1,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    fetchData(http.Client());
    _currentLocation();
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

    posizione_assoluta = LatLng(currentLocation.latitude, currentLocation.longitude);

      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 16.0,
        ),
      ));

      setState(() {
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId("Posizione"),
          position: posizione_assoluta,
          infoWindow: InfoWindow(
            title: 'Really cool place',
            snippet: '5 Star Rating',
          ),
          icon: BitmapDescriptor.fromAsset("immagini/ape.png"),
        ));
      });
   }
}

// Funzione che genera il menu laterale nel giusto context
Drawer menulaterale(context){
  return Drawer(
      child: new ListView(
        children: <Widget> [
          new DrawerHeader(child: new Text('AirHive'),),
          new ListTile(
            title: new Text('Mappa'),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) => new MyApp()),);
            },
          ),
          new ListTile(
            title: new Text('Account'),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) => new AccountPage()),);
            },
          ),
          new Divider(),
          new ListTile(
            title: new Text('Impostazioni'),
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(builder: (context) => new SettingsPage()),);
            },
          ),
          new Divider(),
          new ListTile(
            title: new Text('We are what we breathe.'),
            onTap: () {},
          ),
        ],
      )
  );
}