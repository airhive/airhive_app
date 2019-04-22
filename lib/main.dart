import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:preferences/preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:device_info/device_info.dart';
import 'package:webview_flutter/webview_flutter.dart';

part "home.dart";

String login_token;

/*
//Defining a class to store preferences
class CurrSettings{
  final MapType currMapType; //Type of Map
  final String currAqiType; //Type of Air Quality Index (AQI)
  final String currLang; //Language

  CurrSettings({
    this.currMapType,
    this.currAqiType,
    this.currLang,

  });

  factory CurrSettings.fromJson(Map<String, dynamic> prefjson) {

    return CurrSettings(
        currMapType: prefjson['currMapType'] as MapType,
        currAqiType: prefjson['currAqiType'] as String,
        currLang: prefjson['currLang'] as String,
    );
  }
  factory CurrSettings.setDefSettings(){

    return CurrSettings(
      currMapType: MapType.terrain,
      currAqiType: 'CAQI',
      currLang: 'IT',
    );
  }

}

//Defining a function to set default values for preferences
CurrSettings setDefSettings(CurrSettings sett) {
  sett.currMapType = MapType.terrain;
  sett.currAqiType = 'CAQI';
  sett.currLang = 'IT';

  return sett;

}*/

//Defining a map to assign string to maptype
Map<String, MapType> typeofMaps = {
  'terrain':MapType.terrain,
  'hybrid':MapType.hybrid,
  'satellite':MapType.satellite,
  'normal':MapType.normal,
  'dark':MapType.normal, //@ZANATTA1310 HO MODIFICATO QUA C'ERA .values

};

//Defining a class to store preferences
class Preferences{
  final MapType typeOfMap;
  final String aqiType;
  final String language;

  Preferences(
      this.typeOfMap,
      this.aqiType,
      this.language,
      );

  Preferences.fromJson(Map<String, dynamic> json)
      : typeOfMap = json['typeofmap'],
        aqiType = json['aqitype'],
        language = json['language'];

  Map<String, dynamic> toJson() =>
      {
        'typeofmap': typeOfMap.toString(),
        'aqitype': aqiType,
        'language': language,
      };

}

Preferences getDefaultsPrefs(){
  return Preferences(
      MapType.terrain,
      'CAQI',
      'IT',
  );
}

/*
METODO PER RACCOLTA PREFERENCES
String _preferences;

Future<void> getPrefs() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String _prefs = prefs.getString('prefs');
  if(_prefs != null){
    Map prefsMap = jsonDecode(_prefs);
    //_preferences = new Preferences.fromJson(prefsMap);
    _preferences = _prefs;
    print(_preferences);
  } else {
    Preferences preferences = getDefaultsPrefs();
    Map<String, dynamic> jsonpref = preferences.toJson();
    print(jsonpref);
    String prefjson = jsonEncode(jsonpref);
    print(prefjson);
    prefs.setString('prefs', prefjson);
    _preferences = prefs.get('prefs');
    print(_preferences);
  }
}
*/

//Creating a function to check for the presence of a preference file in shared_preferences
//If the file does not exist create one with default values
/*
Future<void> getSettings(CurrSettings sett) async {
  SharedPreferences sharedPreferences =  await SharedPreferences.getInstance();
  String controlvalue = sharedPreferences.getString('prefs');
  if (controlvalue != null) {
    Map last_sett = jsonDecode(controlvalue);
    CurrSettings settings = CurrSettings.fromJson(last_sett);
    CurrSettings sett = settings;
  } else {

    CurrSettings settings;
    settings = CurrSettings.setDefSettings();
    String prefjson = jsonEncode(settings);
    sharedPreferences.setString('prefs', prefjson);
    return settings;

  }
}
*/

//void main() => runApp(MyApp());
main() async {
  await PrefService.init(prefix: 'pref_');
  await _login(http.Client());
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

  Preferences _preferences;

  Future<void> getPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _prefs = prefs.getString('prefs');
    if(_prefs != null){
      Map<String, dynamic> prefsMap = jsonDecode(_prefs);
      _preferences = new Preferences.fromJson(prefsMap);
      print(_preferences);
    } else {
      Preferences preferences = getDefaultsPrefs();
      Map<String, dynamic> jsonpref = preferences.toJson();
      String prefjson = jsonEncode(jsonpref);
      prefs.setString('prefs', prefjson);
      _preferences = preferences;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: app_theme(),
      home: Builder(
        builder: (context) => Scaffold(
          drawer: menulaterale(context),
          appBar: new AppBar(
            title: new Text("Impostazioni"),
            backgroundColor: Colors.yellow[700],
          ),
          body: new PreferencePage([

            //Impostazioni stile mappa
            PreferenceTitle("Stile mappa"),
            RadioPreference(
              'Rilievi',
              'TERRAIN',
              'map_theme',
              isDefault: true,
              onSelect: (){
                //_currentMapType = MapType.terrain;
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
            RadioPreference(
              'Normale',
              'ROADMAP',
              'map_theme',
              onSelect: (){
                //_currentMapType = MapType.normal;
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
            RadioPreference(
              'Dark',
              'DARK',
              'map_theme',
            ),

            RadioPreference(
              'Satellite',
              'SATELLITE',
              'map_theme',
              onSelect: (){
                //_currentMapType = MapType.satellite;
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),


            //Impostazioni tipo indice qualità aria
          ]),



          ),
      ),
    );
  }
}

class AccountPage extends StatefulWidget{
  _AccountPage createState()=> _AccountPage();
}

//Pagina account
class _AccountPage extends State<AccountPage> {
  bool mostra_caricamento = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: app_theme(),
      home: Builder(
        builder: (context) => Scaffold(
          drawer: menulaterale(context),
          appBar: new AppBar(
            title: new Text("Account"),
            backgroundColor: Colors.yellow[700],
          ),
          body: Builder(builder: (BuildContext context){
                return Stack(
                    children: <Widget>[
                      WebView(
                        onPageFinished: (ciao) => {setState((){
                          mostra_caricamento = false;
                          print("https://www.airhive.it/account/?relog=true&tkn=$login_token");
                        })},
                        initialUrl: "https://www.airhive.it/account/index.php?relog=true&tkn=$login_token",
                        javascriptMode: JavascriptMode.unrestricted,
                      ),
                      mostra_caricamento ? CircularProgressIndicator() : Container(),
                    ]
              );
              },
          ),
        ),
      ),
    );
  }
}

class LegalePage extends StatefulWidget{
  _LegalePage createState()=> _LegalePage();
}

//Writing account page code
class _LegalePage extends State<LegalePage> {
  bool mostra_caricamento = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: app_theme(),
      home: Builder(
        builder: (context) => Scaffold(
          drawer: menulaterale(context),
          appBar: new AppBar(
            title: new Text("Legale"),
            backgroundColor: Colors.yellow[700],
          ),
          body: Builder(builder: (BuildContext context){
            return Stack(
                children: <Widget>[
                  WebView(
                    onPageFinished: (ciao) => {setState((){
                      mostra_caricamento = false;
                    })},
                    initialUrl: "https://www.airhive.it/legal?app=true",
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                  mostra_caricamento ? CircularProgressIndicator() : Container(),
                ]
            );
          },
          ),
        ),
      ),
    );
  }
}

class LoginData{
  final bool success;
  final String token;

  LoginData({
    this.success,
    this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      success: json['success'] as bool,
      token: json['tkn'] as String,
    );
  }
}

// Login su airhive.it appena la app parte
Future<void> _login(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token_old = (await prefs.getString("token")) ?? "CIAONE";
  String modello_device;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid){
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    modello_device = androidInfo.model;
  }
  else if (Platform.isIOS){
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    modello_device = iosInfo.utsname.machine;
  }
  final response =
  await client.get('https://www.airhive.it/php/login.php?deviceModel=$modello_device&deviceName=My+Device&app=true&tkn=$token_old');
  final parsed = json.decode(response.body);

  LoginData res =  LoginData.fromJson(parsed);
  bool success = res.success;
  String token = res.token;

  if((token != token_old) & success){
    prefs.setString("token", token);
    token_old = token;
  }
  login_token = token_old;
}

// Il tema della app
ThemeData app_theme(){
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.yellow[700],
    accentColor: Colors.yellow[700],

    iconTheme: IconThemeData(
        color: Colors.white,
    ),

    //fontFamily: 'Montserrat',

    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );
}

// Genera il menu laterale nel giusto context
Drawer menulaterale(context){
  return Drawer(
      child: new ListView(
        children: <Widget> [
          new DrawerHeader(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                },
                child: new Image.asset(
                  "immagini/airhive.png",
                  scale: 5.5,
           ), ),
            decoration: BoxDecoration(
              color: Colors.yellow[700],
            ),
          ),
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
          new ListTile(
            title: new Text('Legale'),
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(builder: (context) => new LegalePage()),);
            },
          ),
          new Divider(),
          new ListTile(
            title: new Text('We are what we breathe.'),
          ),
        ],
      )
  );
}

