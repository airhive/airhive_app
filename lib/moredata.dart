part of "main.dart";

//Defining a page to show more pollutants data
class DataPage extends StatefulWidget {
  DataPage ({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _DataPageState();
  }
}

class _DataPageState extends State<DataPage> {

  @override
  Widget build(BuildContext context) {

    return new DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(null),
            ),
          ],
          leading: new Container(),
          bottom: TabBar(
            tabs: [
              Tab(text: "Storico"),
              Tab(text: "Attuale",),
              Tab(text: "Previsioni"),
            ],
          ),
          title: Text('Grafici'),
        ),
        body: TabBarView(
          children: [
            Text("COMING SOON"),
            Text("COMING SOON"),
            Text("COMING SOON"),
          ],
        ),
      ),
    );
  }
}