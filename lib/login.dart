part of "main.dart";

bool conessioneassente = false;
String login_token;
Data_login login_data;
String mail_inviata = "no";

class RisultatoVerifica{
  final bool success;

  RisultatoVerifica({
    this.success,
  });

  factory RisultatoVerifica.fromJson(Map<String, dynamic> json) {
    return RisultatoVerifica(
      success: json['success'] as bool,
    );
  }

}

class Data_login{
  final String AccountPermission;
  String UserAccountVerified;

  Data_login({
    this.AccountPermission,
    this.UserAccountVerified,
  });

  factory Data_login.fromJson(Map<String, dynamic> json) {
    return Data_login(
      AccountPermission: json['LicenseID'] as String,
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
      data: Data_login.fromJson(json["data"]),
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
  bool codice_verificato = true;
  String testo_errore_mail = null;
  final _textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
          appBar: new AppBar(
            title: new Text("Account"),
            backgroundColor: Colors.yellow[700],
          ),
          //resizeToAvoidBottomInset: false,
          drawer: menulaterale(context),
          body:
          ((login_data.UserAccountVerified == '0') & (mail_inviata == "no")) ? Center(
              child:Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Center(child:Text(
                      Translations.of(context).text('sign_in'),
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
                            onPressed: () {privacy ? pulsante_mail(context, _textcontroller):null;},
                          ),
                          hintText: "example@example.com",
                          hintStyle: TextStyle(fontWeight: FontWeight.w300),
                          errorText: privacy ? testo_errore_mail : Translations.of(context).text('accept_privacy_to_continue'),
                      ),
                      onSubmitted: (a) => {pulsante_mail(context, _textcontroller)},
                    ),
                    Container(height:50),
                    CheckboxListTile(
                      title: Text(Translations.of(context).text('accept_privacy_button_text')), //    <-- label
                      value: privacy,
                      onChanged: (newValue) {setState(() {
                        privacy = privacy ? false : true;
                      }); },
                    )
                  ],
                ),
              ),
          ): (login_data.UserAccountVerified == '0') ? Stack(
            children: <Widget>[
              Center(
                child:Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      //Container(height: 50),
                      Center(child:Text(
                        Translations.of(context).text('verification_code'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      )),
                      Container(height: 50),
                      TextField(
                        controller: _textcontroller,
                        maxLength: 6,
                        maxLengthEnforced: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            fillColor: Colors.yellow[700],
                            prefixIcon: Icon(Icons.code),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {_verificamail(http.Client(), _textcontroller.text);_textcontroller.clear();},
                            ),
                            hintText: Translations.of(context).text('verification_code'),
                            hintStyle: TextStyle(fontWeight: FontWeight.w300),
                            errorText: codice_verificato ? null : Translations.of(context).text('error_code_text'),
                        ),
                        onSubmitted: (a) => {_verificamail(http.Client(), _textcontroller.text), _textcontroller.clear()},
                      ),
                    ],
                  ),
                ),
              ),
              new Align(
                alignment: FractionalOffset(0.95, 0.95),
                child: FloatingActionButton.extended(
                  label: Text("Mail"),
                  icon: Icon(Icons.arrow_back),
                  tooltip: 'Torna alla mail.',
                  onPressed: () {
                    setState(() {
                      mail_inviata = "no";
                    });
                  },
                ),
              ),
            ],
          ):WebView(
            initialUrl: "https://www.airhive.it/account/?relog=true&json=true&app=true&tkn=$login_token",
            javascriptMode: JavascriptMode.unrestricted,
          ),
        );
  }

  void pulsante_mail(context, TextEditingController _textcontroller) async {
    if(! _textcontroller.text.contains("@")){
      setState(() {
        testo_errore_mail = "Non si direbbe un indirizzo mail.";
      });
      return;
    };
    FocusScope.of(context).requestFocus(new FocusNode());
    if (privacy == false){
      return;
    };
    _inviamail(http.Client(), _textcontroller.text);
    _textcontroller.clear();
    SnackBar(content: Text('Mail inviata!'),
      duration: const Duration(minutes: 5),);
  }
  // Invia la mail per la registrazione
  Future<void> _inviamail(http.Client client, String destinatario) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("indirizzo_mail", destinatario);
    try {
      final response =
      await client.get(
          'https://www.airhive.it/register/php/register.php?tkn=$login_token&email=$destinatario&relog=true&recaptcha=IYgqYOHUVafr1R142x8v&json=true&privacy=$privacy');
      final parsed = json.decode(response.body);
      bool success = RisultatoVerifica
          .fromJson(parsed)
          .success;
      if (success) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          mail_inviata = "si";
        });
        prefs.setString("mail_inviata", mail_inviata);
      }
      else {
        setState(() {
          testo_errore_mail = Translations.of(context).text('error_text');
        });
      }
    }
    catch(SocketException){
      setState(() {
        testo_errore_mail = "Connessione a internet assente";
      });
    }
  }

  // Verifica il codice per la registrazione
  Future<void> _verificamail(http.Client client, String codice) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String indirizzo_mail = await prefs.getString("indirizzo_mail");
    final response =
    await client.get(
        'https://www.airhive.it/register/php/verify.php?relog=true&tkn=$login_token&email=$indirizzo_mail&json=true&verificationCode=$codice');
    final parsed = json.decode(response.body);
    bool success =  RisultatoVerifica.fromJson(parsed).success;
    if(success){
      setState(() {
        login_data.UserAccountVerified = "1";
        mail_inviata = "no";
        codice_verificato = true;
      });
      prefs.setString("mail_inviata", "no");
    }
    else {
      setState(() {
        codice_verificato = false;
      });
    }
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

  print('https://www.airhive.it/php/wakeDevice.php?deviceType=$modello_device&deviceName=My+Device&tkn=$token_old');
  try {
    final response =
    await client.get(
        'https://www.airhive.it/php/wakeDevice.php?deviceType=$modello_device&deviceName=My+Device&tkn=$token_old');
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
  catch (SocketException){
    conessioneassente = true;
    LoginData res = LoginData(
        success: false,
        data:Data_login(AccountPermission: "0", UserAccountVerified: "0"),
        token: token_old);
    login_token = token_old;
    login_data = res.data;
  };

}