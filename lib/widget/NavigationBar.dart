import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servis_motor/page/historiServis.dart';
import 'package:servis_motor/page/listServis.dart';
import 'package:servis_motor/page/servis.dart';

class NavigationBar extends StatefulWidget {
  final Map<String, dynamic> profile;

  const NavigationBar({Key key, this.profile}) : super(key: key);
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  CollectionReference _ref = Firestore.instance.collection('antrian');
  Map<String, dynamic> get user => widget.profile;

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(height: 8),
          new BarTime(),
          new Card(
            child: StreamBuilder<QuerySnapshot>(
              stream: _ref
                  .where('success', isEqualTo: false)
                  .where('uid', isEqualTo: user['uid'])
                  .orderBy('noAntrian', descending: true)
                  .limit(1)
                  .snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    leading: CircularProgressIndicator(),
                    title: Text('Loading...'),
                  );
                } else if (snap.data.documents.length == 0) {
                  return ListTile(
                    title: Text('Anda Belum Memiliki Pengajuan Servis'),
                    subtitle: Text('Tap untuk Daftar Servis'),
                    trailing: Icon(Icons.add, color: Colors.yellow),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ServisPage(profile: widget.profile),
                    )),
                  );
                } else {
                  Map<String, dynamic> data = snap.data.documents.single.data;
                  String date = DateFormat('dd MMMM yyyy, HH:mm')
                      .format(data['daftar'].toDate());

                  return ListTile(
                    title: Text('Anda Memiliki Pengajuan Servis'),
                    subtitle: Text('${data['motor']} - $date'),
                    trailing: Icon(Icons.warning, color: Colors.yellow),
                  );
                }
              },
            ),
          ),
          new Card(
            child: ListTile(
              leading: Icon(Icons.apps),
              title: Text('Servis Anda'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ListServis(profile: widget.profile),
              )),
            ),
          ),
          new Card(
            child: ListTile(
              leading: Icon(Icons.history),
              title: Text('Histori Servis'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HistoriServis(profile: widget.profile),
              )),
            ),
          ),
        ],
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
                Text("09:00"),
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
                Text("21:00"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
