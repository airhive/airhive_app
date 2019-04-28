import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

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
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';




//Local imports
import 'translations.dart';

part "home.dart";
part "login.dart";
part "legale.dart";
part "settings.dart";


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: app_theme(),
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
      home: new HomePage(),
      routes: <String, WidgetBuilder> {
      '/homemap': (BuildContext context) => new HomePage(),
      '/settings': (BuildContext context) => new SettingsPage(),
      '/account': (BuildContext context) => new AccountPage(),
      '/legal': (BuildContext context) => new LegalePage(),
      }
    );
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
            title: new Text(Translations.of(context).text('map_button_text')),
            onTap: () {
              Navigator.pushNamed(context, '/homemap');
            },
          ),
          new ListTile(
            title: new Text(Translations.of(context).text('account_button_text')),
            onTap: () {
              Navigator.pushNamed(context, '/account');
            },
          ),
          new Divider(),
          new ListTile(
            title: new Text(Translations.of(context).text('settings_button_text')),
            onTap: (){
              Navigator.pushNamed(context, '/settings');
            },
          ),
          new ListTile(
            title: new Text(Translations.of(context).text('legal_privacy_button_text')),
            onTap: (){
              Navigator.pushNamed(context, '/legal');
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

//main
void main() async {
  await PrefService.init(prefix: 'pref_');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  mail_inviata = (await prefs.getString("mail_inviata")) ?? "no";
  currMapNum = await getMapType();
  await _login(http.Client());
  runApp(MyApp());
}