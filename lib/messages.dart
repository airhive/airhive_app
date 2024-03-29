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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
    return new Scaffold(
           appBar: new AppBar(
             title: new Text(allTranslations.text('messagesPage.title')),
             backgroundColor: Theme.of(context).primaryColor,
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
      ) : Text(allTranslations.text('messagesPage.no_info_offline')),
    );
  }
}