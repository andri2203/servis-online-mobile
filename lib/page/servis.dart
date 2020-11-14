import 'dart:math';

import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServisPage extends StatefulWidget {
  final Map<String, dynamic> profile;

  const ServisPage({Key key, this.profile}) : super(key: key);
  @override
  _ServisPageState createState() => _ServisPageState();
}

class _ServisPageState extends State<ServisPage> {
  Map<String, dynamic> get user => widget.profile;
  List<String> _jenis = ['Berat', 'Ringan', 'Ganti Oli'];
  var formkey = new GlobalKey<FormState>();
  bool loading = false;
  String jenisSelect;
  String tglDaftar = DateTime.now().toString();
  bool montirPicked = false;
  Map<String, dynamic> montir = new Map<String, dynamic>();
  List<Map<String, dynamic>> montirAva = new List<Map<String, dynamic>>();

  Firestore firestore = Firestore.instance;

  var platC = new TextEditingController();
  var motorC = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      appBar: AppBar(
        backgroundColor: Color(0xFF8A2387),
        title: Text('Daftar Servis'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          child: Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: formkey,
                child: ListView(
                  children: <Widget>[
                    if (loading == true)
                      ListTile(
                        leading: CircularProgressIndicator(),
                        title: Text('Loading...'),
                      ),
                    SizedBox(height: 20),
                    Text(
                      'Daftarkan Untuk Servis',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      readOnly: loading,
                      validator: (value) =>
                          value.isEmpty ? 'Nama Kendaraan wajib diisi' : null,
                      controller: motorC,
                      decoration: InputDecoration(
                        labelText: 'Nama Kendaraan',
                        hintText: 'Masukkan Nama Kendaraan',
                      ),
                    ),
                    TextFormField(
                      readOnly: loading,
                      validator: (value) =>
                          value.isEmpty ? 'Nomor Plat wajib diisi' : null,
                      controller: platC,
                      decoration: InputDecoration(
                        labelText: 'Nomor Plat',
                        hintText: 'Masukkan No. Plat',
                      ),
                    ),
                    DropdownButtonFormField(
                      icon: Icon(Icons.select_all),
                      hint: Text("Pilih Jenis Servis"),
                      value: jenisSelect,
                      items: _jenis.map((value) {
                        return DropdownMenuItem(
                            child: Text(value), value: value);
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          jenisSelect = value;
                        });
                      },
                    ),
                    DateTimePicker(
                      readOnly: loading,
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'd MMM, yyyy',
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime.now().toLocal(),
                      lastDate: DateTime(2100),
                      icon: Icon(Icons.event),
                      dateLabelText: 'Tanggal Daftar',
                      timeLabelText: "Jam",
                      onChanged: (val) {
                        setState(() {
                          tglDaftar = val;
                        });
                      },
                      validator: (val) {
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          tglDaftar = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: _handleServisRegister,
      ),
    );
  }

  Future _handleServisRegister() async {
    if (formkey.currentState.validate() && loading == false) {
      setState(() {
        loading = true;
      });
      CollectionReference _refAntrian = firestore.collection('antrian');
      CollectionReference _refMontir = firestore.collection('montir');

      QuerySnapshot _antrian = await _refAntrian
          .orderBy('noAntrian', descending: true)
          .getDocuments(source: Source.server);
      int _numAntrian = _antrian.documents.length + 1;

      QuerySnapshot _montir = await _refMontir.getDocuments();

      QuerySnapshot _check = await _refAntrian
          .where('daftar',
              isGreaterThanOrEqualTo: Timestamp.fromMillisecondsSinceEpoch(
                  DateTime.parse(tglDaftar).millisecondsSinceEpoch),
              isLessThan: Timestamp.fromMillisecondsSinceEpoch(
                  DateTime.parse(tglDaftar).millisecondsSinceEpoch + 600000))
          .getDocuments(source: Source.server);

      _montir.documents.forEach((element) {
        Map<String, dynamic> _data = element.data;
        if (_check.documents.length > 0) {
          for (var i = 0; i < _check.documents.length; i++) {
            Map<String, dynamic> _montirOnJob = _check.documents[i].data;
            if (_data['kode'] != _montirOnJob['kodeMontir']) {
              setState(() {
                montirAva.add(_data);
              });
            }
          }
        } else {
          setState(() {
            montirAva.add(_data);
          });
        }
      });

      if (montirAva.length > 0) {
        int _randMontir = Random().nextInt(montirAva.length);
        setState(() {
          montir = montirAva[_randMontir];
        });

        _refAntrian.document("${montir['kode']}-$_numAntrian")
          ..setData({
            'noAntrian': _numAntrian,
            'montir': montir['nama'],
            'kodeMontir': montir['kode'],
            'uid': user['uid'],
            'nama': user['displayName'],
            'plat': platC.text,
            'motor': motorC.text,
            'servis': jenisSelect,
            'daftar': DateTime.parse(tglDaftar),
            'createAt': DateTime.now(),
            'kerusakan': [],
            'success': 0,
          }).whenComplete(() {
            return showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text('Pesanan Anda Berhasil'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Antrian : ${montir['kode']}-$_numAntrian"),
                        Text("Montir : ${montir['nama']}"),
                        Text("Tanggal : ${DateTime.parse(tglDaftar)}"),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          setState(() {
                            platC.text = '';
                            motorC.text = '';
                            jenisSelect = null;
                            tglDaftar = '';
                            loading = false;
                          });
                        },
                        child: Text('Tutup'),
                      ),
                    ],
                  );
                });
          });
      } else {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Maaf!!..'),
                content: Text(
                    'Semua Montir Sedang sibuk. Silahkan pesan di jam / tanggal berbeda'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      setState(() {
                        loading = false;
                      });
                    },
                    child: Text('Tutup'),
                  ),
                ],
              );
            });
      }
    }
  }
}
