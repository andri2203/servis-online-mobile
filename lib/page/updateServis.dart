import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateServis extends StatefulWidget {
  final DocumentSnapshot doc;

  const UpdateServis({Key key, this.doc}) : super(key: key);

  @override
  _UpdateServisState createState() => _UpdateServisState();
}

class _UpdateServisState extends State<UpdateServis> {
  DocumentSnapshot get doc => widget.doc;
  Map<String, dynamic> get data => widget.doc.data;
  List<String> _jenis = ['Berat', 'Ringan', 'Ganti Oli'];
  var formkey = new GlobalKey<FormState>();
  bool loading = false;
  String jenisSelect;
  String tglDaftar;

  Firestore firestore = Firestore.instance;

  var platC = new TextEditingController();
  var motorC = new TextEditingController();

  @override
  void initState() {
    setState(() {
      platC.text = data['plat'];
      motorC.text = data['motor'];
      jenisSelect = data['servis'];
      tglDaftar = data['daftar'].toDate().toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      appBar: AppBar(
        backgroundColor: Color(0xFF8A2387),
        title: Column(
          children: <Widget>[
            Text('Update Servis'),
            Text('Nomor : ${doc.documentID}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white38,
                )),
          ],
        ),
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
                      initialValue: data['daftar'].toDate().toString(),
                      firstDate: DateTime.now(),
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
        onPressed: () => _handleServisRegister(context),
      ),
    );
  }

  Future _handleServisRegister(BuildContext context) async {
    if (formkey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      CollectionReference ref = firestore.collection('antrian');
      ref.document(doc.documentID).updateData({
        'plat': platC.text,
        'motor': motorC.text,
        'servis': jenisSelect,
        'daftar': DateTime.parse(tglDaftar),
      }).whenComplete(() {
        setState(() {
          platC.text = '';
          motorC.text = '';
          jenisSelect = null;
          tglDaftar = '';
          loading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }
}
