part of "main.dart";

//Defining variables to define custom types of maps
String _darkMap;
String _nightMap;
String _retroMap;
String _gtaMap;
String _silverMap;
String _aubergineMap;

int currMap;


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

  List<RadioModel> mapData = new List<RadioModel>();

  void loadMapSettings() {
    mapData.add(new RadioModel(false, "immagini/normale.png", "Standard"));
    mapData.add(new RadioModel(false, "immagini/satellite.png", "Satellite"));
    mapData.add(new RadioModel(false, "immagini/ibrido.png", "Hybrid"));
    mapData.add(new RadioModel(false, "immagini/topo.png", "Topographical"));
    mapData.add(new RadioModel(false, "immagini/dark.png", "Dark"));
    mapData.add(new RadioModel(false, "immagini/night.png", "Night"));
    mapData.add(new RadioModel(false, "immagini/retro.png", "Vintage"));
    mapData.add(new RadioModel(false, "immagini/silver.png", "Silver"));
    mapData.add(new RadioModel(false, "immagini/aubergine.png", "Aubergine"));
    mapData[currMap].isSelected = true;

  }




  @override
  void initState() {
    super.initState();
    loadMapSettings();
  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
        onWillPop: _willPopCalback,
        child: new Scaffold(
            drawer: menulaterale(context),
            appBar: new AppBar(
              title: new Text(Translations.of(context).text('settings_title')),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[

                  new Container(
                    child: Text(Translations.of(context).text('map_style_title'), style: new TextStyle(fontSize: 20),),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

                  ),

                  new Expanded(
                      child: new GridView.count(

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
      margin: new EdgeInsets.all(10.0),
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
                  width: 4.0,
                  color: _item.isSelected
                      ? Colors.yellow[700]
                      : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
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
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}
