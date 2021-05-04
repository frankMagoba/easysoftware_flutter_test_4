import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';

class UserList extends StatefulWidget {
  UserList({Key key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  String token;
  int id;
  final items = List<String>.generate(20, (i) => "Prospect ${i + 1}");

  @override
  void initState() {
    super.initState();
    getProspects();
  }

  Future getProspects() async {
    http.Response response = await http.get(
      'https://607e868602a23c0017e8b79e.mockapi.io/api/v1/users',
    );
    var list = json.decode(response.body);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User List',
        ),
      ),
      body: FutureBuilder(
          future: getProspects(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              );
            }
            if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  'No Users',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'sf-ui',
                  ),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Card(
                        elevation: 0.7,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            leading: Container(
                              padding: EdgeInsets.only(right: 12.0),
                              decoration: new BoxDecoration(
                                  border: new Border(
                                      right: new BorderSide(
                                          width: 1.0, color: Colors.blue))),
                              child: Icon(Icons.person, color: Colors.blue),
                            ),
                            title: Text(
                              snapshot.data[index]['name'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: LinearProgressIndicator(
                                          backgroundColor: Color.fromRGBO(
                                              209, 224, 224, 0.2),
                                          value: 9,
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.blue)),
                                    )),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(snapshot.data[index]['email'],
                                          style:
                                              TextStyle(color: Colors.black))),
                                )
                              ],
                            ),
                            trailing: Icon(Icons.keyboard_arrow_right,
                                color: Colors.black, size: 30.0),
                            // onTap: () {
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => ProspectDetail(
                            //               snapshot.data[index]['ap_name'],
                            //               snapshot.data[index]['ap_date'],
                            //               snapshot.data[index]['ap_type'],
                            //               snapshot.data[index]['ap_phone_no'],
                            //               snapshot.data[index]['ap_email'],
                            //               snapshot.data[index]['ap_location'],
                            //               snapshot.data[index]['ap_reason'],
                            //               snapshot.data[index]['ap_priority'],
                            //               snapshot.data[index]['ap_id'])));
                            // },
                          ),
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
