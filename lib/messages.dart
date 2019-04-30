part of "main.dart";

//Defining a page to store messages and alerts
class MessagesPage extends StatefulWidget {
  MessagesPage({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: menulaterale(context),
      appBar: new AppBar(
        title: new Text(Translations.of(context).text('settings_title')),
        backgroundColor: Colors.yellow[700],
      ),
      body: new Text("Qui sarà inserita la pagina delle notifiche"),


    );
  }
}
