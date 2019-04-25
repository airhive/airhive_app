part of "main.dart";

class LegalePage extends StatefulWidget{
  _LegalePage createState()=> _LegalePage();
}

//Writing account page code
class _LegalePage extends State<LegalePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
           appBar: new AppBar(
             title: new Text("Legale e privacy"),
             backgroundColor: Colors.yellow[700],
           ),
           drawer: menulaterale(context),
           body: WebView(
             initialUrl: "https://www.airhive.it/legal?app=true",
             javascriptMode: JavascriptMode.unrestricted,
           ),
        );
  }
}