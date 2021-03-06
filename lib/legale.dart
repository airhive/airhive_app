part of "main.dart";

class LegalePage extends StatefulWidget{
  _LegalePage createState()=> _LegalePage();
}

//Writing account page code
class _LegalePage extends State<LegalePage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  int stack_visibile = 0;

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
    final TranslationsBloc translationsBloc = BlocProvider.of<TranslationsBloc>(context);

    return new Scaffold(
           appBar: new AppBar(
             title: new Text(allTranslations.text('legalPage.title')),
             backgroundColor: Theme.of(context).primaryColor,
           ),
           drawer: menulaterale(context),
      body: !conessioneassente ? IndexedStack(
          index: stack_visibile,
          children: [
            Center(child: CircularProgressIndicator()),
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
      ) : Text(allTranslations.text('legalPage.no_info_offline')),
    );
  }
}