part of "main.dart";

LatLng posizione_assoluta = LatLng(45.4510525, 9.4126428);

class Pm{
  final double pm_10_4;
  final double pm_10_3;
  final double pm_10_2;
  final double pm_10_1;
  final double pm_10;
  final double pm_10p1;
  final double pm_10p2;
  final double pm_10p3;
  final double pm_10p4;

  Pm({
    this.pm_10_4,
    this.pm_10_3,
    this.pm_10_2,
    this.pm_10_1,
    this.pm_10,
    this.pm_10p1,
    this.pm_10p2,
    this.pm_10p3,
    this.pm_10p4,
});

  factory Pm.fromJson(Map<String, dynamic> json) {
    return Pm(
      pm_10_4: json['pm10-4'] as double,
      pm_10_3: json['pm10-3'] as double,
      pm_10_2: json['pm10-2'] as double,
      pm_10_1: json['pm10-1'] as double,
      pm_10: json['pm10'] as double,
      pm_10p1: json['pm10+1'] as double,
      pm_10p2: json['pm10+2'] as double,
      pm_10p3: json['pm10+3'] as double,
      pm_10p4: json['pm10+4'] as double,
    );
  }
}

class No{
  final double no_4;
  final double no_3;
  final double no_2;
  final double no_1;
  final double no;
  final double nop1;
  final double nop2;
  final double nop3;
  final double nop4;

  No({
    this.no_4,
    this.no_3,
    this.no_2,
    this.no_1,
    this.no,
    this.nop1,
    this.nop2,
    this.nop3,
    this.nop4,
  });

  factory No.fromJson(Map<String, dynamic> json) {
    return No(
      no_4: json['no2-4'] as double,
      no_3: json['no2-3'] as double,
      no_2: json['no2-2'] as double,
      no_1: json['no2-1'] as double,
      no: json['no2'] as double,
      nop1: json['no2+1'] as double,
      nop2: json['no2+2'] as double,
      nop3: json['no2+3'] as double,
      nop4: json['no2+4'] as double,
    );
  }
}

class O3{
  final double o3_4;
  final double o3_3;
  final double o3_2;
  final double o3_1;
  final double o3;
  final double o3p1;
  final double o3p2;
  final double o3p3;
  final double o3p4;

  O3({
    this.o3_4,
    this.o3_3,
    this.o3_2,
    this.o3_1,
    this.o3,
    this.o3p1,
    this.o3p2,
    this.o3p3,
    this.o3p4,
  });

  factory O3.fromJson(Map<String, dynamic> json) {
    return O3(
      o3_4: json['o3-4'] as double,
      o3_3: json['o3-3'] as double,
      o3_2: json['o3-2'] as double,
      o3_1: json['o3-1'] as double,
      o3: json['o3'] as double,
      o3p1: json['o3+1'] as double,
      o3p2: json['o3+2'] as double,
      o3p3: json['o3+3'] as double,
      o3p4: json['o3+4'] as double,
    );
  }
}

class Properties{
  final String id_sensore;
  final Pm pm_10;
  final No no2;
  final O3 o3;
  double caqi;

  Properties({
    this.id_sensore,
    this.pm_10,
    this.no2,
    this.o3,
    this.caqi,
  });

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      id_sensore: json['id_sensore'] as String,
      pm_10: Pm.fromJson(json['pm']) as Pm,
      no2: No.fromJson(json["no2"]) as No,
      o3: O3.fromJson(json["o3"]) as O3,
      caqi: 0.0,
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

class GraficoLineare{
  final int momento;
  final double valore;

  GraficoLineare(this.momento, this.valore);
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();

  //Firebase
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _textcontroller = TextEditingController();

  //Google Maps
  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(45.4510525, 9.4126428),
    zoom: 0.1,
  );
  GoogleMap googleMap;

  // apri_info decide se la barra con le info dei marker deve essere aperta o meno
  bool apri_info = false;
  double valore_aqi;
  Properties valori_sensore;

  bool apri_ricerca = false;
  String testo_ricerca = "";
  Position risultato_ricerca;

  Set<Marker> _markers = {};
  Set<Marker> _oldmarker = {};
  final Set<Marker> _markerscaqi = {};
  final Set<Marker> _markerspm = {};

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      print(token);
    });
  }


  @override
  Widget build(BuildContext context) {

    googleMap = GoogleMap(
      onTap: _googlemaptap,
      compassEnabled: false,
      onMapCreated: _onMapCreated,
      myLocationEnabled: false,
      initialCameraPosition: _initialCamera,
      markers: _markers,
      mapType: ListOfMaps[currMapNum], //Also change map type
    );


    return new Scaffold(
          key: _scaffoldKey,
          //resizeToAvoidBottomInset: false,
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
                                  child: Icon(Icons.location_on, color: Colors.white),
                                  backgroundColor: Colors.yellow[700].withOpacity(0.95),
                                  elevation: 1.0,
                                )
                            ),
                            SizedBox(height: 10),
                            new Align(
                              alignment: Alignment.bottomRight,
                              child: FloatingActionButton(
                                heroTag: "cerca",
                                onPressed: () => {
                                setState(() {
                                  apri_ricerca = true;
                                }
                                )
                                },
                                tooltip: 'Cerca',
                                child: Icon(Icons.search, color: Colors.white),
                                backgroundColor: Colors.yellow[700].withOpacity(0.95),
                                elevation: 1.0,
                              ),
                            ),
                          ]),
                      SizedBox(width: 15),
                    ]),
              ),
              apri_info ? new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    height : 200,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget> [
                          Container(
                            color: Colors.white,
                            width: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                valori_sensore.caqi < 70 ? Text("Bel tempo zio"):Text("NON APRIRE LA FINESTRA"),
                              ],
                            ),
                          ),
                          Container(
                            width: 20.0,
                            color: Colors.yellow[700],
                          ),
                          Container(
                            color: Colors.white,
                            width: 50,
                            child: Center(
                              child: new RotatedBox(
                                  quarterTurns: -1,
                                  child: new Text(
                                    "Presente",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                    ),
                                  )
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            width: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                LinearPercentIndicator(
                                  trailing: Expanded(child: Text("CAQI")),
                                  center: Text(valori_sensore.caqi.toStringAsFixed(2)),
                                  width: 160.0,
                                  lineHeight: 14.0,
                                  percent: valori_sensore.caqi / 150,
                                  backgroundColor: Colors.green,
                                  progressColor: Colors.red,
                                ),
                                LinearPercentIndicator(
                                  trailing: Expanded(child: Text("PM10")),
                                  center: Text(valori_sensore.pm_10.pm_10.toString()),
                                  width: 160.0,
                                  lineHeight: 14.0,
                                  percent: valori_sensore.pm_10.pm_10 / 150,
                                  backgroundColor: Colors.green,
                                  progressColor: Colors.red,
                                ),
                                LinearPercentIndicator(
                                  trailing: Expanded(child: Text("NO2")),
                                  center: Text(valori_sensore.no2.no.toString()),
                                  width: 160.0,
                                  lineHeight: 14.0,
                                  percent: valori_sensore.no2.no / 500,
                                  backgroundColor: Colors.green,
                                  progressColor: Colors.red,
                                ),
                                LinearPercentIndicator(
                                  trailing: Expanded(child: Text("O3")),
                                  center: Text(valori_sensore.o3.o3.toString()),
                                  width: 160.0,
                                  lineHeight: 14.0,
                                  percent: valori_sensore.o3.o3 / 400,
                                  backgroundColor: Colors.green,
                                  progressColor: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 20.0,
                            color: Colors.yellow[700],
                          ),
                          Container(
                            color: Colors.white,
                            width: 50,
                            child: Center(
                              child: new RotatedBox(
                                  quarterTurns: -1,
                                  child: new Text(
                                    "Passato",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                    ),
                                  )
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            width: 350,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: <Widget> [
                                Container(
                                  color: Colors.white,
                                  height: 200,
                                  child: new charts.LineChart(
                                      _datiChartCAQI(),
                                      defaultRenderer: new charts.LineRendererConfig(includeArea: true, stacked: true),
                                      animate: true,
                                      behaviors: [
                                        new charts.ChartTitle(
                                            'CAQI',
                                            behaviorPosition: charts.BehaviorPosition.start,
                                            titleOutsideJustification:
                                            charts.OutsideJustification.middleDrawArea),
                                        new charts.ChartTitle(
                                          'Tempo',
                                          behaviorPosition: charts.BehaviorPosition.bottom,
                                          titleOutsideJustification:
                                          charts.OutsideJustification.middleDrawArea),
                                        new charts.SeriesLegend(
                                            position: charts.BehaviorPosition.end, desiredMaxRows: 3),
                                      ],
                                    ),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: 200,
                                  child: new charts.LineChart(
                                    _datiStoricoChartPM(),
                                    defaultRenderer: new charts.LineRendererConfig(includeArea: true),
                                    animate: true,
                                    behaviors: [
                                      new charts.ChartTitle(
                                          'PM',
                                          behaviorPosition: charts.BehaviorPosition.start,
                                          titleOutsideJustification:
                                          charts.OutsideJustification.middleDrawArea),
                                      new charts.ChartTitle(
                                          'Tempo',
                                          behaviorPosition: charts.BehaviorPosition.bottom,
                                          titleOutsideJustification:
                                          charts.OutsideJustification.middleDrawArea),
                                      new charts.SeriesLegend(
                                          position: charts.BehaviorPosition.end, desiredMaxRows: 2),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: 200,
                                  child: new charts.LineChart(
                                    _datiStoricoChartNO2(),
                                    defaultRenderer: new charts.LineRendererConfig(includeArea: true),
                                    animate: true,
                                    behaviors: [
                                      new charts.ChartTitle(
                                          'NO2',
                                          behaviorPosition: charts.BehaviorPosition.start,
                                          titleOutsideJustification:
                                          charts.OutsideJustification.middleDrawArea),
                                      new charts.ChartTitle(
                                          'Tempo',
                                          behaviorPosition: charts.BehaviorPosition.bottom,
                                          titleOutsideJustification:
                                          charts.OutsideJustification.middleDrawArea),
                                      new charts.SeriesLegend(
                                          position: charts.BehaviorPosition.end, desiredMaxRows: 2),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: 200,
                                  child: new charts.LineChart(
                                    _datiStoricoChartO3(),
                                    defaultRenderer: new charts.LineRendererConfig(includeArea: true),
                                    animate: true,
                                    behaviors: [
                                      new charts.ChartTitle(
                                          'O3',
                                          behaviorPosition: charts.BehaviorPosition.start,
                                          titleOutsideJustification:
                                          charts.OutsideJustification.middleDrawArea),
                                      new charts.ChartTitle(
                                          'Tempo',
                                          behaviorPosition: charts.BehaviorPosition.bottom,
                                          titleOutsideJustification:
                                          charts.OutsideJustification.middleDrawArea),
                                      new charts.SeriesLegend(
                                          position: charts.BehaviorPosition.end, desiredMaxRows: 2),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 20.0,
                            color: Colors.yellow[700],
                          ),
                          Container(
                            color: Colors.white,
                            width: 50,
                            child: Center(
                              child: new RotatedBox(
                                  quarterTurns: -1,
                                  child: new Text(
                                    "Futuro",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                    ),
                                  )
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            width: 350,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: <Widget> [
                                Container(
                                  color: Colors.white,
                                  height: 200,
                                  child: new charts.LineChart(
                                    _datiFuturiChartCAQI(),
                                    defaultRenderer: new charts.LineRendererConfig(includeArea: true, stacked: true),
                                    animate: true,
                                    behaviors: [
                                      new charts.ChartTitle(
                                          'CAQI',
                                          behaviorPosition: charts.BehaviorPosition.start,
                                          titleOutsideJustification:
                                          charts.OutsideJustification.middleDrawArea),
                                      new charts.ChartTitle(
                                          'Tempo',
                                          behaviorPosition: charts.BehaviorPosition.bottom,
                                          titleOutsideJustification:
                                          charts.OutsideJustification.middleDrawArea),
                                      new charts.SeriesLegend(
                                          position: charts.BehaviorPosition.end, desiredMaxRows: 3),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: 200,
                                  child: new charts.LineChart(
                                    _datiFuturiChartPM(),
                                    defaultRenderer: new charts.LineRendererConfig(includeArea: true),
                                    animate: true,
                                    behaviors: [
                                      new charts.ChartTitle(
                                          'PM',
                                          behaviorPosition: charts.BehaviorPosition.start,
                                          titleOutsideJustification:
                                          charts.OutsideJustification.middleDrawArea),
                                      new charts.ChartTitle(
                                          'Tempo',
                                          behaviorPosition: charts.BehaviorPosition.bottom,
                                          titleOutsideJustification:
                                          charts.OutsideJustification.middleDrawArea),
                                      new charts.SeriesLegend(
                                          position: charts.BehaviorPosition.end, desiredMaxRows: 2),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: 200,
                                  child: new charts.LineChart(
                                    _datiFuturiChartNO2(),
                                    defaultRenderer: new charts.LineRendererConfig(includeArea: true),
                                    animate: true,
                                    behaviors: [
                                      new charts.ChartTitle(
                                          'NO2',
                                          behaviorPosition: charts.BehaviorPosition.start,
                                          titleOutsideJustification:
                                          charts.OutsideJustification.middleDrawArea),
                                      new charts.ChartTitle(
                                          'Tempo',
                                          behaviorPosition: charts.BehaviorPosition.bottom,
                                          titleOutsideJustification:
                                          charts.OutsideJustification.middleDrawArea),
                                      new charts.SeriesLegend(
                                          position: charts.BehaviorPosition.end, desiredMaxRows: 2),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: 200,
                                  child: new charts.LineChart(
                                    _datiFuturiChartO3(),
                                    defaultRenderer: new charts.LineRendererConfig(includeArea: true),
                                    animate: true,
                                    behaviors: [
                                      new charts.ChartTitle(
                                          'O3',
                                          behaviorPosition: charts.BehaviorPosition.start,
                                          titleOutsideJustification:
                                          charts.OutsideJustification.middleDrawArea),
                                      new charts.ChartTitle(
                                          'Tempo',
                                          behaviorPosition: charts.BehaviorPosition.bottom,
                                          titleOutsideJustification:
                                          charts.OutsideJustification.middleDrawArea),
                                      new charts.SeriesLegend(
                                          position: charts.BehaviorPosition.end, desiredMaxRows: 2),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                    ),
                  ),
                ],
              ) : new Container(),
              apri_ricerca ? new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: TextField(
                      controller: _textcontroller,
                      textInputAction: TextInputAction.search,
                      textCapitalization: TextCapitalization.sentences,
                      cursorColor: Colors.yellow[700],
                      decoration: InputDecoration(
                          fillColor: Colors.yellow[700],
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _textcontroller.clear();
                              }),
                          hintText: "Cerca",
                          hintStyle: TextStyle(fontWeight: FontWeight.w300)
                      ),
                      textAlign: TextAlign.left,
                      onSubmitted: ricerca,
                      onChanged: (val) => debounce(const Duration(milliseconds: 300), gettestoricerca, [val]),
                    ),
                    color: Colors.white,
                    height : 50,
                  ),
                  Container(
                    child: FlatButton(
                      child: Text(testo_ricerca),
                      color: Colors.yellow[700],
                      onPressed: vaaposizione,
                    ),
                    color: Colors.white,
                    height : 50,
                  ),
                ],
              ) : new Container(),
            ], ),
        );
  }

  //Scarica il JSON e prepara i marker
  Future<void> fetchData(http.Client client) async {
    final response =
    await client.get('https://house.zan-tech.com/dati/tutto.py');
    final parsed = json.decode(response.body);

    Sensori res =  Sensori.fromJson(parsed);
    String tempo = res.tempo;
    List<Features> features = res.features;
    for(var i = 0; i < features.length; i++) {
      Geometry geometry = features[i].geometry;
      Properties properties = features[i].properties;
      double aqi_loc = (properties.pm_10.pm_10 + properties.no2.no / 4 + properties.o3.o3 / 2.4) / 3;
      properties.caqi = aqi_loc;
      //Trucchetto per decidere di che colore mettere il marker
      String colore = aqi_loc < 100 ? "high" : "very_high";
      colore = aqi_loc < 75 ? "medium" : colore;
      colore = aqi_loc < 50 ? "low" : colore;
      colore = aqi_loc < 25 ? "very_low" : colore;
      setState(() {
        _markerscaqi.add(Marker(
          markerId: MarkerId(properties.id_sensore),
          position: LatLng(geometry.coordinates[1], geometry.coordinates[0]),
          alpha : 0.6,
          onTap: () {
            setState(() {
              apri_info = true;
              apri_ricerca = false;
              valori_sensore = properties;
              _markers.remove(Marker(markerId: MarkerId("Selezione")));
              _markers.add(
                  Marker(
                      markerId: MarkerId("Selezione"),
                      position: LatLng(geometry.coordinates[1], geometry.coordinates[0]),
                  )
              );
            });
          },
          icon: BitmapDescriptor.fromAsset("immagini/$colore.png"),
        ));
      });
    }
    //Organizzato per poter cambiare tutti i marker tranne quello della posizione.
    _oldmarker = _markers;
    setState(() {
      _markers = _oldmarker.union(_markerscaqi);
    });
  }

  //Chiude robe toccando la mappa
  void _googlemaptap(LatLng posizione_toccata){
    //Ritardo studiato per tenere nascosti i pulsanti non nascondibili di gmaps
    sleep(const Duration(milliseconds:100));
    setState(() {
      apri_info = false;
      apri_ricerca = false;
      _markers.remove(Marker(markerId: MarkerId("Ricerca")));
      _markers.remove(Marker(markerId: MarkerId("Selezione")));
    });
  }


  //Alla creazione della mappa scarica il JSON e centra nella giusta posizione
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    fetchData(http.Client());
    _currentLocation();
  }

  //Centra nella posizione e aggiunge il marker con l'ape
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
        zoom: 13.0,
      ),
    ));

    setState(() {
      _markers.remove(Marker(markerId: MarkerId("Posizione")));
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("Posizione"),
        position: posizione_assoluta,
        icon: BitmapDescriptor.fromAsset("immagini/ape.png"),
      ));
    });
  }

  // Questa map prende le cose in attesa.
  Map<Function, Timer> _timeouts = {};
  void debounce(Duration timeout, Function target, [List arguments = const []]) {
    if (_timeouts.containsKey(target)) {
      _timeouts[target].cancel();
    }

    Timer timer = Timer(timeout, () {
      Function.apply(target, arguments);
    });

    _timeouts[target] = timer;
  }

  // Prende il testo della ricerca in real time e controlla se è un posto
  void gettestoricerca(String testo_parziale) async {
    List<Placemark> posizione_info = await Geolocator().placemarkFromAddress(
        testo_parziale,
        localeIdentifier: "it_IT"
    );
    setState(() {
      testo_ricerca = posizione_info[0].name + ", " + posizione_info[0].locality;
      risultato_ricerca = posizione_info[0].position;
    });
  }

  // Se premi su invio nella ricerca parte questo
  void ricerca(String testo) async {
    List<Placemark> posizione_info = await Geolocator().placemarkFromAddress(testo);
    setState(() {
      risultato_ricerca = posizione_info[0].position;
    });
    vaaposizione();
  }

  // Muove la camera fino alla posizione risultato_ricerca
  void vaaposizione() async {
    final GoogleMapController controller = await _controller.future;
    LatLng posizione = LatLng(risultato_ricerca.latitude, risultato_ricerca.longitude);

    _textcontroller.clear();

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: posizione,
        zoom: 13.0,
      ),
    ));

    setState(() {
      _markers.remove(Marker(markerId: MarkerId("Ricerca")));
      _markers.add(
        Marker(
          markerId: MarkerId("Ricerca"),
          position: posizione,
          infoWindow: InfoWindow(
            title: 'Posto cercato',
          ),
        )
      );
      apri_ricerca = false;
    });
  }

  // Ritorna una lista col widget dei grafici storici per CAQI
  List<charts.Series<GraficoLineare, int>> _datiChartCAQI() {
    final pmchartdata = [
      new GraficoLineare(0, valori_sensore.pm_10.pm_10_4 / 3),
      new GraficoLineare(1, valori_sensore.pm_10.pm_10_3 / 3),
      new GraficoLineare(2, valori_sensore.pm_10.pm_10_2 / 3),
      new GraficoLineare(3, valori_sensore.pm_10.pm_10_1 / 3),
      new GraficoLineare(4, valori_sensore.pm_10.pm_10 / 3),
    ];

    var no2chartdata = [
      new GraficoLineare(0, valori_sensore.no2.no_4 / 12),
      new GraficoLineare(1, valori_sensore.no2.no_3 / 12),
      new GraficoLineare(2, valori_sensore.no2.no_2 / 12),
      new GraficoLineare(3, valori_sensore.no2.no_1 / 12),
      new GraficoLineare(4, valori_sensore.no2.no / 12),
    ];

    var o3chartdata = [
      new GraficoLineare(0, valori_sensore.o3.o3_4 / (2.4*3)),
      new GraficoLineare(1, valori_sensore.o3.o3_3 / (2.4*3)),
      new GraficoLineare(2, valori_sensore.o3.o3_2 / (2.4*3)),
      new GraficoLineare(3, valori_sensore.o3.o3_1 / (2.4*3)),
      new GraficoLineare(4, valori_sensore.o3.o3 / (2.4*3)),
    ];

    return [
      new charts.Series<GraficoLineare, int>(
        id: 'PM',
        displayName: "PM",
        // colorFn specifies that the line will be blue.
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        // areaColorFn specifies that the area skirt will be light blue.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: pmchartdata,
      ),
      new charts.Series<GraficoLineare, int>(
        id: 'NO2',
        // colorFn specifies that the line will be red.
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        // areaColorFn specifies that the area skirt will be light red.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: no2chartdata,
      ),
      new charts.Series<GraficoLineare, int>(
        id: 'O3',
        // colorFn specifies that the line will be green.
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        // areaColorFn specifies that the area skirt will be light green.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.green.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: o3chartdata,
      ),
    ];
  }

  List<charts.Series<GraficoLineare, int>> _datiFuturiChartCAQI() {
    final pmchartdata = [
      new GraficoLineare(0, valori_sensore.pm_10.pm_10 / 3),
      new GraficoLineare(1, valori_sensore.pm_10.pm_10p1 / 3),
      new GraficoLineare(2, valori_sensore.pm_10.pm_10p2 / 3),
      new GraficoLineare(3, valori_sensore.pm_10.pm_10p3 / 3),
      new GraficoLineare(4, valori_sensore.pm_10.pm_10p4 / 3),
    ];

    var no2chartdata = [
      new GraficoLineare(0, valori_sensore.no2.no / 12),
      new GraficoLineare(1, valori_sensore.no2.nop1 / 12),
      new GraficoLineare(2, valori_sensore.no2.nop2 / 12),
      new GraficoLineare(3, valori_sensore.no2.nop3 / 12),
      new GraficoLineare(4, valori_sensore.no2.nop4 / 12),
    ];

    var o3chartdata = [
      new GraficoLineare(0, valori_sensore.o3.o3 / (2.4*3)),
      new GraficoLineare(1, valori_sensore.o3.o3p1 / (2.4*3)),
      new GraficoLineare(2, valori_sensore.o3.o3p2 / (2.4*3)),
      new GraficoLineare(3, valori_sensore.o3.o3p3 / (2.4*3)),
      new GraficoLineare(4, valori_sensore.o3.o3p4 / (2.4*3)),
    ];

    return [
      new charts.Series<GraficoLineare, int>(
        id: 'PM',
        displayName: "PM",
        // colorFn specifies that the line will be blue.
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        // areaColorFn specifies that the area skirt will be light blue.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: pmchartdata,
      ),
      new charts.Series<GraficoLineare, int>(
        id: 'NO2',
        // colorFn specifies that the line will be red.
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        // areaColorFn specifies that the area skirt will be light red.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: no2chartdata,
      ),
      new charts.Series<GraficoLineare, int>(
        id: 'O3',
        // colorFn specifies that the line will be green.
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        // areaColorFn specifies that the area skirt will be light green.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.green.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: o3chartdata,
      ),
    ];
  }

  // Ritorna una lista col widget dei grafici per PM
  List<charts.Series<GraficoLineare, int>> _datiStoricoChartPM() {
    final pmchartdata = [
      new GraficoLineare(0, valori_sensore.pm_10.pm_10_4),
      new GraficoLineare(1, valori_sensore.pm_10.pm_10_3),
      new GraficoLineare(2, valori_sensore.pm_10.pm_10_2),
      new GraficoLineare(3, valori_sensore.pm_10.pm_10_1),
      new GraficoLineare(4, valori_sensore.pm_10.pm_10),
    ];
    return [
      new charts.Series<GraficoLineare, int>(
          id: 'PM',
          displayName: "PM",
          // colorFn specifies that the line will be blue.
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          // areaColorFn specifies that the area skirt will be light blue.
          areaColorFn: (_, __) =>
          charts.MaterialPalette.blue.shadeDefault.lighter,
          domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
          measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
          data: pmchartdata,
        ),
    ];
  }
  List<charts.Series<GraficoLineare, int>> _datiFuturiChartPM() {
    final pmchartdata = [
      new GraficoLineare(0, valori_sensore.pm_10.pm_10),
      new GraficoLineare(1, valori_sensore.pm_10.pm_10p1),
      new GraficoLineare(2, valori_sensore.pm_10.pm_10p2),
      new GraficoLineare(3, valori_sensore.pm_10.pm_10p3),
      new GraficoLineare(4, valori_sensore.pm_10.pm_10p4),
    ];
    return [
      new charts.Series<GraficoLineare, int>(
        id: 'PM',
        displayName: "PM",
        // colorFn specifies that the line will be blue.
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        // areaColorFn specifies that the area skirt will be light blue.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: pmchartdata,
      ),
    ];
  }

  // Ritorna una lista col widget dei grafici per NO2
  List<charts.Series<GraficoLineare, int>> _datiStoricoChartNO2() {
    var no2chartdata = [
      new GraficoLineare(0, valori_sensore.no2.no_4),
      new GraficoLineare(1, valori_sensore.no2.no_3),
      new GraficoLineare(2, valori_sensore.no2.no_2),
      new GraficoLineare(3, valori_sensore.no2.no_1),
      new GraficoLineare(4, valori_sensore.no2.no),
    ];

    return [
      new charts.Series<GraficoLineare, int>(
          id: 'NO2',
          // colorFn specifies that the line will be red.
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          // areaColorFn specifies that the area skirt will be light red.
          areaColorFn: (_, __) =>
          charts.MaterialPalette.red.shadeDefault.lighter,
          domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
          measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
          data: no2chartdata,
        ),
    ];
  }
  List<charts.Series<GraficoLineare, int>> _datiFuturiChartNO2() {
    var no2chartdata = [
      new GraficoLineare(0, valori_sensore.no2.no),
      new GraficoLineare(1, valori_sensore.no2.nop1),
      new GraficoLineare(2, valori_sensore.no2.nop2),
      new GraficoLineare(3, valori_sensore.no2.nop3),
      new GraficoLineare(4, valori_sensore.no2.nop4),
    ];

    return [
      new charts.Series<GraficoLineare, int>(
        id: 'NO2',
        // colorFn specifies that the line will be red.
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        // areaColorFn specifies that the area skirt will be light red.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: no2chartdata,
      ),
    ];
  }

  // Ritorna una lista col widget dei grafici per O3
  List<charts.Series<GraficoLineare, int>> _datiStoricoChartO3() {
    var o3chartdata = [
      new GraficoLineare(0, valori_sensore.o3.o3_4),
      new GraficoLineare(1, valori_sensore.o3.o3_3),
      new GraficoLineare(2, valori_sensore.o3.o3_2),
      new GraficoLineare(3, valori_sensore.o3.o3_1),
      new GraficoLineare(4, valori_sensore.o3.o3),
    ];

      return [
        new charts.Series<GraficoLineare, int>(
          id: 'O3',
          // colorFn specifies that the line will be green.
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          // areaColorFn specifies that the area skirt will be light green.
          areaColorFn: (_, __) =>
          charts.MaterialPalette.green.shadeDefault.lighter,
          domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
          measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
          data: o3chartdata,
        ),
      ];
  }
  List<charts.Series<GraficoLineare, int>> _datiFuturiChartO3() {
    var o3chartdata = [
      new GraficoLineare(0, valori_sensore.o3.o3),
      new GraficoLineare(1, valori_sensore.o3.o3p1),
      new GraficoLineare(2, valori_sensore.o3.o3p2),
      new GraficoLineare(3, valori_sensore.o3.o3p3),
      new GraficoLineare(4, valori_sensore.o3.o3p4),
    ];

    return [
      new charts.Series<GraficoLineare, int>(
        id: 'O3',
        // colorFn specifies that the line will be green.
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        // areaColorFn specifies that the area skirt will be light green.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.green.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: o3chartdata,
      ),
    ];
  }

}