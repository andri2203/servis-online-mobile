import 'package:flutter/material.dart';
import 'package:servis_motor/page/home.dart';
import 'package:servis_motor/utils/auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Servis Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('id', 'ID'),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> _profile;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Set User Profile
    authService.profile.listen((event) => setState(() => _profile = event));
    // Set Loading
    authService.loading.listen((event) => setState(() => _loading = event));
  }

  void callbackSignOut() {
    authService.signOut();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (_profile.isEmpty) {
            return Container(
              decoration: new BoxDecoration(
                  gradient: LinearGradient(
                stops: [0.0, 1.0],
                colors: [Color(0xFF8A2387), Color(0xFFE94057)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            return HomeUI(
              profile: _profile,
              callback: callbackSignOut,
            );
          }
        } else {
          return login();
        }
      },
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic decoration = (String label, String hint) => InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent)),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      );
  final TextEditingController nomorHPC = new TextEditingController();
  final TextEditingController nikKtpC = new TextEditingController();

  Widget login() {
    return Container(
      decoration: new BoxDecoration(
          gradient: LinearGradient(stops: [
        0.0,
        1.0,
      ], colors: [
        Color(0xFF8A2387),
        Color(0xFFE94057),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Servis Online"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(15),
              child: _loading == false
                  ? Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'DAFTAR',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 26, color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            validator: (value) =>
                                value.isEmpty ? 'Tidak Boleh Kosong' : null,
                            controller: nikKtpC,
                            decoration: decoration('NIK', 'NIK KTP Anda'),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            validator: (value) =>
                                value.isEmpty ? 'Tidak Boleh Kosong' : null,
                            controller: nomorHPC,
                            decoration:
                                decoration('Nomor HP', '0821-xxxx-xxxx'),
                          ),
                          SizedBox(height: 8),
                          SignInButton(
                            Buttons.Google,
                            text: "Daftar dengan Google",
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                return authService.googleSignIn({
                                  'nik': nikKtpC.text,
                                  'nohp': nomorHPC.text,
                                }).whenComplete(() {
                                  setState(() {
                                    nikKtpC.text = '';
                                    nomorHPC.text = '';
                                  });
                                });
                              }

                              return null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Sudah pernah daftar?',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SignInButton(
                            Buttons.Google,
                            text: "Masuk dengan Google",
                            onPressed: () {
                              return authService.googleSignIn({});
                            },
                          ),
                        ],
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Sistem Login Menggunakan akun Google",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38)),
        ),
      ),
    );
  }
}
