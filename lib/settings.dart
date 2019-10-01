part of "main.dart";

//Defining list to store the options showed on settings page
List<RadioModel> mapData = new List<RadioModel>();
List<LanguageRadioModel> languageData = new List<LanguageRadioModel>();

//Defining variables to define custom types of maps
String _darkMap;
String _nightMap;
String _retroMap;
String _gtaMap;
String _silverMap;
String _aubergineMap;

int currMap;

/*
* Defining a list to store language codes:
*   position  ->  Language
*      0      ->  Italian
*      1      ->  English
*      2      ->  German
 */

const ListOfLangs = ["it", "en", "de"];
int currLang;
int getDefLang(){
  String currLoc = Platform.localeName.toLowerCase();
  int res = ListOfLangs.length;
  for(var i = 0; i < ListOfLangs.length;){
    if(currLoc == ListOfLangs[i]){
      res = i;
      break;
    } else{
      i++;
    }

  if(res<ListOfLangs.length){
    return res;
  } else {
    return 1;
  }

  }
}
int defLangNum = getDefLang();

//Defining a function to get the language from saved preferences (if not present set it to the default value)
Future<int> getLanguage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int controlValue = prefs.getInt('languageNum');
  if(controlValue != null) {
    return controlValue;
  } else {
    prefs.setInt('languageNum', defLangNum);
    return defLangNum;
  }
}

//Defining a function to save a selected language into preferences and set it as current type of map
Future<void> setLanguage(int langToSet) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  currLang = langToSet;
  allTranslations.setNewLanguage(ListOfLangs[currLang]);
  languageData.forEach((element) => element.isSelected = false);
  languageData[currLang].isSelected = true;
  prefs.setInt('languageNum', langToSet);

}


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
 *    5     -> silver
 *    6     -> aubergine
 * */
final ListOfStyles = [_darkMap, _nightMap, _retroMap, _gtaMap, null, _silverMap, _aubergineMap];
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
  String mapDropdownValue;


  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<bool> _willPopCalback() async {
    Navigator.pushNamed(context, '/homemap');
    return false;
  }


  void loadRadioSettings() {
    //Initialise mapData list
    mapData.add(new RadioModel(false, "immagini/normale.png", allTranslations.text('settingsPage.standard_map')));
    mapData.add(new RadioModel(false, "immagini/satellite.png", allTranslations.text('settingsPage.satellite_map')));
    mapData.add(new RadioModel(false, "immagini/ibrido.png", allTranslations.text('settingsPage.hybrid_map')));
    mapData.add(new RadioModel(false, "immagini/topo.png", allTranslations.text('settingsPage.topographical_map')));
    mapData.add(new RadioModel(false, "immagini/dark.png", allTranslations.text('settingsPage.dark_map')));
    mapData.add(new RadioModel(false, "immagini/night.png", allTranslations.text('settingsPage.night_map')));
    mapData.add(new RadioModel(false, "immagini/retro.png", allTranslations.text('settingsPage.retro_map')));
    mapData.add(new RadioModel(false, "immagini/silver.png", allTranslations.text('settingsPage.silver_map')));
    mapData.add(new RadioModel(false, "immagini/aubergine.png", allTranslations.text('settingsPage.aubergine_map')));

    //Initialize languageData list
    languageData.add(new LanguageRadioModel(false, 'it', "Italiano"));
    languageData.add(new LanguageRadioModel(false, 'gb', "English"));
    languageData.add(new LanguageRadioModel(false, 'de', "Deutsch"));

    mapData[currMap].isSelected = true;
    languageData[currLang].isSelected = true;

  }







  @override
  void initState() {
    super.initState();
    loadRadioSettings();
  }

  @override
  Widget build(BuildContext context) {

    mapData[0].text = allTranslations.text('settingsPage.standard_map');
    mapData[1].text = allTranslations.text('settingsPage.satellite_map');
    mapData[2].text = allTranslations.text('settingsPage.hybrid_map');
    mapData[3].text = allTranslations.text('settingsPage.topographical_map');
    mapData[4].text = allTranslations.text('settingsPage.dark_map');
    mapData[5].text = allTranslations.text('settingsPage.night_map');
    mapData[6].text = allTranslations.text('settingsPage.retro_map');
    mapData[7].text = allTranslations.text('settingsPage.silver_map');
    mapData[8].text = allTranslations.text('settingsPage.aubergine_map');


    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));


    return WillPopScope(
        onWillPop: _willPopCalback,
        child: new Scaffold(
            drawer: menulaterale(context),
            appBar: new AppBar(
              title: new Text(allTranslations.text('settingsPage.title')),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: ListView(
                //crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[

                  new Container(
                    child: Text(allTranslations.text('settingsPage.map_settings'), style: new TextStyle(fontSize: 20),),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

                  ),

                  new ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 400),
                      child: new GridView.count(

                        shrinkWrap: true,
                        physics: new NeverScrollableScrollPhysics(),

                        crossAxisCount: 3,
                        children: <Widget>[

                          new InkWell(
                            splashColor: Colors.yellow[700],
                            onTap: (){
                              setState(() {
                                mapData.forEach((element) => element.isSelected = false);
                                currMap = 0;
                                setMapType(0);
                                setStyleOfMap(4);
                                mapData[currMap].isSelected = true;
                              });
                            },
                            child: new RadioItem(mapData[0]),
                          ),

                          new InkWell(
                            splashColor: Colors.yellow[700],
                            onTap: (){
                              setState(() {
                                mapData.forEach((element) => element.isSelected = false);
                                currMap = 1;
                                setMapType(1);
                                setStyleOfMap(4);
                                mapData[currMap].isSelected = true;
                              });
                            },
                            child: new RadioItem(mapData[1]),
                          ),
                          new InkWell(
                            splashColor: Colors.yellow[700],
                            onTap: (){
                              setState(() {
                                mapData.forEach((element) => element.isSelected = false);
                                currMap = 2;
                                setMapType(2);
                                setStyleOfMap(4);
                                mapData[currMap].isSelected = true;
                              });
                            },
                            child: new RadioItem(mapData[2]),
                          ),
                          new InkWell(
                            splashColor: Colors.yellow[700],
                            onTap: (){
                              setState(() {
                                mapData.forEach((element) => element.isSelected = false);
                                currMap = 3;
                                setMapType(3);
                                setStyleOfMap(4);
                                mapData[currMap].isSelected = true;
                              });
                            },
                            child: new RadioItem(mapData[3]),
                          ),
                          new InkWell(
                            splashColor: Colors.yellow[700],
                            onTap: (){
                              setState(() {
                                mapData.forEach((element) => element.isSelected = false);
                                currMap = 4;
                                setMapType(0);
                                setStyleOfMap(0);
                                mapData[currMap].isSelected = true;
                              });
                            },
                            child: new RadioItem(mapData[4]),
                          ),
                          new InkWell(
                            splashColor: Colors.yellow[700],
                            onTap: (){
                              setState(() {
                                mapData.forEach((element) => element.isSelected = false);
                                currMap = 5;
                                setMapType(0);
                                setStyleOfMap(1);
                                mapData[currMap].isSelected = true;
                              });
                            },
                            child: new RadioItem(mapData[5]),
                          ),
                          new InkWell(
                            splashColor: Colors.yellow[700],
                            onTap: (){
                              setState(() {
                                mapData.forEach((element) => element.isSelected = false);
                                currMap = 6;
                                setMapType(0);
                                setStyleOfMap(2);
                                mapData[currMap].isSelected = true;
                              });
                            },
                            child: new RadioItem(mapData[6]),
                          ),
                          new InkWell(
                            splashColor: Colors.yellow[700],
                            onTap: (){
                              setState(() {
                                mapData.forEach((element) => element.isSelected = false);
                                currMap = 7;
                                setMapType(0);
                                setStyleOfMap(5);
                                mapData[currMap].isSelected = true;
                              });
                            },
                            child: new RadioItem(mapData[7]),
                          ),
                          new InkWell(
                            splashColor: Colors.yellow[700],
                            onTap: (){
                              setState(() {
                                mapData.forEach((element) => element.isSelected = false);
                                currMap = 8;
                                setMapType(0);
                                setStyleOfMap(6);
                                mapData[currMap].isSelected = true;
                              });
                            },
                            child: new RadioItem(mapData[8]),
                          ),
                        ],

                      )),
                  new Container(
                    child: Text(allTranslations.text('settingsPage.language_settings'), style: new TextStyle(fontSize: 20),),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

                  ),

                  new ConstrainedBox(
                      constraints: BoxConstraints.expand(height: 120),
                      child: new GridView.count(

                        shrinkWrap: true,
                        physics: new NeverScrollableScrollPhysics(),

                        crossAxisCount: 3,

                        children: <Widget>[

                          new InkWell(
                            splashColor: Colors.yellow[700],
                            onTap: () {
                              setState(() {
                                setLanguage(0);
                              });
                            },
                            child: new LanguageRadioItem(languageData[0]),
                          ),

                          new InkWell(
                            splashColor: Colors.yellow[700],
                            onTap: () {

                              setState(() {
                                setLanguage(1);
                              });
                            },
                            child: new LanguageRadioItem(languageData[1]),
                          ),
                          new InkWell(
                            splashColor: Colors.yellow[700],
                            onTap: () {
                              setState(() {
                                setLanguage(2);
                              });
                            },
                            child: new LanguageRadioItem(languageData[2]),
                          ),

                        ],

                      )),

                ]
            )
        ));
  }
}

//Radio button model for map selection
class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: 10.0),
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            height: 75.0,
            width: 75.0,
            child: new Center(
              child: new Image.asset(_item.buttonText),

            ),
            decoration: new BoxDecoration(
              border: new Border.all(
                  width: 5.0,
                  color: _item.isSelected
                      ? Colors.yellow[700]
                      : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: new Text(_item.text),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}


//Radio button model for language selection
class LanguageRadioItem extends StatelessWidget {
  final LanguageRadioModel _item;
  LanguageRadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(10.0),
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            height: 53.25,
            width: 75.0,
            child: new Center(
              child: new Image.asset('immagini/${_item.buttonText}.png'),

            ),
            decoration: new BoxDecoration(
              border: new Border.all(
                  width: 4.5,
                  color: _item.isSelected
                      ? Colors.yellow[700]
                      : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: new Text(_item.text),
          )
        ],
      ),
    );
  }
}

class LanguageRadioModel {
  bool isSelected;
  final String buttonText;
  String text;

  LanguageRadioModel(this.isSelected, this.buttonText, this.text);
}
