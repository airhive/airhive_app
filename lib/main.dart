import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' hide LocationAccuracy;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Local imports
import 'dynamic_models.dart';

part "home.dart";
part "login.dart";
part "legale.dart";
part "settings.dart";
part "messages.dart";
part "moredata.dart";
part "global_translations.dart";

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  TranslationsBloc translationsBloc;

  @override
  void initState(){
    super.initState();
    translationsBloc = TranslationsBloc();
  }

  @override
  void dispose(){
    translationsBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider<TranslationsBloc>(
        bloc: translationsBloc,
        child: StreamBuilder<Locale>(
            stream: translationsBloc.currentLocale,
            initialData: allTranslations.locale,


            builder: (BuildContext context, AsyncSnapshot<Locale> snapshot){
              return new MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: app_theme(),
                  darkTheme: app_theme_dark(),
                  locale: snapshot.data ?? allTranslations.locale,
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: allTranslations.supportedLocales(),

                  /*
        localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('it', ''),
        const Locale('de', ''),
      ],
      */



                  home: new HomePage(),
                  routes: <String, WidgetBuilder> {
                    '/homemap': (BuildContext context) => new HomePage(),
                    '/settings': (BuildContext context) => new SettingsPage(),
                    '/account': (BuildContext context) => new AccountPage(),
                    '/legal': (BuildContext context) => new LegalePage(),
                    '/messages': (BuildContext context) => new MessagesPage(),
                    '/moredata': (BuildContext context ) => new DataPage(),
                  }
              );}));
  }
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

    fontFamily: 'PassionOne', // cambia dappertutto

    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontFamily: 'PassionOne'),
      title: TextStyle(fontSize: 36.0, fontFamily: 'PassionOne'),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans'),
    ),
  );
}


//The dark theme for the app
ThemeData app_theme_dark(){
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    accentColor: Colors.white,

    iconTheme: IconThemeData (
      color: Colors.white,
    ),

    fontFamily: 'PassionOne',

    textTheme: TextTheme(
      headline: TextStyle(fontSize:72.0, fontFamily: 'PassionOne'),
      title: TextStyle(fontSize: 36.0, fontFamily: 'PassionOne'),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'OpenSans'),

    ),
  );
}


// Genera il menu laterale nel giusto context
Drawer menulaterale(context){
  final TranslationsBloc translationsBloc = BlocProvider.of<TranslationsBloc>(context);

  return Drawer(
      child: new Container(
          color: Theme.of(context).primaryColor,
          child: new ListView(
            children: <Widget> [
              new DrawerHeader(
                decoration: new BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black26,
                    )],
                  color: Theme.of(context).primaryColor,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: new Image.asset(
                    "immagini/airhive_white2.png",
                    scale: 5.5,
                  ), ),

              ),
              new ListTile(
                leading: Icon(Icons.map, color: Colors.white),
                title: new Text(allTranslations.text('sideMenu.map_button'),
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18,
                    )
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/homemap');
                },
              ),
              new ListTile(
                leading: Icon(Icons.account_box, color: Colors.white),
                title: new Text(allTranslations.text('sideMenu.account_button'),
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18,
                    )
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/account');
                },
              ),
              new ListTile(
                leading: Icon(Icons.markunread, color: Colors.white),
                title: new Text(allTranslations.text('sideMenu.alerts_button'),
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18,
                    )
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/messages');
                },
              ),
              new Divider(height: 10, color: Colors.black26,),
              new ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: new Text(allTranslations.text('sideMenu.settings_button'),
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18,
                    )
                ),
                onTap: (){
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              new ListTile(
                leading: Icon(Icons.receipt, color: Colors.white),
                title: new Text(allTranslations.text('sideMenu.legal_button'),
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18,
                    )
                ),
                onTap: (){
                  Navigator.pushNamed(context, '/legal');
                },
              ),
              new Divider(height: 10, color: Colors.black26,),
              new ListTile(
                title: new Text('We are what we breathe',
                    style: TextStyle(
                      fontFamily:"OpenSans",
                      color: Colors.white,
                      fontSize: 15,
                    )
                ),
                subtitle: new Text('Copyright © 2019 AirHive',
                    style: TextStyle(
                      fontFamily:"OpenSans",
                      color: Colors.white,
                      fontSize: 10,
                    )
                ),
              ),
            ],
          )
      )
  );
}

//Per inviare la posizione in ogni momento
Future<void> inviaposizione(http.Client client, double lat, double lng) async {
  try {
    await client.get(
        'https://www.airhive.it/php/updateDevicePos.php?deviceTkn=$login_token&lat=$lat&lng=$lng');
  }
  catch (SocketException){
  };
}

//Controlla se c'è connessione
Future<void> connectionCheck() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      conessioneassente = false;
    }
  } on SocketException catch (_) {
    conessioneassente = true;
  }
}

//Function to check the current map used
int getCurrMap(){
  if(isCurrSetting(0, currMapNum)&&isCurrSetting(4, currStyleNum)){
    return 0;
  }else if(isCurrSetting(2, currMapNum)){
    return 1;
  } else if (isCurrSetting(1, currMapNum)){
    return 2;
  } else if(isCurrSetting(3, currMapNum)){
    return 3;
  }else if(isCurrSetting(0, currMapNum)&&isCurrSetting(0, currStyleNum)){
    return 4;
  }else if(isCurrSetting(0, currMapNum)&&isCurrSetting(1, currStyleNum)){
    return 5;
  } else if(isCurrSetting(0, currMapNum)&&isCurrSetting(2, currStyleNum)){
    return 6;
  } else if(isCurrSetting(0, currMapNum)&&isCurrSetting(5, currStyleNum)){
    return 7;
  }else if(isCurrSetting(0, currMapNum)&&isCurrSetting(6, currStyleNum)){
    return 8;
  }
}


//main
void main() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await allTranslations.init();

  mail_inviata = (await prefs.getString("mail_inviata")) ?? "no";

  //Retrieve map information from shared preferences
  currMapNum = await getMapType();
  currStyleNum = await getMapStyle();
  currMap = getCurrMap();

  await _login(http.Client());
  //runApp(MyApp());
  runApp(
      MultiProvider(
        providers:[
          ChangeNotifierProvider<MapStyleModel>(builder: (context) => MapStyleModel(),
          ),
        ],
        child: MyApp(),
      )
  );
}