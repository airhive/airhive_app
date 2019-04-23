part of "main.dart";

String login_token;
Data_login login_data;
String mail_inviata = "no";

class Data_login{
  final String AccountPermission;
  final String UserAccountVerified;

  Data_login({
    this.AccountPermission,
    this.UserAccountVerified,
  });

  factory Data_login.fromJson(Map<String, dynamic> json) {
    return Data_login(
      AccountPermission: json['AccountPermission'] as String,
      UserAccountVerified: json['UserAccountVerified'] as String,
    );
  }

}

class LoginData{
  final bool success;
  final Data_login data;
  final String token;

  LoginData({
    this.success,
    this.data,
    this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      success: json['success'] as bool,
      data: Data_login.fromJson(json["data"]) as Data_login,
      token: json['tkn'] as String,
    );
  }
}

class AccountPage extends StatefulWidget{
  _AccountPage createState()=> _AccountPage();
}

//Pagina account
class _AccountPage extends State<AccountPage> {
  bool privacy = false;
  bool mostra_caricamento = true;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  final _textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: app_theme(),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: new AppBar(
            title: new Text("Account"),
            backgroundColor: Colors.yellow[700],
          ),
          //resizeToAvoidBottomInset: false,
          drawer: menulaterale(context),
          body:
          ((login_data.UserAccountVerified == '0') & (mail_inviata == "no")) ? Container(
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Center(child:Text(
                  "Registrati",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                )),
                Container(height: 50),
                TextField(
                  controller: _textcontroller,
                  decoration: InputDecoration(
                      fillColor: Colors.yellow[700],
                      prefixIcon: Icon(Icons.mail),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {pulsante_mail(_textcontroller);},
                      ),
                      hintText: "Mail",
                      hintStyle: TextStyle(fontWeight: FontWeight.w300)
                  ),
                  onSubmitted: (a) => {pulsante_mail(_textcontroller)},
                ),
                CheckboxListTile(
                  title: Text("Acconsento alla privacy."), //    <-- label
                  value: privacy,
                  onChanged: (newValue) {setState(() {
                    privacy = true;
                  }); },
                )
              ],
            ),
          ): (login_data.UserAccountVerified == '0') ? Stack(
            children: <Widget>[
              Container(
                height: 300,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //Container(height: 50),
                    Center(child:Text(
                      "Codice verifica",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    )),
                    Container(height: 50),
                    TextField(
                      controller: _textcontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          fillColor: Colors.yellow[700],
                          prefixIcon: Icon(Icons.code),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {_verificamail(http.Client(), _textcontroller.text);_textcontroller.clear();},
                          ),
                          hintText: "Codice di verifica",
                          hintStyle: TextStyle(fontWeight: FontWeight.w300)
                      ),
                      onSubmitted: (a) => {_verificamail(http.Client(), _textcontroller.text), _textcontroller.clear()},
                    ),
                  ],
                ),
              ),
              new Align(
                alignment: FractionalOffset(0.95, 0.95),
                child: FloatingActionButton.extended(
                  label: Text("Mail"),
                  icon: Icon(Icons.arrow_back),
                  tooltip: 'Increase volume by 10',
                  onPressed: () {
                    setState(() {
                      mail_inviata = "no";
                    });
                  },
                ),
              ),
            ],
          ):WebView(
            initialUrl: "https://www.airhive.it/account/?relog=true&tkn=$login_token",
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }

  void pulsante_mail(TextEditingController _textcontroller) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    _inviamail(http.Client(), _textcontroller.text);
    _textcontroller.clear();
    SnackBar(content: Text('Mail inviata!'),
      duration: const Duration(minutes: 5),);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    mail_inviata = "si";
    prefs.setString("mail_inviata", mail_inviata);
  }
  // Invia la mail per la registrazione
  Future<void> _inviamail(http.Client client, String destinatario) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("indirizzo_mail", destinatario);
    print('https://www.airhive.it/register/php/register.php?tkn=$login_token&email=$destinatario&relog=true&recaptcha=IYgqYOHUVafr1R142x8v&json=true&privacy=true');
    final response =
    await client.get(
        'https://www.airhive.it/register/php/register.php?tkn=$login_token&email=$destinatario&relog=true&recaptcha=IYgqYOHUVafr1R142x8v&json=true&privacy=true');
  }

  // Verifica il codice per la registrazione
  Future<void> _verificamail(http.Client client, String codice) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String indirizzo_mail = await prefs.getString("indirizzo_mail");
    final response =
    await client.get(
        'https://www.airhive.it/register/php/verify.php?relog=true&tkn=$login_token&email=$indirizzo_mail&json=true&verificationCode=$codice');
  }
}

// Login su airhive.it appena la app parte
Future<void> _login(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token_old = (await prefs.getString("token")) ?? "CIAONE";
  String modello_device;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid){
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    modello_device = androidInfo.model;
  }
  else if (Platform.isIOS){
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    modello_device = iosInfo.utsname.machine;
  }
  final response =
  await client.get('https://www.airhive.it/php/login.php?deviceModel=$modello_device&deviceName=My+Device&app=true&tkn=$token_old');
  final parsed = json.decode(response.body);

  LoginData res =  LoginData.fromJson(parsed);
  bool success = res.success;
  String token = res.token;

  if((token != token_old) & success){
    prefs.setString("token", token);
    token_old = token;
  }
  login_token = token_old;
  login_data = res.data;
}