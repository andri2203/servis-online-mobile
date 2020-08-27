import 'package:flutter/material.dart';

class UserWidget extends StatefulWidget {
  final Map<String, dynamic> profile;

  const UserWidget({Key key, this.profile}) : super(key: key);
  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  get user => widget.profile;
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.17,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Image.network(
              user['photoURL'],
              fit: BoxFit.cover,
              width: 60,
              height: 60,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress != null && user['photoURL'] == null)
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                return child;
              },
            ),
          ),
          SizedBox(height: 5),
          Text(user['displayName'].toUpperCase(),
              style: TextStyle(
                  fontSize: 15.725,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Text('${user['data']['nik']} ~ ${user['data']['nohp']}',
              style: TextStyle(fontSize: 12.725, color: Colors.white))
        ],
      ),
    );
  }
}
