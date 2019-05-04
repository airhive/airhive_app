part of "main.dart";

class GraficoLineare{
  final int momento;
  final double valore;

  GraficoLineare(this.momento, this.valore);
}

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

  // Ritorna una lista col widget dei grafici storici per CAQI
  List<charts.Series<GraficoLineare, int>> _datiChartCAQI() {
    final pmchartdata = [
      new GraficoLineare(0, valori_sensore.pm_10.pm_10_4 / 3),
      new GraficoLineare(1, valori_sensore.pm_10.pm_10_3 / 3),
      new GraficoLineare(2, valori_sensore.pm_10.pm_10_2 / 3),
      new GraficoLineare(3, valori_sensore.pm_10.pm_10_1 / 3),
      new GraficoLineare(4, valori_sensore.pm_10.pm_10 / 3),
    ];

    var no2chartdata = [
      new GraficoLineare(0, valori_sensore.no2.no_4 / 12),
      new GraficoLineare(1, valori_sensore.no2.no_3 / 12),
      new GraficoLineare(2, valori_sensore.no2.no_2 / 12),
      new GraficoLineare(3, valori_sensore.no2.no_1 / 12),
      new GraficoLineare(4, valori_sensore.no2.no / 12),
    ];

    var o3chartdata = [
      new GraficoLineare(0, valori_sensore.o3.o3_4 / (2.4*3)),
      new GraficoLineare(1, valori_sensore.o3.o3_3 / (2.4*3)),
      new GraficoLineare(2, valori_sensore.o3.o3_2 / (2.4*3)),
      new GraficoLineare(3, valori_sensore.o3.o3_1 / (2.4*3)),
      new GraficoLineare(4, valori_sensore.o3.o3 / (2.4*3)),
    ];

    return [
      new charts.Series<GraficoLineare, int>(
        id: 'PM',
        displayName: "PM",
        // colorFn specifies that the line will be blue.
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        // areaColorFn specifies that the area skirt will be light blue.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: pmchartdata,
      ),
      new charts.Series<GraficoLineare, int>(
        id: 'NO2',
        // colorFn specifies that the line will be red.
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        // areaColorFn specifies that the area skirt will be light red.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: no2chartdata,
      ),
      new charts.Series<GraficoLineare, int>(
        id: 'O3',
        // colorFn specifies that the line will be green.
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        // areaColorFn specifies that the area skirt will be light green.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.green.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: o3chartdata,
      ),
    ];
  }

  List<charts.Series<GraficoLineare, int>> _datiFuturiChartCAQI() {
    final pmchartdata = [
      new GraficoLineare(0, valori_sensore.pm_10.pm_10 / 3),
      new GraficoLineare(1, valori_sensore.pm_10.pm_10p1 / 3),
      new GraficoLineare(2, valori_sensore.pm_10.pm_10p2 / 3),
      new GraficoLineare(3, valori_sensore.pm_10.pm_10p3 / 3),
      new GraficoLineare(4, valori_sensore.pm_10.pm_10p4 / 3),
    ];

    var no2chartdata = [
      new GraficoLineare(0, valori_sensore.no2.no / 12),
      new GraficoLineare(1, valori_sensore.no2.nop1 / 12),
      new GraficoLineare(2, valori_sensore.no2.nop2 / 12),
      new GraficoLineare(3, valori_sensore.no2.nop3 / 12),
      new GraficoLineare(4, valori_sensore.no2.nop4 / 12),
    ];

    var o3chartdata = [
      new GraficoLineare(0, valori_sensore.o3.o3 / (2.4*3)),
      new GraficoLineare(1, valori_sensore.o3.o3p1 / (2.4*3)),
      new GraficoLineare(2, valori_sensore.o3.o3p2 / (2.4*3)),
      new GraficoLineare(3, valori_sensore.o3.o3p3 / (2.4*3)),
      new GraficoLineare(4, valori_sensore.o3.o3p4 / (2.4*3)),
    ];

    return [
      new charts.Series<GraficoLineare, int>(
        id: 'PM',
        displayName: "PM",
        // colorFn specifies that the line will be blue.
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        // areaColorFn specifies that the area skirt will be light blue.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: pmchartdata,
      ),
      new charts.Series<GraficoLineare, int>(
        id: 'NO2',
        // colorFn specifies that the line will be red.
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        // areaColorFn specifies that the area skirt will be light red.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: no2chartdata,
      ),
      new charts.Series<GraficoLineare, int>(
        id: 'O3',
        // colorFn specifies that the line will be green.
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        // areaColorFn specifies that the area skirt will be light green.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.green.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: o3chartdata,
      ),
    ];
  }

  // Ritorna una lista col widget dei grafici per PM
  List<charts.Series<GraficoLineare, int>> _datiStoricoChartPM() {
    final pmchartdata = [
      new GraficoLineare(0, valori_sensore.pm_10.pm_10_4),
      new GraficoLineare(1, valori_sensore.pm_10.pm_10_3),
      new GraficoLineare(2, valori_sensore.pm_10.pm_10_2),
      new GraficoLineare(3, valori_sensore.pm_10.pm_10_1),
      new GraficoLineare(4, valori_sensore.pm_10.pm_10),
    ];
    return [
      new charts.Series<GraficoLineare, int>(
        id: 'PM',
        displayName: "PM",
        // colorFn specifies that the line will be blue.
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        // areaColorFn specifies that the area skirt will be light blue.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: pmchartdata,
      ),
    ];
  }
  List<charts.Series<GraficoLineare, int>> _datiFuturiChartPM() {
    final pmchartdata = [
      new GraficoLineare(0, valori_sensore.pm_10.pm_10),
      new GraficoLineare(1, valori_sensore.pm_10.pm_10p1),
      new GraficoLineare(2, valori_sensore.pm_10.pm_10p2),
      new GraficoLineare(3, valori_sensore.pm_10.pm_10p3),
      new GraficoLineare(4, valori_sensore.pm_10.pm_10p4),
    ];
    return [
      new charts.Series<GraficoLineare, int>(
        id: 'PM',
        displayName: "PM",
        // colorFn specifies that the line will be blue.
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        // areaColorFn specifies that the area skirt will be light blue.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: pmchartdata,
      ),
    ];
  }

  // Ritorna una lista col widget dei grafici per NO2
  List<charts.Series<GraficoLineare, int>> _datiStoricoChartNO2() {
    var no2chartdata = [
      new GraficoLineare(0, valori_sensore.no2.no_4),
      new GraficoLineare(1, valori_sensore.no2.no_3),
      new GraficoLineare(2, valori_sensore.no2.no_2),
      new GraficoLineare(3, valori_sensore.no2.no_1),
      new GraficoLineare(4, valori_sensore.no2.no),
    ];

    return [
      new charts.Series<GraficoLineare, int>(
        id: 'NO2',
        // colorFn specifies that the line will be red.
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        // areaColorFn specifies that the area skirt will be light red.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: no2chartdata,
      ),
    ];
  }
  List<charts.Series<GraficoLineare, int>> _datiFuturiChartNO2() {
    var no2chartdata = [
      new GraficoLineare(0, valori_sensore.no2.no),
      new GraficoLineare(1, valori_sensore.no2.nop1),
      new GraficoLineare(2, valori_sensore.no2.nop2),
      new GraficoLineare(3, valori_sensore.no2.nop3),
      new GraficoLineare(4, valori_sensore.no2.nop4),
    ];

    return [
      new charts.Series<GraficoLineare, int>(
        id: 'NO2',
        // colorFn specifies that the line will be red.
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        // areaColorFn specifies that the area skirt will be light red.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: no2chartdata,
      ),
    ];
  }

  // Ritorna una lista col widget dei grafici per O3
  List<charts.Series<GraficoLineare, int>> _datiStoricoChartO3() {
    var o3chartdata = [
      new GraficoLineare(0, valori_sensore.o3.o3_4),
      new GraficoLineare(1, valori_sensore.o3.o3_3),
      new GraficoLineare(2, valori_sensore.o3.o3_2),
      new GraficoLineare(3, valori_sensore.o3.o3_1),
      new GraficoLineare(4, valori_sensore.o3.o3),
    ];

    return [
      new charts.Series<GraficoLineare, int>(
        id: 'O3',
        // colorFn specifies that the line will be green.
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        // areaColorFn specifies that the area skirt will be light green.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.green.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: o3chartdata,
      ),
    ];
  }
  List<charts.Series<GraficoLineare, int>> _datiFuturiChartO3() {
    var o3chartdata = [
      new GraficoLineare(0, valori_sensore.o3.o3),
      new GraficoLineare(1, valori_sensore.o3.o3p1),
      new GraficoLineare(2, valori_sensore.o3.o3p2),
      new GraficoLineare(3, valori_sensore.o3.o3p3),
      new GraficoLineare(4, valori_sensore.o3.o3p4),
    ];

    return [
      new charts.Series<GraficoLineare, int>(
        id: 'O3',
        // colorFn specifies that the line will be green.
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        // areaColorFn specifies that the area skirt will be light green.
        areaColorFn: (_, __) =>
        charts.MaterialPalette.green.shadeDefault.lighter,
        domainFn: (GraficoLineare inquinanti, _) => inquinanti.momento,
        measureFn: (GraficoLineare inquinanti, _) => inquinanti.valore,
        data: o3chartdata,
      ),
    ];
  }
}