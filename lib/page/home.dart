import 'package:flutter/material.dart';
import 'package:servis_motor/utils/auth.dart';
import 'package:servis_motor/widget/NavigationBar.dart';
import 'package:servis_motor/widget/UserWidget.dart';

class HomeUI extends StatefulWidget {
  final Map<String, dynamic> profile;

  const HomeUI({Key key, this.profile}) : super(key: key);

  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  @override
  void initState() {
    super.initState();
    print(widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: new BoxDecoration(
          gradient: LinearGradient(stops: [
        0.0,
        0.4,
        0.4,
        1.0
      ], colors: [
        Color(0xFF8A2387),
        Color(0xFFE94057),
        Color(0xFFDDDDDD),
        Color(0xFFDDDDDD)
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: new AppBar(
          title: new Text(
            "Servis Online",
            style: TextStyle(fontFamily: "Times New Roman", fontSize: 16),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          padding: new EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new UserWidget(profile: widget.profile),
              new SizedBox(height: 20),
              new Container(
                color: Colors.white,
                width: double.infinity,
                child: BottomNavigationBar(
                    currentIndex: 0,
                    items: [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), title: Text("Beranda")),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.add), title: Text("Servis")),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.person), title: Text("Profil")),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.exit_to_app), title: Text("Keluar")),
                    ],
                    type: BottomNavigationBarType.fixed,
                    onTap: navigationRouteHandler),
              ),
              new NavigationBar(),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  void navigationRouteHandler(int i) {
    switch (i) {
      case 0:
        print("Route Index Home");
        break;

      case 1:
        print("Route Index Servis");
        break;

      case 2:
        print("Route Index Profil");
        break;

      case 3:
        authService.signOut();
        break;
    }
  }
}
