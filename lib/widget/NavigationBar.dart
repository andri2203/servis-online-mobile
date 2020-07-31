import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: new Container(
        width: double.infinity,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(height: 8),
            new BarTime(),
            new Card(
              child: ListTile(
                // leading: Icon(Icons.assessment),
                title: Text('Anda Memiliki Pengajuan Servis'),
                subtitle: Text('Tanggal 31 Juli 2020, 12:30'),
                // trailing: Icon(Icons.check, color: Colors.green),
                trailing: Icon(Icons.warning, color: Colors.yellow),
              ),
            ),
            new Card(
              child: ListTile(
                leading: Icon(Icons.apps),
                title: Text('Servis Anda'),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            new Card(
              child: ListTile(
                leading: Icon(Icons.history),
                title: Text('Histori Servis'),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Card(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Column(
              children: <Widget>[
                Text("Buka",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("08:15"),
              ],
            ),
          ),
        ),
        Card(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Column(
              children: <Widget>[
                Text("Tutup",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("17:15"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
