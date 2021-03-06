import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servis_motor/page/laporanServis.dart';
import 'package:servis_motor/page/servis.dart';
import 'package:servis_motor/page/updateServis.dart';

class ListServis extends StatefulWidget {
  final Map<String, dynamic> profile;

  const ListServis({Key key, this.profile}) : super(key: key);
  @override
  _ListServisState createState() => _ListServisState();
}

class _ListServisState extends State<ListServis> {
  Map<String, dynamic> get user => widget.profile;
  CollectionReference ref = Firestore.instance.collection('antrian');
  List<String> _list = ['Edit', 'Laporan', 'Hapus'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      appBar: AppBar(
        backgroundColor: Color(0xFF8A2387),
        title: Column(
          children: <Widget>[
            Text('Servis Anda'),
            Text('Servis Anda yang belum selesai',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white38,
                )),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
          stream: ref
              .where('success', isLessThan: 2)
              .where('uid', isEqualTo: user['uid'])
              .orderBy('success', descending: true)
              .orderBy('noAntrian', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.none ||
                !snapshot.hasData) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircularProgressIndicator(),
                    title: Text('Loading...'),
                  ),
                ),
              );
            } else if (snapshot.data.documents.length == 0) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Anda Belum Memiliki Pengajuan Servis'),
                    subtitle: Text('Tap untuk Daftar Servis'),
                    trailing: Icon(Icons.add, color: Colors.yellow),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ServisPage(profile: widget.profile),
                    )),
                  ),
                ),
              );
            } else {
              return ListView(
                children: snapshot.data.documents.map((ds) {
                  Map<String, dynamic> data = ds.data;
                  String date = DateFormat('dd MMMM yyyy, HH:mm')
                      .format(data['daftar'].toDate());
                  Map<String, dynamic> status = data['success'] == 0
                      ? {
                          'text': "Menunggu".toUpperCase(),
                          "color": Colors.amber,
                          "font-color": Colors.black
                        }
                      : {
                          'text': "Sedang Diservis".toUpperCase(),
                          "color": Colors.green,
                          "font-color": Colors.white
                        };

                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ListTile(
                        leading: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: new EdgeInsets.all(8),
                              color: status['color'],
                              child: Text(
                                status['text'],
                                style: TextStyle(color: status['font-color']),
                              ),
                            )
                          ],
                        ),
                        title: Text(
                          ds.documentID,
                          style: TextStyle(fontSize: 17),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(data['montir'].toUpperCase(),
                                style: TextStyle(fontSize: 15)),
                            Text('${data['motor']}/$date')
                          ],
                        ),
                        trailing: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            icon: Icon(Icons.more_horiz),
                            items: _list.map((value) {
                              return DropdownMenuItem(
                                  child: Text(value), value: value);
                            }).toList(),
                            onChanged: (value) {
                              switch (value) {
                                case 'Edit':
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UpdateServis(doc: ds),
                                  ));
                                  break;
                                case 'Laporan':
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        LaporanServis(doc: ds),
                                  ));
                                  break;
                                case 'Hapus':
                                  showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        title: Text('Hapus ${ds.documentID}?'),
                                        content: Text(
                                            'Yakin ingin hapus permohonan servis ini?'),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(ctx).pop(),
                                              child: Text('Tidak')),
                                          FlatButton(
                                              onPressed: () async {
                                                ref
                                                    .document(ds.documentID)
                                                    .delete()
                                                    .whenComplete(() =>
                                                        Navigator.of(ctx)
                                                            .pop());
                                              },
                                              child: Text('Ya'))
                                        ],
                                      );
                                    },
                                  );
                                  break;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
