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
            child: Image(
              image: NetworkImage(user['photoURL']),
              width: 60,
            ),
          ),
          SizedBox(height: 5),
          Text(user['displayName'].toUpperCase(),
              style: TextStyle(
                  fontSize: 15.725,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Text(user['data']['motor'] + ' ~ ' + user['data']['nomorPolisi'],
              style: TextStyle(fontSize: 12.725, color: Colors.white))
        ],
      ),
    );
  }
}
