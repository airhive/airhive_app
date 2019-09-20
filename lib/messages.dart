part of "main.dart";

//Defining a page to store messages and alerts

class MessagesPage extends StatefulWidget{
  _MessagesPage createState()=> _MessagesPage();
}

class _MessagesPage extends State<MessagesPage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  int stack_visibile = 0;
  String urlString = "https://www.airhive.it/account/notification/?app=true&tkn=$login_token";

  @override
  void initState() {
    if (conessioneassente){
      connectionCheck();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
           appBar: new AppBar(
             title: new Text(Translations.of(context).text('notifications_button_text')),
             backgroundColor: Colors.yellow[700],
           ),
           drawer: menulaterale(context),
      body: !conessioneassente ? IndexedStack(
          index: stack_visibile,
          children: [
            Center(child: CircularProgressIndicator()),
            WebView(
             initialUrl: urlString,
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
      ) : Text("Queste informazioni non sono disponibili senza una connessione a internet."),
    );
  }
}
