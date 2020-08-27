import 'package:flutter/material.dart';
import 'package:servis_motor/page/servis.dart';
import 'package:servis_motor/widget/NavigationBar.dart';
import 'package:servis_motor/widget/UserWidget.dart';

import 'package:servis_motor/page/profile.dart';

class HomeUI extends StatefulWidget {
  final Map<String, dynamic> profile;
  final VoidCallback callback;

  const HomeUI({Key key, this.profile, this.callback}) : super(key: key);

  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  @override
  void initState() {
    super.initState();
    this.handleDialog();
  }

  handleDialog() {
    if (widget.profile['data'].isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          useRootNavigator: true,
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Isi data dahulu'),
              content: Text('Anda Belum memiliki identitas yang kami minta.'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Tidak'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(profile: widget.profile),
                    ));
                  },
                  child: Text('Ya'),
                ),
              ],
            );
          },
        );
      });
    }
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
          child: ListView(
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
                    onTap: (index) => navigationRouteHandler(index, context)),
              ),
              new NavigationBar(profile: widget.profile),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  void navigationRouteHandler(int i, BuildContext context) {
    switch (i) {
      case 0:
        print("Route Index Home");
        break;

      case 1:
        print("Route Index Servis");
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ServisPage(profile: widget.profile),
        ));
        break;

      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(profile: widget.profile),
        ));
        break;

      case 3:
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Yakin ingin keluar?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Tidak')),
                FlatButton(
                    onPressed: () {
                      widget.callback();
                      Navigator.of(context).pop();
                    },
                    child: Text('Ya'))
              ],
            );
          },
        );
        break;
    }
  }
}
