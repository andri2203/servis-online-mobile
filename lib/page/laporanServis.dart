import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LaporanServis extends StatefulWidget {
  final DocumentSnapshot doc;

  const LaporanServis({Key key, this.doc}) : super(key: key);
  @override
  _LaporanServisState createState() => _LaporanServisState();
}

class _LaporanServisState extends State<LaporanServis> {
  DocumentSnapshot get doc => widget.doc;
  List<dynamic> get dataItem => doc['kerusakan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      appBar: AppBar(
        backgroundColor: Color(0xFF8A2387),
        centerTitle: true,
        title: Column(
          children: <Widget>[
            Text('Laporan Servis ${doc.documentID}'),
            Text('Motor : ${doc['motor']}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white38,
                )),
          ],
        ),
      ),
      body: Card(
        margin: EdgeInsets.all(15),
        child: Container(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Table(
                  columnWidths: {
                    0: IntrinsicColumnWidth(),
                    1: IntrinsicColumnWidth(),
                    2: FlexColumnWidth(1.2),
                  },
                  children: [
                    TableRow(children: [
                      Text('No. Antrian'),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(':'),
                      ),
                      Text(doc.documentID),
                    ]),
                    TableRow(children: [
                      Text('Nama'),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(':'),
                      ),
                      Text(doc['nama']),
                    ]),
                    TableRow(children: [
                      Text('Motor'),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(':'),
                      ),
                      Text(doc['motor']),
                    ]),
                    TableRow(children: [
                      Text('Tanggal Daftar'),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(':'),
                      ),
                      Text(DateFormat('dd MMMM yyyy, HH:mm a')
                          .format(doc['daftar'].toDate())),
                    ]),
                    TableRow(children: [
                      Text('Total'),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(':'),
                      ),
                      Text(dataItem
                          .fold(
                              0,
                              (previousValue, element) =>
                                  previousValue + int.parse(element['harga']))
                          .toString()),
                    ]),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Divider(color: Colors.black)),
                DataTable(
                    dataRowHeight: 25.0,
                    headingRowHeight: 30.0,
                    dividerThickness: 1.5,
                    columns: const <DataColumn>[
                      DataColumn(label: Text('#'), numeric: true),
                      DataColumn(label: Text('Item Rusak')),
                      DataColumn(label: Text('Harga Item')),
                    ],
                    rows: List<DataRow>.generate(
                      doc['kerusakan'].length,
                      (index) => DataRow(cells: <DataCell>[
                        DataCell(Text((index).toString())),
                        DataCell(Text(doc['kerusakan'][index]['jenis'])),
                        DataCell(Text(doc['kerusakan'][index]['harga']))
                      ]),
                    )),
              ],
            )),
      ),
    );
  }
}
