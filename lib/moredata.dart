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
  Completer<GoogleMapController> _controller = Completer();

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
            storico(),
            attuale(),
            previsioni(),
          ],
        ),
      ),
    );
  }

  Widget attuale(){
    final CameraPosition _initialCamera = CameraPosition(
      target: pos_curr_marker,
      zoom: 13,
    );
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget> [
        Stack(
          children: <Widget> [
            Container(
              height: 200,
              child:GoogleMap(
                compassEnabled: false,
                onMapCreated:(controller) => {_controller.complete(controller)},
                myLocationEnabled: false,
                initialCameraPosition: _initialCamera,
                markers: _markers,
                mapType: ListOfMaps[currMapNum], //Also change map type
              ),
            ),
            Container(
              height: 200,
              color: Colors.transparent,
            )
          ],
        ),
        Container(
          color: Colors.transparent,
          height: 130,
          child: Stack(
            children: <Widget> [
              Container(
                height:160,
                child: new charts.PieChart(
                  _CaqiData(),
                  animate:true,
                  defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 10,
                      startAngle: 4 / 5 * 3.1415,
                      arcLength: (valori_sensore.caqi.toInt() / 100) * (7 * 3.1415) / 5
                  ),
                  behaviors: [
                    new charts.ChartTitle(
                      "Air quality index",
                      titleStyleSpec: charts.TextStyleSpec(
                          fontSize: 12, // size in Pts.
                          color: charts.MaterialPalette.black),
                      behaviorPosition: charts.BehaviorPosition.start,
                      titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment(0.05, 0.0),
                  child: Text(valori_sensore.caqi.toStringAsFixed(2).toString())
              ),
            ],
          ),
        ),
        Container(
          color: Colors.transparent,
          height: 130,
          child: Stack(
            children: <Widget> [
              Container(
                height:160,
                child: new charts.PieChart(
                  _PmData(),
                  animate:true,
                  defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 10,
                      startAngle: 4 / 5 * 3.1415,
                      arcLength: (valori_sensore.pm_10.pm_10.toInt() / 100) * (7 * 3.1415) / 5
                  ),
                  behaviors: [
                    new charts.ChartTitle(
                      "PM 10",
                      titleStyleSpec: charts.TextStyleSpec(
                          fontSize: 12, // size in Pts.
                          color: charts.MaterialPalette.black),
                      behaviorPosition: charts.BehaviorPosition.start,
                      titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment(0.05, 0.0),
                  child: Text(valori_sensore.pm_10.pm_10.toStringAsFixed(2).toString())
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<charts.Series<GaugeSegment, String>> _CaqiData() {
    int val_pm = valori_sensore.caqi.toInt();
    List<GaugeSegment> data = [
      new GaugeSegment('High', val_pm),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'CAQI',
        colorFn: (_, __) => (val_pm < 25) ?
        charts.MaterialPalette.green.shadeDefault:
        (val_pm < 50) ? charts.MaterialPalette.yellow.shadeDefault:
        (val_pm < 75) ? charts.MaterialPalette.deepOrange.shadeDefault:
        charts.MaterialPalette.red.shadeDefault,
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }

  List<charts.Series<GaugeSegment, String>> _PmData() {
    int val_pm = valori_sensore.pm_10.pm_10.toInt();
    List<GaugeSegment> data = [
      new GaugeSegment('High', val_pm),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'CAQI',
        colorFn: (_, __) => (val_pm < 25) ?
        charts.MaterialPalette.green.shadeDefault:
        (val_pm < 50) ? charts.MaterialPalette.yellow.shadeDefault:
        (val_pm < 75) ? charts.MaterialPalette.deepOrange.shadeDefault:
        charts.MaterialPalette.red.shadeDefault,
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }

  Widget storico(){
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget> [
        Container(
          color: Colors.white,
          height: 200,
          child: new charts.LineChart(
            _datiChartCAQI(),
            defaultRenderer: new charts.LineRendererConfig(includeArea: true, stacked: true),
            animate: true,
            behaviors: [
              new charts.ChartTitle(
                  'CAQI',
                  behaviorPosition: charts.BehaviorPosition.start,
                  titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
              new charts.ChartTitle(
                  'Tempo',
                  behaviorPosition: charts.BehaviorPosition.bottom,
                  titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
              new charts.SeriesLegend(
                  position: charts.BehaviorPosition.end, desiredMaxRows: 3),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          height: 200,
          child: new charts.LineChart(
            _datiStoricoChartPM(),
            defaultRenderer: new charts.LineRendererConfig(includeArea: true),
            animate: true,
            behaviors: [
              new charts.ChartTitle(
                  'PM',
                  behaviorPosition: charts.BehaviorPosition.start,
                  titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
              new charts.ChartTitle(
                  'Tempo',
                  behaviorPosition: charts.BehaviorPosition.bottom,
                  titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
              new charts.SeriesLegend(
                  position: charts.BehaviorPosition.end, desiredMaxRows: 2),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          height: 200,
          child: new charts.LineChart(
            _datiStoricoChartNO2(),
            defaultRenderer: new charts.LineRendererConfig(includeArea: true),
            animate: true,
            behaviors: [
              new charts.ChartTitle(
                  'NO2',
                  behaviorPosition: charts.BehaviorPosition.start,
                  titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
              new charts.ChartTitle(
                  'Tempo',
                  behaviorPosition: charts.BehaviorPosition.bottom,
                  titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
              new charts.SeriesLegend(
                  position: charts.BehaviorPosition.end, desiredMaxRows: 2),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          height: 200,
          child: new charts.LineChart(
            _datiStoricoChartO3(),
            defaultRenderer: new charts.LineRendererConfig(includeArea: true),
            animate: true,
            behaviors: [
              new charts.ChartTitle(
                  'O3',
                  behaviorPosition: charts.BehaviorPosition.start,
                  titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
              new charts.ChartTitle(
                  'Tempo',
                  behaviorPosition: charts.BehaviorPosition.bottom,
                  titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
              new charts.SeriesLegend(
                  position: charts.BehaviorPosition.end, desiredMaxRows: 2),
            ],
          ),
        ),
      ],
    );
  }
  Widget previsioni(){
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget> [
        Container(
          color: Colors.white,
          height: 200,
          child: new charts.LineChart(
            _datiFuturiChartCAQI(),
            defaultRenderer: new charts.LineRendererConfig(includeArea: true, stacked: true),
            animate: true,
            behaviors: [
              new charts.ChartTitle(
              'CAQI',
              behaviorPosition: charts.BehaviorPosition.start,
              titleOutsideJustification:
              charts.OutsideJustification.middleDrawArea),
              new charts.ChartTitle(
              'Tempo',
              behaviorPosition: charts.BehaviorPosition.bottom,
              titleOutsideJustification:
              charts.OutsideJustification.middleDrawArea),
              new charts.SeriesLegend(
              position: charts.BehaviorPosition.end, desiredMaxRows: 3),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          height: 200,
          child: new charts.LineChart(
            _datiFuturiChartPM(),
            defaultRenderer: new charts.LineRendererConfig(includeArea: true),
            animate: true,
            behaviors: [
              new charts.ChartTitle(
              'PM',
              behaviorPosition: charts.BehaviorPosition.start,
              titleOutsideJustification:
              charts.OutsideJustification.middleDrawArea),
              new charts.ChartTitle(
              'Tempo',
              behaviorPosition: charts.BehaviorPosition.bottom,
              titleOutsideJustification:
              charts.OutsideJustification.middleDrawArea),
              new charts.SeriesLegend(
              position: charts.BehaviorPosition.end, desiredMaxRows: 2),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          height: 200,
          child: new charts.LineChart(
            _datiFuturiChartNO2(),
            defaultRenderer: new charts.LineRendererConfig(includeArea: true),
            animate: true,
            behaviors: [
              new charts.ChartTitle(
              'NO2',
              behaviorPosition: charts.BehaviorPosition.start,
              titleOutsideJustification:
              charts.OutsideJustification.middleDrawArea),
              new charts.ChartTitle(
              'Tempo',
              behaviorPosition: charts.BehaviorPosition.bottom,
              titleOutsideJustification:
              charts.OutsideJustification.middleDrawArea),
              new charts.SeriesLegend(
              position: charts.BehaviorPosition.end, desiredMaxRows: 2),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          height: 200,
          child: new charts.LineChart(
            _datiFuturiChartO3(),
            defaultRenderer: new charts.LineRendererConfig(includeArea: true),
            animate: true,
            behaviors: [
              new charts.ChartTitle(
              'O3',
              behaviorPosition: charts.BehaviorPosition.start,
              titleOutsideJustification:
              charts.OutsideJustification.middleDrawArea),
              new charts.ChartTitle(
              'Tempo',
              behaviorPosition: charts.BehaviorPosition.bottom,
              titleOutsideJustification:
              charts.OutsideJustification.middleDrawArea),
              new charts.SeriesLegend(
              position: charts.BehaviorPosition.end, desiredMaxRows: 2),
            ],
          ),
        ),
      ],
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