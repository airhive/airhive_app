part of "main.dart";

LatLng posizione_assoluta = LatLng(45.4510525, 9.4126428);
Properties valori_sensore;
LatLng pos_curr_marker;
Set<Marker> _globalmarkers = {};

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
      pm_10_4: 0.0,
      pm_10_3: 0.0,
      pm_10_2: 0.0,
      pm_10_1: 0.0,
      pm_10: json['pm10'].toDouble(),
      pm_10p1: 0.0,
      pm_10p2: 0.0,
      pm_10p3: 0.0,
      pm_10p4: 0.0,
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
      no_4: 0.0,
      no_3: 0.0,
      no_2: 0.0,
      no_1: 0.0,
      no: json['no2'].toDouble(),
      nop1: 0.0,
      nop2: 0.0,
      nop3: 0.0,
      nop4: 0.0,
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
      o3_4: 0.0,
      o3_3: 0.0,
      o3_2: 0.0,
      o3_1: 0.0,
      o3: json['o3'].toDouble(),
      o3p1: 0.0,
      o3p2: 0.0,
      o3p3: 0.0,
      o3p4: 0.0,
    );
  }
}

class Meteo{
  final double temp;
  final double umi;
  final double prec;
  final double vento;

  Meteo({
    this.temp,
    this.umi,
    this.prec,
    this.vento,
  });

  factory Meteo.fromJson(Map<String, dynamic> json) {
    return Meteo(
      temp: json['temp'].toDouble(),
      umi: json['umi'].toDouble(),
      prec: json['prec'].toDouble(),
      vento: json['vento'].toDouble(),
    );
  }
}



class Properties{
  final String id_sensore;
  final Pm pm_10;
  final No no2;
  final O3 o3;
  final Meteo meteo;
  double caqi;

  Properties({
    this.id_sensore,
    this.pm_10,
    this.no2,
    this.o3,
    this.meteo,
    this.caqi,
  });

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      id_sensore: json['idsensore'] as String,
      pm_10: Pm(
        pm_10_4: 0.0,
        pm_10_3: 0.0,
        pm_10_2: 0.0,
        pm_10_1: 0.0,
        pm_10: json['pm10'].toDouble(),
        pm_10p1: 0.0,
        pm_10p2: 0.0,
        pm_10p3: 0.0,
        pm_10p4: 0.0,
      ),
      no2: No(
        no_4: 0.0,
        no_3: 0.0,
        no_2: 0.0,
        no_1: 0.0,
        no: json['no2'].toDouble(),
        nop1: 0.0,
        nop2: 0.0,
        nop3: 0.0,
        nop4: 0.0,
      ),
      o3: O3(
        o3_4: 0.0,
        o3_3: 0.0,
        o3_2: 0.0,
        o3_1: 0.0,
        o3: json['o3'].toDouble(),
        o3p1: 0.0,
        o3p2: 0.0,
        o3p3: 0.0,
        o3p4: 0.0,
      ),
      meteo: Meteo(
        temp: json['temp'].toDouble(),
        umi: 0.0,//json['umi'].toDouble(),
        prec: json['prec'].toDouble(),
        vento: json['vento'].toDouble(),
      ),
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

class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
}

// Per le dimensioni delle icone
Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
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
    target: posizione_assoluta,
    zoom: 0.1,
  );
  GoogleMap googleMap;

  // apri_info decide se la barra con le info dei marker deve essere aperta o meno
  bool apri_info = false;
  double valore_aqi;
  String tempo_rilevazione;

  bool apri_ricerca = false;
  String testo_ricerca = "";
  Position risultato_ricerca;

  Set<Marker> _oldmarker = {};
  Set<Marker> _markers = {};
  final Set<Marker> _markerscaqi = {};
  final Set<Marker> _markerspm = {};
  final Set<Marker> _markersno = {};
  final Set<Marker> _markerso3 = {};
  int vedo = 0; //0 CAQI, 1 PM, 2 NO, 3 O3
  int index = 1; //Index della bottombar

  @override
  void initState() {

    rootBundle.loadString('map_styles/dark.txt').then((string) {
      _darkMap = string;
    });
    rootBundle.loadString('map_styles/night.txt').then((string1) {
      _nightMap = string1;
    });
    rootBundle.loadString('map_styles/retro.txt').then((string2) {
      _retroMap = string2;
    });
    rootBundle.loadString('map_styles/gtav.txt').then((string3) {
      _gtaMap = string3;
    });
    rootBundle.loadString('map_styles/silver.txt').then((string4) {
      _silverMap = string4;
    });
    rootBundle.loadString('map_styles/aubergine.txt').then((string5) {
      _aubergineMap = string5;
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _showAlert(message["notification"]["body"], message["notification"]["title"]);
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
      print("Impostazioni salvate: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      sendfiretoken(http.Client(), token);
    });

    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _seOffline(context));
  }


  @override
  Widget build(BuildContext context) {


    googleMap = GoogleMap(
      onTap: _googlemaptap,
      compassEnabled: false,
      onMapCreated: _onMapCreated,
      myLocationEnabled: false,
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: _initialCamera,
      markers: _markers,
      mapType: ListOfMaps[currMapNum], //Also change map type
    );

    return WillPopScope(
        onWillPop: _willPopCalbackHome,
        child: new Scaffold(
          key: _scaffoldKey,
          //resizeToAvoidBottomInset: false,
          drawer: menulaterale(context),
          body: Stack(
            children: <Widget>[
              googleMap,
              new Align(
                alignment: FractionalOffset(0.035, 0.07),
                child: GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: new Image.asset(
                    "immagini/logo.png",
                    scale: 27,
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
                                  heroTag: "cambiavalori",
                                  onPressed: () => {
                                    setState(() {
                                      if (vedo == 0) {
                                        _markers = _oldmarker.union(_markerspm);
                                        vedo = 1;
                                      }
                                      else if (vedo == 1){
                                        _markers = _oldmarker.union(_markersno);
                                        vedo = 2;
                                      }
                                      else if (vedo == 2){
                                        _markers = _oldmarker.union(_markerso3);
                                        vedo = 3;
                                      }
                                      else if (vedo == 3){
                                        _markers = _oldmarker.union(_markerscaqi);
                                        vedo = 0;
                                      }
                                    })
                                  },
                                  tooltip: 'Cambia visualizzazione',
                                  child: [
                                    Text("CAQI", style: TextStyle(color: Colors.white)),
                                    Text("PM10", style: TextStyle(color: Colors.white)),
                                    Text("NO2", style: TextStyle(color: Colors.white)),
                                    Text("O3", style: TextStyle(color: Colors.white))][vedo],
                                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.95),
                                  elevation: 1.0,
                                )
                            ),
                            SizedBox(height: 10),
                            new Align(
                                alignment: Alignment.bottomRight,
                                child: FloatingActionButton(
                                  heroTag: "localizzazione",
                                  onPressed: () => _currentLocation(),
                                  tooltip: 'Localizzami',
                                  child: Icon(Icons.location_on, color: Colors.white),
                                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.95),
                                  elevation: 1.0,
                                )
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
                    color: Colors.transparent,
                    height : MediaQuery.of(context).size.height * 0.35,
                    child:ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget> [
                          Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: <Widget>[
                                     Container(
                                       height: 30,
                                       width: MediaQuery.of(context).size.width,
                                       color: valori_sensore.caqi < 25 ? Colors.green.withOpacity(0.7) :
                                       valori_sensore.caqi < 50 ? Colors.lightGreen.withOpacity(0.7):
                                       valori_sensore.caqi < 75 ? Colors.yellow[500].withOpacity(0.7): Colors.deepOrange[600].withOpacity(0.7),
                                       child: Center(child:
                                       valori_sensore.caqi < 25 ? Text(Translations.of(context).text('ottima_aria')):
                                       valori_sensore.caqi < 50 ? Text(Translations.of(context).text('buona_aria')):
                                       valori_sensore.caqi < 70 ? Text(Translations.of(context).text('cattiva_aria')):
                                       Text(Translations.of(context).text('pessima_aria'))
                                       ),
                                     ),
                                     Container(
                                       height:1,
                                       //color: Colors.black,
                                     ),
                                     GestureDetector(
                                       onTap: () => {Navigator.pushNamed(context, '/moredata')},
                                       child: Container(
                                         color: Colors.white,
                                         height: MediaQuery.of(context).size.height * 0.20,
                                         child: Stack(
                                           children: <Widget> [
                                             Container(
                                               height:160,
                                                 child: new charts.PieChart(
                                                   _PmData(),
                                                   animate:true,
                                                   defaultRenderer: new charts.ArcRendererConfig(
                                                       arcWidth: 10,
                                                       startAngle: 4 / 5 * 3.1415,
                                                       arcLength: (valori_sensore.caqi.toInt() / 100) * (7 * 3.1415) / 5
                                                   ),
                                                   behaviors: [
                                                     new charts.ChartTitle(
                                                       "Air quality index",
                                                       titleStyleSpec: charts.TextStyleSpec(
                                                         fontSize: 12, // size in Pts.
                                                         color: charts.MaterialPalette.black),
                                                       behaviorPosition: charts.BehaviorPosition.start,
                                                       titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
                                                     ),
                                                     // Per centrare
                                                     new charts.ChartTitle(
                                                       "",
                                                       behaviorPosition: charts.BehaviorPosition.end,
                                                     ),
                                                   ],
                                               ),
                                             ),
                                            Center(
                                                 child: Text(valori_sensore.caqi.toStringAsFixed(2).toString(), style: TextStyle(color: Colors.black),)
                                             ),
                                             Align(
                                                 alignment: Alignment(1.0, -1.0),
                                                 child: Icon(Icons.info_outline, color: Colors.black),
                                             )
                                            ],
                                           ),
                                      ),
                                     ),
                                     Container(
                                       height: 30,
                                       width: MediaQuery.of(context).size.width,
                                       color: Theme.of(context).primaryColor,
                                       child: Center(child: Text("${Translations.of(context).text('aggiornato_alle')} $tempo_rilevazione")),
                                     ),
                                     Container(
                                       height: 150,
                                       color: Colors.white,
                                       child:
                                       Row(
                                       children: <Widget>[
                                         Container(
                                            width: MediaQuery.of(context).size.width / 3,
                                            child:
                                              Stack(
                                                children: <Widget> [
                                                  Container(
                                                    child: new charts.PieChart(
                                                      _PrecData(),
                                                      animate:true,
                                                      defaultRenderer: new charts.ArcRendererConfig(
                                                          arcWidth: 10,
                                                          startAngle: 4 / 5 * 3.1415,
                                                          arcLength: (valori_sensore.meteo.prec.toInt() / 100) * (7 * 3.1415) / 5
                                                      ),
                                                      behaviors: [
                                                        new charts.ChartTitle(
                                                          Translations.of(context).text('precipitazioni'),
                                                          titleStyleSpec: charts.TextStyleSpec(
                                                            fontSize: 12, // size in Pts.
                                                            color: charts.MaterialPalette.black),
                                                          behaviorPosition: charts.BehaviorPosition.bottom,
                                                          titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Align(
                                                      alignment: Alignment(0, -0.1),
                                                      child: Text((valori_sensore.meteo.prec * 5/10).toStringAsFixed(2).toString(), style: TextStyle(color: Colors.black),)
                                                  )
                                                ],
                                              ),
                                              ),
                                         Container(
                                            width: MediaQuery.of(context).size.width / 3,
                                            child:
                                               Stack(
                                                 children: <Widget> [
                                                   Container(
                                                     child: new charts.PieChart(
                                                       _TempData(),
                                                       animate:true,
                                                       defaultRenderer: new charts.ArcRendererConfig(
                                                           arcWidth: 10,
                                                           startAngle: 4 / 5 * 3.1415,
                                                           arcLength: (valori_sensore.meteo.temp.toInt() / 100) * (7 * 3.1415) / 5
                                                       ),
                                                       behaviors: [
                                                         new charts.ChartTitle(
                                                           Translations.of(context).text('temperatura'),
                                                           titleStyleSpec: charts.TextStyleSpec(
                                                               fontSize: 12, // size in Pts.
                                                               color: charts.MaterialPalette.black),
                                                           behaviorPosition: charts.BehaviorPosition.bottom,
                                                           titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                   Align(
                                                       alignment: Alignment(0.0, -0.1),
                                                       child: Text((valori_sensore.meteo.temp * 3/10).toStringAsFixed(2).toString(), style: TextStyle(color: Colors.black),)
                                                   )
                                                 ],
                                               ),
                                             ),
                                             Container(
                                               width: MediaQuery.of(context).size.width / 3,
                                               child:
                                               Stack(
                                                 children: <Widget> [
                                                   Container(
                                                     child: new charts.PieChart(
                                                       _PrecData(),
                                                       animate:true,
                                                       defaultRenderer: new charts.ArcRendererConfig(
                                                           arcWidth: 10,
                                                           startAngle: 4 / 5 * 3.1415,
                                                           arcLength: (valori_sensore.meteo.vento.toInt() / 100) * (7 * 3.1415) / 5
                                                       ),
                                                       behaviors: [
                                                         new charts.ChartTitle(
                                                           Translations.of(context).text('vento'),
                                                           titleStyleSpec: charts.TextStyleSpec(
                                                               fontSize: 12, // size in Pts.
                                                               color: charts.MaterialPalette.black),
                                                           behaviorPosition: charts.BehaviorPosition.bottom,
                                                           titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                   Align(
                                                       alignment: Alignment(0.0, -0.1),
                                                       child: Text((valori_sensore.meteo.vento * 5/10).toStringAsFixed(2).toString(), style: TextStyle(color: Colors.black),)
                                                   )
                                                 ],
                                               ),
                                             ),
                                            ],
                                          ),
                                     ),
                                ],
                              ),
                        ],
                      )
                    )
                   ]
              ) : new Container(),
              apri_ricerca ? new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _textcontroller,
                      textInputAction: TextInputAction.search,
                      textCapitalization: TextCapitalization.sentences,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                          fillColor: Colors.yellow[700],
                          prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor,),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.clear, color: Theme.of(context).primaryColor,),
                              onPressed: () {
                                setState(() {
                                  apri_ricerca = false;
                                  index = 1;
                                });
                                _textcontroller.clear();
                              }),
                          hintText: Translations.of(context).text('blank_research_text'),
                          hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.black45)
                      ),
                      textAlign: TextAlign.left,
                      onSubmitted: ricerca,
                      onChanged: (val) => debounce(const Duration(milliseconds: 400), gettestoricerca, [val]),
                    ),
                    color: Colors.white,
                    height : 50,
                  ),
                  Container(
                    child: FlatButton(
                      child: Text(testo_ricerca),
                      color: Theme.of(context).primaryColor,
                      onPressed: vaaposizione,
                    ),
                    color: Colors.white,
                    height : 50,
                  ),
                ],
              ) : new Container(),
            ], ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,

            currentIndex: index,
            onTap: (int index) {
              setState((){ this.index = index; });
              if(index == 0) {_scaffoldKey.currentState.openDrawer(); this.index = 1; index = 1;}
              if(index != 2){ setState((){ apri_ricerca = false; });  }
              if(index == 2){ setState((){ apri_ricerca = !apri_ricerca; });  }
              if(!apri_ricerca && index == 2){ setState((){ this.index = 1; });  }
              },
            items: [
              new BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                title: Text('Menu'),
              ),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  title: Text(Translations.of(context).text('map_button_text'))
              ),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  title: Text(Translations.of(context).text('blank_research_text'))
              )
            ],
          ),
        ),
    );
  }

  //Invia il token di firebase
  Future<void> sendfiretoken(http.Client client, String nottkn) async {
    Locale myLocale = Localizations.localeOf(context);
    String lingua = myLocale.toString().substring(0,2).toUpperCase();
    try{
      await client.get('https://www.airhive.it/php/declareNotTkn.php?notTkn=$nottkn&tkn=$login_token&hl=$lingua');
    }
    on SocketException catch(_){
      return;
    }
  }

  // Alert dialog
  Widget _buildDialog(BuildContext context, String testo_msg, String titolo_msg) {
    return AlertDialog(
      title: Text(titolo_msg),
      content: Text(testo_msg),
      actions: <Widget>[
        FlatButton(
          child: Text(Translations.of(context).text('chiudi')),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ],
    );
  }

  void _showAlert(String testo_msg, String titolo_msg) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, testo_msg, titolo_msg),
    );
  }

  // Alert in caso di offline
  Widget _buildDialogOffline(BuildContext context, String testo_msg, String titolo_msg) {
    return AlertDialog(
      title: Text(titolo_msg),
      content: Text(testo_msg),
      actions: <Widget>[
        Row(
        children:[
          FlatButton(
              child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: Text(Translations.of(context).text('riprova')),
            onPressed: () {
              connectionCheck();
              Navigator.pop(context, false);
              if(conessioneassente){
                _showOfflineAlert(Translations.of(context).text('funzioni_non_disponibili'), Translations.of(context).text('dispositivo_offline'));
                return ;
              }
              _login(http.Client());
              fetchData(http.Client());
              _updatelocationstream();
              },
            ),
          ]
        )
      ],
    );
  }

  void _showOfflineAlert(String testo_msg, String titolo_msg) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialogOffline(context, testo_msg, titolo_msg),
    );
  }

  void _seOffline(BuildContext context){
    if (conessioneassente){
      _showOfflineAlert(Translations.of(context).text('funzioni_non_disponibili'), Translations.of(context).text('dispositivo_offline'));
    }
  }

  //Scarica il JSON e prepara i marker
  Future<void> fetchData(http.Client client) async {
    //Aspetta di avere un token per il login
    while (login_token == ""){
      //Se non c'è connessione non fare niente
      if (conessioneassente){
        return ;
      }
    }
    try {
      final response =
      await client.get('https://www.airhive.it/data/?tkn=$login_token');
      final parsed = json.decode(response.body)['data'];

      //Dimensione di tutte le icone
      int dimensioneicone = 30;
      final Uint8List markerIconBlu = await getBytesFromAsset("immagini/punto_blu.png", dimensioneicone);

      Sensori res = Sensori.fromJson(parsed);

      tempo_rilevazione = DateFormat('kk:mm - d/MM').format(DateTime.parse(res.tempo));
      List<Features> features = res.features;

      Uint8List markerHigh = await getBytesFromAsset("immagini/high.png", dimensioneicone);
      Uint8List markerVeryHigh = await getBytesFromAsset("immagini/very_high.png", dimensioneicone);
      Uint8List markerMedium = await getBytesFromAsset("immagini/medium.png", dimensioneicone);
      Uint8List markerLow = await getBytesFromAsset("immagini/low.png", dimensioneicone);
      Uint8List markerVeryLow = await getBytesFromAsset("immagini/very_low.png", dimensioneicone);

      //Marker del caqi
      for (var i = 0; i < features.length; i++) {
        Geometry geometry = features[i].geometry;
        Properties properties = features[i].properties;
        double aqi_loc = (properties.pm_10.pm_10 + properties.no2.no / 4 +
            properties.o3.o3 / 2.4) / 3;
        properties.caqi = aqi_loc;

        //Trucchetto per decidere di che colore mettere il marker
        Uint8List markerIcon = aqi_loc < 100 ? markerHigh : markerVeryHigh;
        markerIcon = aqi_loc < 75 ? markerMedium : markerIcon;
        markerIcon = aqi_loc < 50 ? markerLow : markerIcon;
        markerIcon = aqi_loc < 25 ? markerVeryLow : markerIcon;
        setState(() {
          _markerscaqi.add(Marker(
            markerId: MarkerId(properties.id_sensore),
            position: LatLng(geometry.coordinates[1], geometry.coordinates[0]),
            alpha: 0.6,
            onTap: () {
              setState(() {
                apri_info = true;
                apri_ricerca = false;
                index = 1;
                pos_curr_marker = LatLng(geometry.coordinates[1], geometry.coordinates[0]);
                valori_sensore = properties;
                _markers.remove(Marker(markerId: MarkerId("Ricerca")));
                _markers.remove(Marker(markerId: MarkerId("Selezione")));
                _markers.add(
                    Marker(
                      markerId: MarkerId("Selezione"),
                      position: pos_curr_marker,
                      icon: BitmapDescriptor.fromBytes(markerIconBlu),
                    )
                );
              });
            },
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ));
        });
      }
      //Organizzato per poter cambiare tutti i marker tranne quello della posizione.
      _oldmarker = _markers;
      setState(() {
        _markers = _oldmarker.union(_markerscaqi);
      });
      _globalmarkers = _markers;

      //I marker del PM
      for (var i = 0; i < features.length; i++) {
        Geometry geometry = features[i].geometry;
        Properties properties = features[i].properties;
        double aqi_loc = properties.pm_10.pm_10;
        //Trucchetto per decidere di che colore mettere il marker
        Uint8List markerIcon = aqi_loc < 100 ? markerHigh : markerVeryHigh;
        markerIcon = aqi_loc < 75 ? markerMedium : markerIcon;
        markerIcon = aqi_loc < 50 ? markerLow : markerIcon;
        markerIcon = aqi_loc < 25 ? markerVeryLow : markerIcon;

        setState(() {
          _markerspm.add(Marker(
            markerId: MarkerId(properties.id_sensore),
            position: LatLng(geometry.coordinates[1], geometry.coordinates[0]),
            alpha: 0.6,
            onTap: () {
              setState(() {
                apri_info = true;
                apri_ricerca = false;
                index = 1;
                pos_curr_marker = LatLng(geometry.coordinates[1], geometry.coordinates[0]);
                valori_sensore = properties;
                _markers.remove(Marker(markerId: MarkerId("Ricerca")));
                _markers.remove(Marker(markerId: MarkerId("Selezione")));
                _markers.add(
                    Marker(
                      markerId: MarkerId("Selezione"),
                      position: pos_curr_marker,
                      icon: BitmapDescriptor.fromBytes(markerIconBlu),
                    )
                );
              });
            },
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ));
        });
      }
      for (var i = 0; i < features.length; i++) {
        Geometry geometry = features[i].geometry;
        Properties properties = features[i].properties;
        double aqi_loc = properties.no2.no / 4;
        //Trucchetto per decidere di che colore mettere il marker
        Uint8List markerIcon = aqi_loc < 100 ? markerHigh : markerVeryHigh;
        markerIcon = aqi_loc < 75 ? markerMedium : markerIcon;
        markerIcon = aqi_loc < 50 ? markerLow : markerIcon;
        markerIcon = aqi_loc < 25 ? markerVeryLow : markerIcon;

        setState(() {
          _markersno.add(Marker(
            markerId: MarkerId(properties.id_sensore),
            position: LatLng(geometry.coordinates[1], geometry.coordinates[0]),
            alpha: 0.6,
            onTap: () {
              setState(() {
                apri_info = true;
                apri_ricerca = false;
                index = 1;
                pos_curr_marker = LatLng(geometry.coordinates[1], geometry.coordinates[0]);
                valori_sensore = properties;
                _markers.remove(Marker(markerId: MarkerId("Ricerca")));
                _markers.remove(Marker(markerId: MarkerId("Selezione")));
                _markers.add(
                    Marker(
                      markerId: MarkerId("Selezione"),
                      position: pos_curr_marker,
                      icon: BitmapDescriptor.fromBytes(markerIconBlu),
                    )
                );
              });
            },
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ));
        });
      }
      for (var i = 0; i < features.length; i++) {
        Geometry geometry = features[i].geometry;
        Properties properties = features[i].properties;
        double aqi_loc = properties.o3.o3 / 3;
        //Trucchetto per decidere di che colore mettere il marker
        Uint8List markerIcon = aqi_loc < 100 ? markerHigh : markerVeryHigh;
        markerIcon = aqi_loc < 75 ? markerMedium : markerIcon;
        markerIcon = aqi_loc < 50 ? markerLow : markerIcon;
        markerIcon = aqi_loc < 25 ? markerVeryLow : markerIcon;

        setState(() {
          _markerso3.add(Marker(
            markerId: MarkerId(properties.id_sensore),
            position: LatLng(geometry.coordinates[1], geometry.coordinates[0]),
            alpha: 0.6,
            onTap: () {
              setState(() {
                apri_info = true;
                apri_ricerca = false;
                index = 1;
                pos_curr_marker = LatLng(geometry.coordinates[1], geometry.coordinates[0]);
                valori_sensore = properties;
                _markers.remove(Marker(markerId: MarkerId("Ricerca")));
                _markers.remove(Marker(markerId: MarkerId("Selezione")));
                _markers.add(
                    Marker(
                      markerId: MarkerId("Selezione"),
                      position: pos_curr_marker,
                      icon: BitmapDescriptor.fromBytes(markerIconBlu),
                    )
                );
              });
            },
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ));
        });
      }
    }
    on SocketException catch (_){
      return;
    }
  }

  Future<bool> _willPopCalbackHome() async {
    bool torna_indietro = true;
    if (apri_info || apri_ricerca){
      torna_indietro = false;
    }
    chiudi_tutto();
    return torna_indietro;
  }

  //Chiude robe toccando la mappa
  void _googlemaptap(LatLng posizione_toccata) async {
    chiudi_tutto();
  }

  void chiudi_tutto(){
    setState(() {
      apri_info = false;
      apri_ricerca = false;
      _markers.remove(Marker(markerId: MarkerId("Ricerca")));
      _markers.remove(Marker(markerId: MarkerId("Selezione")));
      index = 1;
    });
  }

  //Alla creazione della mappa scarica il JSON e centra nella giusta posizione (also change map style if needed)
  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(ListOfStyles[currStyleNum]);
    _controller.complete(controller);
    fetchData(http.Client());
    _updatelocationstream();

  }

  void _updatelocationstream() async {
    try {
      GeolocationStatus geolocationStatus = await Geolocator()
          .checkGeolocationPermissionStatus();
      _currentLocation();
      final Uint8List markerApe = await getBytesFromAsset(
          "immagini/ape.png", 60);
      Geolocator geolocator = Geolocator();
      geolocator.getPositionStream(LocationOptions(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5
      )).listen((position) {
        try {
          posizione_assoluta = LatLng(position.latitude, position.longitude);
        } on Exception {
          null;
        }

        setState(() {
          _markers.remove(Marker(markerId: MarkerId("Posizione")));
          _markers.add(Marker(
            // This marker id can be anything that uniquely identifies each marker.
            markerId: MarkerId("Posizione"),
            position: posizione_assoluta,
            icon: BitmapDescriptor.fromBytes(markerApe),
          ));
        });
      });
    } on PlatformException catch(_){}
  }

  //Centra nella posizione e aggiunge il marker con l'ape
  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    final Uint8List markerApe = await getBytesFromAsset(
        "immagini/ape.png", 60);
    try {
      LocationData currentLocation;
      var location = new Location();
      try {
        currentLocation = await location.getLocation();
      } on Exception {
        currentLocation = null;
      }

      posizione_assoluta =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: posizione_assoluta,
          zoom: 13.0,
        ),
      ));

      setState(() {
        _markers.remove(Marker(markerId: MarkerId("Posizione")));
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId("Posizione"),
          position: posizione_assoluta,
          icon: BitmapDescriptor.fromBytes(markerApe),
        ));
      });
      inviaposizione(http.Client(), posizione_assoluta.latitude, posizione_assoluta.longitude);
    } on PlatformException catch(_){}
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
    try {
      List<Placemark> posizione_info = await Geolocator().placemarkFromAddress(
        testo_parziale,
        localeIdentifier: "it_IT"
      );
      setState(() {
        testo_ricerca = posizione_info[0].name + ", " + posizione_info[0].locality;
        risultato_ricerca = posizione_info[0].position;
      });
    } on PlatformException catch(_) {}
  }

  // Se premi su invio nella ricerca parte questo
  void ricerca(String testo) async {
    try {
      List<Placemark> posizione_info = await Geolocator().placemarkFromAddress(
          testo);
      setState(() {
        risultato_ricerca = posizione_info[0].position;
      });
      vaaposizione();
    }
    on PlatformException catch(_) {
      setState(() {
        testo_ricerca = Translations.of(context).text('indirizzo_sconosciuto');
      });
    }
  }

  // Muove la camera fino alla posizione risultato_ricerca
  void vaaposizione() async {
    try {
      final GoogleMapController controller = await _controller.future;
      LatLng posizione = LatLng(
          risultato_ricerca.latitude, risultato_ricerca.longitude);

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
        index = 1;
      });
    } on NoSuchMethodError catch(_){
      setState(() {
        testo_ricerca = Translations.of(context).text('indirizzo_sconosciuto');
      });
    }
  }

  // Ritorna una lista col widget dei valori per CAQI
  List<charts.Series<GaugeSegment, String>> _PmData() {
    int val_pm = valori_sensore.pm_10.pm_10.toInt();
    List<GaugeSegment> data = [
      new GaugeSegment('High', val_pm),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'CAQI',
        colorFn: (_, __) => (val_pm < 25) ?
          charts.MaterialPalette.green.shadeDefault:
          (val_pm < 50) ? charts.MaterialPalette.yellow.shadeDefault:
          (val_pm < 75) ? charts.MaterialPalette.deepOrange.shadeDefault:
          charts.MaterialPalette.red.shadeDefault,
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }

  //Precipitazioni
  List<charts.Series<GaugeSegment, String>> _PrecData() {
    int val_prec = valori_sensore.meteo.prec.toInt();
    List<GaugeSegment> data = [
      new GaugeSegment('High', val_prec),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'PREC',
        colorFn: (_, __) => (val_prec < 25) ?
        charts.MaterialPalette.green.shadeDefault:
        (val_prec < 50) ? charts.MaterialPalette.yellow.shadeDefault:
        (val_prec < 75) ? charts.MaterialPalette.deepOrange.shadeDefault:
        charts.MaterialPalette.red.shadeDefault,
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }

  List<charts.Series<GaugeSegment, String>> _TempData() {
    int val_temp = valori_sensore.meteo.temp.toInt();
    List<GaugeSegment> data = [
      new GaugeSegment('High', val_temp),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'PREC',
        colorFn: (_, __) => (val_temp < 25) ?
        charts.MaterialPalette.green.shadeDefault:
        (val_temp < 50) ? charts.MaterialPalette.yellow.shadeDefault:
        (val_temp < 75) ? charts.MaterialPalette.deepOrange.shadeDefault:
        charts.MaterialPalette.red.shadeDefault,
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }

  List<charts.Series<GaugeSegment, String>> _VentoData() {
    int val_vento = valori_sensore.meteo.vento.toInt();
    List<GaugeSegment> data = [
      new GaugeSegment('High', val_vento),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'PREC',
        colorFn: (_, __) => (val_vento < 25) ?
        charts.MaterialPalette.green.shadeDefault:
        (val_vento < 50) ? charts.MaterialPalette.yellow.shadeDefault:
        (val_vento < 75) ? charts.MaterialPalette.deepOrange.shadeDefault:
        charts.MaterialPalette.red.shadeDefault,
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }

}