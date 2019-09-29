part of "main.dart";

bool conessioneassente = false;
String login_token;
Data_login login_data;
String mail_inviata = "no";

class InviaMail{
  final bool success;
  final String sid;

  InviaMail({
    this.success,
    this.sid,
  });

  factory InviaMail.fromJson(Map<String, dynamic> json) {
    return InviaMail(
      success: json['success'] as bool,
      sid: json['sid'] as String,
    );
  }

}

class RisultatoVerifica{
  final bool success;
  final bool twofactor;

  RisultatoVerifica({
    this.success,
    this.twofactor,
  });

  factory RisultatoVerifica.fromJson(Map<String, dynamic> json) {
    return RisultatoVerifica(
      success: json['success'] as bool,
      twofactor: json['twofactor'] as bool,
    );
  }

}

class Data_login{
  final String AccountPermission;
  int UserAccountVerified;

  Data_login({
    this.AccountPermission,
    this.UserAccountVerified,
  });

  factory Data_login.fromJson(Map<String, dynamic> json) {
    return Data_login(
      AccountPermission: json['LicenseID'] as String,
      UserAccountVerified: json['UserAccountVerified'] as int,
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
  int stack_visibile = 0;
  final _textcontroller = TextEditingController();

  @override
  void initState() {
    if (conessioneassente){
      connectionCheck();
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return  new Scaffold(
          appBar: new AppBar(
            title: new Text(allTranslations.text('loginPage.title')),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          //resizeToAvoidBottomInset: false,
          drawer: menulaterale(context),
          body:
          ((login_data.UserAccountVerified == 0) & (mail_inviata == "no")) ? Center(
            child:Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Center(child:Text(
                    allTranslations.text('loginPage.sign_in'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
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
                      hintStyle: TextStyle(fontFamily: "OpenSans"),
                      errorText: privacy ? testo_errore_mail : allTranslations.text('loginPage.accept_privacy_to_continue'),
                    ),
                    onSubmitted: (a) => {pulsante_mail(context, _textcontroller)},
                  ),
                  Container(height:50),
                  CheckboxListTile(
                    title: Text(allTranslations.text('loginPage.accept_privacy')), //    <-- label
                    value: privacy,
                    onChanged: (newValue) {setState(() {
                      privacy = privacy ? false : true;
                    }); },
                  )
                ],
              ),
            ),
          ): (login_data.UserAccountVerified == 0) ? Stack(
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
                        allTranslations.text('loginPage.verification_code'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
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
                          hintText: allTranslations.text('loginPage.verification_code'),
                          hintStyle: TextStyle(fontFamily: "OpenSans"),
                          errorText: codice_verificato ? null : allTranslations.text('loginPage.error_code'),
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
                  tooltip: allTranslations.text('loginPage.back_to_mail'),
                  onPressed: () {
                    setState(() {
                      mail_inviata = "no";
                    });
                  },
                ),
              ),
            ],
          ) : !conessioneassente ? IndexedStack(
              index: stack_visibile,
              children: [
                Center(child: CircularProgressIndicator()),
                WebView(
                  initialUrl: "https://www.airhive.it/account/?app=true&tkn=$login_token",
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (st) {
                    setState(() {
                      stack_visibile = 1;
                    });
                  },
               )
              ]
          )
          : Text(allTranslations.text('loginPage.no_info_offline')),
        );
  }
  void pulsante_mail(context, TextEditingController _textcontroller) async {
    if(! _textcontroller.text.contains("@")){
      setState(() {
        testo_errore_mail = allTranslations.text('loginPage.not_email');
      });
      return;
    };
    FocusScope.of(context).requestFocus(new FocusNode());
    if (privacy == false){
      return;
    };
    _inviamail(http.Client(), _textcontroller.text);
    _textcontroller.clear();
  }
  // Invia la mail per la registrazione
  Future<void> _inviamail(http.Client client, String destinatario) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("indirizzo_mail", destinatario);
    try {
      // Timeout per evitare caricamenti infiniti
      final response =
      await client.get(
          'https://www.airhive.it/explore/php/login.php?inApp=true&mail=$destinatario&tkn=$login_token').timeout(const Duration(seconds: 7));
      final parsed = json.decode(response.body);
      InviaMail res = InviaMail.fromJson(parsed);
      bool success = res.success;
      if (success) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          mail_inviata = "si";
        });
        prefs.setString("mail_inviata", mail_inviata);
        prefs.setString("session_id", res.sid);
      }
      else {
        setState(() {
          testo_errore_mail = allTranslations.text('loginPage.error');
        });
      }
    } on SocketException catch(_){
      setState(() {
        testo_errore_mail = allTranslations.text('loginPage.offline_device');
      });
    } on TimeoutException catch (_){
      setState(() {
        testo_errore_mail = allTranslations.text('loginPage.offline_device');
      });
    }
  }


// giulio non andrebbe eilinata la parte sotto? lato server https://www.airhive.it/register/php/verify.php?relog=true&tkn=$login_token&email=$indirizzo_mail&jso non esiste più, bastano i due link che abbiamo configurato insieme l'altro giorno

  // Verifica il codice per la registrazione
  Future<void> _verificamail(http.Client client, String codice) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String indirizzo_mail = await prefs.getString("indirizzo_mail");
    String session_id = await prefs.getString("session_id");
    final response =
    await client.get(
      'https://www.airhive.it/explore/php/login.php?inApp=true&sid=$session_id&twofactor=$codice');
    final parsed = json.decode(response.body);
    bool success =  RisultatoVerifica.fromJson(parsed).success;
    bool twofactor =  RisultatoVerifica.fromJson(parsed).twofactor;
    if (success) {
      if (twofactor) {
        setState(() {
          login_data.UserAccountVerified = 1;
          mail_inviata = "no";
          codice_verificato = true;
        });
        prefs.setString("mail_inviata", "no");
      } else {
        setState(() {
          codice_verificato = false;
        });
      }
    } else {
      testo_errore_mail = allTranslations.text('loginPage.offline_device');
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

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version+"("+packageInfo.buildNumber+")";

  try {
    final response =
    await client.get(
        'https://www.airhive.it/php/wakeDevice.php?deviceType=$modello_device&deviceName=My+Device&tkn=$token_old&appVersion=$version');
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
    connectionCheck();
    conessioneassente = true;
    LoginData res = LoginData(
        success: false,
        data:Data_login(AccountPermission: "false", UserAccountVerified: 0),
        token: token_old);
    login_token = token_old;
    login_data = res.data;
  };

}