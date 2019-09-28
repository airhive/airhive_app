part of 'main.dart';

class MapCustomRadio extends StatefulWidget {
  @override
  createState() {
    return new MapCustomRadioState();
  }
}

class MapCustomRadioState extends State<MapCustomRadio> {
  List<RadioModel> sampleData = new List<RadioModel>();

  @override
  void initState() {
    super.initState();
    sampleData.add(new RadioModel(false, "immagini/normale.png", ""));
    sampleData.add(new RadioModel(false, "immagini/satellite.png", ""));
    sampleData.add(new RadioModel(false, "immagini/ibrido.png", ""));
    sampleData.add(new RadioModel(false, "immagini/topo.png", ""));
    sampleData.add(new RadioModel(false, "immagini/dark.png", ""));
    sampleData.add(new RadioModel(false, "immagini/night.png", ""));
    sampleData.add(new RadioModel(false, "immagini/retro.png", ""));
    sampleData.add(new RadioModel(false, "immagini/silver.png", ""));
    sampleData.add(new RadioModel(false, "immagini/aubergine.png", ""));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView.builder(
        itemCount: sampleData.length,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
            //highlightColor: Colors.red,
            splashColor: Colors.blueAccent,
            onTap: () {
              setState(() {
                sampleData.forEach((element) => element.isSelected = false);
                sampleData[index].isSelected = true;
              });
            },
            child: new RadioItem(sampleData[index]),
          );
        },
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(10.0),
      child: new Row(
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
                      ? Colors.blueAccent
                      : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(left: 10.0),
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
