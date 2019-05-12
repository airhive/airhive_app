part of "main.dart";


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

    final TranslationsBloc translationsBloc = BlocProvider.of<TranslationsBloc>(context);

    return new Scaffold(
          drawer: menulaterale(context),
          appBar: new AppBar(
            title: new Text(allTranslations.text('settings_title')),
            backgroundColor: Colors.yellow[700],
          ),
          body: new PreferencePage([

            //Impostazioni stile mappa
            PreferenceTitle(allTranslations.text('map_style_title')),
            RadioPreference(
              allTranslations.text('map_type_normal_button_text'),
              'ROADMAP',
              'map_theme',
              isDefault: isCurrSetting(0, currMapNum),
              onSelect: (){
                setMapType(0);
              },
            ),
            RadioPreference(
              allTranslations.text('map_type_satellite_button_text'),
              'SATELLITE',
              'map_theme',
              isDefault: isCurrSetting(2, currMapNum),
              onSelect: (){
                setMapType(1);
              },
            ),
            RadioPreference(
              allTranslations.text('map_type_hybrid_button_text'),
              'HYBRID',
              'map_theme',
              isDefault: isCurrSetting(1, currMapNum),
              onSelect: (){
                setMapType(2);
              },
            ),
            RadioPreference(
              allTranslations.text('map_type_topographical_button_text'),
              'TERRAIN',
              'map_theme',
              isDefault: isCurrSetting(3, currMapNum),
              onSelect: (){
                setMapType(3);
              },
            ),
            PreferenceTitle(allTranslations.text('language_title')),
            DropdownPreference(
              'Language',
              'language_selection',
              defaultVal: 'Italiano',
              values: ['Italiano', 'English', 'Deutsch'],
            ),






          ]),



        );
  }
}
