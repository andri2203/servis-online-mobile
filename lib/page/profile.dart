import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> profile;

  const ProfilePage({Key key, this.profile}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> user;
  GlobalKey<FormState> formState = new GlobalKey<FormState>();
  TextEditingController nik;
  TextEditingController nohp;
  CollectionReference ref = Firestore.instance.collection('users');

  @override
  void initState() {
    setState(() {
      user = widget.profile;
      nik = new TextEditingController(text: user['data']['nik']);
      nohp = new TextEditingController(text: user['data']['nohp']);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      appBar: AppBar(
        backgroundColor: Color(0xFF8A2387),
        title: Text('Info Profil'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Form(
                    key: formState,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Image(
                            image: NetworkImage(user['photoURL']),
                            fit: BoxFit.fill,
                            width: 60,
                            height: 60,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(user['displayName'].toUpperCase(),
                            style: TextStyle(fontSize: 14)),
                        SizedBox(height: 2),
                        Text('${user['data']['nik']} ~ ${user['data']['nohp']}',
                            style: TextStyle(fontSize: 10.725)),
                        SizedBox(
                            height: 15, child: Divider(color: Colors.black45)),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text('Info Data Anda')),
                        TextFormField(
                          controller: nik,
                          validator: (value) =>
                              value.isEmpty ? 'Nik tidak boleh kosong' : null,
                          decoration: InputDecoration(
                              labelText: 'NIK', hintText: 'NIK KTP Anda'),
                        ),
                        TextFormField(
                          controller: nohp,
                          validator: (value) => value.isEmpty
                              ? 'Nomor HP tidak boleh kosong'
                              : null,
                          decoration: InputDecoration(
                              labelText: 'Nomor HP',
                              hintText: '0821-xxxx-xxxx'),
                        ),
                        SizedBox(height: 10),
                        RaisedButton(
                          child: Text('Ubah Info'),
                          onPressed: () => handleUbahInfo(context),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  void handleUbahInfo(BuildContext context) {
    if (formState.currentState.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Center(child: CircularProgressIndicator());
        },
      );
      ref.document(user['uid']).updateData({
        'data': {'nik': nik.text, 'nohp': nohp.text}
      }).whenComplete(() {
        Navigator.of(context).pop();
      });
    }
  }
}
