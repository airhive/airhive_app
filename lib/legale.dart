part of "main.dart";

class LegalePage extends StatefulWidget{
  _LegalePage createState()=> _LegalePage();
}

//Writing account page code
class _LegalePage extends State<LegalePage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  int stack_visibile = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
           appBar: new AppBar(
             title: new Text("Legale e privacy"),
             backgroundColor: Colors.yellow[700],
           ),
           drawer: menulaterale(context),
      body: IndexedStack(
          index: stack_visibile,
          children: [
            CircularProgressIndicator(),
            WebView(
             initialUrl: "https://www.airhive.it/legal?app=true",
             onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
             },
             javascriptMode: JavascriptMode.unrestricted,
             onPageFinished: (st) {
               setState(() {
                 stack_visibile = 1;
               });
             },
           ),
          ],
      ),
    );
  }
}