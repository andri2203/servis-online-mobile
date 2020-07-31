import 'package:flutter/material.dart';
import 'package:servis_motor/page/home.dart';
import 'package:servis_motor/page/login.dart';
import 'package:servis_motor/utils/auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeUI(profile: _profile);
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
  final TextEditingController merekC = new TextEditingController();
  final TextEditingController platC = new TextEditingController();

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
        body: Container(
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
                        controller: platC,
                        decoration: decoration(
                            'Nomor Plat Motor', 'Contoh : BL 1234 ABC'),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        validator: (value) =>
                            value.isEmpty ? 'Tidak Boleh Kosong' : null,
                        controller: merekC,
                        decoration: decoration(
                            'Merek & Tipe Motor', 'Contoh : Yamaha R1'),
                      ),
                      SizedBox(height: 8),
                      SignInButton(
                        Buttons.Google,
                        text: "Daftar dengan Google",
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            return authService.googleSignIn({
                              'nomorPolisi': platC.text,
                              'motor': merekC.text,
                            });
                          }

                          return null;
                        },
                      ),
                      Text(
                        'Sudah pernah daftar?',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      SignInButton(
                        Buttons.Google,
                        text: "Masuk dengan Google",
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            return authService.googleSignIn({
                              'nomorPolisi': platC.text,
                              'motor': merekC.text,
                            });
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator()),
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
