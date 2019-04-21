part of "main.dart";

LatLng posizione_assoluta = LatLng(45.4510525, 9.4126428);

class Properties{
  final String id_sensore;
  final double pm_10;
  final double pm_10_1;
  final double pm_10_2;
  final double pm_10_3;
  final double pm_10_4;
  final double temp;
  final double umi;
  final double prec;
  final double vento;
  final double no2;
  final double no2_1;
  final double no2_2;
  final double no2_3;
  final double no2_4;
  final double o3;
  final double o3_1;
  final double o3_2;
  final double o3_3;
  final double o3_4;
  final double caqi;

  Properties({
    this.id_sensore,
    this.pm_10,
    this.pm_10_1,
    this.pm_10_2,
    this.pm_10_3,
    this.pm_10_4,
    this.temp,
    this.umi,
    this.prec,
    this.vento,
    this.no2,
    this.no2_1,
    this.no2_2,
    this.no2_3,
    this.no2_4,
    this.o3,
    this.o3_1,
    this.o3_2,
    this.o3_3,
    this.o3_4,
    this.caqi,
  });

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      id_sensore: json['id_sensore'] as String,
      pm_10: json['pm10'] as double,
      pm_10_1: json['pm10-1'] as double,
      pm_10_2: json['pm10-2'] as double,
      pm_10_3: json['pm10-3'] as double,
      pm_10_4: json['pm10-4'] as double,
      temp: json['temp'] as double,
      umi: json['umi'] as double,
      prec: json['prec'] as double,
      vento: json['vento'] as double,
      no2: json["no2"] as double,
      no2_1: json['no2-1'] as double,
      no2_2: json['no2-2'] as double,
      no2_3: json['no2-3'] as double,
      no2_4: json['no2-4'] as double,
      o3: json["o3"] as double,
      o3_1: json['o3-1'] as double,
      o3_2: json['o3-2'] as double,
      o3_3: json['o3-3'] as double,
      o3_4: json['o3-4'] as double,
      caqi: (json['pm10-4'] + json["no2-4"] / 4 + json["o3-4"] / 2.4) / 3 as double,
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

class _MyHomePageState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();

  final _textcontroller = TextEditingController();

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

/*
  Preferences _preferences;

  Future<Null> getPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _prefs = prefs.getString('prefs');
    if(_prefs != null && _prefs != ''){
      Map prefsMap = jsonDecode(_prefs);
      _preferences = new Preferences.fromJson(prefsMap);
    } else {
      _preferences = getDefaultsPrefs();
      String prefjson = jsonEncode(_preferences);
      prefs.setString('prefs', prefjson);
    }
  }
*/
  Preferences _preferences;

  Future<Preferences> getPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _prefs = prefs.getString('prefs');
    if(_prefs != null){
      Map<String, dynamic> prefsMap = jsonDecode(_prefs);
      return new Preferences.fromJson(prefsMap);
    } else {
      Preferences preferences = getDefaultsPrefs();
      Map<String, dynamic> jsonpref = preferences.toJson();
      String prefjson = jsonEncode(jsonpref);
      prefs.setString('prefs', prefjson);
      return preferences;
    }
  }

  Future<void> ResolvePrefs() async {
    _preferences = await getPrefs();
  }
  @override

  void initState() {
    super.initState();
    ResolvePrefs();
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
      mapType: MapType.terrain, //Also change map type
    );

    return MaterialApp(
      theme: app_theme(),
      home: Builder(
        builder: (context) => Scaffold(
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
                            width: 50,
                            child: Center(
                              child: new RotatedBox(
                                  quarterTurns: -1,
                                  child: new Text(
                                    "Adesso",
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
                                  center: Text(valori_sensore.pm_10_4.toString()),
                                  width: 160.0,
                                  lineHeight: 14.0,
                                  percent: valori_sensore.pm_10_4 / 150,
                                  backgroundColor: Colors.green,
                                  progressColor: Colors.red,
                                ),
                                LinearPercentIndicator(
                                  trailing: Expanded(child: Text("NO2")),
                                  center: Text(valori_sensore.no2_4.toString()),
                                  width: 160.0,
                                  lineHeight: 14.0,
                                  percent: valori_sensore.no2_4 / 500,
                                  backgroundColor: Colors.green,
                                  progressColor: Colors.red,
                                ),
                                LinearPercentIndicator(
                                  trailing: Expanded(child: Text("O3")),
                                  center: Text(valori_sensore.o3_4.toString()),
                                  width: 160.0,
                                  lineHeight: 14.0,
                                  percent: valori_sensore.o3_4 / 400,
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
                                    "Storico",
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
                            child: new charts.LineChart(
                                _datiChartStorico(),
                                defaultRenderer: new charts.LineRendererConfig(includeArea: true, stacked: true),
                                animate: true,
                                behaviors: [
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
                            width: 250.0,
                            color: Colors.blue,
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
                      onChanged: gettestoricerca,
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
        ),
      ),
    );
  }

  //Scarica il JSON e prepara i marker
  Future<void> fetchData(http.Client client) async {
    final response =
    await client.get('https://house.zan-tech.com/dati/storico.py');
    final parsed = json.decode(response.body);

    Sensori res =  Sensori.fromJson(parsed);
    String tempo = res.tempo;
    List<Features> features = res.features;
    for(var i = 0; i < features.length; i++) {
      Geometry geometry = features[i].geometry;
      Properties properties = features[i].properties;
      double aqi_loc = properties.caqi;
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

  List<charts.Series<GraficoLineare, int>> _datiChartStorico() {
    final pmchartdata = [
      new GraficoLineare(0, valori_sensore.pm_10),
      new GraficoLineare(1, valori_sensore.pm_10_1),
      new GraficoLineare(2, valori_sensore.pm_10_2),
      new GraficoLineare(3, valori_sensore.pm_10_3),
      new GraficoLineare(4, valori_sensore.pm_10_4),
    ];

    var no2chartdata = [
      new GraficoLineare(0, valori_sensore.no2 / 4),
      new GraficoLineare(1, valori_sensore.no2_1 / 4),
      new GraficoLineare(2, valori_sensore.no2_2 / 4),
      new GraficoLineare(3, valori_sensore.no2_3 / 4),
      new GraficoLineare(4, valori_sensore.no2_4 / 4),
    ];

    var o3chartdata = [
      new GraficoLineare(0, valori_sensore.o3 / 2.4),
      new GraficoLineare(1, valori_sensore.o3_1 / 2.4),
      new GraficoLineare(2, valori_sensore.o3_2 / 2.4),
      new GraficoLineare(3, valori_sensore.o3_3 / 2.4),
      new GraficoLineare(4, valori_sensore.o3_4 / 2.4),
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
        areaColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,
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

}