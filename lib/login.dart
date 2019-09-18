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
          body: WebView(
            initialUrl: "https://www.airhive.it/account/?relog=true&json=true&app=true&tkn=$login_token",
            javascriptMode: JavascriptMode.unrestricted,
          ),
        );
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