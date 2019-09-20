part of "main.dart";

//Defining variables to define custom types of maps
String _darkMap;
String _nightMap;
String _retroMap;
String _gtaMap;


/*
* Defining a list to store map types:
*
* position -> MapType
*    0     -> normal
*    1     -> satellite
*    2     -> hybrid
*    3     -> terrain
 */
const ListOfMaps = [MapType.normal, MapType.satellite, MapType.hybrid, MapType.terrain];
int currMapNum; //An integer to indicate the current type of map at runtime
int defMapNum = 3; //An integer to indicate the default type of map



/*
 * Defining a list to store map styles:
 *
 * position -> MapStyle
 *    0     -> dark
 *    1     -> night
 *    2     -> retro
 *    3     -> gta
 *    4     -> classic
 * */
final ListOfStyles = [_darkMap, _nightMap, _retroMap, _gtaMap, null];
int currStyleNum; //An integer to indicate the default style of map at runtime
int defStyleNum = 4; //An integer to indicate the default map style


//Defining a function to get the type of map from saved preferences (if not present set it to the default value)
Future<int> getMapType() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int controlValue = prefs.getInt('maptype');
  if(controlValue != null) {
    return controlValue;
  } else {
    prefs.setInt('maptype', defMapNum);
    return defMapNum;
  }
}

//Defining a function to save a selected type of map into preferences and set it as current type of map
Future<void> setMapType(int mapToSet) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  currMapNum = mapToSet;
  prefs.setInt('maptype', mapToSet);

}

//Defining a function to get the style of map from saved preferences (if not present set it to the default value)
Future<int> getMapStyle() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int controlValue = prefs.getInt('mapstyle');
  if(controlValue != null) {
    return controlValue;
  } else {
    prefs.setInt('mapstyle', defStyleNum);
    return defStyleNum;
  }
}

//Defining a function to save a selected style of map into preferences and set it as current style of map
Future<void> setStyleOfMap(int styleToSet) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  currStyleNum = styleToSet;
  prefs.setInt('mapstyle', styleToSet);

}

//Define a function to check if a setting is the current setting
bool isCurrSetting(var toCheck, var curSett){
  if (toCheck == curSett) {
    return true;
  } else {
    return false;
  }
}



//Writing Settings page code
class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
          drawer: menulaterale(context),
          appBar: new AppBar(
            title: new Text(Translations.of(context).text('settings_title')),
            backgroundColor: Colors.yellow[700],
          ),
          body: new PreferencePage([

            //Impostazioni stile mappa
            PreferenceTitle(Translations.of(context).text('map_style_title')),
            RadioPreference(
              Translations.of(context).text('map_type_normal_button_text'),
              'ROADMAP',
              'map_theme',
              isDefault: isCurrSetting(0, currMapNum)&&isCurrSetting(4, currStyleNum),
              onSelect: (){
                setMapType(0);
                setStyleOfMap(4);
              },
            ),
            RadioPreference(
              Translations.of(context).text('map_type_satellite_button_text'),
              'SATELLITE',
              'map_theme',
              isDefault: isCurrSetting(2, currMapNum),
              onSelect: (){
                setMapType(1);
                setStyleOfMap(4);
              },
            ),
            RadioPreference(
              Translations.of(context).text('map_type_hybrid_button_text'),
              'HYBRID',
              'map_theme',
              isDefault: isCurrSetting(1, currMapNum),
              onSelect: (){
                setMapType(2);
                setStyleOfMap(4);
              },
            ),
            RadioPreference(
              Translations.of(context).text('map_type_topographical_button_text'),
              'TERRAIN',
              'map_theme',
              isDefault: isCurrSetting(3, currMapNum),
              onSelect: (){
                setMapType(3);
                setStyleOfMap(4);
              },
            ),
            RadioPreference(
              Translations.of(context).text('map_type_dark_button_text'),
              'DARK',
              'map_theme',
              isDefault: isCurrSetting(0, currMapNum)&&isCurrSetting(0, currStyleNum),
              onSelect: (){
                setMapType(0);
                setStyleOfMap(0);
              },
            ),
            RadioPreference(
              Translations.of(context).text('map_type_night_button_text'),
              'NIGHT',
              'map_theme',
              isDefault: isCurrSetting(0, currMapNum)&&isCurrSetting(1, currStyleNum),
              onSelect: (){
                setMapType(0);
                setStyleOfMap(1);
              },
            ),
            RadioPreference(
              Translations.of(context).text('map_type_retro_button_text'),
              'RETRO',
              'map_theme',
              isDefault: (isCurrSetting(0, currMapNum))&&(isCurrSetting(2, currStyleNum)),
              onSelect: (){
                setMapType(0);
                setStyleOfMap(2);
              },
            ),






          ]),



        );
  }
}
