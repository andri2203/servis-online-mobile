import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  TextEditingController platC, merekC = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode scopeNode = FocusScope.of(context);

        if (!scopeNode.hasPrimaryFocus) {
          scopeNode.unfocus();
        }
      },
      child: Container(
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'LOGIN',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    validator: (value) =>
                        value.isEmpty ? 'Tidak Boleh Kosong' : '',
                    controller: platC,
                    decoration: decoration(
                      'Nomor Plat Motor',
                      'Contoh : BL 1234 ABC',
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    validator: (value) =>
                        value.isEmpty ? 'Tidak Boleh Kosong' : '',
                    controller: merekC,
                    decoration: decoration(
                      'Merek & Tipe Motor',
                      'Contoh : Yamaha R1',
                    ),
                  ),
                  SizedBox(height: 8),
                  SignInButton(
                    Buttons.Google,
                    text: "Masuk dengan Google",
                    onPressed: () {
                      if (_formKey.currentState.validate()) {}
                    },
                  )
                ],
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
      ),
    );
  }
}
